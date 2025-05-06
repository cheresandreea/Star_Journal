import 'package:get/get.dart';
import 'package:star_journal/controller/SyncService.dart';
import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';

class Controller extends GetxController {
  final IRepository localRepository;
  final SyncService syncService;

  Controller(this.localRepository, this.syncService);

  var stars = <Star>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStars();
    syncService.startSynchronization();
  }

  void loadStars() async {
    final fetchedStars = await localRepository.getStars();
    stars.assignAll(fetchedStars);
  }

  Future<List<Star>> getStars() async {
    return localRepository.getStars();
  }

  Future<Star> addStar(Star star) async {
    validateStar(star);
    final addedStar = await localRepository.addStar(star);
    print("Added star: $addedStar");
    stars.add(addedStar);
    syncService.enqueueSync(addedStar, 'add');
    return addedStar;
  }

  Future<void> deleteStar(int? id) async {
    if (id == null || id <= 0) throw Exception('Invalid ID');
    await localRepository.deleteStar(id);
    stars.removeWhere((star) => star.id == id);
    syncService.enqueueSync(Star(id: id, name: '', radius: 0, xPosition: 0, yPosition: 0, temperature: 0, galaxy: '', constellation: '', description: '', syncStatus: false), 'delete');
  }

  Future<Star?> getStarById(int id) async {
    if (id <= 0) throw Exception('Invalid ID');
    return localRepository.getStarById(id);
  }

  Future<Star> updateStar(Star star) async {
    validateStar(star);
    final updatedStar = await localRepository.updateStar(star);
    final index = stars.indexWhere((s) => s.id == star.id);
    if (index != -1) {
      stars[index] = updatedStar;
    }
    syncService.enqueueSync(updatedStar, 'update');
    return updatedStar;
  }

  void validateStar(Star star) {
    if (star.name.isEmpty) throw Exception('Name is required');
    if (star.radius! <= 0) throw Exception('Radius must be greater than 0');
    if (star.xPosition! <= 0) throw Exception('X Position must be greater than 0');
    if (star.yPosition! <= 0) throw Exception('Y Position must be greater than 0');
    if (star.temperature! <= 0) throw Exception('Temperature must be greater than 0');
    if (star.galaxy!.isEmpty) throw Exception('Galaxy is required');
    if (star.constellation!.isEmpty) throw Exception('Constellation is required');
    if (star.description!.isEmpty) throw Exception('Description is required');
  }


}
