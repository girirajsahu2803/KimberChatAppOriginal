import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_kimber/auth.dart';
import 'package:flutter_app_kimber/helperFunction.dart';
import 'package:flutter_app_kimber/screens/Error404.dart';
import 'package:flutter_app_kimber/screens/actualChattingScreen.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
//------------Screens-----------------------------------------------------------
import 'package:flutter_app_kimber/screens/Screen0.dart';
import 'package:flutter_app_kimber/screens/signup.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/screens/forgetPassword.dart';
import 'package:flutter_app_kimber/screens/chatRoom.dart';
import 'package:flutter_app_kimber/screens/Error404.dart';
//-----------------------------------------------------------------------------

class SearchScreen extends StatefulWidget {
  // SearchScreen({this.username});
  // final String username;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethod authMethod=AuthMethod();
  FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  DataBaseMethod dataBaseMethod = DataBaseMethod();

  String search;
  TextEditingController searchbarcontroller = new TextEditingController();

  QuerySnapshot searchSnapshot;
  initSearch() {
    dataBaseMethod.getUserByUserName(search).then((val) {
      setState(() {
        searchSnapshot = val;
        // print('hi 2');
      });
    });
  }

  decodingQuerySnapshot() {

    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var temp = searchSnapshot.docs[index];
              String x =  _firebaseAuth.currentUser.email.toString();
              print(x+'&1');
              return SearchResult(
                name: temp['name'],
                emailAddress: temp['email'],
                myName: _firebaseAuth.currentUser.email.toString(),
              );
            },
          )
        : Container();
  }
createChatRoomandSenduser({String useremail,String reciever}){

   if(useremail!=_firebaseAuth.currentUser.email.toString()){
     String chatRoomId= getChatRoomId(useremail, _firebaseAuth.currentUser.email.toString());
     List<String> users =[
       useremail,
       _firebaseAuth.currentUser.email.toString()
     ];
     Map<String,dynamic>chatRoomMap={
       'users':users,
       'chatroomId':chatRoomId,
     };
     DataBaseMethod().createChatRoom(chatRoomId,chatRoomMap);
     Navigator.push(context, MaterialPageRoute(builder: (context){
       return ActualChatScreen(recievername: reciever,chatroomId: chatRoomId,);
     }));
   }else{
     print('you cant send message to yourself');
   }
}

Widget SearchResult ({String myName, String name, String emailAddress}){
   String nameHere =name;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  emailAddress,
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w700,
                    fontSize: 5,
                  ),
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoomandSenduser(useremail: emailAddress,reciever: nameHere);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ActualChatScreen()));
                String  x =HelperFunction.curretUserNameFed(myName);
                print(x+'&2');
                print(nameHere+'xe');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(1000),
                  ),
                  color: Colors.blueAccent,
                ),
                child: Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBarMain(context,height,width),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              child: TextFormField(
                controller: searchbarcontroller,
                // ignore: missing_return
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDec.copyWith(
                  hintText: 'Search Contacts',
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                    child: IconButton(
                        icon:Icon(Icons.search, color: Colors.white)  ,
                        onPressed: () {
                          initSearch();
                        }),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          decodingQuerySnapshot(),
        ],
      ),
      //body: ,
    );
  }
}

// class SearchResult extends StatelessWidget {
//   SearchResult({this.name, this.emailAddress,this.myName});
//   final String myName;
//   final String name;
//   final String emailAddress;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.white24,
//         borderRadius: BorderRadius.all(Radius.circular(50)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Row(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Text(
//                   emailAddress,
//                   style: TextStyle(
//                     color: Colors.white54,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 )
//               ],
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {
//                 //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ActualChatScreen()));
//                 String  x =HelperFunction.curretUserNameFed(myName);
//                 print(x);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(1000),
//                   ),
//                   color: Colors.blueAccent,
//                 ),
//                 child: Text(
//                   'Message',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return'$b\_$a';
  }else{
    return '$a\_$b';
  }
}
