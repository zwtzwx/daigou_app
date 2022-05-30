import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/services/article_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
 * 投诉建议
 */

class SuggestPage extends StatefulWidget {
  const SuggestPage({Key? key, this.arguments}) : super(key: key);

  final Map? arguments;

  @override
  State<SuggestPage> createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> images = [];

  @override
  void dispose() {
    super.dispose();
  }

  // 上传图片
  void onUploadImage() {
    UploadUtil.imagePicker(
        context: context,
        child: CupertinoActionSheet(
          title: const Text('请选择上传方式'),
          actions: [
            CupertinoActionSheetAction(
              child: const Text('相册'),
              onPressed: () {
                Navigator.pop(context, 'gallery');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('照相机'),
              onPressed: () {
                Navigator.pop(context, 'camera');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
        ),
        onSuccessCallback: (imgUrl) {
          setState(() {
            images.add(imgUrl.toString());
          });
        });
  }

  // 提交
  void onSubmit() {
    String content = _textController.text;
    if (content.isEmpty) {
      EasyLoading.showToast('请输入建议内容');
      return;
    }
    Map<String, dynamic> params = {
      'title': widget.arguments?['title'],
      'content': content,
      'image': images
    };
    EasyLoading.show();
    ArticleService.onSuggestion(params, (data) {
      EasyLoading.dismiss();
      EasyLoading.showSuccess(data.toString())
          .then((value) => Routers.pop(context));
    }, (message) {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConfig.bgGray,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '投诉建议',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      child: Caption(
                        str: '类型：${widget.arguments?['title']}',
                      ),
                    ),
                    buildContent(),
                    buildImages(),
                  ],
                ),
              ),
              Gaps.vGap50,
              SizedBox(
                width: double.infinity,
                height: 40,
                child: MainButton(
                  text: '提交',
                  onPressed: onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        Row(
          children: const [
            Caption(
              str: '*',
              color: ColorConfig.textRed,
            ),
            Caption(
              str: '内容：',
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: ScreenUtil().setHeight(150),
          decoration: BoxDecoration(
            border: Border.all(color: ColorConfig.textGrayC),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: NormalInput(
            controller: _textController,
            focusNode: _focusNode,
            maxLength: 200,
            hintText: '描述一下您的问题，便于我们及时处理！',
          ),
        ),
      ],
    );
  }

  Widget buildImages() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Caption(
            str: '相关图片：',
          ),
        ),
        SizedBox(
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            children: [
              ...buildImgBox(),
              images.length >= 5 ? const SizedBox() : buildUploadBox(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Caption(
            str: '${images.length}/5张',
            fontSize: 14,
            color: ColorConfig.textGray,
          ),
        ),
      ],
    );
  }

  List<Widget> buildImgBox() {
    List<Widget> list = [];
    for (var v in images) {
      list.add(
        GestureDetector(
          onTap: onUploadImage,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: LoadImage(v),
          ),
        ),
      );
    }
    return list;
  }

  Widget buildUploadBox() {
    return GestureDetector(
      onTap: onUploadImage,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.whiteGray,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: ColorConfig.textGrayC9,
              size: 35,
            ),
            Caption(
              str: '选择图片',
              color: ColorConfig.textNormal,
              fontSize: 14,
            )
          ],
        ),
      ),
    );
  }
}
