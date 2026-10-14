import 'dart:io';

import 'package:docket_server/src/notify/web_push.dart';
import 'package:docket_server/src/security/phone.dart';

/// Generates Docket's own secrets into config/passwords.yaml and copies them
/// to Serverpod Cloud, without ever printing a value.
///
///   dart run tool/secrets.dart generate
///   dart run tool/secrets.dart push-cloud
const _file = 'config/passwords.yaml';
const _keys = [
  'vapidPublicKey',
  'vapidPrivateKey',
  'vapidSubject',
  'phoneEncryptionKey',
];
const _optional = ['twilioAccountSid', 'twilioAuthToken', 'twilioFrom'];

Future<void> main(List<String> args) async {
  final command = args.isEmpty ? '' : args.first;
  switch (command) {
    case 'generate':
      _generate(args.length > 1 ? args[1] : 'https://docket.serverpod.space');
    case 'push-cloud':
      await _pushCloud();
    default:
      stderr.writeln('Usage: dart run tool/secrets.dart generate|push-cloud');
      exitCode = 64;
  }
}

Map<String, String> _shared(List<String> lines) {
  final values = <String, String>{};
  var inShared = false;
  for (final line in lines) {
    if (line.startsWith('shared:')) {
      inShared = true;
      continue;
    }
    if (inShared && line.isNotEmpty && !line.startsWith(' ')) inShared = false;
    if (!inShared) continue;
    final match = RegExp(r"^\s+(\w+):\s*'?([^']*)'?\s*$").firstMatch(line);
    if (match != null) values[match.group(1)!] = match.group(2)!;
  }
  return values;
}

void _generate(String subject) {
  final file = File(_file);
  final lines = file.readAsLinesSync();
  final existing = _shared(lines);
  if (_keys.every(existing.containsKey)) {
    stdout.writeln('Docket secrets already present in $_file.');
    return;
  }
  final vapid = VapidKeys.generate();
  final fresh = {
    'vapidPublicKey': vapid.publicKeyB64Url,
    'vapidPrivateKey': vapid.privateKeyB64Url,
    'vapidSubject': subject,
    'phoneEncryptionKey': PhoneCipher.generateKeyBase64(),
  }..removeWhere((k, _) => existing.containsKey(k));
  final block = [
    if (!lines.any((l) => l.startsWith('shared:'))) 'shared:',
    for (final e in fresh.entries) "  ${e.key}: '${e.value}'",
  ];
  final at = lines.indexWhere((l) => l.startsWith('shared:'));
  if (at >= 0) {
    lines.insertAll(at + 1, block);
  } else {
    lines
      ..add('')
      ..addAll(block);
  }
  file.writeAsStringSync('${lines.join('\n')}\n');
  stdout.writeln('Wrote ${fresh.keys.join(', ')} to $_file.');
}

Future<void> _pushCloud() async {
  final values = _shared(File(_file).readAsLinesSync());
  for (final key in [..._keys, ..._optional]) {
    final value = values[key];
    if (value == null || value.isEmpty) {
      if (_keys.contains(key)) stderr.writeln('$key is missing from $_file.');
      continue;
    }
    final result = await Process.run('serverpod', [
      'cloud',
      '--non-interactive',
      'password',
      'set',
      key,
      value,
    ]);
    stdout.writeln(
      result.exitCode == 0 ? 'Set $key on Cloud.' : 'Setting $key failed.',
    );
  }
}
