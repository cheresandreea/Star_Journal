import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';
import 'package:star_journal/repository/Repository.dart';
import 'package:star_journal/repository/RepositoryDB.dart';
import 'package:star_journal/NetworkService.dart';

class RepositoryManager implements IRepository {
  final Repository localRepository;
  final RepositoryDB serverRepository; 

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
    final addedStar = await localRepository.addStar(star);
    print('Added star locally: $addedStar');
    try {
      await serverRepository.addStar(addedStar);
      print('Added star to remote: $addedStar');
    } catch (e) {
      print('Failed to sync star to remote: $e');
    }
    return addedStar;
  }

  @override
  Future<void> deleteStar(int id) async {
    await localRepository.deleteStar(id);
    try {
      await serverRepository.deleteStar(id);
    } catch (e) {
      print('Failed to delete star from remote: $e');
    }
  }

  @override
  Future<Star?> getStarById(int id) async {
    return localRepository.getStarById(id);
  }

  @override
  Future<Star> updateStar(Star star) async {
    final updatedStar = await localRepository.updateStar(star);
    try {
      await serverRepository.updateStar(updatedStar);
    } catch (e) {
      print('Failed to update star on remote: $e');
    }
    return updatedStar;
  }
}
