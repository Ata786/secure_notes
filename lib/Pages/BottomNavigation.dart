import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/Colors.dart';
import '../Bloc/bloc.dart';
import '../Bloc/bloc_event.dart';
import '../Bloc/bloc_state.dart';
import '../Pages/Notes.dart';
import '../Pages/OtherAccounts.dart';
import '../Routes/Routes.dart';


class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key? key}) : super(key: key);

  List list = [Notes(),OtherAccounts()];
  int i = 0;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BlocIndex,BlocState>(
        builder: (context,state){
          if(state is SetIndexState){
            return setUi(context,i,Colors.purple,list);
          }else if(state is IndexState){
            return setUi(context,state.index,Colors.purple,list);
          }else{
            return Center(child: Text('State error'));
          }
        },
    );
  }
}

Widget setUi(BuildContext context,int selectedIndex,Color color,List list){
  return SafeArea(
      child: Scaffold(
        body: list.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
            context.read<BlocIndex>().add(IndexEvent(index));
        },
        currentIndex: selectedIndex,
        selectedIconTheme: IconThemeData(size: 30.0),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book),label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.supervisor_account),label: 'Friends'),
        ],
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: selectedIndex == 0 ?  FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, Routers.CREATE_NOTES);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(CustomColor.PRIMARY_COLOR),
      ) : null
      ),
  );
}

