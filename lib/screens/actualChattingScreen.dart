
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io'as dart ;

class ActualChatScreen extends StatefulWidget {
  static String id = 'actualchatroom';

  ActualChatScreen({ this.recievername, this.chatroomId});

  final String recievername;
  final String chatroomId;

  @override
  _ActualChatScreenState createState() => _ActualChatScreenState();
}

class _ActualChatScreenState extends State<ActualChatScreen> {
  TextEditingController messageController = TextEditingController();
  String currentMessage;
  DataBaseMethod dataBaseMethod = DataBaseMethod();

  sendMessages(String message) {
    Map<String, dynamic> messageData = {
      'messages': message,
      'time': DateTime.now().microsecondsSinceEpoch.toString(),
      'sender': FirebaseAuth.instance.currentUser.email.toString(),
    };

    dataBaseMethod.getConvoMessages(widget.chatroomId, messageData);
  }

  String messageSendingAccount;
  QuerySnapshot snapshotdata;



  identifier(String sendingAccount) {
    if (sendingAccount == FirebaseAuth.instance.currentUser.email) {
      return true;
    } else {
      return false;
    }
  }


  QuerySnapshot searchSnapshot;
  initSearch() {
    dataBaseMethod.getuserDescriptionByName(widget.recievername).then((val) {
      setState(() {
        searchSnapshot = val;
        print(val);
         print('hi 2');
      });

    });
  }
String description ;

  @override

  void initState() {
    print(widget.recievername);

    super.initState();
    dataBaseMethod.getuserDescriptionByName(widget.recievername);
    initSearch();
  }
  decodeDescription(searchSnapshot) {
    return searchSnapshot != null
        ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var temp = searchSnapshot.docs[index];
          description = temp['description']??'hell no';
        print(temp['description']+'----decription');
        return Text(temp['description']);
      },
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_forward, color: Colors.blueAccent),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
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
      body: Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LineGrad,
            ),
            child: InkWell(
              splashColor: Colors.yellowAccent,
              onTap: ()async{
                print('namePressed');
                await decodeDescription(searchSnapshot);
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(20),
                  ),

                    context: context,
                    // ignore: missing_return
                    builder: (context){
                      return
                        Container(
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: DropUp(name: widget.recievername,height: height,width: width,
                            description: description,snapshot: searchSnapshot,))
                      ;
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      widget.recievername ?? 'Reciever',
                      style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('ChatRoom')
                                  .doc(widget.chatroomId)
                                  .collection('chats')
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null)
                                  return CircularProgressIndicator();
                                return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ListView(
                                            reverse: true,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 20.0),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            children: snapshot.data.docs.map<
                                                    Widget>(
                                                (DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data() as Map<String,
                                                          dynamic> ??
                                                      null;
                                              messageSendingAccount =
                                                  data['sender'];

                                              return (snapshot.data != null)
                                                  ? identifier(
                                                          messageSendingAccount)
                                                      ? MessageBubbleus(
                                                          message:
                                                              data['messages'],
                                                          sender:
                                                              data['sender'],

                                                        )
                                                      : MessageBubblethem(
                                                          message:
                                                              data['messages'],
                                                          sender:
                                                              data['sender'],
                                                        )
                                                  : Container();
                                            }).toList()),
                                      ],
                                    ) ??
                                    Container();
                              }) ??
                          Container(),
                    ],
                  ),
                ),
              ) ??
              Container(),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  // ignore: missing_return
                  onChanged: (value) {
                    setState(() {
                      currentMessage = value??null;
                    });
                  },
                  decoration: InputDec.copyWith(
                      hintText: 'Type a message',
                      suffixIcon: IconButton(
                        padding: EdgeInsets.only(right: 8),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          // pickImage();
                        },
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.black45,
                        ),
                        onPressed: () {if(currentMessage!=null){
                          messageController.clear();
                          sendMessages(currentMessage);}
                        })),
              ),
            ],
          ),
        ]),
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context){ return SearchScreen();},),);
      //   },
      // ),
    );
  }
}



class MessageBubbleus extends StatelessWidget {
  MessageBubbleus({this.message, this.sender, this.sendername,});

  final String message;
  final String sender;
  final String sendername;

  @override
  Widget build(BuildContext context) {
    DataBaseMethod dataBaseMethod = DataBaseMethod();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text(
          //   sendername,
          //   style: TextStyle(fontSize: 10),
          // ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubblethem extends StatelessWidget {
  MessageBubblethem({this.message, this.sender, this.sendername});

  final String message;
  final String sender;
  final Widget sendername;

  @override
  Widget build(BuildContext context) {
    returnCardColor(){
      List<Color> Colorget =[Colors.red,Colors.blue,Colors.greenAccent,Colors.pink,Colors.pinkAccent,Colors.white,Colors.deepOrange];
      Random random = Random();
      int randomNumber =random.nextInt(7);
      return Colorget[randomNumber];
    }
    DataBaseMethod dataBaseMethod = DataBaseMethod();
    Color get = returnCardColor();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10,),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DropUp extends StatelessWidget {
  DropUp({this.name,this.description,this.height,this.width,this.snapshot});
  final String name;
  final String description;
  final height;
  final width;
  final  snapshot;
  @override
  Widget build(BuildContext context) {
    DataBaseMethod dataBaseMethod =DataBaseMethod();
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),

      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height/13,
                width: width,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Profile',style: TextStyle(fontSize: 35),),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                  child: Container(
                      height: 150,
                      width: 150,
                      child:
                      Image.asset('images/download.png',fit: BoxFit.cover,))),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text('Hello'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    child: Text(name,style: TextStyle(fontSize: 35,color: Colors.yellowAccent),),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text('Description:',style: TextStyle(fontSize: 15,color: Colors.white),),
                  ),
                ),
              ],
            ),
            LimitedBox(
              child: Container(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: dataBaseMethod.decodeDescription(snapshot),
                        //Text(description??'no description added',style: TextStyle(fontSize: 17,color:(description==null)? Colors.red:Colors.yellowAccent),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
