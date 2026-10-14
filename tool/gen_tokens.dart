// Writes the site's CSS tokens and the app's Dart tokens from
// design/tokens.json, so the two can't drift apart.
//
// Run from the repository root:
//
//   dart run tool/gen_tokens.dart          writes both files
//   dart run tool/gen_tokens.dart --check  exits 1 when either file is stale

import 'dart:convert';
import 'dart:io';

const _sourcePath = 'design/tokens.json';
const _cssPath = 'docket_server/web/site/css/tokens.css';
const _dartPath = 'docket_flutter/lib/shared/theme/tokens.dart';
const _notice =
    "Generated from design/tokens.json by tool/gen_tokens.dart. Don't edit.";

const _exitStale = 1;
const _exitUsage = 64;
const _exitBadTokens = 65;
const _exitNoSource = 66;

const _remBasePx = 16;

void main(List<String> args) {
  final check = args.contains('--check');
  if (args.any((arg) => arg != '--check')) {
    stderr.writeln('Usage: dart run tool/gen_tokens.dart [--check]');
    exit(_exitUsage);
  }

  final source = File(_sourcePath);
  if (!source.existsSync()) {
    stderr.writeln('$_sourcePath not found. Run this from the repo root.');
    exit(_exitNoSource);
  }

  final Tokens tokens;
  try {
    tokens = Tokens.fromJson(
      _Json(jsonDecode(source.readAsStringSync()), 'tokens'),
    );
  } on FormatException catch (error) {
    stderr.writeln('$_sourcePath is invalid: ${error.message}');
    exit(_exitBadTokens);
  }

  final outputs = {_cssPath: renderCss(tokens), _dartPath: renderDart(tokens)};

  if (check) {
    final stale = [
      for (final MapEntry(key: path, value: expected) in outputs.entries)
        if (!_hasContent(path, expected)) path,
    ];
    if (stale.isEmpty) {
      stdout.writeln('Token files match $_sourcePath.');
      return;
    }
    for (final path in stale) {
      stderr.writeln('$path is stale.');
    }
    stderr.writeln('Run dart run tool/gen_tokens.dart from the repo root.');
    exit(_exitStale);
  }

  for (final MapEntry(key: path, value: content) in outputs.entries) {
    File(path)
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(content);
    stdout.writeln('Wrote $path');
  }
}

bool _hasContent(String path, String expected) {
  final file = File(path);
  return file.existsSync() && file.readAsStringSync() == expected;
}

String renderCss(Tokens tokens) {
  final css = StringBuffer()
    ..writeln('/* $_notice */')
    ..writeln()
    ..writeln(':root {');

  void property(String name, String value) => css.writeln('  --$name: $value;');

  for (final MapEntry(key: name, value: color) in tokens.colors.entries) {
    property('color-${_kebab(name)}', color.hex);
  }
  css.writeln();

  for (final px in tokens.space) {
    property('space-$px', '${_number(px / _remBasePx)}rem');
  }
  css.writeln();

  for (final MapEntry(key: name, value: px) in tokens.radii.entries) {
    property('radius-${_kebab(name)}', _px(px));
  }
  property(
    'shadow-ticket',
    [
      for (final layer in tokens.ticketShadow)
        [
          _px(layer.x),
          _px(layer.y),
          _px(layer.blur),
          if (layer.spread != 0) _px(layer.spread),
          'rgba(${layer.color.red}, ${layer.color.green}, '
              '${layer.color.blue}, ${_number(layer.alpha)})',
        ].join(' '),
    ].join(', '),
  );
  property('notch', _px(tokens.notch));
  css.writeln();

  for (final MapEntry(key: name, value: ms) in tokens.durations.entries) {
    property('duration-${_kebab(name)}', '${ms}ms');
  }
  property('ease', 'cubic-bezier(${tokens.easing.map(_number).join(', ')})');
  css.writeln();

  for (final (name, font) in [('sans', tokens.sans), ('mono', tokens.mono)]) {
    property('font-$name', ['"${font.name}"', ...font.fallback].join(', '));
  }

  for (final MapEntry(key: role, value: style) in tokens.siteType.entries) {
    final prefix = 'text-${_kebab(role)}';
    css.writeln();
    property('$prefix-size', style.size);
    property('$prefix-leading', _number(style.leading));
    property('$prefix-weight', '${style.weight}');
    if (style.trackingEm case final tracking?) {
      property('$prefix-tracking', '${_number(tracking)}em');
    }
  }

  css.writeln('}');
  return css.toString();
}

