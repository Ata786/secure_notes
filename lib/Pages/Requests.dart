import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/Bloc/RequestButton/request_bt_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:uuid/uuid.dart';
import '../Components/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget setRequests(double myHeight,double myWidth){
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  return Container(
    child: FutureBuilder(
      future: firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Request').get(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return  AnimationLimiter(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(seconds: 1),
                      child: SlideAnimation(
                          verticalOffset: 100.0,
                          horizontalOffset: 10.0,
                          child: Container(
                            child: requests(myHeight,myWidth,document,index,context),
                          )
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


Widget requests(double myHeight,double myWidth,DocumentSnapshot document,int index,BuildContext context){
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  return  Container(
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
                imageUrl: document['image'],
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
                Text(document['userName'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 25),),
                Text(document['email'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 30),)
              ],
            ),
          ),
          SizedBox(width: myWidth / 30,),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(CustomColor.PRIMARY_COLOR)
                  ),
                  onPressed: ()async{

                    firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Friends').doc(document['userId']).set({
                      'userId': document['userId'],
                      'friendId': document['friendId'],
                      'userName': document['userName'],
                      'image': document['image'],
                      'email': document['email'],
                    }).then((value){
                      firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Request').doc(document['userId']).delete();
                    });

                     DocumentSnapshot s = await firebaseFirestore.collection('User').doc(auth.currentUser!.uid).get();
                     String name = s['userName'];
                     String image = s['image'];
                    String email = s['email'];

                    firebaseFirestore.collection('User').doc(document['userId']).collection('Friends').doc(auth.currentUser!.uid).set({
                      'userId': document['userId'],
                      'friendId': auth.currentUser!.uid,
                      'userName': name,
                      'image': image,
                      'email': email,
                    });

                  },
                  child: Center(child: Text('Accept',style: TextStyle(fontSize: ((myHeight / 8) / 2) / 4),)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  onPressed: ()async{
                    firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Request').doc(document['userId']).delete();

                  },
                  child: Center(child: Text('Reject',style: TextStyle(fontSize: ((myHeight / 8) / 2) / 4),)),
                ),
              ],
            )
          )
        ],
      ),
    ),
  );
}