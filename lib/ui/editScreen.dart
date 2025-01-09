import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:star_journal/controller/Controller.dart';
import 'package:star_journal/domain/Star.dart';

class EditScreen extends StatefulWidget {
  final String id;

  EditScreen({required this.id});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _radiusController;
  late TextEditingController _xPositionController;
  late TextEditingController _yPositionController;
  late TextEditingController _temperatureController;
  late TextEditingController _galaxyController;
  late TextEditingController _constellationController;
  late TextEditingController _descriptionController;

  String? _errorMessage;

  Star? _star;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<Controller>();
    _star = controller.stars.firstWhere(
          (star) => star.id.toString() == widget.id,
      orElse: () => Star(id: 0, name: 'Not Found'));

    if (_star != null) {
      _nameController = TextEditingController(text: _star!.name);
      _radiusController = TextEditingController(text: _star!.radius?.toString() ?? "");
      _xPositionController = TextEditingController(text: _star!.xPosition?.toString() ?? "");
      _yPositionController = TextEditingController(text: _star!.yPosition?.toString() ?? "");
      _temperatureController = TextEditingController(text: _star!.temperature?.toString() ?? "");
      _galaxyController = TextEditingController(text: _star!.galaxy ?? "");
      _constellationController = TextEditingController(text: _star!.constellation ?? "");
      _descriptionController = TextEditingController(text: _star!.description ?? "");
    }
  }

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

    final updatedStar = Star(
      id: _star!.id,
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
    controller.updateStar(updatedStar);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Star'),
      ),
      body: _star == null
          ? Center(child: Text('Star not found'))
          : Padding(
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
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStar,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
