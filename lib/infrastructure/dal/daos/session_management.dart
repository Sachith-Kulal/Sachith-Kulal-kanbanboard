import 'package:shared_preferences/shared_preferences.dart';
import '../services/localization_service.dart';

class SessionManagement{

  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static setSession({ String accessToken ="48776d7deb5aa16c11df7b955e0273fa46069f7e", String projectId ="2339593914", String sectionId =""}) async {
    SharedPreferences prefs = await init();

    await prefs.setString('accessToken', accessToken);
    await prefs.setString('projectId', projectId);
    await prefs.setString('sectionId', sectionId);
    await prefs.setString('Name', "Sachith");
  }
  static setTimer({required String timerTaskId, required int counter}) async {
    SharedPreferences prefs = await init();
    await prefs.setString('timerTaskId', timerTaskId);
    await prefs.setInt('counter', counter);
    await prefs.setBool('timerActive', true);
  }

  static updateTimer({ required int counter}) async {
    SharedPreferences prefs = await init();
    await prefs.setInt('counter', counter);
  }



  static void removeTimer() async {
    SharedPreferences prefs = await init();
    await prefs.remove("timerTaskId");
    await prefs.remove("counter");
    await prefs.remove("timerActive");
  }

  static  Future<String> getProjectId() async {
    SharedPreferences prefs = await init();
    String id = prefs.getString('projectId') ?? "";
    return id;
  }

  static getAccessToken() async {
    SharedPreferences prefs = await init();
    String accessToken = prefs.getString('accessToken') ?? "";
    return accessToken;
  }

  static getName() async {
    SharedPreferences prefs = await init();
    String name = prefs.getString('name') ?? "";
    return name;
  }

  static getSectionId() async {
    SharedPreferences prefs = await init();
    String sectionId = prefs.getString('sectionId') ?? "";
    return sectionId;
  }

  static Future<String> getTimerTaskId() async {
    SharedPreferences prefs = await init();
    String timerTaskId = prefs.getString('timerTaskId') ?? "";
    return timerTaskId;
  }
  static Future<int> getCounter() async {
    SharedPreferences prefs = await init();
    int accessToken = prefs.getInt('counter') ?? 0;
    return accessToken;
  }

  static Future<bool> isTimerActive() async {
    SharedPreferences prefs = await init();
    bool timerActive = prefs.getBool('timerActive') ?? false;
    return timerActive;
  }

  static setSettings({required String language,bool isDarkMode = false}) async {
    SharedPreferences prefs = await init();
    await prefs.setString('language', language);
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  static getLanguage() async {
    SharedPreferences prefs = await init();
    String timerActive = prefs.getString('language') ?? LocalizationService.langs[0];
    return timerActive;
  }
  static isDarkMode() async {
    SharedPreferences prefs = await init();
    bool timerActive = prefs.getBool('isDarkMode') ?? false;
    return timerActive;
  }
}