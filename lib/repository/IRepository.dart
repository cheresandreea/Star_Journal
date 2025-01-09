import '../domain/Star.dart';

abstract class IRepository {
  Future<List<Star>> getStars();
  Future<Star> addStar(Star star);
  Future<Star> updateStar(Star star);
  Future<void> deleteStar(int id);
  Future<Star?> getStarById(int id);
}