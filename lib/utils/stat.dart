class Stat {
  final int id;
  final int urgent;
  final int important;
  final int added;
  final int removed;

  Stat({
    this.id,
    this.urgent,
    this.important,
    this.added,
    this.removed,
  });

  static final String date = DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'urgent': urgent,
      'important': important,
      'added': added,
      'removed': removed
    };
  }
}
