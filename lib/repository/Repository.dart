import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:star_journal/domain/Star.dart';
import 'package:star_journal/repository/IRepository.dart';

class Repository implements IRepository {
  final Database database;

  Repository(this.database);

  static Future<Repository> create() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'star_journal_database.db'),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Star("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "name TEXT NOT NULL, "
              "radius REAL NOT NULL, "
              "xPosition REAL NOT NULL, "
              "yPosition REAL NOT NULL, "
              "temperature INTEGER NOT NULL,"
              "galaxy TEXT NOT NULL, "
              "constellation TEXT NOT NULL, "
              "description TEXT NOT NULL,"
              "syncStatus BOOLEAN NOT NULL"
              ")",
        );
      },
      version: 2,
    );
    final repo = Repository(database);
    if (await repo.getStars().then((value) => value.isEmpty)) {
      await repo.populateStars();
    }
    return Repository(database);
  }

    Future<void> populateStars() async {
      final stars = [
        Star(
          id: 0,
          name: 'Sirius',
          radius: 1.71,
          xPosition: 1.0,
          yPosition: 2.0,
          temperature: 9940,
          galaxy: 'Milky Way',
          constellation: 'Canis Major',
          description: 'The brightest star in the Earth\'s night sky.',
          syncStatus: true,
        ),
        Star(
          id: 0,
          name: 'Betelgeuse',
          radius: 887.0,
          xPosition: 3.0,
          yPosition: 4.0,
          temperature: 3500,
          galaxy: 'Milky Way',
          constellation: 'Orion',
          description: 'A red supergiant star nearing the end of its life.',
          syncStatus: true,
        ),
        Star(
          id: 0,
          name: 'Proxima Centauri',
          radius: 0.1542,
          xPosition: 5.0,
          yPosition: 6.0,
          temperature: 3042,
          galaxy: 'Milky Way',
          constellation: 'Centaurus',
          description: 'The closest known star to the Sun.',
          syncStatus: true,
        ),
      ];

      for (var star in stars) {
        await addStar(star);
      }
    }

    @override
    Future<List<Star>> getStars() async {
      final List<Map<String, dynamic>> maps = await database.query('Star');
      return List.generate(maps.length, (i) {
        return Star(
          id: maps[i]['id'],
          // Provide 0 as fallback
          name: maps[i]['name'],
          // Provide empty string as fallback
          radius: maps[i]['radius'] ?? 0.0,
          // Provide 0.0 as fallback
          xPosition: maps[i]['xPosition'] ?? 0.0,
          // Provide 0.0 as fallback
          yPosition: maps[i]['yPosition'] ?? 0.0,
          // Provide 0.0 as fallback
          temperature: maps[i]['temperature'] ?? 0,
          // Provide 0 as fallback
          galaxy: maps[i]['galaxy'] ?? '',
          // Provide empty string as fallback
          constellation: maps[i]['constellation'] ?? 'Major',
          // Provide empty string as fallback
          description: maps[i]['description'] ??
              '', // Provide empty string as fallback
          syncStatus: maps[i]['syncStatus'] == 1,
        );
      });
    }

    Future<List<Star>> getPendingStars() async {
      final List<Map<String, dynamic>> maps = await database.query(
        'Star',
        where: 'syncStatus = ?',
        whereArgs: ['pending'],
      );
      return maps.map((map) => Star.fromJson(map)).toList();
    }

    @override
    Future<Star> addStar(Star star) async {
      try {
        final id = await database.insert(
          'Star',
          {
            'name': star.name,
            'radius': star.radius,
            'xPosition': star.xPosition,
            'yPosition': star.yPosition,
            'temperature': star.temperature,
            'galaxy': star.galaxy,
            'constellation': star.constellation,
            'description': star.description,
            'syncStatus': 'pending',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return Star(
          id: id,
          name: star.name,
          radius: star.radius,
          xPosition: star.xPosition,
          yPosition: star.yPosition,
          temperature: star.temperature,
          galaxy: star.galaxy,
          constellation: star.constellation,
          description: star.description,
          syncStatus: false
        );
      } catch (e) {
        throw Exception('Failed to add star');
      }
    }

    @override
    Future<Star> updateStar(Star star) async {
      try {
        await database.update(
          'Star',
          {
            'name': star.name,
            'radius': star.radius,
            'xPosition': star.xPosition,
            'yPosition': star.yPosition,
            'temperature': star.temperature,
            'galaxy': star.galaxy,
            'constellation': star.constellation,
            'description': star.description,
            'syncStatus': 0,
          },
          where: "id = ?",
          whereArgs: [star.id],
        );
        return star;
      } catch (e) {
        throw Exception('Failed to update star');
      }
    }

    @override
    Future<void> deleteStar(int id) async {
      try {
        await database.delete(
          'Star',
          where: "id = ?",
          whereArgs: [id],
        );
      } catch (e) {
        throw Exception('Failed to delete star');
      }
    }

    @override
    Future<Star?> getStarById(int id) async {
      try {
        final List<Map<String, dynamic>> maps = await database.query(
          'Star',
          where: "id = ?",
          whereArgs: [id],
        );
        if (maps.isNotEmpty) {
          final row = maps.first;
          return Star(
            id: row['id'],
            name: row['name'],
            radius: row['radius'],
            xPosition: row['xPosition'],
            yPosition: row['yPosition'],
            temperature: row['temperature'],
            galaxy: row['galaxy'],
            constellation: row['constellation'],
            description: row['description'],
            syncStatus: row['syncStatus'] == 1,
          );
        }
        return null;
      } catch (e) {
        throw Exception('Failed to get star');
      }
    }
    Future<void> markAsSynced(int id) async {
      final db = database;
      await db.update(
        'Star',
        {'syncStatus': 1}, // 1 means synced
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  Future<List<Star>> getUnsyncedStars() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Star',
      where: 'syncStatus = ?',
      whereArgs: [0], // 0 means unsynced
    );

    return List.generate(maps.length, (i) {
      return Star(
        id: maps[i]['id'],
        name: maps[i]['name'],
        radius: maps[i]['radius'],
        xPosition: maps[i]['xPosition'],
        yPosition: maps[i]['yPosition'],
        temperature: maps[i]['temperature'],
        galaxy: maps[i]['galaxy'],
        constellation: maps[i]['constellation'],
        description: maps[i]['description'],
        syncStatus: maps[i]['synced'] == 1,
      );
    });
  }
  }