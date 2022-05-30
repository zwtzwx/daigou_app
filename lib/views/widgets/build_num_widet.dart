import 'package:flutter/material.dart';

class BuildNumWidget {
  static Widget buildNonalCarWidget(
      Widget icons, double width, int num, Color circleColor, Color textColor) {
    bool isShow = num == 0 ? true : false;
    return Stack(
      children: [
        icons,
        Positioned(
          child: Offstage(
            offstage: isShow,
            child: _buildBorderCircle(num, width, circleColor, textColor),
          ),
        ),
      ],
    );
  }

  static Widget buildNonalMsgWidget(
      Widget icons, double width, int num, Color circleColor, Color textColor) {
    bool isShow = num == 0 ? true : false;
    return Stack(
      children: <Widget>[
        icons,
        Positioned(
            right: 0.0,
            child: Offstage(
              offstage: isShow,
              child: _buildCircle(num, width, circleColor, textColor),
            ))
      ],
    );
  }

  static Widget _buildCircle(
      int num, double width, Color? circleColor, Color? textColor) {
    return Container(
        width: width,
        height: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor ?? Colors.white,
        ),
        child: Text(
          num > 99 ? "99+" : num.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 8.0,
              color: textColor ?? Colors.red,
              fontWeight: FontWeight.bold),
        ));
  }

  static Widget _buildBorderCircle(
      int num, double width, Color? circleColor, Color? textColor) {
    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1.0, color: Colors.red),
        color: circleColor ?? Colors.red,
      ),
      child: Text(
        num > 99 ? "99+" : num.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 8.0,
            color: textColor ?? Colors.red,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
