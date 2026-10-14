/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/priority_reason.dart' as _ic48vmv6;
import '../enums/room_state.dart' as _is416j1i;
import '../protocol.dart' as _iv35mfmj;
part 'add_priority_action.dart';
part 'add_walk_in_action.dart';
part 'call_next_action.dart';
part 'call_specific_action.dart';
part 'close_day_action.dart';
part 'finish_action.dart';
part 'mark_no_show_action.dart';
part 'recall_action.dart';
part 'remove_action.dart';
part 'set_room_state_action.dart';
part 'start_service_action.dart';
part 'transfer_action.dart';

sealed class DeskAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeskAction({
    required this.actionId,
    required this.deviceId,
    required this.seq,
    required this.issuedAtLocal,
  });

  _is.UuidValue actionId;

  _is.UuidValue deviceId;

  int seq;

  DateTime issuedAtLocal;

  /// Returns a shallow copy of this [DeskAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
  });
}

class _Undefined {}
