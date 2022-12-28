import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/Components/CheckInternet.dart';
import '../Bloc/CheckBox/check_box_bloc.dart';
import '../Bloc/CheckEmpty/check_empty_bloc.dart';
import '../Bloc/DeleteButton/delete_button_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Firebase/UserModel.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Routes/Routes.dart';
import 'Posts.dart';
import '../Bloc/PostBloc/post_bloc.dart';

class Notes extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChildNotes();
  }
  
}

class ChildNotes extends State<Notes> with TickerProviderStateMixin {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot? documents;


  bool? checkBoxValue = false;
  int check = 1;
  List<Color> colors = [Color(0xfffff5e1),Color(0xffe9f5fc),Color(0xffffe9f3),Color(0xfff3f5f7)];
  List<bool> itemCheck = [];
  QuerySnapshot? document;
  String? docId;
  String? documentId;
  int? ind;
  List<String> ids = [];
  int i = 0;
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          if(tabController!.index == 0){
            i = 0;
          }else{
            i = 1;
          }
        });
      });

    firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').get().then((QuerySnapshot querySnapshot){
      if(querySnapshot.docs.length == 0){
        context.read<CheckEmptyBloc>().add(CheckEmtpyEventEnable(true));
        context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(0));
      }else{
        context.read<CheckEmptyBloc>().add(CheckEmtpyEventEnable(false));
      }
    });
    context.read<CheckBoxBloc>().add(CheckBoxEventFirst(0));

    firebaseFirestore.collection('UserPosts').get().then((QuerySnapshot q) {
      if(q.docs.length == 0){
        context.read<PostBloc>().add(PostChangeEvent(true));
      }else{
        context.read<PostBloc>().add(PostChangeEvent(false));
      }
    });


  }

  Future<UserModel> getUser()async{
    String id = auth.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('User').doc(id).get();
    String name = documentSnapshot['userName'];
    String url = documentSnapshot['image'];
    String email = documentSnapshot['email'];
    UserModel userModel = UserModel(userId: '',userName: name,url: url,email: email);
    return userModel;
  }


  Future<QuerySnapshot> getNotes()async{

    QuerySnapshot doc = await firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').get();

    return doc;
  }


  
  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String,dynamic>{}) as Map;

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: myHeight,
            width: myWidth,
            child: SingleChildScrollView(
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
                                          child:  CachedNetworkImage(
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
                                          ),
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
                                          return Text(snapshot.data!.email,style: TextStyle(fontSize: myHeight / 60,fontFamily: CustomColor.PRIMARY_BOLD_FONT));
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
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: myHeight / 100,),
                  i == 1 ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Padding(
                        padding: EdgeInsets.only(right: myWidth / 20),
                        child: IconButton(onPressed: (){
                          Navigator.pushNamed(context, Routers.SEARCH_PAGE);
                        }, icon: Icon(Icons.search,color: Colors.black,size: myWidth / 13,)))
                  ],) : Row(children: [Container(height: myWidth / 12,)],),
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
                          Text('Posts'),
                          Text('Notes'),
                        ]
                    ),
                  ),
                  Container(
                    width: myWidth,
                    height: myHeight / 1.74,
                    child: TabBarView(
                        controller: tabController,
                        children: [
                          posts(myHeight,myWidth,firebaseFirestore,auth.currentUser!.uid),
                          notes(myHeight,myWidth)
                        ]
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: BlocBuilder<DeleteButtonBloc,DeleteButtonState>(
            builder: (context,state){
              if(state is DeleteButtonInitial){
                return Container();
              }else if(state is DeleteButtonCheckState){
                if(state.i == 1){
                  return FloatingActionButton(
                    onPressed: (){
                      setState(() {

                          documentId = document!.docs[ind!].id;
                          firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').doc(documentId).delete().then((value){
                            context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(0));
                            context.read<CheckBoxBloc>().add(CheckBoxEventFirst(0));
                          });

                        firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').get().then((QuerySnapshot querySnapshot){
                          if(querySnapshot.docs.length == 0){
                            context.read<CheckEmptyBloc>().add(CheckEmtpyEventEnable(true));
                            context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(0));
                          }else{
                            context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(1));
                          }
                        });
                      });
                    },
                    backgroundColor: Color(CustomColor.PRIMARY_COLOR),
                    child: Icon(Icons.delete),
                  );
                }else{
                  return Container();
                }
              }else{
                return Container();
              }
            },
          )
        )
    );
  }

  Widget setCheckBox(int i){
    return Checkbox(
        value: itemCheck[i],
        onChanged: (v){
          setState(() {
            itemCheck[i] = v!;
            ind = i;
          });
        }
    );
  }

  Widget notes(double myHeight,double myWidth){
    return Container(
      height: myHeight / 1.99,
      width: myWidth,
      child: BlocBuilder<CheckEmptyBloc,CheckEmptyState>(
        builder: (context,state){
          if(state is CheckEmptyInitial){
            return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),),);
          }else if(state is CheckEmptyStateEnable){
            if(state.type == true){
              return Container(
                height: myHeight / 5,
                width: myWidth / 2,
                child: Center(child: SvgPicture.asset('assets/not_found.svg'),),);
            }else{
              return FutureBuilder<QuerySnapshot>(
                future: getNotes(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 6 / 8
                      ),
                      itemBuilder: (context,index){
                        itemCheck.add(false);
                        return GestureDetector(
                          onTap: (){
                            QueryDocumentSnapshot data = snapshot.data!.docs[index];

                            Navigator.pushNamed(context, Routers.UPDATE_NOTES,arguments: {
                              'allData': data
                            });
                          },
                          onLongPress: (){
                            document = snapshot.data;
                            if(check == 1){
                              context.read<CheckBoxBloc>().add(CheckBoxEventFirst(1));
                              context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(1));
                            }else{
                              check = 1;
                              context.read<CheckBoxBloc>().add(CheckBoxEventFirst(0));
                              context.read<DeleteButtonBloc>().add(DeleteButtonCheckEvent(0));
                            }
                          },
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
                                      BlocBuilder<CheckBoxBloc,CheckBoxState>(
                                          builder: (context,state){
                                            if(state is CheckBoxInitial){
                                              return Container();
                                            }else if(state is CheckBoxStateFirst){
                                              if(state.i == 1){
                                                check = 0;
                                                return setCheckBox(index);
                                              }else{
                                                return Container();
                                              }
                                            }else{
                                              return Container();
                                            }
                                          }
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text('Data Error ${snapshot.error}'),);
                  }else{
                    return Center(child: CircularProgressIndicator(color: Color(CustomColor.PRIMARY_COLOR),),);
                  }
                },
              );
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

}