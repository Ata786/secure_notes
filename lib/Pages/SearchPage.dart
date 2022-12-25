import 'package:flutter/material.dart';
import '../Components/Colors.dart';
import '../Components/EditText.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

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
                    fieldEnable: true
                ),
              ),
              Container(
                height: myHeight / 1.3,
                width: myWidth,
                margin: EdgeInsets.only(top: myHeight / 30),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

