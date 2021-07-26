import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
 static String sharedpreferrenceUserLoggedInKey ='ISLOGGEDIN';
 static String sharedPreferrenceUserNameKey ='USERNAMEKEY';
 static String sharedPreferrenceEmailKey ='USERMAILKEY';

 //saving data into shared preferrence

static Future <bool>saveuserLoggedIn(bool isUserLoggedIn)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharedpreferrenceUserLoggedInKey,isUserLoggedIn);
}
 static Future <bool>saveuserName(String userName)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   return await prefs.setString(sharedPreferrenceUserNameKey,userName);
 }
 static Future <bool>saveuserEmail(String userEmail)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   return await prefs.setString(sharedPreferrenceUserNameKey,userEmail);
 }

 //getting the data into shared preferrences
 static Future <void>getuserLoggedIn()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool x = await prefs.getBool(sharedpreferrenceUserLoggedInKey)??false;
   return x;
 }
 static  curretUserNameFed(String username){
   sharedPreferrenceUserNameKey = username;
  return sharedPreferrenceUserNameKey;
 }


 static Future <String>getuserName()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String x =  prefs.getString(sharedpreferrenceUserLoggedInKey)??false;
   return x;
 }
 static Future <void>getuserEmail()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool x = await prefs.getString(sharedpreferrenceUserLoggedInKey)??false;
   return x;
 }
}