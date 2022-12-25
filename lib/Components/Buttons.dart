import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Function ()? pressed;
  ButtonStyle? buttonStyle;
  String? btText;
  TextStyle? btTextStyle;
  double? btHeight,btWidth;
  Button({Key? key,this.pressed,this.buttonStyle,this.btText,this.btTextStyle,this.btHeight,this.btWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: btHeight,
      width: btWidth,
      child: ElevatedButton(
          onPressed: pressed,
          style: buttonStyle,
          child: Text(btText!,style: btTextStyle,)
      ),
    );
  }
}
