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
  final bool syncStatus;

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
    this.syncStatus = false,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    return Star(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? 'Unnamed Star',
      radius: json['radius']?.toDouble(),
      xPosition: json['xPosition']?.toDouble(),
      yPosition: json['yPosition']?.toDouble(),
      temperature: json['temperature']?.toInt(),
      galaxy: json['galaxy'] ?? '', // Provide a default empty string if missing
      constellation: json['constellation'] ?? '', // Provide a default empty string if missing
      description: json['description'] ?? '', // Provide a default empty string if missing
      syncStatus: json['syncStatus'] == 1,
    );
  }

  @override
  String toString() {
    return 'Star(id: $id, name: $name, radius: $radius, xPosition: $xPosition, yPosition: $yPosition, temperature: $temperature, galaxy: $galaxy, constellation: $constellation, description: $description, syncStatus: $syncStatus)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'radius': radius,
      'xPosition': xPosition,
      'yPosition': yPosition,
      'temperature': temperature,
      'galaxy': galaxy,
      'constellation': constellation,
      'description': description,
      'syncStatus': syncStatus ? 1 : 0,
    };
  }

  Star copyWith({
    int? id,
    String? name,
    double? radius,
    double? xPosition,
    double? yPosition,
    int? temperature,
    String? galaxy,
    String? constellation,
    String? description,
    bool? syncStatus,
  }) {
    return Star(
      id: id ?? this.id,
      name: name ?? this.name,
      radius: radius ?? this.radius,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      temperature: temperature ?? this.temperature,
      galaxy: galaxy ?? this.galaxy,
      constellation: constellation ?? this.constellation,
      description: description ?? this.description,
      syncStatus: syncStatus ?? this.syncStatus, // Default to current syncStatus
    );
  }
}
