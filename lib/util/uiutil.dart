class UIUtil {
  
  static String formatTime(int hour, int min){
    String formattedHour = "";
    String formattedMin = "";

    formattedHour = "$hour";

    if(hour < 10){
      formattedHour = "0$hour";
    }

    formattedMin = "$min";

    if(min == 0){
      formattedMin = "00";
    }

    return "$formattedHour:$formattedMin";
  } 

  static String formatHour(int hour){
    String formattedHour = "";

    formattedHour = "$hour";

    if(hour < 10){
      formattedHour = "0$hour";
    }

    return formattedHour;
  }

  static String formatStringHour(String hour){
    String formattedHour = "";

    formattedHour = "$hour";

    if(int.parse(hour) < 10){
      formattedHour = "0$hour";
    }

    return formattedHour;
  }

  static formatMin(int min){
    String formattedMin = "";

    formattedMin = "$min";

    if(min == 0){
      formattedMin = "00";
    }

    return formattedMin;
  }

}
