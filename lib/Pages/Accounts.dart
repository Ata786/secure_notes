import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Components/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/RequestButton/request_bt_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
QuerySnapshot? userData;

Widget setAccounts(double myHeight,double myWidth){
  return Container(
    child: FutureBuilder(
      future: getUsers(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return  AnimationLimiter(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){

                    DocumentSnapshot d =snapshot.data!.docs[index];

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(seconds: 1),
                      child: SlideAnimation(
                          verticalOffset: 100.0,
                          horizontalOffset: 10.0,
                          child: Container(
                            child: auth.currentUser!.uid == snapshot.data!.docs[index].id ? null : accounts(myHeight,myWidth,d,context,index),
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


Widget accounts(double myHeight,double myWidth,DocumentSnapshot d,BuildContext context,int index){

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  int i = 0;

  return  Container(
    height: myHeight / 10,
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
                imageUrl: d['image'],
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
            width: myWidth / 2.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d['userName'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 25),),
                Text(d['email'],style: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 30),)
              ],
            ),
          ),
          SizedBox(width: myWidth / 20,),
      Container(
        height: (myHeight / 10) / 2,
        width: myWidth / 4.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(CustomColor.PRIMARY_COLOR)
          ),
          onPressed: ()async{


            if(i == 0){
              DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('User').doc(auth.currentUser!.uid).get();
              String name = documentSnapshot['userName'];
              String url = documentSnapshot['image'];
              String email = documentSnapshot['email'];


              firebaseFirestore.collection('User').doc(d.id).collection('Request').doc(auth.currentUser!.uid).set({
                'userId': auth.currentUser!.uid,
                  'friendId': d.id,
                  'userName': name,
                  'image': url,
                  'email': email,
              });


            }else{
              print('unsuccesfull Request');
            }
          },
          child: BlocBuilder<RequestBtBloc,RequestBtState>(
            builder: (context,state){
              if(state is RequestBtInitial){
                return Text('Request',style: TextStyle(fontSize: ((myHeight / 10) / 2) / 4),);
              }else if(state is RequestState){
                if(state.i == 1){
                 return Text('Pending...',style: TextStyle(fontSize: ((myHeight / 10) / 2) / 4),);
                }else{
                  return Text('Request',style: TextStyle(fontSize: ((myHeight / 10) / 2) / 4),);
                }
              }else{
                return Text('Request',style: TextStyle(fontSize: ((myHeight / 10) / 2) / 4),);
              }
            },
          )
        ),
      )
        ],
      ),
    ),
  );
}

Future<QuerySnapshot> getUsers()async{

  QuerySnapshot friends = await firebaseFirestore.collection('User').doc(auth.currentUser!.uid).collection('Friends').get();

  List<String> friendsIds = friends.docs.map((e) => e.id).toList();

  if(friendsIds.isNotEmpty){
    userData = await firebaseFirestore.collection('User').where('id',whereNotIn: friendsIds).get();
  }else{
    userData = await firebaseFirestore.collection('User').get();
  }

  return userData!;
}


