import 'package:flutter/material.dart';

class Uihelper {
  static Widget CustomImage({required String img}) {
    return Image.asset("assets/images/$img");
  }

  static Widget CustomText({
    required String text,
    required Color color,
    required FontWeight fontWeight,
    String? fontfamily,
    required double fontSize,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontfamily ?? "regular",
        fontSize: fontSize,
      ),
    );
  }

  static Widget CustomTextField({
    required TextEditingController controller,
    required String text,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      height: 50,
      width: 346,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0XFFC5C5C5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  static Widget CustomButton(
      {required VoidCallback callback, required String text}) {
    return ElevatedButton(
      onPressed: callback,
      child: Text(text),
    );
  }
}