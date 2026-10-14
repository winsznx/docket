import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/services.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// Each line's name, code, usual minutes per patient and whether it takes
/// new patients, and each room with the line it calls from. Saved one at a
/// time with `upsertLine` and `upsertRoom`.
class LinesRoomsSection extends StatefulWidget {
  const LinesRoomsSection({
    super.key,
    required this.access,
    required this.view,
    required this.onChanged,
  });

  final OwnerAccess access;
  final OwnerView view;
  final ValueChanged<OwnerView> onChanged;

  @override
  State<LinesRoomsSection> createState() => _LinesRoomsSectionState();
}

class _LinesRoomsSectionState extends State<LinesRoomsSection> {
  bool _addingLine = false;
  bool _addingRoom = false;

  OwnerView get _view => widget.view;

  void _lineSaved(Line saved) {
    final lines = [..._view.lines];
    final at = lines.indexWhere((l) => l.id == saved.id);
    if (at < 0) {
      lines.add(saved);
    } else {
      lines[at] = saved;
    }
    setState(() => _addingLine = false);
    widget.onChanged(_view.copyWith(lines: lines));
  }

  void _roomSaved(Room saved) {
    final rooms = [..._view.rooms];
    final at = rooms.indexWhere((r) => r.id == saved.id);
    if (at < 0) {
      rooms.add(saved);
    } else {
      rooms[at] = saved;
    }
    setState(() => _addingRoom = false);
    widget.onChanged(_view.copyWith(rooms: rooms));
  }

  @override
  Widget build(BuildContext context) {
    final clinicId = widget.access.clinicId;
    final lines = _view.lines;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GroupTitle(OwnerStrings.linesTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.linesExplain),
        for (final line in lines) ...[
          const SizedBox(height: DocketSpace.s32),
          _LineEditor(
            key: ValueKey(line.id),
            access: widget.access,
            line: line,
            takenCodes: lines.where((l) => l.id != line.id).map((l) => l.code),
            onSaved: _lineSaved,
          ),
        ],
        const SizedBox(height: DocketSpace.s32),
        if (_addingLine)
          _LineEditor(
            access: widget.access,
            line: Line(
              clinicId: clinicId,
              name: '',
              code: suggestLineCode('', lines.map((l) => l.code)),
              defaultServiceSeconds: 480,
              acceptingJoins: true,
              sortOrder: lines.length,
            ),
            takenCodes: lines.map((l) => l.code),
            onSaved: _lineSaved,
            onCancel: () => setState(() => _addingLine = false),
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: () => setState(() => _addingLine = true),
              label: OwnerStrings.addLine,
              icon: LucideIcons.plus,
            ),
          ),
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.roomsTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.roomsExplain),
        for (final room in _view.rooms) ...[
          const SizedBox(height: DocketSpace.s32),
          _RoomEditor(
            key: ValueKey(room.id),
            access: widget.access,
            room: room,
            lines: lines,
            onSaved: _roomSaved,
          ),
        ],
        const SizedBox(height: DocketSpace.s32),
        if (_addingRoom && lines.isNotEmpty)
          _RoomEditor(
            access: widget.access,
            room: Room(
              clinicId: clinicId,
              lineId: lines.first.id!,
              name: OwnerStrings.defaultRoomName(_view.rooms.length + 1),
              sortOrder: _view.rooms.length,
            ),
            lines: lines,
            onSaved: _roomSaved,
            onCancel: () => setState(() => _addingRoom = false),
          )
        else if (lines.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: () => setState(() => _addingRoom = true),
              label: OwnerStrings.addRoom,
              icon: LucideIcons.plus,
            ),
          ),
      ],
    );
  }
}

class _LineEditor extends StatefulWidget {
  const _LineEditor({
    super.key,
    required this.access,
    required this.line,
    required this.takenCodes,
    required this.onSaved,
    this.onCancel,
  });

  final OwnerAccess access;
  final Line line;
  final Iterable<String> takenCodes;
  final ValueChanged<Line> onSaved;
  final VoidCallback? onCancel;

  @override
  State<_LineEditor> createState() => _LineEditorState();
}

class _LineEditorState extends State<_LineEditor> {
  late final _name = TextEditingController(text: widget.line.name);
  late final _code = TextEditingController(text: widget.line.code);
  late final _minutes = TextEditingController(
    text: '${(widget.line.defaultServiceSeconds / 60).round()}',
  );
  bool _tried = false;
  bool _busy = false;
  String? _error;

