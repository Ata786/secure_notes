import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_event.dart';
import 'bloc_state.dart';

class BlocIndex extends Bloc<Event,BlocState>{
  BlocIndex() : super(SetIndexState()){

    on<IndexEvent>((event, emit){
      emit.call(IndexState(event.i));
    });

    on<ImageEvent>((event, emit){
      emit.call(ImageState(event.file));
    });

    on<SetIndexEvent>((event, emit){
      emit.call(SetIndexState());
    });




  }
}
