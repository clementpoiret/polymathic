class Task {
  final int id;
  final String content;
  final int isImportant;
  final int isUrgent;

  Task({
    this.id,
    this.content,
    this.isImportant,
    this.isUrgent,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'important': this.isImportant,
      'urgent': this.isUrgent
    };
  }
}
