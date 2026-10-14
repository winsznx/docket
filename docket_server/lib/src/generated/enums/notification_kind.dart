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

enum NotificationKind implements _is.SerializableModel {
  joined,
  headsUp,
  called,
  graceReminder,
  reslotted,
  expired,
  dayClosed,
  transferred;

  static NotificationKind fromJson(String name) {
    switch (name) {
      case 'joined':
        return NotificationKind.joined;
      case 'headsUp':
        return NotificationKind.headsUp;
      case 'called':
        return NotificationKind.called;
      case 'graceReminder':
        return NotificationKind.graceReminder;
      case 'reslotted':
        return NotificationKind.reslotted;
      case 'expired':
        return NotificationKind.expired;
      case 'dayClosed':
        return NotificationKind.dayClosed;
      case 'transferred':
        return NotificationKind.transferred;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "NotificationKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
