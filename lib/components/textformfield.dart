
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  late TextEditingController? controller = TextEditingController();
  late IconData prefixIcon;
  late bool? obscure;
  Widget? suffixIcon;
  late String labelText;
  late String hintText;
  final String? Function(String?)? validator; // Accepts custom validator function
  String? Function(String?)? onChanged;
  String ? initialValue;
  InputDecoration? decoration;
  bool readonly;
  bool enabled;
  //  Color? fillColor;
  //  bool? filled=false;

  TextFormFieldWidget({
    super.key,
    this.controller,
    required this.prefixIcon,
    required this.hintText,
    required this.labelText,
    this.obscure = false,
    this.suffixIcon,
    this.validator,
    this.initialValue,
    this.onChanged, this.decoration,
    this.readonly=false,
    this.enabled=true,
    //this.fillColor,
    //this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      style:  const TextStyle(
        color: Colors.black,
      ),

      initialValue: initialValue,
      onChanged:onChanged ,
      controller: controller,
      obscureText: obscure ?? false,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon,),
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:  const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:  const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide:  const BorderSide(color: Colors.black),
        ),


        filled: true,
        fillColor:Colors.white,

      ),
      validator:validator,
      readOnly: readonly,
      enabled: enabled,

    );
  }
}
