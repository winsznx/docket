import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/services.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

const _defaultOpen = '08:00';
const _defaultCutoff = '17:00';
const _defaultClose = '18:00';
const _defaultMinutes = 8;
const _shownZones = 8;

class _LineDraft {
  _LineDraft({
    String name = '',
    String code = '',
    int minutes = _defaultMinutes,
  }) : name = TextEditingController(text: name),
       code = TextEditingController(text: code),
       minutes = TextEditingController(text: '$minutes');

  final TextEditingController name;
  final TextEditingController code;
  final TextEditingController minutes;

  /// The code was typed by hand, so it no longer follows the name.
  bool codeEdited = false;

  void dispose() {
    name.dispose();
    code.dispose();
    minutes.dispose();
  }
}

class _RoomDraft {
  _RoomDraft({String name = ''}) : name = TextEditingController(text: name);

  final TextEditingController name;

  /// Which wizard line this room calls from, by position.
  int line = 0;

  void dispose() => name.dispose();
}

/// The first-run setup: the clinic, its hours, lines and rooms, then the
/// links the clinic needs on day one (PRD 17.5).
class SetupWizard extends StatefulWidget {
  const SetupWizard({super.key, required this.onDone, required this.onCancel});

  final ValueChanged<OwnerAccess> onDone;
  final VoidCallback onCancel;

