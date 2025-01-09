class Star {
  final int id;
  final String name;
  final double? radius;
  final double? xPosition;
  final double? yPosition;
  final int? temperature;
  final String? galaxy;
  final String? constellation;
  final String? description;

  Star({
    required this.id,
    required this.name,
    this.radius,
    this.xPosition,
    this.yPosition,
    this.temperature,
    this.galaxy,
    this.constellation,
    this.description,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    return Star(
      id: json['id'],
      name: json['name'],
      radius: json['radius'],
      xPosition: json['xPosition'],
      yPosition: json['yPosition'],
      temperature: json['temperature'],
      galaxy: json['galaxy'],
      constellation: json['constellation'],
      description: json['description'],
    );
  }
}