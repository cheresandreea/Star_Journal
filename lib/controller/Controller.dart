import 'package:get/get.dart';
import 'package:star_journal/controller/SyncService.dart';
import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';
import 'package:star_journal/repository/RepositoryDB.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../repository/Repository.dart';

class Controller extends GetxController {
  final Repository localRepository;
  final RepositoryDB serverRepository;


  late WebSocketChannel channel;

  Controller(this.localRepository, this.serverRepository);

  var stars = <Star>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStars();
    connectWebSocket();
  }


  void loadStars() async {
    final fetchedStars = await localRepository.getStars();
    stars.assignAll(fetchedStars);
  }

  void refresh() async {
    if (await serverRepository.isOnline()) {
      final pendingStars = await localRepository.getPendingAdds();
      for (final star in pendingStars) {
        try {
          final syncedStar = await serverRepository.addStar(star);
          await localRepository.addStar(syncedStar); // ensure it exists
        } catch (e) {
          print("Failed to sync star: ${star.name}, error: $e");
        }
      }
      await localRepository.clearPendingAdds();
      loadStars(); // refresh UI
      print("Pending stars synced successfully.");
    }
  }



  Future<List<Star>> getStars() async {
    return localRepository.getStars();
  }

  Future<Star> addStar(Star star) async {
    try {
      if (await serverRepository.isOnline()) {
        final addedStar = await serverRepository.addStar(star);
        await localRepository.addStar(addedStar); // save locally
        stars.add(addedStar);
        print("Added star to remote: $addedStar");
        return addedStar;
      } else {
        print("Server is offline, saving star to pending");
        await localRepository.addStar(star); // add to main table
        await localRepository.savePendingAdd(star); // save in PendingAdd
        stars.add(star);
        return star;
      }
    } catch (e) {
      print("Failed to add star: $e");
      Get.snackbar('Error', 'Failed to add star');
      throw Exception('Failed to add star');
    }
  }


  Future<void> deleteStar(int id) async {
    try {
      await localRepository.deleteStar(id);
      stars.removeWhere((star) => star.id == id);
    } catch (e) {
      print("Failed to delete star: $e");
      throw Exception('Failed to delete star');
    }
  }

  Future<Star?> getStarById(int id) async {
    if (id <= 0) throw Exception('Invalid ID');
    return localRepository.getStarById(id);
  }

  Future<Star> updateStar(Star star) async {
    try {
      validateStar(star);
      final updatedStar = await localRepository.updateStar(star);
      print("Updated star on remote: $updatedStar");
    } catch (e) {
      print("Failed to update star: $e");
      throw Exception('Failed to update star');
    }
    return star;
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

  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse('ws:http://192.168.1.253:3000/ws'));
    channel.stream.listen((message) {
      final newStar = Star.fromJson(jsonDecode(message));
      Get.snackbar('New Star Added', 'Star: ${newStar.name}');
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

}
