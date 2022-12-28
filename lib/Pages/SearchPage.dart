import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/Colors.dart';
import '../Components/EditText.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String title = '';

  TextEditingController searchController = TextEditingController();
  List<Color> colors = [Color(0xfffff5e1),Color(0xffe9f5fc),Color(0xffffe9f3),Color(0xfff3f5f7)];


  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: myWidth / 20,left: myWidth / 20),
                    child: Text('Search Notes',style: TextStyle(fontSize: myWidth / 15,),),
                  )),
              Padding(
                padding: EdgeInsets.only(top: myWidth / 20,left: myWidth / 15,right: myWidth / 15),
                child: EditText(
                    controller: searchController,
                    hintText: 'Enter Notes Title',
                    borderSide: BorderSide(color: Color(CustomColor.PRIMARY_COLOR)),
                    borderRadius: BorderRadius.circular(myWidth / 30),
                    fieldEnable: true,
                  prefix: Icon(Icons.search),
                  onChange: (value){
                      setState(() {
                        title = value;
                      });
                  },
                ),
              ),
              Container(
                height: myHeight / 1.3,
                width: myWidth,
                margin: EdgeInsets.only(top: myHeight / 30),
                child: FutureBuilder(
                  future: firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').get(),
                  builder: (context,snapshot){
                    if(snapshot.hasError){
                      return Center(child: Text('Data not loading...'),);
                    }else if(snapshot.hasData){
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 6 / 8
                          ),
                          itemBuilder: (context,index){
                          if(title.isEmpty){
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(myWidth / 70),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(myWidth / 30),
                                    color: colors[index % colors.length]
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: myHeight / 50,),
                                    Center(child: Container(
                                      height: myHeight / 15,
                                      child: Padding(
                                        padding:EdgeInsets.only(left: 5,right: 5),
                                        child: Text(snapshot.data!.docs[index]['title'],
                                          style: TextStyle(
                                            fontSize: myWidth / 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),),
                                    SizedBox(height: myHeight / 60,),
                                    Container(
                                      height: myHeight / 7.5,
                                      child: Padding(
                                        padding:EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          snapshot.data!.docs[index]['Description'],
                                          style: TextStyle(
                                            fontSize: myWidth / 25,
                                          ),
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: myHeight / 50,),
                                    Container(
                                      height: myHeight / 30,
                                      width: myWidth / 2.3,
                                      child: Row(
                                        children: [
                                          Text(snapshot.data!.docs[index]['Data'],textAlign: TextAlign.end,
                                            style: TextStyle(color: Colors.grey),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }if(snapshot.data!.docs[index]['title'].toString().toLowerCase().startsWith(title.toLowerCase())){
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(myWidth / 70),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(myWidth / 30),
                                    color: colors[index % colors.length]
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: myHeight / 50,),
                                    Center(child: Container(
                                      height: myHeight / 15,
                                      child: Padding(
                                        padding:EdgeInsets.only(left: 5,right: 5),
                                        child: Text(snapshot.data!.docs[index]['title'],
                                          style: TextStyle(
                                            fontSize: myWidth / 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),),
                                    SizedBox(height: myHeight / 60,),
                                    Container(
                                      height: myHeight / 7.5,
                                      child: Padding(
                                        padding:EdgeInsets.only(left: 10,right: 10),
                                        child: Text(
                                          snapshot.data!.docs[index]['Description'],
                                          style: TextStyle(
                                            fontSize: myWidth / 25,
                                          ),
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: myHeight / 50,),
                                    Container(
                                      height: myHeight / 30,
                                      width: myWidth / 2.3,
                                      child: Row(
                                        children: [
                                          Text(snapshot.data!.docs[index]['Data'],textAlign: TextAlign.end,
                                            style: TextStyle(color: Colors.grey),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                            return Center();
                          },
                      );
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
                )
              )
            ],
          ),
        ),
      ),
    ));
  }
}
