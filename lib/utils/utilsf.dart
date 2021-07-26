
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Widget appBarMain(BuildContext context,double height,double width) {
  return AppBar(
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
  );
}

const Color kactiveButtonColor = Colors.yellowAccent;
const Color kinactiveButtonColor = Colors.grey;
const InputDec = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintStyle: TextStyle(color: Colors.white24),
  hintText: 'Email',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const LineGrad = LinearGradient(
    colors: [
      const Color(0xFF3366FF),
      Colors.tealAccent,
    ],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp);

class DataBaseMethod {

  // uploadGroupInfo(String groupName,groupInfoMap){
  //
  //   FirebaseFirestore.instance.
  //   collection('Groups').
  //   doc(groupName).
  //   set(groupInfoMap);
  //
  // }

uploadGroupInfo({String name,map}){
  FirebaseFirestore.instance.collection('Groups').doc(name).set(map);

}







  getUserByUserName(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserNameByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  decodeUserName1(QuerySnapshot searchSnapShot1){

    try{return (searchSnapShot1!=null)
        ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapShot1.docs.length,
        itemBuilder: (context,index) {

          var temp = searchSnapShot1.docs[index];
          TextStore textStore=TextStore(widget:Text(temp['name']??'s',style:TextStyle(color: Colors.yellowAccent,fontSize:30)),string: temp['name']);
          return Text(temp['name']??'s',style:TextStyle(color: Colors.yellowAccent,fontSize:30));
        }
    )
        :Text('no name');}catch(e){print(e);}
  }




  uploadUserInfo(String name, String email) {
    FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
    });
  }

  createChatRoom(String chatroomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatroomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
getuserDescriptionByName(String name)async{
 return await FirebaseFirestore.instance.collection('UserProfile').where('name',isEqualTo: name).get();

  }
getGroupDescriptionByName(String name)async{
  return await FirebaseFirestore.instance.collection('Groups').where('name',isEqualTo: name).get();

}
  getuserDescriptionByemail(String name)async{
    return await FirebaseFirestore.instance.collection('UserProfile').where('email',isEqualTo: name).get();
  }
  getuserNameByemailFinal({String email})async{
    return await FirebaseFirestore.instance.collection('users').where('email',isEqualTo:email).get();
  }

 Future<Widget> getuserDescriptionByName1(String email)async{
    QuerySnapshot searchSnapshot;
     await FirebaseFirestore.instance.collection('UserProfile').where('email',isEqualTo: email).get().
    then((value) => searchSnapshot=value);

    return (searchSnapshot != null)
        ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var temp = searchSnapshot.docs[index];

        print(temp['description']);
        return (searchSnapshot!=null)?Text(temp['description'],style: TextStyle(color: Colors.white,fontSize: 20),):Text('No Description Set',style: TextStyle(color: Colors.red),);
      },
    )
        : Text('Screwed');

  }


  Future<Widget> getuserNameByNameemail(String email)async{
    QuerySnapshot searchSnapshot;
    await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: email).get().
    then((value) => searchSnapshot=value);

    return (searchSnapshot != null)
        ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var temp = searchSnapshot.docs[index];
        print(temp['name']);
        return (searchSnapshot!=null)?Text(temp['name'],style: TextStyle(color: Colors.white,fontSize: 20),):Text('No Description Set',style: TextStyle(color: Colors.red),);
      },
    )
        : Text('Screwed');

  }


  decodeUserName(QuerySnapshot searchSnapShot){
    try{return (searchSnapShot!=null)
        ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapShot.docs.length,
        itemBuilder: (context,index) {
          var temp = searchSnapShot.docs[index];
         // nameHere=temp['name'];
          return Text(temp['name']??'name',style:TextStyle(color: Colors.yellowAccent,fontSize:30));
        }
    )
        :Text('no name');}catch(e){print(e);}
  }


  uploadUserDescription({String description,String email}){
    FirebaseFirestore.instance.collection('UserProfile').doc(email).set({
      'description':description,
      'email':email,
    });
  }

  decodeName(searchSnapshot) {
    return (searchSnapshot != null)
        ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var temp = searchSnapshot.docs[index];
        print(temp['name']);
         TextStore textStore=TextStore(widget:Text(temp['name']??' s',style: TextStyle(color: Colors.yellowAccent,fontSize: 25,), ),string: temp['name']);
        return (searchSnapshot!=null)?textStore.widget:Text('No name Set',style: TextStyle(color: Colors.red),);
      },
    )
        : Container();
  }

  decodeDescription(searchSnapshot) {
    return (searchSnapshot != null)
        ? ListView.builder(
           itemCount: searchSnapshot.docs.length,
           shrinkWrap: true,
             itemBuilder: (context, index) {
            var temp = searchSnapshot.docs[index];
             print(temp['description']);
            return (searchSnapshot!=null)?Text(temp['description']??' ',style: TextStyle(color: Colors.white,fontSize: 15,),):Text('No Description Set',style: TextStyle(color: Colors.red),);
      },
    )
        : Container();
  }
  decodeDescriptionNUserName(searchSnapshot) {
    return (searchSnapshot != null)
        ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var temp = searchSnapshot.docs[index];
        print(temp['description']);
           return (searchSnapshot!=null)?Text(temp['Name']??'',style: TextStyle(color: Colors.white,fontSize: 20),):Text('Name',style: TextStyle(color: Colors.red),);
      },
    )
        : Container();
  }

