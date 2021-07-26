import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GroupChatScreen extends StatefulWidget {
  static String id = 'actualchatroom';

  GroupChatScreen({ this.recievername, this.chatroomId});

  final String recievername;
  final String chatroomId;

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController messageController = TextEditingController();
  String currentMessage;
  DataBaseMethod dataBaseMethod = DataBaseMethod();

  sendMessages(String message) {
    Map<String, dynamic> messageData = {
      'messages': message,
      'time': DateTime.now().microsecondsSinceEpoch.toString(),
      'sender': FirebaseAuth.instance.currentUser.email.toString(),
    };

    dataBaseMethod.getGroupConvoMessages(widget.chatroomId, messageData);
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
    dataBaseMethod.getGroupDescriptionByName(widget.recievername).then((val) {
      setState(() {
        searchSnapshot = val;
        print(val);
        print('hi 2');
      });

    });
  }
  String description ;

  final FirebaseMessaging _firebaseMessaging =FirebaseMessaging.instance;
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
        print(temp['description']);
        return Text(temp['description']);
      },
    )
        : Container();
  }
  List users=[];






  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    Widget memberList(){
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Groups').doc(widget.chatroomId).snapshots(),
          // ignore: missing_return
          builder: (context,snapshot){
            FirebaseFirestore.instance.collection('Groups').doc(widget.chatroomId).get().then(
                    (DocumentSnapshot document){

                  users = List.from(snapshot.data.get('members'));
                  print(users);

                });
            return ListView.builder(
                shrinkWrap: true,
                itemCount: (users.length==null)?2:users.length,
                itemBuilder: (context,index){
                  List refresh=users;
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width:width/1.7 ,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          children: [
                            Icon(Icons.people_alt_outlined,color: Colors.yellowAccent,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(refresh[index]),

                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })??Container();

          });

    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      // FirebaseFirestore.instance.collection('Groups').doc(widget.chatroomId).get().then(
      // (DocumentSnapshot document){
      //
      // users = List.from(snapshot.data.get('members'));
      // print(users);
      //
      // });
      //
      memberList();
    }

List temp2;




    return Scaffold(
      drawerEdgeDragWidth: width/4,
      drawer: Container(
        width: width/1.7,
        child:Drawer(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                        gradient: LineGrad,

                      ),
                      accountName: Text(widget.recievername,style: TextStyle(fontSize: width/12,fontWeight: FontWeight.w700,color: Colors.yellowAccent),),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Text('Features',style:  TextStyle(fontSize: width/22,fontWeight: FontWeight.w700,color: Colors.yellowAccent),),
                  ),
                  Divider(),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.mic,color: Colors.yellowAccent,),
                        title: Text('Voice Message'),
                      ),
                      ListTile(
                        leading: Icon(Icons.camera,color: Colors.yellowAccent,),
                        title: Text('Video Message'),
                      ),
                    ],
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: (){temp2 =users;

                    },
                    child: Container(
                      child: Text('Members',style:  TextStyle(fontSize: width/22,fontWeight: FontWeight.w700,color: Colors.yellowAccent),),
                    ),
                  ),
                  Divider(),

                  Container(
                    child:
                    memberList(),
                  ),


                ],

              ),
            ),

        )
      ),
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
              borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight:Radius.circular(20)),
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
                          .collection('Groups')
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
  DropUp({this.name,this.description,this.height,this.width,this.snapshot,this.members});
  final String name;
  final String description;
  final height;
  final width;
  final  snapshot;
  final List members;
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
                  child: Text('Group',style: TextStyle(fontSize: 35),),
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
                    child: Text(' '),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    child: Text(name,style: TextStyle(fontSize: 35,color: Colors.yellowAccent,fontWeight: FontWeight.w700),),
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
            Divider(),
          ],
        ),
      ),
    );
  }
}
