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

}