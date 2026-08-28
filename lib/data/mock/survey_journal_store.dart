class SurveyJournalStore {
  static final List<Map<String, String>> journals = [];

  static void addJournal(Map<String, String> item) {
    journals.insert(0, item);
  }

  static void deleteJournal(int index) {
    if (index >= 0 && index < journals.length) {
      journals.removeAt(index);
    }
  }
}
