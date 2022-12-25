import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  String? hintText,helperText;
  Color? color,filledColor;
  TextInputType? textInputType;
  bool? filled;
  Icon? prefix,suffix;
  BorderSide borderSide;
  BorderRadius borderRadius;
  TextStyle? hintStyle,helperStyle,textStyle;
  TextEditingController? controller;
  double? editHeight,editWidth;
  int? maxLines;
  int? maxLength;
  Function(String)? onChange;
  bool fieldEnable;

  EditText({Key? key,this.hintText,this.color,this.textInputType,this.filled,this.filledColor,this.prefix,this.suffix,required this.borderSide,required this.borderRadius,this.hintStyle,this.controller,this.editHeight,this.editWidth,this.helperText,this.helperStyle,this.maxLines,this.maxLength,this.onChange,this.textStyle,required this.fieldEnable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: editHeight,
      width: editWidth,
      child: TextFormField(
        enabled: fieldEnable,
        style: textStyle,
        controller: controller,
        maxLines: maxLines,
        keyboardType: textInputType,
        maxLength: maxLength,
        onChanged: onChange,
        decoration: InputDecoration(
          filled: filled,
          fillColor: filledColor,
          prefixIcon: prefix,
          suffix: suffix,
          hintText: hintText,
          hintStyle: hintStyle,
          helperText: helperText,
          helperStyle: helperStyle,
          border: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: borderRadius,
          )
        ),
      ),
    );
  }
}
