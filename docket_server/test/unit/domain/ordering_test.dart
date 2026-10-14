import 'package:docket_server/src/domain/ordering.dart';
import 'package:test/test.dart';

void main() {
  group('Given sort keys for a line', () {
    test('when a patient joins an empty line then the key is 1024', () {
      expect(Ordering.appendKey(null), 1024);
    });

    test('when a patient joins then the key is the maximum plus 1024', () {
      expect(Ordering.appendKey(3072), 4096);
    });

    test('when re-slotted with offset 3 among five then it lands third', () {
      final keys = [1024.0, 2048.0, 3072.0, 4096.0, 5120.0];
      final p = Ordering.reslot(keys, 3);
      final placed = [...keys, p.sortKey]..sort();
      expect(placed.indexOf(p.sortKey) + 1, 3);
      expect(p.sortKey, 2560);
      expect(p.needsRenumber, isFalse);
    });

    test('when fewer tickets wait than the offset then it goes last', () {
      final p = Ordering.reslot([1024.0], 3);
      expect(p.sortKey, 2048);
    });

    test('when exactly offset minus one wait then it goes last', () {
      final p = Ordering.reslot([1024.0, 2048.0], 3);
      expect(p.sortKey, 3072);
    });

    test('when the offset is 1 then it goes before the front', () {
      final p = Ordering.reslot([1024.0, 2048.0], 1);
      expect(p.sortKey, lessThan(1024));
    });

    test('when the line is empty then it goes first', () {
      expect(Ordering.reslot([], 3).sortKey, 1024);
    });

    test('when the gap collapses under 0.000001 then it asks to renumber', () {
      final p = Ordering.reslot([1.0, 1.0000015], 2);
      expect(p.needsRenumber, isTrue);
    });

    test('when renumbering then keys are evenly spaced in order', () {
      expect(Ordering.renumbered(3), [1024, 2048, 3072]);
    });

    test(
      'when re-slotting repeatedly into the same gap then renumbering is eventually asked',
      () {
        var keys = [1024.0, 2048.0];
        var asked = false;
        for (var i = 0; i < 60 && !asked; i++) {
          final p = Ordering.reslot(keys, 2);
          asked = p.needsRenumber;
          keys = [keys.first, p.sortKey];
        }
        expect(asked, isTrue);
      },
    );
  });
}
