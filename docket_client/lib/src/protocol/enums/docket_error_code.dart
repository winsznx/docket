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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

enum DocketErrorCode implements _isc.SerializableModel {
  clinicNotFound,
  lineNotAccepting,
  dayClosed,
  joinCutoffPassed,
  ticketNotFound,
  invalidTransition,
  roomNotOpen,
  notStaff,
  notOwner,
  rateLimited,
  sandboxExpired,
  inviteInvalid,
  smsDisabled,
  pushInvalid,
  validation;

  static DocketErrorCode fromJson(String name) {
    switch (name) {
      case 'clinicNotFound':
        return DocketErrorCode.clinicNotFound;
      case 'lineNotAccepting':
        return DocketErrorCode.lineNotAccepting;
      case 'dayClosed':
        return DocketErrorCode.dayClosed;
      case 'joinCutoffPassed':
        return DocketErrorCode.joinCutoffPassed;
      case 'ticketNotFound':
        return DocketErrorCode.ticketNotFound;
      case 'invalidTransition':
        return DocketErrorCode.invalidTransition;
      case 'roomNotOpen':
        return DocketErrorCode.roomNotOpen;
      case 'notStaff':
        return DocketErrorCode.notStaff;
      case 'notOwner':
        return DocketErrorCode.notOwner;
      case 'rateLimited':
        return DocketErrorCode.rateLimited;
      case 'sandboxExpired':
        return DocketErrorCode.sandboxExpired;
      case 'inviteInvalid':
        return DocketErrorCode.inviteInvalid;
      case 'smsDisabled':
        return DocketErrorCode.smsDisabled;
      case 'pushInvalid':
        return DocketErrorCode.pushInvalid;
      case 'validation':
        return DocketErrorCode.validation;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DocketErrorCode"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