  bool get _isNew => widget.line.id == null;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _minutes.dispose();
    super.dispose();
  }

  String? _localError() {
    final e =
        validateLineName(_name.text) ??
        validateLineCode(_code.text) ??
        validateServiceMinutes(_minutes.text);
    if (e != null) return e;
    final code = _code.text.trim().toUpperCase();
    return widget.takenCodes.contains(code)
        ? OwnerStrings.lineCodesClash
        : null;
  }

  Future<void> _save({bool? accepting}) async {
    final fieldsOnly = accepting == null;
    if (fieldsOnly) setState(() => _tried = true);
    final local = fieldsOnly ? _localError() : null;
    if (local != null) {
      setState(() => _error = local);
      announce(context, local);
      return;
    }
    final line = fieldsOnly
        ? widget.line.copyWith(
            name: _name.text.trim(),
            code: _code.text.trim().toUpperCase(),
            defaultServiceSeconds: int.parse(_minutes.text.trim()) * 60,
          )
        : widget.line.copyWith(acceptingJoins: accepting);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await client.owner.upsertLine(
        widget.access.clinicId,
        line,
        widget.access.sandboxToken,
      );
      if (!mounted) return;
      announce(context, OwnerStrings.lineSaved);
      widget.onSaved(saved);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final onCancel = widget.onCancel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isNew) ...[
          Text(
            OwnerStrings.newLine,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: DocketSpace.s12),
        ],
        LabeledField(
          label: OwnerStrings.lineName,
          controller: _name,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          autofocus: _isNew,
          onChanged: (_) => setState(() {}),
          error: _tried ? validateLineName(_name.text) : null,
        ),
        const SizedBox(height: DocketSpace.s16),
        Wrap(
          spacing: DocketSpace.s24,
          runSpacing: DocketSpace.s16,
          children: [
            SizedBox(
              width: 120,
              child: LabeledField(
                label: OwnerStrings.lineCode,
                controller: _code,
                maxLength: 1,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(
              width: 260,
              child: LabeledField(
                label: OwnerStrings.lineMinutes,
                controller: _minutes,
                keyboardType: TextInputType.number,
                suffix: OwnerStrings.minutes,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: DocketSpace.s4),
        Explanation(
          '${OwnerStrings.lineMinutesExplain} '
          '${OwnerStrings.range(1, 60, OwnerStrings.minutes)}',
        ),
        if (!_isNew) ...[
          const SizedBox(height: DocketSpace.s16),
          DocketSwitch(
            label: OwnerStrings.takingPatients,
            value: widget.line.acceptingJoins,
            onChanged: _busy ? null : (v) => _save(accepting: v),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s12),
          ErrorLine(error),
        ],
        const SizedBox(height: DocketSpace.s16),
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s8,
          children: [
            DocketButton(
              onPressed: _busy ? null : _save,
              label: OwnerStrings.saveLine,
              icon: LucideIcons.check,
              filled: true,
            ),
            if (onCancel != null)
              DocketButton(
                onPressed: onCancel,
                label: OwnerStrings.cancel,
                icon: LucideIcons.x,
              ),
          ],
        ),
      ],
    );
  }
}

class _RoomEditor extends StatefulWidget {
  const _RoomEditor({
    super.key,
    required this.access,
    required this.room,
    required this.lines,
    required this.onSaved,
    this.onCancel,
  });

  final OwnerAccess access;
  final Room room;
  final List<Line> lines;
  final ValueChanged<Room> onSaved;
  final VoidCallback? onCancel;

  @override
  State<_RoomEditor> createState() => _RoomEditorState();
}

class _RoomEditorState extends State<_RoomEditor> {
  late final _name = TextEditingController(text: widget.room.name);
  late UuidValue _line = widget.room.lineId;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final local = validateRoomName(_name.text);
    if (local != null) {
      setState(() => _error = local);
      announce(context, local);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await client.owner.upsertRoom(
        widget.access.clinicId,
        widget.room.copyWith(name: _name.text.trim(), lineId: _line),
        widget.access.sandboxToken,
      );
      if (!mounted) return;
      announce(context, OwnerStrings.roomSaved);
      widget.onSaved(saved);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final onCancel = widget.onCancel;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.room.id == null) ...[
          Text(OwnerStrings.newRoom, style: text.titleLarge),
          const SizedBox(height: DocketSpace.s12),
        ],
        LabeledField(
          label: OwnerStrings.roomName,
          controller: _name,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          autofocus: widget.room.id == null,
        ),
        const SizedBox(height: DocketSpace.s12),
        Text(OwnerStrings.roomLine, style: text.titleMedium),
        const SizedBox(height: DocketSpace.s8),
        Wrap(
          spacing: DocketSpace.s8,
          runSpacing: DocketSpace.s8,
          children: [
            for (final line in widget.lines)
              ChoicePill(
                label: line.name,
                selected: line.id == _line,
                onSelected: () => setState(() => _line = line.id!),
              ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s12),
          ErrorLine(error),
        ],
        const SizedBox(height: DocketSpace.s16),
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s8,
          children: [
            DocketButton(
              onPressed: _busy ? null : _save,
              label: OwnerStrings.saveRoom,
              icon: LucideIcons.check,
              filled: true,
            ),
            if (onCancel != null)
              DocketButton(
                onPressed: onCancel,
                label: OwnerStrings.cancel,
                icon: LucideIcons.x,
              ),
          ],
        ),
      ],
    );
  }
}
