import 'package:get/get.dart';
import 'package:star_journal/NetworkService.dart';
import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/Repository.dart';
import 'package:star_journal/repository/RepositoryDB.dart';

class SyncService extends GetxController{
  final Repository localRepository; // Local DB
  final RepositoryDB serverRepository; // Remote DB
  final List<Map<String, dynamic>> syncQueue = [];

  SyncService(this.localRepository, this.serverRepository);

  void startSynchronization() async {
    while (true) {
      await Future.delayed(Duration(seconds: 5)); // Sync every 30 seconds
      await processQueue();
    }
  }
  bool isSyncing = false;
  Future<void> processQueue() async {
    if (isSyncing) return;
    isSyncing = true;
    if (await isOnline()) {
      while (syncQueue.isNotEmpty) {
        final operation = syncQueue.removeAt(0);
        final star = operation['star'] as Star;
        final type = operation['type'] as String;
        try {
          if (type == 'add') {
            await serverRepository.addStar(star);
          } else if (type == 'update') {
            await serverRepository.updateStar(star);
          } else if (type == 'delete') {
            await serverRepository.deleteStar(star.id);
          }
          await localRepository.markAsSynced(star.id);
        } catch (e) {
          print('Failed to sync star: $e');
          syncQueue.add(operation); // Re-add to queue if failed
        }
      }
      await _pullServerChanges();
    }
    isSyncing = false;
  }

  Future<void> _pullServerChanges() async {
    final serverStars = await serverRepository.getStars();
    for (var star in serverStars) {
        await localRepository.updateStar(star);
    }
  }

  Future<bool> isOnline() async {
    NetworkService networkService = NetworkService();
    final connectivityResult = await networkService.isOnline();
    print("Checking if online: $connectivityResult");
    return connectivityResult;
  }

  void enqueueSync(Star star, String type) {
    syncQueue.add({'star': star, 'type': type});
    processQueue();
  }
}