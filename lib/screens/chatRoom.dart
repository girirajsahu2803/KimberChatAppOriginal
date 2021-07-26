import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/auth.dart';
import 'package:flutter_app_kimber/screens/groupChatScreen.dart';
import 'package:flutter_app_kimber/screens/groupForming.dart';

import 'package:flutter_app_kimber/utils/Navbar.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helperFunction.dart';
import 'actualChattingScreen.dart';
import 'searchScreen.dart';

import 'dart:math';

class ChatRoom extends StatefulWidget {
  static String id = 'chatroom';

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod authMethod = new AuthMethod();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DataBaseMethod dataBaseMethod = DataBaseMethod();
  QuerySnapshot searchSnapshot;










  createChatRoomandSenduser({String useremail,String reciever}) {
    if (useremail != _firebaseAuth.currentUser.email.toString()) {
      String chatRoomId =
          getChatRoomId(useremail, _firebaseAuth.currentUser.email.toString());
      List<String> users = [
        useremail,
        _firebaseAuth.currentUser.email.toString()
      ];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId,
      };
      DataBaseMethod().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ActualChatScreen(recievername: reciever,chatroomId: chatRoomId,);
      }));
    } else {
      print('you cant send message to yourself');
    }
  }
  QuerySnapshot snapshotdata;
  getCurretUserName(){
    dataBaseMethod.getUserNameByUserEmail(FirebaseAuth.instance.currentUser.email).then((val){
      snapshotdata=val;
    });
    return (snapshotdata!=null)?
        ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.vertical,
          itemCount:snapshotdata.docs.length ,
            // ignore: missing_return
            itemBuilder: (context,index){
            String x = snapshotdata.docs[index]['name'];
            print(x+'Zen');
            return Text(x,style:TextStyle(color: Colors.yellowAccent,fontSize: 20));

            }) :print('null+1');

  }
  returnCardColor(){
    List<Color> Colorget =[Colors.red,Colors.blue,Colors.greenAccent,Colors.pink,Colors.pinkAccent,Colors.white,Colors.deepOrange];
    Random random = Random();
    int randomNumber =random.nextInt(7);
    return Colorget[randomNumber];
  }

  Widget SearchResult({String myName, String name, String emailAddress}) {
    return InkWell(
      splashColor: Colors.tealAccent,
      child: GestureDetector(
        onTap:(){
          createChatRoomandSenduser(useremail: emailAddress,reciever: name);
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ActualChatScreen()));
          String x = HelperFunction.curretUserNameFed(myName);
          print(x + '&2');
        } ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.all(Radius.circular(20)),

            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(

                children: [
                  Container(
                    width:10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: returnCardColor(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          emailAddress,
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  createGroupChatAndSend({String x}){

    Navigator.push(context, MaterialPageRoute(builder: (context){return GroupChatScreen(recievername: x,chatroomId: x,);}));

  }

  Widget SearchGroupResult({String myName, String name, String emailAddress}) {
    return InkWell(
      splashColor: Colors.tealAccent,
      child: GestureDetector(
        onTap:(){
          createGroupChatAndSend(x:name);
        } ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.all(Radius.circular(20)),

            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(

                children: [
                  Container(
                    width:10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: returnCardColor(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Color buttonColor1=kactiveButtonColor;
  Color buttonColor2=kinactiveButtonColor;
  Color buttonColor3=kinactiveButtonColor;
  int pageviewContext ;

 changeButtonColor(int context){
   setState(() {
     pageviewContext=context;
     if(context==0){
       buttonColor1=Colors.yellowAccent;
       buttonColor2=Colors.grey;
       buttonColor3=Colors.grey;
     } else if(context==1){
       buttonColor1=Colors.grey;
       buttonColor2=Colors.yellowAccent;
       buttonColor3=Colors.grey;
     }
     else if(context==2){
       buttonColor1=Colors.grey;
       buttonColor3=Colors.yellowAccent;
       buttonColor2=Colors.grey;
     }
   });

 }
  @override
  Widget build(BuildContext context) {
    double width =MediaQuery.of(context).size.width;
    double height =MediaQuery.of(context).size.height;
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
       getCurretUserName();
    }
    return Scaffold(
      drawerEdgeDragWidth: (MediaQuery.of(context).size.width)/3,
      drawer: NavBarWid(
        width:width/1.3 ,
        name:getCurretUserName(),
        emailAddress: FirebaseAuth.instance.currentUser.email,),
      appBar: AppBar(
        leadingWidth: width/2,
        leading:
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height:height/9,
            width: width/2,
            child: Image.asset('images/KimberLogo-removebg-preview.png',fit: BoxFit.contain),
          ),
        ) ,
        actions: [

        ],
        //title: Text('Kimber'),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  Colors.tealAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height/13,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(onPressed: (){
                  },
                  child: Text('Chats',style: TextStyle(color: buttonColor1,fontSize:  MediaQuery.of(context).size.height/42),),),
                  MaterialButton(onPressed: (){
                  },
                    child: Text('Groups',style: TextStyle(color: buttonColor2,fontSize:  MediaQuery.of(context).size.height/42),),),
                  MaterialButton(onPressed: (){
                  },
                    child: Text('nothing',style: TextStyle(color: buttonColor3,fontSize:  MediaQuery.of(context).size.height/42),),),
                ],
              ),
            ),

          Expanded(
            child: PageView(
               onPageChanged: (context){
                 print(context);
                 changeButtonColor(context);

               },
              scrollDirection: Axis.horizontal,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      new StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            return ListView(
                              physics:const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                                Map<String,dynamic> data = document.data() as Map<String,dynamic>;
                                return (data['email']!= _firebaseAuth.currentUser.email) ?Container(
                                  padding: EdgeInsets.all(2.5),
                                  child: SearchResult(
                                    name: data['name'],
                                    emailAddress: data['email'],
                                    myName: _firebaseAuth.currentUser.email,
                                  ),
                                ):Container();
                              }).toList(),
                            );

                          }),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      new StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('Groups').snapshots(),
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            return ListView(
                              physics:const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                                Map<String,dynamic> data = document.data() as Map<String,dynamic>;
                                return (data['email']!= _firebaseAuth.currentUser.email) ?Container(
                                  padding: EdgeInsets.all(2.5),
                                  child: SearchGroupResult(
                                    name: data['name'],
                                    emailAddress: data['email'],
                                    myName: _firebaseAuth.currentUser.email,
                                  ),
                                ):Container();
                              }).toList(),
                            );

                          }),
                    ],
                  ),
                ),
                Container(
                  child: Center(child: Text('textPage'),),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (pageviewContext==1)?Padding(
              padding: const EdgeInsets.all(4.0),
              child: FloatingActionButton(
                splashColor: Colors.yellowAccent,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GroupForming();
                      },
                    ),
                  );
                },
              ),
            ):Container(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchScreen();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
