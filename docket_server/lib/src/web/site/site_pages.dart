/// One page of the public site.
class SitePage {
  const SitePage({
    required this.path,
    required this.template,
    required this.name,
    required this.title,
    required this.description,
  });

  /// The literal path the page is served at.
  final String path;

  /// The Mustache template in `web/templates` that holds the page body.
  final String template;

  /// The page's name in the header, the menu, the footer and next links.
  final String name;

  /// The document title.
  final String title;

  /// The meta and Open Graph description.
  final String description;
}

/// A link to somewhere the site sends people, by name.
typedef SiteLink = ({String path, String name});

/// The live demo, which is the Flutter app's `/try` route and the last stop
/// in the reading order.
const SiteLink tryLiveClinic = (path: '/try', name: 'Try a live clinic');

const String repositoryUrl = 'https://github.com/winsznx/docket';

/// Every page in reading order, from DESIGN.md 4.1. The nav, the menu, the
/// footer and each page's next link are built from this list, so a page shows
/// up in them only once it's listed here.
const List<SitePage> sitePages = [
  SitePage(
    path: '/',
    template: 'home',
    name: 'Home',
    title: 'Docket | Wait anywhere',
    description:
        'Docket lets walk-in patients wait anywhere. The clinic taps one '
        'button, every phone in line moves at once, and missed calls re-slot '
        'on timers that survive a server restart.',
  ),
  SitePage(
    path: '/problem',
    template: 'problem',
    name: 'The problem',
    title: 'The problem | Docket',
    description:
        'At Nigerian outpatient clinics your place in line only exists inside '
        'the room. Measured visits ran from 44.9 minutes at a private hospital '
        'to 274 minutes at a teaching hospital.',
  ),
  SitePage(
    path: '/how-it-works',
    template: 'how_it_works',
    name: 'How it works',
    title: 'How it works | Docket',
    description:
        "Scan the code at the desk, wait anywhere, get a heads-up when you're "
        "close and confirm when it's your turn. One button at the desk moves "
        'every phone.',
  ),
  SitePage(
    path: '/patients',
    template: 'patients',
    name: 'For patients',
    title: 'For patients | Docket',
    description:
        'Docket runs in the browser of any phone, with nothing to install. How '
        'alerts work, what happens if you miss your call and what Docket keeps.',
  ),
  SitePage(
    path: '/clinics',
    template: 'clinics',
    name: 'For clinics',
    title: 'For clinics | Docket',
    description:
        'The desk, the waiting-room board that calls numbers aloud and the '
        "owner's setup all run in a browser on the computer you already have.",
  ),
  SitePage(
    path: '/reliability',
    template: 'reliability',
    name: 'Reliability',
    title: 'Reliability | Docket',
    description:
        'The desk keeps calling offline, timers live in the database so a '
        'restart loses no one, and phones reconnect and catch up on their own.',
  ),
  SitePage(
    path: '/under-the-hood',
    template: 'under_the_hood',
    name: 'Under the hood',
    title: 'Under the hood | Docket',
    description:
        'Docket is built on Serverpod 4. Each Serverpod feature beside the '
        'moment it powers, the architecture and links to the code and tests.',
  ),
  SitePage(
    path: '/privacy',
    template: 'privacy',
    name: 'Privacy',
    title: 'Privacy | Docket',
    description:
        'Docket keeps initials and, if you choose, a phone number, and deletes '
        'both the day after your visit. No medical fields, ever.',
  ),
];

/// The page after [page] in reading order. After the last page comes the live
/// demo.
SiteLink nextAfter(SitePage page) {
  final index = sitePages.indexOf(page);
  if (index < 0 || index == sitePages.length - 1) return tryLiveClinic;
  final next = sitePages[index + 1];
  return (path: next.path, name: next.name);
}
