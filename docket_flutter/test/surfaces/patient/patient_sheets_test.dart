import 'package:docket_flutter/shared/strings/patient.dart';
import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/surfaces/patient/patient_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(void Function(BuildContext context) open) => MaterialApp(
  theme: docketTheme(Brightness.light),
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () => open(context),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('the iPhone sheet shows the three taps and texts beside them', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        (context) =>
            showInstallSheet(context, onSms: (phone, consent) async => null),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(PatientStrings.installTitle), findsOneWidget);
    for (final step in PatientStrings.installSteps) {
      expect(find.text(step), findsOneWidget);
    }
    expect(find.text('1'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text(PatientStrings.smsInstead), findsOneWidget);
    expect(find.text(PatientStrings.smsConsent), findsOneWidget);
  });

  testWidgets('without texts the iPhone sheet only shows the taps', (
    tester,
  ) async {
    await tester.pumpWidget(_host((context) => showInstallSheet(context)));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(PatientStrings.smsInstead), findsNothing);
    expect(find.text(PatientStrings.smsConsent), findsNothing);
  });

  testWidgets('texts need a number, start unticked and pass the consent', (
    tester,
  ) async {
    final sent = <(String, bool)>[];
    await tester.pumpWidget(
      _host(
        (context) => showSmsSheet(
          context,
          onSms: (phone, consent) async {
            sent.add((phone, consent));
            return consent ? null : 'Tick the box to get texts first.';
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final box = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(box.value, isFalse);

    await tester.tap(find.text(PatientStrings.smsTurnOn));
    await tester.pumpAndSettle();
    expect(find.text(PatientStrings.phoneMissing), findsOneWidget);
    expect(sent, isEmpty);

    await tester.enterText(find.byType(TextField), '0803 123 4567');
    await tester.tap(find.text(PatientStrings.smsTurnOn));
    await tester.pumpAndSettle();
    expect(sent.single, ('0803 123 4567', false));
    expect(find.text('Tick the box to get texts first.'), findsOneWidget);

    await tester.tap(find.text(PatientStrings.smsConsent));
    await tester.tap(find.text(PatientStrings.smsTurnOn));
    await tester.pumpAndSettle();
    expect(sent.last, ('0803 123 4567', true));
    expect(find.text(PatientStrings.smsTitle), findsNothing);
  });

  testWidgets('leaving asks first and stays when the patient says so', (
    tester,
  ) async {
    bool? answer;
    await tester.pumpWidget(
      _host((context) async => answer = await confirmLeave(context, 'C-031')),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text(PatientStrings.leaveTitle), findsOneWidget);
    expect(find.text(PatientStrings.leaveBody('C-031')), findsOneWidget);

    await tester.tap(find.text(PatientStrings.leaveKeep));
    await tester.pumpAndSettle();
    expect(answer, isFalse);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(PatientStrings.leaveConfirm));
    await tester.pumpAndSettle();
    expect(answer, isTrue);
  });
}
