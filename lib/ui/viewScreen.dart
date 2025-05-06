import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_journal/controller/Controller.dart';
import 'package:star_journal/domain/Star.dart';

class ViewScreen extends StatelessWidget {
  final String id;

  ViewScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.find<Controller>();

    return Scaffold(
      appBar: AppBar(
        title: Text('View Star'),
      ),
      body: Obx(
            () {
          final star = controller.stars.firstWhere(
                  (star) => star.id.toString() == id, orElse: () => Star(id: 0, name: 'Not Found'));

          if (star.id == 0) {
            return Center(child: Text('Star not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${star.name}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Radius: ${star.radius?.toStringAsFixed(2) ?? "Unknown"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Position (X, Y): (${star.xPosition?.toStringAsFixed(2) ?? "Unknown"}, ${star.yPosition?.toStringAsFixed(2) ?? "Unknown"})',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Temperature: ${star.temperature?.toString() ?? "Unknown"} K',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Galaxy: ${star.galaxy ?? "Unknown"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Constellation: ${star.constellation ?? "Unknown"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${star.description ?? "No description available"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Synced: ${star.syncStatus ?? "No description available"}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}
