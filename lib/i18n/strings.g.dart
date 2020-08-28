
// Generated file. Do not edit.

import 'package:flutter/foundation.dart';
import 'package:fast_i18n/fast_i18n.dart';

const String _baseLocale = 'en';
String _locale = _baseLocale;
Map<String, Strings> _strings = {
	'en': Strings.instance,
	'fr': StringsFr.instance,
};

/// use this to get your translations, e.g. t.someKey.anotherKey
Strings get t {
	return _strings[_locale];
}

class LocaleSettings {

	/// use the locale of the device, fallback to default locale
	static Future<void> useDeviceLocale() async {
		_locale = await FastI18n.findDeviceLocale(_strings.keys.toList(), _baseLocale);
	}

	/// set the locale, fallback to default locale
	static void setLocale(String locale) {
		_locale = FastI18n.selectLocale(locale, _strings.keys.toList(), _baseLocale);
	}

	/// get the current locale
	static String get currentLocale {
		return _locale;
	}

	/// get the base locale
	static String get baseLocale {
		return _baseLocale;
	}

	/// get the supported locales
	static List<String> get locales {
		return _strings.keys.toList();
	}
}

class Strings {
	static Strings _instance = Strings();
	static Strings get instance => _instance;

	String get welcome => 'Welcome to';
	String get askName => 'What\'s your name?';
	String hi({@required Object name}) => 'Hi, $name!';
	String get tasks => 'Tasks';
	String get yourTask => 'Your task';
	String get estimatedDuration => 'Estimated duration (hours)';
	String get estimatedDurationHint => 'Number of hours for completion';
	String get hours => 'hour(s)';
	String get reports => 'Reports';
	String get about => 'About';
	String get addTask => 'Add a new task';
	String get enterYourTask => 'Type your task here';
	String get noOngoingTasks => 'There are no ongoing tasks :(';
	String get importantTask => 'Important task';
	String get urgentTask => 'Urgent task';
	String statsForXDays({@required Object n}) => 'Statistics for the last $n days:';
	String get completedTasks => 'Completed Tasks';
	String completedTasksForXDays({@required Object n}) => 'Completed Tasks ($n days)';
	String get productivityIndex => 'Productivity Index (/100)';
	String get urgentAndImportantAbr => 'Urg. & Imp.';
	String get importantAbr => 'Imp.';
	String get urgentAbr => 'Urg.';
	String get noneAbr => 'None';
	String get taskWarningTitle => 'Wow, that\'s a lot!';
	String get taskWarningText => 'You already have 6 scheduled tasks for today.\nAccording to the Ivy Lee Method for productivity, you should focus on those 6 tasks before adding more.';
	String get cancel => 'Cancel';
	String get proceedAnyway => 'Proceed Anyway';
}

class StringsFr extends Strings {
	static StringsFr _instance = StringsFr();
	static StringsFr get instance => _instance;

	@override String get welcome => 'Bienvenue sur';
	@override String get askName => 'Comment vous appelez-vous ?';
	@override String hi({@required Object name}) => 'Salut $name !';
	@override String get yourTask => 'Votre tâche';
	@override String get tasks => 'Tâches';
	@override String get estimatedDuration => 'Durée estimée (heures)';
	@override String get estimatedDurationHint => 'Nombre d\'heures pour la complétion';
	@override String get hours => 'heure(s)';
	@override String get reports => 'Rapports';
	@override String get about => 'A Propos';
	@override String get addTask => 'Ajouter une tâche';
	@override String get enterYourTask => 'Entrez votre tâche ici';
	@override String get noOngoingTasks => 'Il n\'y a pas de tâche en cours :(';
	@override String get importantTask => 'Tâche importante';
	@override String get urgentTask => 'Tâche urgente';
	@override String statsForXDays({@required Object n}) => 'Statistiques sur $n jours :';
	@override String get completedTasks => 'Tâches Complétées';
	@override String completedTasksForXDays({@required Object n}) => 'Tâches Complétées ($n jours)';
	@override String get productivityIndex => 'Index de Productivité (/100)';
	@override String get urgentAndImportantAbr => 'Urg. & Imp.';
	@override String get importantAbr => 'Imp.';
	@override String get urgentAbr => 'Urg.';
	@override String get noneAbr => 'Aucun';
	@override String get taskWarningTitle => 'Wow, c\'est beaucoup !';
	@override String get taskWarningText => 'Vous avez déjà 6 tâches de prévues aujourd\'hui.\nSelon la méthode Ivy Lee, vous devriez vous concentrer sur ces 6 tâches avant d\'en ajouter d\'autres.';
	@override String get cancel => 'Annuler';
	@override String get proceedAnyway => 'Continuer';
}
