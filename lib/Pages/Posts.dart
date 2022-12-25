import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../Bloc/PostBloc/post_bloc.dart';
import '../Components/Colors.dart';

Widget posts(double myHeight,double myWidth,FirebaseFirestore firebaseFirestore,String auth){
  return Container(
    child: BlocBuilder<PostBloc,PostState>(
      builder: (context,state){
        if(state == PostInitial){
          return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),));
        }else if(state is PostChangeState){
          if(state.check == true){
            return Container(
              height: myHeight / 5,
              width: myWidth / 2,
              child: Center(child: SvgPicture.asset('assets/not_found.svg'),),);
          }else{
            return StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore.collection('User').doc(auth).collection('Friends').snapshots(),
                builder: (context,snapshot){
              if(snapshot.hasData){
                List<String> list = snapshot.data!.docs.map((e) => e.id).toList();
                list.add(auth);
                return StreamBuilder(
                    stream: firebaseFirestore.collection('UserPosts').where(FieldPath.documentId,whereIn: list).snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Center(child: Text('error is ${snapshot.error}'),);
                      }
                      if(snapshot.hasData){
                        return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 6 / 9.5
                          ),
                          itemBuilder: (context,index){
                            if(snapshot.data!.docs[index].id != list){
                              return Container(
                                  height: myHeight / 2,
                                  width: myHeight / 2,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: (myHeight / 2) / 1.6,
                                          child: Card(
                                            margin: EdgeInsets.all(myWidth / 70),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            elevation: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(height: myHeight / 50,),
                                                Center(
                                                  child: Container(
                                                    height: myHeight / 15,
                                                    child: Padding(
                                                      padding:EdgeInsets.only(left: 5,right: 5),
                                                      child:Text(snapshot.data!.docs[index]['title'],
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
                                                    child:Text(
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
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: CircleAvatar(
                                            radius: (myWidth / 2) / 7,
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data!.docs[index]['imageUrl'],
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
                                      )
                                    ],
                                  )
                              );
                            }else{
                              return SizedBox();
                            };
                          },
                        );
                      }else{
                        return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),),);
                      }
                    });
              }else{
                return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),),);
              }
            });
          }
        }else{
          return Container(
            height: myHeight / 5,
            width: myWidth / 2,
            child: Center(child: SvgPicture.asset('assets/not_found.svg'),),);
        }
      },
    )
  );
}