  @override
  State<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends State<SetupWizard> {
  static const _steps = 5;

  final _name = TextEditingController();
  final _slug = TextEditingController();
  final _zone = TextEditingController(text: defaultTimezone);
  final _open = TextEditingController(text: _defaultOpen);
  final _cutoff = TextEditingController(text: _defaultCutoff);
  final _close = TextEditingController(text: _defaultClose);
  final _lines = [
    _LineDraft(
      name: OwnerStrings.defaultLineName,
      code: OwnerStrings.defaultLineCode,
    ),
  ];
  final _rooms = [_RoomDraft(name: OwnerStrings.defaultRoomName(1))];

  int _step = 0;
  bool _tried = false;
  bool _slugEdited = false;
  bool _busy = false;
  String? _error;
  Clinic? _created;
  String? _boardUrl;

  @override
  void dispose() {
    for (final c in [_name, _slug, _zone, _open, _cutoff, _close]) {
      c.dispose();
    }
    for (final l in _lines) {
      l.dispose();
    }
    for (final r in _rooms) {
      r.dispose();
    }
    super.dispose();
  }

  String? _clinicError() =>
      validateClinicName(_name.text) ??
      validateSlug(_slug.text) ??
      validateTimezone(_zone.text);

  String? _hoursError() => validateHours(_open.text, _cutoff.text, _close.text);

  String? _linesError() {
    for (final l in _lines) {
      final e =
          validateLineName(l.name.text) ??
          validateLineCode(l.code.text) ??
          validateServiceMinutes(l.minutes.text);
      if (e != null) return e;
    }
    final codes = _lines.map((l) => l.code.text.trim().toUpperCase());
    if (codes.toSet().length != _lines.length) {
      return OwnerStrings.lineCodesClash;
    }
    return null;
  }

  String? _roomsError() {
    for (final r in _rooms) {
      final e = validateRoomName(r.name.text);
      if (e != null) return e;
      if (r.line < 0 || r.line >= _lines.length) {
        return OwnerStrings.roomLineMissing;
      }
    }
    return null;
  }

  String? _stepError() => switch (_step) {
    0 => _clinicError(),
    1 => _hoursError(),
    2 => _linesError(),
    3 => _roomsError(),
    _ => null,
  };

  void _next() {
    final error = _stepError();
    setState(() {
      _tried = true;
      _error = null;
    });
    if (error != null) {
      announce(context, error, snack: false);
      return;
    }
    setState(() {
      _step++;
      _tried = false;
    });
  }

  void _back() {
    if (_step == 0) {
      widget.onCancel();
      return;
    }
    setState(() {
      _step--;
      _error = null;
    });
  }

  void _nameChanged(String value) {
    if (_slugEdited) return;
    setState(() => _slug.text = suggestSlug(value));
  }

  void _addLine() => setState(() {
    final taken = _lines.map((l) => l.code.text);
    _lines.add(_LineDraft(code: suggestLineCode('', taken)));
  });

  void _removeLine(int index) => setState(() {
    _lines.removeAt(index).dispose();
    for (final r in _rooms) {
      if (r.line == index) {
        r.line = 0;
      } else if (r.line > index) {
        r.line--;
      }
    }
  });

  void _lineNameChanged(_LineDraft line, String value) {
    if (line.codeEdited) return;
    final taken = _lines.where((l) => l != line).map((l) => l.code.text);
    setState(() => line.code.text = suggestLineCode(value, taken));
  }

  Future<void> _create() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final clinic = _created ??= await client.owner.createClinic(
        ClinicSetup(
          name: _name.text.trim(),
          slug: _slug.text.trim(),
          timezone: _zone.text.trim(),
          lines: [
            for (final l in _lines)
              LineSetup(
                name: l.name.text.trim(),
                code: l.code.text.trim().toUpperCase(),
                defaultServiceSeconds: int.parse(l.minutes.text.trim()) * 60,
              ),
          ],
          rooms: [
            for (final r in _rooms)
              RoomSetup(
                name: r.name.text.trim(),
                lineCode: _lines[r.line].code.text.trim().toUpperCase(),
              ),
          ],
        ),
      );
      final hours = (
        _open.text.trim(),
        _cutoff.text.trim(),
        _close.text.trim(),
      );
      if (hours != (clinic.openTime, clinic.joinCutoffTime, clinic.closeTime)) {
        _created = await client.owner.updateSettings(
          clinic.id!,
          settingsOf(clinic).copyWith(
            openTime: hours.$1,
            joinCutoffTime: hours.$2,
            closeTime: hours.$3,
          ),
          null,
        );
      }
      _boardUrl ??= await client.owner.rotateBoardToken(clinic.id!, null);
      if (!mounted) return;
      setState(() {
        _busy = false;
        _step = _steps;
      });
      announce(context, OwnerStrings.readyTitle(clinic.name), snack: false);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = messageOf(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final created = _created;
    final boardUrl = _boardUrl;
    if (_step == _steps && created != null && boardUrl != null) {
      return _ReadyPage(
        clinic: created,
        lines: [
          for (final l in _lines)
            (l.name.text.trim(), l.code.text.trim().toUpperCase()),
        ],
        boardUrl: boardUrl,
        onOpenConsole: () => widget.onDone(
          OwnerAccess(
            clinicId: created.id!,
            clinicName: created.name,
            boardUrl: boardUrl,
          ),
        ),
      );
    }
    final error = _tried ? _stepError() : null;
    final serverError = _error;
    return OwnerPage(
      children: [
        Text(
          OwnerStrings.step(_step + 1, _steps),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: softText(context)),
        ),
        const SizedBox(height: DocketSpace.s8),
        PageTitle(switch (_step) {
          0 => OwnerStrings.clinicStep,
          1 => OwnerStrings.hoursStep,
          2 => OwnerStrings.linesStep,
          3 => OwnerStrings.roomsStep,
          _ => OwnerStrings.reviewStep,
        }),
        const SizedBox(height: DocketSpace.s32),
        ...switch (_step) {
          0 => _clinicStep(),
          1 => _hoursStep(),
          2 => _linesStep(),
          3 => _roomsStep(),
          _ => _reviewStep(),
        },
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s24),
          ErrorLine(error),
        ],
        if (serverError != null) ...[
          const SizedBox(height: DocketSpace.s24),
          ErrorLine(serverError),
        ],
        const SizedBox(height: DocketSpace.s32),
        if (_busy) ...[
          const DocketProgressLine(semanticsLabel: OwnerStrings.creating),
          const SizedBox(height: DocketSpace.s16),
        ],
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s12,
          children: [
            DocketButton(
              onPressed: _busy ? null : (_step == _steps - 1 ? _create : _next),
              label: _step == _steps - 1
                  ? OwnerStrings.create
                  : OwnerStrings.next,
              icon: _step == _steps - 1 ? LucideIcons.check : null,
              filled: true,
            ),
            DocketButton(
              onPressed: _busy ? null : _back,
              label: _step == 0 ? OwnerStrings.cancel : OwnerStrings.back,
              icon: _step == 0 ? LucideIcons.x : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _clinicStep() => [
    LabeledField(
      label: OwnerStrings.clinicName,
      controller: _name,
      hint: OwnerStrings.clinicNameHint,
      autofocus: true,
      maxLength: 60,
      textCapitalization: TextCapitalization.words,
      onChanged: _nameChanged,
      error: _tried ? validateClinicName(_name.text) : null,
    ),
    const SizedBox(height: DocketSpace.s32),
    LabeledField(
      label: OwnerStrings.slug,
      controller: _slug,
      explanation: OwnerStrings.slugExplain(Browser.origin, _slug.text),
      maxLength: maxSlugLength,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z0-9-]')),
      ],
      onChanged: (_) => setState(() => _slugEdited = true),
      error: _tried ? validateSlug(_slug.text) : null,
    ),
    const SizedBox(height: DocketSpace.s32),
    LabeledField(
      label: OwnerStrings.timezone,
      controller: _zone,
      explanation: OwnerStrings.timezoneExplain,
      onChanged: (_) => setState(() {}),
      error: _tried ? validateTimezone(_zone.text) : null,
    ),
    const SizedBox(height: DocketSpace.s12),
    Wrap(
      spacing: DocketSpace.s8,
      runSpacing: DocketSpace.s8,
      children: [
        for (final zone in commonTimezones.take(_shownZones))
          ChoicePill(
            label: zone,
            selected: _zone.text.trim() == zone,
            onSelected: () => setState(() => _zone.text = zone),
          ),
      ],
    ),
  ];

  List<Widget> _hoursStep() => [
    const Explanation(OwnerStrings.hoursExplain),
    const SizedBox(height: DocketSpace.s24),
    for (final (label, explain, controller) in [
      (OwnerStrings.openLabel, OwnerStrings.openExplain, _open),
      (OwnerStrings.cutoffLabel, OwnerStrings.cutoffExplain, _cutoff),
      (OwnerStrings.closeLabel, OwnerStrings.closeExplain, _close),
    ]) ...[
      LabeledField(
        label: label,
        explanation: '$explain ${OwnerStrings.timeFormat}',
        controller: controller,
        width: 160,
        keyboardType: TextInputType.datetime,
        maxLength: 5,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9:]'))],
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: DocketSpace.s24),
    ],
  ];

