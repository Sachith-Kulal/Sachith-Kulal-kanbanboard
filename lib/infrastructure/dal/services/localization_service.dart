import 'dart:ui';

import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('ka', 'KA');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('ka', 'KA');

  // Supported languages
  static final langs = ['English', 'Kannada'];

  // Supported locales
  static final locales = [const Locale('en', 'US'), const Locale('ka', 'KA')];

  // Keys and their translations
  // Translations will be fetched from MultiTranslate Tool
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'all': 'All',
          'toDo': 'To Do',
          'progress': 'Progress',
          'done': 'Done',
          'completed': 'Completed',
          'myProjectKananBoard': 'My Project kanban board',
          'allTasks': 'All Tasks',
          'toDoTasks': 'To Do Tasks',
          'progressTasks': 'Progress Tasks',
          'doneTasks': 'Done Tasks',
          'completedTasks': 'Completed Tasks',
          'createTask': 'Create Task',
          'editAndCommentTask': 'Edit & Comment on Task',
          'taskName': 'Task Name',
          'description': 'Description',
          'save': 'Save',
          'comments': 'Comments',
          'comment': 'Comment',
          'setting': 'Setting',
          'darkMode': 'Dark Mode',
          'language': 'Language',
          'saveComment': 'save comment',
        },
        'ka_KA': {
          'all': 'ಎಲ್ಲಾ',
          'toDo': 'ಮಾಡಲು',
          'progress': 'ಪ್ರಗತಿ',
          'done': 'ಮಾಡಲಾಗಿದೆ',
          'completed': 'ಪೂರ್ಣಗೊಂಡಿದೆ',
          'myProjectKananBoard': 'ನನ್ನ ಪ್ರಾಜೆಕ್ಟ್ ಕಾನ್ಬನ್ ಬೋರ್ಡ್',
          'allTasks': 'ಎಲ್ಲಾ ಕಾರ್ಯಗಳು',
          'toDoTasks': 'ಕಾರ್ಯಗಳನ್ನು ಮಾಡಲು',
          'progressTasks': 'ಪ್ರಗತಿ ಕಾರ್ಯಗಳು',
          'doneTasks': 'ಮುಗಿದ ಕಾರ್ಯಗಳು',
          'completedTasks': 'ಪೂರ್ಣಗೊಂಡ ಕಾರ್ಯಗಳುು',
          'createTask': 'ಕಾರ್ಯವನ್ನು ರಚಿಸಿ',
          'editAndCommentTask': 'ಕಾರ್ಯವನ್ನು ಸಂಪಾದಿಸಿ ಮತ್ತು ಕಾಮೆಂಟ್ ಮಾಡಿ',
          'taskName': 'ಕಾರ್ಯದ ಹೆಸರು',
          'description': 'ವಿವರಣೆ',
          'save': 'ಉಳಿಸಿ',
          'comments': 'ಕಾಮೆಂಟ್‌ಗಳು',
          'comment': 'ಕಾಮೆಂಟ್ ಮಾಡಿ',
          'setting': 'ಸೆಟ್ಟಿಂಗ್',
          'darkMode': 'ಡಾರ್ಕ್ ಮೋಡ್',
          'language': 'ಭಾಷೆ',
          'saveComment': 'ಕಾಮೆಂಟ್ ಉಳಿಸಿ',
        },
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds the locale from the language code
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}
