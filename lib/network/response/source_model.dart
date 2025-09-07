class SourceModel {
  final String id;
  final String name;

  SourceModel(this.id, this.name);

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(map['id'] ?? "", map['name'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  static SourceModel fromDbString(String value){
    final parts = value.split('|');
    return SourceModel(parts[0], parts[1]);
  }

  String toDbString() => '$id|$name';
}
