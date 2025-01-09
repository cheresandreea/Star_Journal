import 'package:get/get.dart';
import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';

class Controller extends GetxController {
  final IRepository repository;
  Controller(this.repository);

  var stars = <Star>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStars();
  }

  void loadStars() async {
    final fetchedStars = await repository.getStars();
    stars.assignAll(fetchedStars);
  }

  Future<List<Star>> getStars() async {
    return repository.getStars();
  }

  Future<Star> addStar(Star star) async {
    validateStar(star);
    final addedStar = await repository.addStar(star);
    stars.add(addedStar);
    return addedStar;
  }

  Future<void> deleteStar(int? id) async {
    if (id == null || id <= 0) throw Exception('Invalid ID');
    await repository.deleteStar(id);
    stars.removeWhere((star) => star.id == id);
  }

  Future<Star?> getStarById(int id) async {
    if (id <= 0) throw Exception('Invalid ID');
    return repository.getStarById(id);
  }

  Future<Star> updateStar(Star star) async {
    validateStar(star);
    final updatedStar = await repository.updateStar(star);
    final index = stars.indexWhere((s) => s.id == star.id);
    if (index != -1) {
      stars[index] = updatedStar;
    }
    return updatedStar;
  }

  void validateStar(Star star) {
    // Check if required fields are null or empty
    if (star.name.isEmpty) throw Exception('Name is required');

    if (star.radius == null || star.radius! <= 0) {
      throw Exception('Radius must be greater than 0');
    }

    if (star.xPosition == null || star.xPosition! <= 0) {
      throw Exception('X Position must be greater than 0');
    }

    if (star.yPosition == null || star.yPosition! <= 0) {
      throw Exception('Y Position must be greater than 0');
    }

    if (star.temperature == null || star.temperature! <= 0) {
      throw Exception('Temperature must be greater than 0');
    }

    if (star.galaxy == null || star.galaxy!.isEmpty) {
      throw Exception('Galaxy is required');
    }

    if (star.constellation == null || star.constellation!.isEmpty) {
      throw Exception('Constellation is required');
    }

    if (star.description == null || star.description!.isEmpty) {
      throw Exception('Description is required');
    }
  }

}
