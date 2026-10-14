import 'dart:convert';
import 'dart:math' as math;

/// One published measurement of how long an outpatient visit took, from the
/// sources in PRD section 2.
class VisitLength {
  const VisitLength({
    required this.place,
    required this.detail,
    required this.minutes,
    required this.source,
    this.isPrivate = false,
  });

  final String place;
  final String detail;
  final double minutes;
  final VisitSource source;

  /// The one private hospital, drawn in the softer color.
  final bool isPrivate;

  String get minutesText => minutes == minutes.roundToDouble()
      ? minutes.toInt().toString()
      : minutes.toString();
}

class VisitSource {
  const VisitSource(this.name, this.url);

  final String name;
  final String url;
}

const _icir = VisitSource(
  'ICIR, "Patients are frustrated in Abuja hospitals due to long wait but '
      'there is no way out yet"',
  'https://www.icirnigeria.org/patients-are-frustrated-in-abuja-hospitals-due-to-long-wait-but-there-is-no-way-out-yet/',
);

const _phcfm = VisitSource(
  'PHCFM, 2012, with data from May 2009',
  'https://phcfm.org/index.php/phcfm/article/download/398/390',
);

const _nmj = VisitSource(
  'Nigerian Medical Journal 62(6), 2021',
  'https://ajol.info/index.php/nmj/article/view/241625',
);

/// The four values from DESIGN.md 4.1, longest first.
const List<VisitLength> visitLengths = [
  VisitLength(
    place: 'UPTH, Port Harcourt',
    detail: '2013 survey, reported by ICIR',
    minutes: 274,
    source: _icir,
  ),
  VisitLength(
    place: 'National Hospital Abuja',
    detail: 'Median encounter, PHCFM 2012',
    minutes: 162,
    source: _phcfm,
  ),
  VisitLength(
    place: 'Public clinics, Rivers State',
    detail: 'Nigerian Medical Journal, 2021',
    minutes: 122.6,
    source: _nmj,
  ),
  VisitLength(
    place: 'Private hospital, Rivers State',
    detail: 'Nigerian Medical Journal, 2021',
    minutes: 44.9,
    source: _nmj,
    isPrivate: true,
  ),
];

/// Template values for the problem page: the chart, its hidden table and the
/// source links.
Map<String, Object?> problemChartValues() => {
  'chartSvg': _chartSvg(visitLengths),
  'chartRows': [
    for (final v in visitLengths)
      {
        'place': v.place,
        'detail': v.detail,
        'minutes': v.minutesText,
      },
  ],
  'sources': [
    for (final s in {for (final v in visitLengths) v.source})
      {'name': s.name, 'url': s.url},
  ],
};

// Row geometry in CSS pixels. The labels are set at the small text size, so
// two label lines, the bar and the gap to the next row fit in one row.
const _placeBaseline = 15;
const _detailBaseline = 35;
const _barTop = 46;
const _barHeight = 28;
const _rowGap = 28;
const _rowHeight = _barTop + _barHeight + _rowGap;
const _labelInset = 12;
const _valueGap = 10;

/// The longest bar takes this share of the chart width, leaving room for the
/// value at its end on a 320 px wide phone.
const _longestBarPercent = 72;

/// A horizontal bar chart drawn without a viewBox, so text stays at its CSS
/// size at every width while bar lengths are percentages of the chart width.
String _chartSvg(List<VisitLength> rows) {
  const esc = HtmlEscape();
  final longest = rows.map((r) => r.minutes).reduce(math.max);
  final height = rows.length * _rowHeight - _rowGap;
  final svg = StringBuffer(
    '<svg class="chart" width="100%" height="$height" aria-hidden="true" '
    'focusable="false">',
  );
  for (final (i, row) in rows.indexed) {
    final top = i * _rowHeight;
    final percent = (row.minutes / longest * _longestBarPercent)
        .toStringAsFixed(2);
    final barClass = row.isPrivate ? 'chart-bar chart-bar-soft' : 'chart-bar';
    svg
      ..write(
        '<text class="chart-place" x="$_labelInset" '
        'y="${top + _placeBaseline}">${esc.convert(row.place)}</text>',
      )
      ..write(
        '<text class="chart-detail" x="$_labelInset" '
        'y="${top + _detailBaseline}">${esc.convert(row.detail)}</text>',
      )
      ..write(
        '<rect class="$barClass" x="0" y="${top + _barTop}" '
        'width="$percent%" height="$_barHeight"/>',
      )
      ..write(
        '<text class="chart-value" x="$percent%" dx="$_valueGap" '
        'y="${top + _barTop + _barHeight / 2}" dominant-baseline="central">'
        '${row.minutesText} min</text>',
      );
  }
  svg
    ..write(
      '<line class="chart-baseline" x1="1" y1="0" x2="1" y2="$height"/>',
    )
    ..write('</svg>');
  return svg.toString();
}
