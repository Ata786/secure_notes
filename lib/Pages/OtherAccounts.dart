import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Firebase/UserModel.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/RequestButton/request_bt_bloc.dart';

import 'Accounts.dart';
import 'Requests.dart';
import 'Friends.dart';


class OtherAccounts extends StatefulWidget {
  const OtherAccounts({Key? key}) : super(key: key);

  @override
  State<OtherAccounts> createState() => Accounts();
}


class Accounts extends State<OtherAccounts> with TickerProviderStateMixin {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot? documents;

  Future<UserModel> getUser()async{
    String id = auth.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('User').doc(id).get();
    String name = documentSnapshot['userName'];
    String url = documentSnapshot['image'];
    String email = documentSnapshot['email'];
    UserModel userModel = UserModel(userId: '',userName: name,url: url,email: email);
    return userModel;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    TabController tabController = TabController(length: 3, vsync: this);

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: myHeight,
            width: myWidth,
            child: Column(
              children: [
                SizedBox(height: myHeight / 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: myHeight / 7,
                      width: myWidth,
                      padding: EdgeInsets.only(left: myWidth / 15),
                      child: Row(
                        children: [
                          FutureBuilder<UserModel>(
                              future: getUser(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Color(0xffd3d3d3))
                                    ),
                                    child: CircleAvatar(
                                      radius: (myHeight / 7) / 2.7,
                                      backgroundColor: Color(CustomColor.PRIMARY_COLOR),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: (myHeight / 7) / 2.8,
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.url,
                                          placeholder: (context, url) => Shimmer.fromColors(
                                              baseColor: Colors.grey[400]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Text('Image',style: TextStyle(fontSize: myHeight / 60))
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                         imageBuilder: (context,provider){
                                            return Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: provider,
                                                  fit: BoxFit.cover
                                                )
                                              ),
                                            );
                                         },
                                        )
                                      ),
                                    ),
                                  );
                                }else{
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Color(0xffd3d3d3))
                                      ),
                                      child: CircleAvatar(
                                        radius: myHeight / 25,
                                      ),
                                    ),
                                  );
                                }
                              }
                          ),
                          SizedBox(width: myWidth / 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: myWidth / 1.8,
                                child: FutureBuilder<UserModel>(
                                    future: getUser(),
                                    builder: (context,snapshot){
                                      if(snapshot.hasData){
                                        return Text(snapshot.data!.userName,style: TextStyle(fontSize: myHeight / 30,fontFamily: CustomColor.PRIMARY_BOLD_FONT));
                                      }else if(snapshot.hasError){
                                        return Text('text error ${snapshot.error}',);
                                      }
                                      else{
                                        return  Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Text('UserName',style: TextStyle(fontSize: myHeight / 30))
                                        );
                                      }
                                    }
                                ),
                              ),
                              Container(
                                width: myWidth / 1.8,
                                child: FutureBuilder<UserModel>(
                                    future: getUser(),
                                    builder: (context,snapshot){
                                      if(snapshot.hasData){
                                        return Text(snapshot.data!.email,style: TextStyle(fontSize: myHeight / 50,fontFamily: CustomColor.PRIMARY_BOLD_FONT));
                                      }else if(snapshot.hasError){
                                        return Text('text error ${snapshot.error}',);
                                      }
                                      else{
                                        return  Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Text('UserName',style: TextStyle(fontSize: myHeight / 60))
                                        );
                                      }
                                    }
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: myHeight / 30,),
                Container(
                  child: TabBar(
                    unselectedLabelStyle: TextStyle(fontSize: myWidth / 25),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color(CustomColor.PRIMARY_COLOR),
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.all(myWidth / 25),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(fontSize: myWidth / 20,fontFamily: CustomColor.PRIMARY_MEDIUM_FONT),
                    controller: tabController,
                      tabs: [
                        Text('Friends'),
                        Text('Requests'),
                        Text('Accounts'),
                      ]
                  ),
                ),
                Container(
                  width: myWidth,
                  height: myHeight / 1.64,
                  child: TabBarView(
                    controller: tabController,
                      children: [
                        setFriends(myHeight,myWidth),
                        setRequests(myHeight,myWidth),
                        setAccounts(myHeight,myWidth),
                      ]
                  ),
                )
              ],
            ),
          ),
        )
    );
  }



}