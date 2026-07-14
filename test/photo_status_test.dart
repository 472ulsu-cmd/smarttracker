import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/domain/models/order_photo.dart';

void main() {
  group('OrderPhotoStatus', () {
    test('fromApiStatus maps values correctly', () {
      expect(OrderPhotoStatus.fromApiStatus(1), OrderPhotoStatus.pending);
      expect(OrderPhotoStatus.fromApiStatus(2), OrderPhotoStatus.approved);
      expect(OrderPhotoStatus.fromApiStatus(3), OrderPhotoStatus.rejected);
      expect(OrderPhotoStatus.fromApiStatus(null), OrderPhotoStatus.pending);
      expect(OrderPhotoStatus.fromApiStatus(99), OrderPhotoStatus.pending);
    });

    test('labels are correct', () {
      expect(OrderPhotoStatus.pending.label, 'На рассмотрении');
      expect(OrderPhotoStatus.approved.label, 'Одобрено');
      expect(OrderPhotoStatus.rejected.label, 'Отклонено');
    });
  });
}
