class SurveyJournalStore {
  static final List<Map<String, dynamic>> journals = [];

  static void addJournal(Map<String, dynamic> journal) {
    journals.insert(0, journal);
  }

  static void deleteJournal(int index) {
    if (index >= 0 && index < journals.length) {
      journals.removeAt(index);
    }
  }
}
