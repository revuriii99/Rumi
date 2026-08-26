import 'package:flutter/foundation.dart';
import '../data/models/financial_profile_model.dart';
import '../data/models/property_model.dart';
import '../data/models/survey_journal_model.dart';
import '../data/mock/mock_properties.dart';
import '../data/models/financial_evaluation_result.dart';

class AppProvider with ChangeNotifier {
  FinancialProfileModel? _userProfile;
  FinancialEvaluationResult? _lastSnapshot;
  List<PropertyModel> _properties = List.from(mockProperties);
  List<PropertyModel> _savedProperties = [];
  List<SurveyJournalModel> _journals = [];

  FinancialProfileModel? get userProfile => _userProfile;
  FinancialEvaluationResult? get lastSnapshot => _lastSnapshot;
  List<PropertyModel> get properties => _properties;
  List<PropertyModel> get savedProperties => _savedProperties;
  List<SurveyJournalModel> get journals => _journals;

  void setFinancialProfile(FinancialProfileModel profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void saveProperty(PropertyModel property) {
    if (!_savedProperties.any((p) => p.id == property.id)) {
      property.isSaved = true;
      _savedProperties.add(property);
      notifyListeners();
    }
  }

  void evaluateProperty(PropertyModel property) {
    if (_userProfile != null) {
      _lastSnapshot = FinancialEvaluationResult.calculate(
        profile: _userProfile!,
        propertyPrice: property.price,
      );
      notifyListeners();
    }
  }

  void addJournal(SurveyJournalModel journal) {
    _journals.add(journal);
    notifyListeners();
  }
}
