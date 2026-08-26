class SurveyJournalModel {
  final String propertyId;
  final String propertyName;
  final DateTime surveyDate;
  final Map<String, String> aspectAnswers;
  final String notes;
  final String? photoPath;

  SurveyJournalModel({
    required this.propertyId,
    required this.propertyName,
    required this.surveyDate,
    required this.aspectAnswers,
    required this.notes,
    this.photoPath,
  });
}
