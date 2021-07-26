import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/auth.dart';

import 'package:flutter_app_kimber/utils/Herotrans.dart';

import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helperFunction.dart';
import 'actualChattingScreen.dart';
import 'searchScreen.dart';

import 'package:intl/intl.dart';


class GroupForming extends StatefulWidget {
  @override
  _GroupFormingState createState() => _GroupFormingState();
}

class _GroupFormingState extends State<GroupForming> {
  @override
  AuthMethod authMethod = AuthMethod();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DataBaseMethod dataBaseMethod = DataBaseMethod();
  QuerySnapshot searchSnapshot;
  String search;
  TextEditingController searchbarcontroller = new TextEditingController();
  bool k = true;

  createChatRoomandSenduser({String useremail, String reciever}) {
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ActualChatScreen(
          recievername: reciever,
          chatroomId: chatRoomId,
        );
      }));
    } else {
      print('you cant send message to yourself');
    }
  }

  bool condition = false;
  GroupList groupList = GroupList();

  Widget SearchResult(
      {String myName, String name, String emailAddress, bool z}) {
    return InkWell(
      splashColor: Colors.tealAccent,
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            k = false;
            groupList.addMembers(x: name, email: emailAddress);
            setState(() {
              condition = true;
            });
          });
        },
        onTap: () {
          createChatRoomandSenduser(useremail: emailAddress, reciever: name);
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ActualChatScreen()));
          String x = HelperFunction.curretUserNameFed(myName);
          print(x + '&2');
        },
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
                Column(
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
                Spacer(),
                (z == true)
                    ? (k == true)
                        ? IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.yellowAccent,
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.done,
                              color: Colors.yellowAccent,
                            ),
                          )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              String x = _firebaseAuth.currentUser.email.toString();
              print(x + '&1');
              return SearchResult(
                z: true,
                name: temp['name'],
                emailAddress: temp['email'],
                myName: _firebaseAuth.currentUser.email.toString(),
              );
            },
          )
        : Container();
  }

  sendGroupInfo(
      {@required String description,
      @required String createdBy,
      @required List x,
      @required String groupName}) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2016-01-25
    Map data = {
      'createdBy': createdBy,
      'description': description,
      'createdOn': formattedDate,
      'members': x,
      'name': groupName
    };

    dataBaseMethod.uploadGroupInfo(name: groupName, map: data);
  }

  buttonGiver(bool condition) {
    if (condition == true) {
      return Material(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Hero(
                tag: 'popInfoBar',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                    child: IconButton(
                     icon: Icon(Icons.check),
                       onPressed: () {
                      List temporary = groupList.memberMail;
                      var x;
                      print(temporary);
                          x=Navigator.push(context, HeroDialogRoute(builder: (context) {
                          return GroupInfoInput(givenlist: groupList.memberMail??null,) ?? Container();
                        }));
                     if(x=true){
                       groupList.groupMembers.clear();
                     //  groupList.memberMail.clear();
                     }
                      // InfoStore infostore=x;
                     //  print(infostore.groupname);

                       // sendGroupInfo(
                       //     description: infostore.description,
                       //     createdBy: _firebaseAuth.currentUser.email,
                       //     x: groupList.memberMail,
                       //     groupName: infostore.groupname);


                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    setState(() {
      k = true;
    });

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: buttonGiver(condition),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    groupList.groupMembers.clear();
                    condition = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      appBar: appBarMain(context, height, width),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
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
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              initSearch();
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: decodingQuerySnapshot(),
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: groupList.groupMembers.length,
                shrinkWrap: true,
                // ignore: missing_return
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (index == 0) {
                              condition = false;
                            }
                            groupList.groupMembers.removeAt(index);
                          });
                        },
                        child: groupList.groupMembers[index].widget),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  new StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return (data['email'] !=
                                    _firebaseAuth.currentUser.email)
                                ? Container(
                                    padding: EdgeInsets.all(2.5),
                                    child: SearchResult(
                                      name: data['name'],
                                      emailAddress: data['email'],
                                      myName: _firebaseAuth.currentUser.email,
                                    ),
                                  )
                                : Container();
                          }).toList(),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddedElements extends StatelessWidget {
  AddedElements({this.name, this.image});

  final String name;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey,
      ),
      child: Row(
        children: [
          (image != null)
              ? Container()
              : Container(
                  height: 10,
                  width: 10,
                  child: ImageIcon(
                    AssetImage(
                      'images/Light Green Bulb Children & Kids Logo.jpg',
                    ),
                  ),
                ),
          Text(name),
        ],
      ),
    );
  }
}
//GroupInfoInput

class GroupInfoInput extends StatelessWidget {
  GroupInfoInput({this.givenlist});
  final List givenlist;
  DataBaseMethod dataBaseMethod=DataBaseMethod();
  sendGroupInfo(
      {@required String description,
        @required String createdBy,
        @required List x,
        @required String groupName}) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2016-01-25
    Map<String, dynamic> data = {
      'createdBy': createdBy,
      'description': description,
      'createdOn': formattedDate,
      'members': x,
      'name': groupName
    };

    dataBaseMethod.uploadGroupInfo(name: groupName, map: data);
  }
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  @override

  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController texteditingcontroller = TextEditingController();
    TextEditingController descriptiontexteditingcontroller =
        TextEditingController();
    DataBaseMethod dataBaseMethod = DataBaseMethod();
    String description;
    return Hero(
      tag: 'popInfoBar',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: height / 2,
            width: width / 1.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      // color: Colors.grey,
                      gradient: new LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.grey,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5.0, left: 12),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellowAccent),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 12, right: 12),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.save),
                                        onPressed: () {
                                          InfoStore infostore = InfoStore(
                                              groupname: texteditingcontroller.text,
                                              description: descriptiontexteditingcontroller.text);
                                          Map<String,String>groupData={'name':texteditingcontroller.text,'description':descriptiontexteditingcontroller.text};


                                      sendGroupInfo(
                                          description: descriptiontexteditingcontroller.text,
                                          createdBy:firebaseAuth.currentUser.email,
                                          x: givenlist,
                                          groupName: texteditingcontroller.text)  ;
                                         // Navigator.pushReplacement(context,
                                         //     MaterialPageRoute(
                                         //         builder: (context){
                                         //           return GroupChatScreen(recievername:texteditingcontroller.text,chatroomId: texteditingcontroller.text,);
                                         //         }));
                                          Navigator.pop(context,true);
                                          givenlist.clear();




                                        },
                                      )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: TextField(
                                  onChanged: (value) {
                                    description = value;
                                  },
                                  controller: texteditingcontroller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      hintText: 'Write a group name',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 12),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.yellowAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Material(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: TextField(
                                  onChanged: (value) {
                                    description = value;
                                  },
                                  controller: descriptiontexteditingcontroller,
                                  maxLines: 6,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      hintText: 'Write a description...',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoStore {
  InfoStore({this.groupname, this.description});

  final String groupname;
  final String description;
}
