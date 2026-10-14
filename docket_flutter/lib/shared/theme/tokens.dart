// Generated from design/tokens.json by tool/gen_tokens.dart. Don't edit.

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

abstract final class DocketColors {
  static const daylight = Color(0xFFFFFFFF);
  static const register = Color(0xFF182C70);
  static const registerSoft = Color(0xFF4A5785);
  static const wash = Color(0xFFF3F5FA);
  static const danfo = Color(0xFFFFC928);
  static const go = Color(0xFF0A7A45);
  static const missed = Color(0xFFB42318);
  static const night = Color(0xFF0B1440);
  static const nightSoft = Color(0xFFA9B3D6);
  static const registerLift = Color(0xFF24398F);
}

abstract final class DocketSpace {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s96 = 96;
  static const double s128 = 128;
  static const double s192 = 192;
}

abstract final class DocketRadius {
  static const double ticket = 28;
  static const double ticketHero = 32;
  static const double input = 14;
  static const double sheet = 28;
  static const double pill = 999;
  static const double notch = 14;
}

abstract final class DocketMotion {
  static const press = Duration(milliseconds: 120);
  static const state = Duration(milliseconds: 240);
  static const ticket = Duration(milliseconds: 480);
  static const curve = Cubic(0.2, 0.7, 0.2, 1);
}

abstract final class DocketType {
  static const sans = 'AtkinsonHyperlegibleNext';
  static const mono = 'AtkinsonHyperlegibleMono';

  static const double ticketLabelMin = 96;
  static const double ticketLabelMax = 128;
  static const double headline = 32;
  static const double body = 18;
  static const double small = 15;

  static const double displayLeading = 0.95;
  static const displayWeight = FontWeight.w800;
  static const double displayTrackingEm = -0.02;

  static const double headingLeading = 1.1;
  static const headingWeight = FontWeight.w700;

  static const double subheadingLeading = 1.25;
  static const subheadingWeight = FontWeight.w700;

  static const double leadLeading = 1.45;
  static const leadWeight = FontWeight.w400;

  static const double bodyLeading = 1.6;
  static const bodyWeight = FontWeight.w400;

  static const double smallLeading = 1.5;
  static const smallWeight = FontWeight.w500;
}

abstract final class DocketShadows {
  static const ticket = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(11, 20, 64, 0.08),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color.fromRGBO(11, 20, 64, 0.18),
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];
}
