import 'package:serverpod/serverpod.dart';

import 'site_pages.dart';

/// The chrome around every page from DESIGN.md 4.2, rendered from
/// `web/templates/layout.html` with the page body embedded unescaped.
class SiteLayout extends TemplateWidget {
  SiteLayout({
    required SitePage page,
    required String body,
    required String origin,
    required String ogImagePath,
  }) : super(name: 'layout') {
    final next = nextAfter(page);
    values = {
      'title': page.title,
      'description': page.description,
      'canonicalUrl': '$origin${page.path}',
      'ogImageUrl': '$origin$ogImagePath',
      'isHome': page.path == '/',
      'headerPages': [
        for (final p in sitePages.skip(1)) _link(p, current: page),
      ],
      'allPages': [for (final p in sitePages) _link(p, current: page)],
      'tryPath': tryLiveClinic.path,
      'tryName': tryLiveClinic.name,
      'nextPath': next.path,
      'nextName': next.name,
      'repositoryUrl': repositoryUrl,
      'body': body,
    };
  }

  static Map<String, Object> _link(SitePage p, {required SitePage current}) => {
    'path': p.path,
    'name': p.name,
    'current': p == current,
  };
}
