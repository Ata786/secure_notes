import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

import '../Components/Colors.dart';

Widget setFriends(double myHeight,double myWidth){

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  return Container(
    child:  FutureBuilder(
      future: firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Friends').get(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return  AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(seconds: 1),
                      child: SlideAnimation(
                          verticalOffset: 70.0,
                          horizontalOffset: 10.0,
                          child: Container(
                            height: myHeight / 8,
                            width: myWidth,
                            margin: EdgeInsets.only(right: myWidth / 30,left: myWidth / 30,top: myWidth / 80,bottom: myWidth / 80),
                            child: Card(
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle
                                    ),
                                    padding: EdgeInsets.only(left: myWidth / 30,),
                                    child: CircleAvatar(
                                      radius: myWidth / 15,
                                      backgroundColor: Color(0xffd3d3d3),
                                      child:  CachedNetworkImage(
                                        imageUrl: snapshot.data!.docs[index]['image'],
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
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: myWidth / 30,),
                                  Container(
                                    height: (myHeight / 8) / 2,
                                    width: myWidth / 2.3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data!.docs[index]['userName'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 25),),
                                        Text(snapshot.data!.docs[index]['email'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 30),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ),
                    );
                  }
              )
          );
        }else{
          return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),),);
        }
      },
    ),
  );
}
