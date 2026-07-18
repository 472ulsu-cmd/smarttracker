import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttracker/data/services/local_photo_store.dart';
import 'package:smarttracker/data/services/sync_config_service.dart';
import 'package:smarttracker/domain/models/sync_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncConfigService', () {
    test('save and load config', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SyncConfigService();
      await service.init();
      await service.save(const SyncConfig(coordinatesPeriodSec: 120, syncPeriodSec: 1800));
      final loaded = service.load();
      expect(loaded.coordinatesPeriodSec, 120);
      expect(loaded.syncPeriodSec, 1800);
    });
  });

  group('LocalPhotoStore', () {
    test('save and get path', () async {
      SharedPreferences.setMockInitialValues({});
      final store = LocalPhotoStore();
      await store.init();
      await store.savePath(42, '/tmp/photo.jpg');
      expect(store.getPath(42), '/tmp/photo.jpg');
    });
  });
}
