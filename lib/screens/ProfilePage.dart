import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/auth.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/utils/Herotrans.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({@required this.name});
  final Widget name;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  QuerySnapshot searchSnapShot;
  QuerySnapshot searchSnapShot1;
  DataBaseMethod dataBaseMethod=DataBaseMethod();
  initSearch(){
  dataBaseMethod.getuserNameByemailFinal(email:firebaseAuth.currentUser.email).then((val){
    setState(() {
      searchSnapShot=val;
    });
  });
    dataBaseMethod.getuserDescriptionByemail(firebaseAuth.currentUser.email).then((value){
      setState((){
        searchSnapShot1=  value;
      });
    },
    );
  }
String nameHere;
  Widget textDescription;

  String descriptionhere;

assigning()async{
    setState(() async{
      textDescription=await dataBaseMethod.getuserDescriptionByName1(nameHere);
    });
}

Widget name;
Widget descriptionLast;
@override

  @override
void initState() {
  // TODO: implement initState
  super.initState();
  initSearch();
  print('given');
  assigning();

   name =dataBaseMethod.decodeUserName1(searchSnapShot1);
   descriptionLast =dataBaseMethod.decodeDescription(searchSnapShot1)??Text('fail');

  }
  Widget build(BuildContext context) {
    double width =MediaQuery.of(context).size.width;
    double height =MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBarMain(context,height,width),
        body: Stack(
          children: [
            Column(
              children: [
                 Container(
                height: height/12,),
                Container(
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: height/5,
                        width: width*5/6,
                        child:  Image.asset(
                              'images/download.png',fit: BoxFit.cover,),

                      ),
                    ],
                  ),
                ),
              ],
            ),
           SingleChildScrollView(
             child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height/15,
                      width: width,
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
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Profile',style: TextStyle(fontSize: 35),),
                      ),
                    ),
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.transparent,
                     ),
                     height: height*1/4,
                      width: (width),
                    ),
                    Padding(
                      padding:const EdgeInsets.symmetric(horizontal:8.0),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Container(
                                  child:   SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:widget.name,
                                      //dataBaseMethod.decodeName(searchSnapShot),
                                    ),
                                    //decodeUserName()??widget.name,
                                  height: height/10,
                                  width:width/3,
                                  )
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: ClipOval(
                                      child: CircleAvatar(
                                        child: Image.asset(
                                            'images/Light Green Bulb Children & Kids Logo.jpg'),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Description',style: TextStyle(fontSize: 20),),
                                       Hero(
                                         tag: 'popUp',
                                         child: OutlinedButton(
                                              onPressed: (){
                                                print(nameHere);
                                                var newDescription =Navigator.push(context,
                                                    HeroDialogRoute(builder: (context){
                                                      return PopUpCard(name:nameHere ,email: firebaseAuth.currentUser.email)  ;
                                                    }));



                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(1000),),
                                                  ),
                                                  child:Icon(Icons.list,color: Colors.yellowAccent,)),),
                                       ),
                                    ],
                                  ),
                                  Divider(),
                                  Container(
                                    child:SizedBox(
                                      height: 100,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child:  dataBaseMethod.decodeDescription(searchSnapShot1)??Text('fail')),
                                        ),
                                    //(dataBaseMethod!=null)? textDescription:Text('No Description added'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
           ),

          ],
        ),
      ),
    );
  }
}

// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// LimitedBox(
// child: Image.asset(
// 'images/download.png'),
// ),
// ],
//
//
// ),
class PopUpCard extends StatelessWidget {
  PopUpCard({this.name,this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    double height =MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
    TextEditingController texteditingcontroller =TextEditingController();
    DataBaseMethod dataBaseMethod=DataBaseMethod();
    String description;
    return Center(
      child: Hero(
        tag: 'popUp',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),

          ),
         height:height/2 ,
         width: width/1.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                  child: Container(

                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20)),
                      color: Colors.yellowAccent,
                    ),

                    child: Center(child: Text('Changes',style: TextStyle(color: Colors.grey,fontSize: 20),)),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0,left: 12),
                            child: Text('Description',style: TextStyle(fontSize: 20,color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Material(
                              child:  TextField(
                                onChanged: (value){
                                  description=value;
                                  },
                                controller: texteditingcontroller,
                                maxLines: 6,
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    hintText: 'Write a note...',
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                              onPressed: (){
                                Navigator.pop(context,texteditingcontroller.text);
                               dataBaseMethod.uploadUserDescription(description:texteditingcontroller.text,email: email);
                              },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Save'),
                            ),
                          ),),
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
    );
  }
}
