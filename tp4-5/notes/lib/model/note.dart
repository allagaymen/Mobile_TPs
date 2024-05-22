class Note {
  late int id;
  late String? description;
  late String? date;
  Note({
    required this.id,
    required this.description,
    required this.date,
  });
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      description: map['description'] as String,
      date: map['date'] as String,
    );
  } 
}
