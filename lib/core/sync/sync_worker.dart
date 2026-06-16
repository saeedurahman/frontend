import 'package:frantend/core/sync/sync_manager.dart';
import 'package:injectable/injectable.dart';

/// Background sync worker — polls sync manager when connectivity is restored.
@lazySingleton
class SyncWorker {
  SyncWorker(this._syncManager);

  final SyncManager _syncManager;
  bool _isRunning = false;

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    _syncManager.onConnectivityRestored.listen((_) async {
      await _syncManager.syncAll();
    });
  }

  void stop() {
    _isRunning = false;
  }
}