  List<Widget> _linesStep() => [
    const Explanation(OwnerStrings.linesExplain),
    for (var i = 0; i < _lines.length; i++) ...[
      const SizedBox(height: DocketSpace.s32),
      _LineFields(
        line: _lines[i],
        tried: _tried,
        onNameChanged: (v) => _lineNameChanged(_lines[i], v),
        onCodeChanged: () => setState(() => _lines[i].codeEdited = true),
        onChanged: () => setState(() {}),
        onRemove: _lines.length > 1 ? () => _removeLine(i) : null,
      ),
    ],
    const SizedBox(height: DocketSpace.s24),
    Align(
      alignment: Alignment.centerLeft,
      child: DocketButton(
        onPressed: _addLine,
        label: OwnerStrings.addLine,
        icon: LucideIcons.plus,
      ),
    ),
  ];

  List<Widget> _roomsStep() => [
    const Explanation(OwnerStrings.roomsExplain),
    for (var i = 0; i < _rooms.length; i++) ...[
      const SizedBox(height: DocketSpace.s32),
      LabeledField(
        label: OwnerStrings.roomName,
        controller: _rooms[i].name,
        maxLength: 40,
        textCapitalization: TextCapitalization.words,
        onChanged: (_) => setState(() {}),
        error: _tried ? validateRoomName(_rooms[i].name.text) : null,
      ),
      const SizedBox(height: DocketSpace.s12),
      Text(
        OwnerStrings.roomLine,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: DocketSpace.s8),
      Wrap(
        spacing: DocketSpace.s8,
        runSpacing: DocketSpace.s8,
        children: [
          for (var l = 0; l < _lines.length; l++)
            ChoicePill(
              label: _lines[l].name.text.trim(),
              selected: _rooms[i].line == l,
              onSelected: () => setState(() => _rooms[i].line = l),
            ),
        ],
      ),
      if (_rooms.length > 1) ...[
        const SizedBox(height: DocketSpace.s8),
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: () => setState(() => _rooms.removeAt(i).dispose()),
            label: OwnerStrings.removeRoom,
            icon: LucideIcons.x,
          ),
        ),
      ],
    ],
    const SizedBox(height: DocketSpace.s24),
    Align(
      alignment: Alignment.centerLeft,
      child: DocketButton(
        onPressed: () => setState(
          () => _rooms.add(
            _RoomDraft(name: OwnerStrings.defaultRoomName(_rooms.length + 1)),
          ),
        ),
        label: OwnerStrings.addRoom,
        icon: LucideIcons.plus,
      ),
    ),
  ];

  List<Widget> _reviewStep() {
    final text = Theme.of(context).textTheme;
    Widget fact(String value) => Padding(
      padding: const EdgeInsets.only(bottom: DocketSpace.s8),
      child: Text(value, style: text.bodyLarge),
    );
    return [
      GroupTitle(_name.text.trim()),
      const SizedBox(height: DocketSpace.s8),
      fact(OwnerStrings.slugExplain(Browser.origin, _slug.text.trim())),
      fact(_zone.text.trim()),
      fact(
        OwnerStrings.reviewHours(
          _open.text.trim(),
          _cutoff.text.trim(),
          _close.text.trim(),
        ),
      ),
      const SizedBox(height: DocketSpace.s24),
      const GroupTitle(OwnerStrings.linesStep),
      const SizedBox(height: DocketSpace.s8),
      for (final l in _lines)
        fact(
          OwnerStrings.reviewLine(
            l.name.text.trim(),
            l.code.text.trim().toUpperCase(),
            int.parse(l.minutes.text.trim()),
          ),
        ),
      const SizedBox(height: DocketSpace.s24),
      const GroupTitle(OwnerStrings.roomsStep),
      const SizedBox(height: DocketSpace.s8),
      for (final r in _rooms)
        fact(
          OwnerStrings.reviewRoom(
            r.name.text.trim(),
            _lines[r.line].name.text.trim(),
          ),
        ),
      const SizedBox(height: DocketSpace.s24),
      const Explanation(OwnerStrings.defaultsNote),
    ];
  }
}

