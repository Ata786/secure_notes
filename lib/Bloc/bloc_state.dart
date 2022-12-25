import 'dart:io';

class BlocState {}

class SetIndexState extends BlocState {}

class IndexState extends BlocState {
  int index;
  IndexState(this.index);
}

class ImageState extends BlocState {
  File file;
  ImageState(this.file);
}
