class Note {
  int? id;
  String title;
  String description;

  Note({this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      if (id != null) '_id': id,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
    );
  }
}