class _LineFields extends StatelessWidget {
  const _LineFields({
    required this.line,
    required this.tried,
    required this.onNameChanged,
    required this.onCodeChanged,
    required this.onChanged,
    required this.onRemove,
  });

  final _LineDraft line;
  final bool tried;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onCodeChanged;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final onRemove = this.onRemove;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledField(
          label: OwnerStrings.lineName,
          controller: line.name,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          onChanged: onNameChanged,
          error: tried ? validateLineName(line.name.text) : null,
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
                controller: line.code,
                maxLength: 1,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                  _UpperCase(),
                ],
                onChanged: (_) => onCodeChanged(),
                error: tried ? validateLineCode(line.code.text) : null,
              ),
            ),
            SizedBox(
              width: 260,
              child: LabeledField(
                label: OwnerStrings.lineMinutes,
                controller: line.minutes,
                keyboardType: TextInputType.number,
                suffix: OwnerStrings.minutes,
                maxLength: 2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onChanged(),
                error: tried ? validateServiceMinutes(line.minutes.text) : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.lineMinutesExplain),
        if (onRemove != null) ...[
          const SizedBox(height: DocketSpace.s8),
          DocketButton(
            onPressed: onRemove,
            label: OwnerStrings.removeLine,
            icon: LucideIcons.x,
          ),
        ],
      ],
    );
  }
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

