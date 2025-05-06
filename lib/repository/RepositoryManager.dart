import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';
import 'package:star_journal/repository/Repository.dart';
import 'package:star_journal/repository/RepositoryDB.dart';
import 'package:star_journal/NetworkService.dart';

class RepositoryManager implements IRepository {
  final Repository localRepository; // Local DB
  final RepositoryDB serverRepository; // Remote DB

  RepositoryManager({
    required this.localRepository,
    required this.serverRepository,
  });

  @override
  Future<List<Star>> getStars() async {
    return localRepository.getStars();
  }

  @override
  Future<Star> addStar(Star star) async {
    // Add to local first for offline storage
    final addedStar = await localRepository.addStar(star);
    print('Added star locally: $addedStar');
    // Optionally, add to remote in the background
    try {
      await serverRepository.addStar(addedStar);
      print('Added star to remote: $addedStar');
    } catch (e) {
      // Handle failure to add remotely (e.g., log or mark for syncing)
      print('Failed to sync star to remote: $e');
    }
    return addedStar;
  }

  @override
  Future<void> deleteStar(int id) async {
    // Delete locally first
    await localRepository.deleteStar(id);
    // Optionally delete remotely in the background
    try {
      await serverRepository.deleteStar(id);
    } catch (e) {
      // Handle failure to delete remotely
      print('Failed to delete star from remote: $e');
    }
  }

  @override
  Future<Star?> getStarById(int id) async {
    return localRepository.getStarById(id);
  }

  @override
  Future<Star> updateStar(Star star) async {
    // Update locally first
    final updatedStar = await localRepository.updateStar(star);
    // Optionally update remotely in the background
    try {
      await serverRepository.updateStar(updatedStar);
    } catch (e) {
      // Handle failure to update remotely
      print('Failed to update star on remote: $e');
    }
    return updatedStar;
  }
}
