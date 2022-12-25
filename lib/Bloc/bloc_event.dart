import 'dart:io';

abstract class Event {}

class SetIndexEvent extends Event {}

class IndexEvent extends Event {
  int i;
  IndexEvent(this.i);
}

class ImageEvent extends Event {
  File file;

  ImageEvent(this.file);
}
