import 'package:serverpod/serverpod.dart';

import 'site_layout.dart';
import 'site_pages.dart';

/// Builds the template values for one page body at request time.
typedef PageContent = Future<Map<String, Object?>> Function(Session session);

/// Serves one site page: the page's own template rendered into the layout.
///
/// HTML keeps `WidgetRoute`'s `private, no-cache` header. Asset links in the
/// layout use `{{{@/site/...}}}` so they resolve to cache-busted paths.
class SitePageRoute extends WidgetRoute {
  SitePageRoute({
    required this.page,
    required this.content,
    required this.origin,
    required CacheBustingConfig assets,
  }) : _assets = assets,
       super(methods: {Method.get, Method.head}, cacheBustingConfig: assets);

  final SitePage page;
  final PageContent content;

  /// The public origin, such as `https://docket.serverpod.space`, used for
  /// canonical and Open Graph URLs.
  final String origin;

  final CacheBustingConfig _assets;

  @override
  Future<WebWidget> build(Session session, Request request) async {
    final body = TemplateWidget(
      name: page.template,
      values: await content(session),
    ).render();
    return SiteLayout(
      page: page,
      body: body,
      origin: origin,
      ogImagePath: await _assets.tryAssetPath('/site/img/og.png'),
    );
  }
}
