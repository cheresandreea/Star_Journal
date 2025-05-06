import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:star_journal/controller/Controller.dart';
import 'package:star_journal/repository/Repository.dart';
import 'package:star_journal/repository/RepositoryDB.dart';

import 'package:star_journal/ui/addScreen.dart';
import 'package:star_journal/ui/editScreen.dart';
import 'package:star_journal/ui/starsScreen.dart';
import 'package:star_journal/ui/viewScreen.dart';


void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final serverRepository = await RepositoryDB.create();
    final localRepository = await Repository.create();
    // final repositoryManager = RepositoryManager(
    //   localRepository: localRepository,
    //   serverRepository: serverRepository,
    // );

    Get.put(Controller(localRepository, serverRepository));
    // final remoteRepo = await RepositoryDB.create();
    // final networkService = NetworkService();
    //
    // final repo = RepositoryManager(
    //   repository: localRepo,
    //   repositoryDB: remoteRepo,
    //   networkService: networkService,
    // );
    // Get.put(Controller(localRepo));

    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BackgroundWithApp(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      getPages: [
        // Home page (stars screen)
        GetPage(name: '/', page: () => StarsScreen()),
        GetPage(
          name: '/viewStar/:id',
          page: () {
            final String id = Get.parameters['id'] ?? '';
            if (id.isEmpty) {
              return StarsScreen();
            }
            return ViewScreen(id: id);
          },
          binding: BindingsBuilder(() {
          }),
        ),
        GetPage(
          name: '/editStar/:id',
          page: () {
            final String id = Get.parameters['id'] ?? '';
            if (id.isEmpty) {
              return StarsScreen();
            }
            return EditScreen(id: id);
          },
           binding: BindingsBuilder(() {
          }),
        ),
        GetPage(name: '/addStar', page: () => AddScreen()),
      ],
    ));
  } catch(e) {
    print(e);
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('An error occurred'),
        ),
      ),
    ));
  }
}
class BackgroundWithApp extends StatelessWidget {
  const BackgroundWithApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/star.png',
              fit: BoxFit.cover,
            ),
          ),
          StarsScreen(), // This is your actual app content
        ],
      ),
    );
  }
}