/// The end of setup: the desk link, the board link, the posters and the
/// first desk invite, then on to the console.
class _ReadyPage extends StatefulWidget {
  const _ReadyPage({
    required this.clinic,
    required this.lines,
    required this.boardUrl,
    required this.onOpenConsole,
  });

  final Clinic clinic;
  final List<(String, String)> lines;
  final String boardUrl;
  final VoidCallback onOpenConsole;

  @override
  State<_ReadyPage> createState() => _ReadyPageState();
}

class _ReadyPageState extends State<_ReadyPage> {
  StaffInviteView? _invite;
  bool _inviting = false;
  String? _error;

  /// The public address of the clinic's pages, taken from the board link
  /// the server made, so links point where patients and staff will go.
  String get _base => Uri.parse(widget.boardUrl).origin;

  Future<void> _createInvite() async {
    setState(() {
      _inviting = true;
      _error = null;
    });
    try {
      final invite = await client.owner.createInvite(
        widget.clinic.id!,
        StaffRole.desk,
        null,
      );
      if (mounted) setState(() => _invite = invite);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _inviting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invite = _invite;
    final error = _error;
    final desk = '$_base/desk';
    return OwnerPage(
      children: [
        PageTitle(OwnerStrings.readyTitle(widget.clinic.name)),
        const SizedBox(height: DocketSpace.s12),
        const Explanation(OwnerStrings.readyLead),
        const SizedBox(height: groupGap),
        LinkBlock(
          title: OwnerStrings.deskLinkTitle,
          explanation: OwnerStrings.deskLinkExplain,
          url: desk,
          onOpen: () => Browser.openInNewTab(desk),
        ),
        const SizedBox(height: groupGap),
        LinkBlock(
          title: OwnerStrings.boardLinkTitle,
          explanation: OwnerStrings.boardLinkExplain,
          url: widget.boardUrl,
          onOpen: () => Browser.openInNewTab(widget.boardUrl),
        ),
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.postersTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.postersExplain),
        const SizedBox(height: DocketSpace.s12),
        for (final (name, code) in widget.lines)
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: () => Browser.openInNewTab(
                posterUrl(_base, widget.clinic.slug, code),
              ),
              label: OwnerStrings.openPoster(name),
              icon: LucideIcons.printer,
            ),
          ),
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.firstInviteTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.firstInviteExplain),
        const SizedBox(height: DocketSpace.s12),
        if (invite == null)
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: _inviting ? null : _createInvite,
              label: OwnerStrings.createDeskInvite,
              icon: LucideIcons.userPlus,
              filled: true,
            ),
          )
        else
          LinkBlock(
            url: invite.inviteUrl,
            onOpen: () => Browser.openInNewTab(invite.inviteUrl),
            note: OwnerStrings.inviteExpires(
              Browser.dayAndTimeIn(widget.clinic.timezone, invite.expiresAt),
            ),
          ),
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s12),
          ErrorLine(error),
        ],
        const SizedBox(height: groupGap),
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: widget.onOpenConsole,
            label: OwnerStrings.openConsole,
            icon: LucideIcons.layoutDashboard,
            filled: true,
          ),
        ),
      ],
    );
  }
}
