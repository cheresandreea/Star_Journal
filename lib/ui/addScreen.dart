import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:star_journal/controller/Controller.dart';
import 'package:star_journal/domain/Star.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddStarScreenState createState() => _AddStarScreenState();
}

class _AddStarScreenState extends State<AddScreen> {
  final _nameController = TextEditingController();
  final _radiusController = TextEditingController();
  final _xPositionController = TextEditingController();
  final _yPositionController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _galaxyController = TextEditingController();
  final _constellationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _radiusController.dispose();
    _xPositionController.dispose();
    _yPositionController.dispose();
    _temperatureController.dispose();
    _galaxyController.dispose();
    _constellationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveStar() {
    setState(() {
      _errorMessage = null;
    });

    final name = _nameController.text;
    final radius = double.tryParse(_radiusController.text);
    final xPosition = double.tryParse(_xPositionController.text);
    final yPosition = double.tryParse(_yPositionController.text);
    final temperature = int.tryParse(_temperatureController.text);
    final galaxy = _galaxyController.text;
    final constellation = _constellationController.text;
    final description = _descriptionController.text;

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Name cannot be empty';
      });
      return;
    }

    if (radius == null || radius <= 0) {
      setState(() {
        _errorMessage = 'Radius must be greater than 0';
      });
      return;
    }

    if (xPosition == null || xPosition <= 0) {
      setState(() {
        _errorMessage = 'X Position must be greater than 0';
      });
      return;
    }

    if (yPosition == null || yPosition <= 0) {
      setState(() {
        _errorMessage = 'Y Position must be greater than 0';
      });
      return;
    }

    if (temperature == null || temperature <= 0) {
      setState(() {
        _errorMessage = 'Temperature must be greater than 0';
      });
      return;
    }

    if (galaxy.isEmpty) {
      setState(() {
        _errorMessage = 'Galaxy cannot be empty';
      });
      return;
    }

    if (constellation.isEmpty) {
      setState(() {
        _errorMessage = 'Constellation cannot be empty';
      });
      return;
    }

    if (description.isEmpty) {
      setState(() {
        _errorMessage = 'Description cannot be empty';
      });
      return;
    }

    // Repeat validation for other fields as needed...

    final newStar = Star(
      id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
      name: name,
      radius: radius,
      xPosition: xPosition,
      yPosition: yPosition,
      temperature: temperature,
      galaxy: galaxy,
      constellation: constellation,
      description: description,
    );

    final controller = Get.find<Controller>();
    controller.addStar(newStar); // Add the new star
    Get.back(); // Navigate back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Star'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _radiusController,
                decoration: InputDecoration(labelText: 'Radius'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _xPositionController,
                decoration: InputDecoration(labelText: 'X Position'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _yPositionController,
                decoration: InputDecoration(labelText: 'Y Position'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _temperatureController,
                decoration: InputDecoration(labelText: 'Temperature'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _galaxyController,
                decoration: InputDecoration(labelText: 'Galaxy'),
              ),
              TextField(
                controller: _constellationController,
                decoration: InputDecoration(labelText: 'Constellation'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              // Repeat TextFields for other inputs...
              ElevatedButton(
                onPressed: _saveStar,
                child: Text('Add Star'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
