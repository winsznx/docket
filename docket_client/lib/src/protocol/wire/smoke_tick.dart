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

abstract class SmokeTick
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SmokeTick._({
    required this.n,
    required this.serverTime,
    required this.serverId,
  });

  factory SmokeTick({
    required int n,
    required DateTime serverTime,
    required String serverId,
  }) = _SmokeTickImpl;

  factory SmokeTick.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmokeTick(
      n: jsonSerialization['n'] as int,
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      serverId: jsonSerialization['serverId'] as String,
    );
  }

  int n;

  DateTime serverTime;

  String serverId;

  /// Returns a shallow copy of this [SmokeTick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SmokeTick copyWith({
    int? n,
    DateTime? serverTime,
    String? serverId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmokeTick',
      'n': n,
      'serverTime': serverTime.toJson(),
      'serverId': serverId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmokeTick',
      'n': n,
      'serverTime': serverTime.toJson(),
      'serverId': serverId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SmokeTickImpl extends SmokeTick {
  _SmokeTickImpl({
    required int n,
    required DateTime serverTime,
    required String serverId,
  }) : super._(
         n: n,
         serverTime: serverTime,
         serverId: serverId,
       );

  /// Returns a shallow copy of this [SmokeTick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SmokeTick copyWith({
    int? n,
    DateTime? serverTime,
    String? serverId,
  }) {
    return SmokeTick(
      n: n ?? this.n,
      serverTime: serverTime ?? this.serverTime,
      serverId: serverId ?? this.serverId,
    );
  }
}
