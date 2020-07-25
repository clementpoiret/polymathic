String getAdvice(Map<String, dynamic> task) {
  final bool isImportant = task['important'] == 1;
  final bool isUrgent = task['urgent'] == 1;

  if (isImportant && isUrgent) {
    return 'Do it, now.';
  } else if (isImportant) {
    return 'Schedule it.';
  } else if (isUrgent) {
    return 'Delegate.';
  } else {
    return 'Avoid this task.';
  }
}

int getScore(Map<String, dynamic> task) {
  // todo: improve the score to be more accurate
  int score = 0;

  if (task['important'] == 1) {
    score += 2;
  }

  if (task['urgent'] == 1) {
    score++;
  }

  return score;
}

List<Map<String, dynamic>> sortTasks(List<Map<String, dynamic>> tasks) {
  List<Map<String, dynamic>> sortedTasks = List.from(tasks);
  sortedTasks.sort((a, b) => getScore(b).compareTo(getScore(a)));

  return sortedTasks;
}

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