getGroupConvoMessages(String chatroomId, Map mapMessage) {
  FirebaseFirestore.instance
      .collection('Groups')
      .doc(chatroomId)
      .collection('chats')
      .add(mapMessage);}

  getConvoMessages(String chatroomId, Map mapMessage) {
    FirebaseFirestore.instance.collection('ChatRoom').doc(chatroomId).collection('chats').add(mapMessage);
   }






  }
//  static Future<File> pickImage({@required ImageSource source})async{
//     File selectedImage =await ImagePicker.pickImage(source: source) as File;
//     return selectedImage;
// }







  arrangeUserNameGroup(var x) {
    List arrangeing = x;

    for (int i = 0; i < arrangeing.length; i++) {
      for (int j = 0; j < arrangeing.length; i++) {
        if (arrangeing[j] > arrangeing[j + 1]) {
          var temp = arrangeing[j];
          arrangeing[j] = arrangeing[j + 1];
          arrangeing[j + 1] = temp;
        }
      }
    }
  }


getDataName(index) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var index;
  var x = users.doc(index).get();
}
// .// class GetUserName1 extends StatelessWidget {
// //   final String documentId;
// //
// //   GetUserName1(this.documentId);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     CollectionReference users = FirebaseFirestore.instance.collection('users');
// //
// //     return FutureBuilder<DocumentSnapshot>(
// //       future: users.doc(documentId).get(),
// //       builder:
// //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// //
// //         if (snapshot.hasError) {
// //           return Text("Something went wrong");
// //         }
// //
// //         if (snapshot.hasData && !snapshot.data.exists) {
// //           return Text("Document does not exist");
// //         }
// //
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           Map<String, dynamic> data = snapshot.data.data() ;
// //           return Text("Full Name: ${data['full_name']} ${data['last_name']}");
// //         }
// //
// //         return Text("loading");
// //       },
// //     );
// //   }
// // }
// // class GetUserName2 extends StatelessWidget {
// //
// //   GetUserName2({this.documentId});
// //   final String documentId;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     CollectionReference users = FirebaseFirestore.instance.collection('users');
// //
// //     return FutureBuilder<DocumentSnapshot>(
// //       future: users.doc(documentId).get(),
// //       builder:
// //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// //
// //         if (snapshot.hasError) {
// //           return Text("Something went wrong");
// //         }
// //
// //         if (!snapshot.hasData && !snapshot.data.exists) {
// //           return Text("Document does not exist");
// //         }
// //
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           Map<String, dynamic> data = snapshot.data.data() ;
// //           String x=data['name'];
// //           String y=data['email'];
// //           print(x);
// //           print(y);
// //           return SearchResult(
// //             name:x,
// //             emailAddress:y,
// //           );
// //         }
// //
// //         return Text("loading");
// //       },
// //     );
// //   }
// // }
// // Text("Full Name: ${data['full_name']} ${data['last_name']}")
class TextStore{
  TextStore({this.widget,this.string});
 final Widget widget;
  final String string;
}
class AddedElements extends StatelessWidget {
  AddedElements({this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ImageIcon(
                            AssetImage(
                              'images/Light_Green_Bulb_Children___Kids_Logo-removebg-preview.png',
                            ),
                            color: Colors.yellowAccent,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(' ' + name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          color: Colors.yellowAccent,
        )
      ],
    );
  }
}

class GroupList {
  FirebaseAuth firebaseAuth =FirebaseAuth.instance;
  List<IntermediaryWidget> groupMembers = [];
  List<String>memberMail=[];
  int flag = 0;
  addMembers({String x,String email}) {

    for (int i = 0; i < groupMembers.length; i++) {
      if (x == groupMembers[i].name) {
        flag=1;
      }

    }
if(flag==0){
  groupMembers.add(
    IntermediaryWidget(
        widget:    AddedElements(name: x,) ,
        name:x ),
  );
 // memberMail.add(firebaseAuth.currentUser.email);
  memberMail.add(email);


}

  }
  List<String>getMemberList(){
    return memberMail;
  }
functionClearList(){
    memberMail.clear();
    groupMembers.clear();
}
}

class IntermediaryWidget{
  IntermediaryWidget({this.widget,this.name});
  Widget widget;
  String name;
}