class TimeUtils {
  static getDisplayTime(int amount, String minute) {
    int minute = amount % 60;
    int hr = amount ~/ 60;
    String hrString = hr > 9 ? '$hr' : "0$hr";
    String minuteString = minute > 9 ? '$minute' : "0$minute";
    return "$hrString:$minuteString Hr";
  }
}