String renderDart(Tokens tokens) {
  final dart = StringBuffer()
    ..writeln('// $_notice')
    ..writeln()
    ..writeln("import 'package:flutter/animation.dart';")
    ..writeln("import 'package:flutter/painting.dart';")
    ..writeln()
    ..writeln('abstract final class DocketColors {');
  for (final MapEntry(key: name, value: color) in tokens.colors.entries) {
    dart.writeln(
      '  static const $name = Color(0xFF${color.hex.substring(1)});',
    );
  }
  dart
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class DocketSpace {');
  for (final px in tokens.space) {
    dart.writeln('  static const double s$px = $px;');
  }
  dart
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class DocketRadius {');
  for (final MapEntry(key: name, value: px) in tokens.radii.entries) {
    dart.writeln('  static const double $name = ${_number(px)};');
  }
  dart
    ..writeln('  static const double notch = ${_number(tokens.notch)};')
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class DocketMotion {');
  for (final MapEntry(key: name, value: ms) in tokens.durations.entries) {
    dart.writeln('  static const $name = Duration(milliseconds: $ms);');
  }
  dart
    ..writeln(
      '  static const curve = Cubic(${tokens.easing.map(_number).join(', ')});',
    )
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class DocketType {')
    ..writeln("  static const sans = '${tokens.sans.flutterFamily}';")
    ..writeln("  static const mono = '${tokens.mono.flutterFamily}';")
    ..writeln();
  for (final MapEntry(key: name, value: px) in tokens.phoneType.entries) {
    dart.writeln('  static const double $name = ${_number(px)};');
  }
  for (final MapEntry(key: role, value: style) in tokens.siteType.entries) {
    dart
      ..writeln()
      ..writeln(
        '  static const double ${role}Leading = ${_number(style.leading)};',
      )
      ..writeln('  static const ${role}Weight = FontWeight.w${style.weight};');
    if (style.trackingEm case final tracking?) {
      dart.writeln(
        '  static const double ${role}TrackingEm = ${_number(tracking)};',
      );
    }
  }
  dart
    ..writeln('}')
    ..writeln()
    ..writeln('abstract final class DocketShadows {')
    ..writeln('  static const ticket = <BoxShadow>[');
  for (final layer in tokens.ticketShadow) {
    dart
      ..writeln('    BoxShadow(')
      ..writeln(
        '      color: Color.fromRGBO(${layer.color.red}, ${layer.color.green}, '
        '${layer.color.blue}, ${_number(layer.alpha)}),',
      )
      ..writeln(
        '      offset: Offset(${_number(layer.x)}, ${_number(layer.y)}),',
      )
      ..writeln('      blurRadius: ${_number(layer.blur)},');
    if (layer.spread != 0) {
      dart.writeln('      spreadRadius: ${_number(layer.spread)},');
    }
    dart.writeln('    ),');
  }
  dart
    ..writeln('  ];')
    ..writeln('}');
  return dart.toString();
}

String _kebab(String camel) =>
    camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '-${m[0]!.toLowerCase()}');

String _number(num value) =>
    value == value.truncate() ? '${value.truncate()}' : '$value';

String _px(num value) => value == 0 ? '0' : '${_number(value)}px';

final class Tokens {
  Tokens({
    required this.colors,
    required this.space,
    required this.radii,
    required this.notch,
    required this.ticketShadow,
    required this.durations,
    required this.easing,
    required this.sans,
    required this.mono,
    required this.siteType,
    required this.phoneType,
  });

  factory Tokens.fromJson(_Json json) {
    final colors = {
      for (final MapEntry(key: name, value: hex)
          in json['color'].fields.entries)
        name: RgbColor.parse(hex),
    };
    final motion = json['motion'];
    final easing = [for (final value in motion['easing'].items) value.number];
    if (easing.length != 4) {
      throw const FormatException('motion.easing needs four numbers');
    }
    final type = json['type'];
    return Tokens(
      colors: colors,
      space: [for (final step in json['space'].items) step.integer],
      radii: {
        for (final MapEntry(key: name, value: px)
            in json['radius'].fields.entries)
          name: px.number,
      },
      notch: json['notch'].number,
      ticketShadow: [
        for (final layer in json['shadow']['ticket'].items)
          ShadowLayer.fromJson(layer, colors),
      ],
      durations: {
        for (final MapEntry(key: name, value: ms)
            in motion['duration'].fields.entries)
          name: ms.integer,
      },
      easing: easing,
      sans: FontToken.fromJson(json['font']['sans']),
      mono: FontToken.fromJson(json['font']['mono']),
      siteType: {
        for (final MapEntry(key: role, value: style)
            in type['site'].fields.entries)
          role: SiteTextRole.fromJson(style),
      },
      phoneType: {
        for (final MapEntry(key: name, value: px)
            in type['phone'].fields.entries)
          name: px.number,
      },
    );
  }

  final Map<String, RgbColor> colors;
  final List<int> space;
  final Map<String, num> radii;
  final num notch;
  final List<ShadowLayer> ticketShadow;
  final Map<String, int> durations;
  final List<num> easing;
  final FontToken sans;
  final FontToken mono;
  final Map<String, SiteTextRole> siteType;
  final Map<String, num> phoneType;
}

final class RgbColor {
  RgbColor._(this.hex);

  factory RgbColor.parse(_Json json) {
    final hex = json.string;
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(hex)) {
      throw FormatException('${json.path} should look like #RRGGBB');
    }
    return RgbColor._(hex.toUpperCase());
  }

  final String hex;

  int get red => _channel(1);
  int get green => _channel(3);
  int get blue => _channel(5);

  int _channel(int start) =>
      int.parse(hex.substring(start, start + 2), radix: 16);
}

final class ShadowLayer {
  ShadowLayer({
    required this.x,
    required this.y,
    required this.blur,
    required this.spread,
    required this.color,
    required this.alpha,
  });

  factory ShadowLayer.fromJson(_Json json, Map<String, RgbColor> colors) {
    final colorName = json['color'];
    final color = colors[colorName.string];
    if (color == null) {
      throw FormatException('${colorName.path} names an unknown color');
    }
    return ShadowLayer(
      x: json['x'].number,
      y: json['y'].number,
      blur: json['blur'].number,
      spread: json['spread'].number,
      color: color,
      alpha: json['alpha'].number,
    );
  }

  final num x;
  final num y;
  final num blur;
  final num spread;
  final RgbColor color;
  final num alpha;
}

final class FontToken {
  FontToken({
    required this.name,
    required this.flutterFamily,
    required this.fallback,
  });

  factory FontToken.fromJson(_Json json) => FontToken(
    name: json['name'].string,
    flutterFamily: json['flutterFamily'].string,
    fallback: [for (final family in json['fallback'].items) family.string],
  );

  final String name;
  final String flutterFamily;
  final List<String> fallback;
}

final class SiteTextRole {
  SiteTextRole({
    required this.size,
    required this.leading,
    required this.weight,
    required this.trackingEm,
  });

  factory SiteTextRole.fromJson(_Json json) {
    final weight = json['weight'].integer;
    if (weight < 100 || weight > 900 || weight % 100 != 0) {
      throw FormatException('${json.path}.weight should be 100 to 900');
    }
    return SiteTextRole(
      size: json['size'].string,
      leading: json['leading'].number,
      weight: weight,
      trackingEm: json.has('trackingEm') ? json['trackingEm'].number : null,
    );
  }

  final String size;
  final num leading;
  final int weight;
  final num? trackingEm;
}

final class _Json {
  _Json(this.value, this.path);

  final Object? value;
  final String path;

  _Json operator [](String key) {
    final map = _as<Map<String, Object?>>('an object');
    if (!map.containsKey(key)) throw FormatException('$path.$key is missing');
    return _Json(map[key], '$path.$key');
  }

  bool has(String key) =>
      _as<Map<String, Object?>>('an object').containsKey(key);

  Map<String, _Json> get fields => {
    for (final MapEntry(:key, :value) in _as<Map<String, Object?>>(
      'an object',
    ).entries)
      key: _Json(value, '$path.$key'),
  };

  List<_Json> get items => [
    for (final (index, item) in _as<List<Object?>>('a list').indexed)
      _Json(item, '$path[$index]'),
  ];

  String get string => _as<String>('a string');
  num get number => _as<num>('a number');
  int get integer => _as<int>('a whole number');

  T _as<T>(String description) {
    final value = this.value;
    if (value is T) return value;
    throw FormatException('$path should be $description');
  }
}
