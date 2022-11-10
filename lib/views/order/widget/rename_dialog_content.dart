import 'package:jiyun_app_client/config/color_config.dart';
import 'package:flutter/material.dart';

double btnHeight = 60;
double borderWidth = 2;

// ignore: must_be_immutable
class RenameDialogContent extends StatefulWidget {
  String? title;
  int? needIdCard;
  int? needClearanceCode;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback? cancelBtnTap;
  VoidCallback? okBtnTap;
  TextEditingController? vc;
  FocusNode? focusVc;
  TextEditingController? vc2;
  FocusNode? focusVc2;
  RenameDialogContent(
      {Key? key,
      required this.title,
      this.cancelBtnTitle = "取消",
      this.okBtnTitle = "确认",
      this.cancelBtnTap,
      this.okBtnTap,
      this.needClearanceCode,
      this.needIdCard,
      this.vc,
      this.vc2})
      : super(key: key);

  @override
  _RenameDialogContentState createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        height: 210,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title!,
                  style: const TextStyle(color: Colors.grey),
                )),
            Gaps.br,
            widget.needIdCard == 1
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black87),
                      controller: widget.vc2,
                      decoration: const InputDecoration(
                          hintText: '请输入身份证号码',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConfig.line),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConfig.line),
                          )),
                    ),
                  )
                : Container(),
            widget.needClearanceCode == 1
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black87),
                      controller: widget.vc2,
                      decoration: const InputDecoration(
                          hintText: '请输入清关号',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConfig.line),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConfig.line),
                          )),
                    ),
                  )
                : Container(),
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Column(
                children: [
                  Container(
                    // 按钮上面的横线
                    width: double.infinity,
                    color: Colors.blue,
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.vc?.text = "";
                          widget.cancelBtnTap!();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style:
                              const TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        // 按钮中间的竖线
                        width: borderWidth,
                        color: Colors.blue,
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.okBtnTap!();
                            Navigator.of(context).pop();
                            widget.vc?.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
