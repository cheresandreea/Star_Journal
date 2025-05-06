import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_journal/controller/Controller.dart';
import 'package:star_journal/ui/editScreen.dart';

class StarsScreen extends StatelessWidget {
  final Controller controller = Get.find();

  StarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stars'),
      ),
      body: Obx(() {
        if (controller.stars.isEmpty) {
          return Center(
            child: Text('No stars found'),
          );
        }
        return ListView.builder(
          itemCount: controller.stars.length,
          itemBuilder: (context, index) {
            final star = controller.stars[index];
            return ListTile(
              title: Text(star.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('Do you really want to delete this star?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Close the dialog if the user chooses "No"
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete the star if the user chooses "Yes"
                                  controller.deleteStar(star.id);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed('/editStar/${star.id}');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      try {
                        Get.toNamed('/viewStar/${star.id}');
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addStar'); // Navigate to the 'add star' screen
        },
        tooltip: 'Add Star',
        child: Icon(Icons.add),
      ),
    );
  }

}
