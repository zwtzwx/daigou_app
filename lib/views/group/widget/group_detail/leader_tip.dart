import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/services/group_service.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class LeaderTip extends StatefulWidget {
  const LeaderTip({
    Key? key,
    this.image,
    required this.remark,
    required this.onConfirm,
    required this.id,
  }) : super(key: key);
  final String? image;
  final String remark;
  final Function onConfirm;
  final int id;

  @override
  State<LeaderTip> createState() => _LeaderTipState();
}

class _LeaderTipState extends State<LeaderTip> {
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkNode = FocusNode();
  String? image;

  @override
  void initState() {
    super.initState();
    _remarkController.text = widget.remark;
    if (widget.image != null && widget.image!.isNotEmpty) {
      image = widget.image;
    }
  }

  @override
  void dispose() {
    _remarkNode.dispose();
    super.dispose();
  }

  void onSubmit() async {
    EasyLoading.show();
    var res = await GroupService.onGroupRemarkChange(widget.id, {
      'remark': _remarkController.text,
      'images': image != null && image!.isNotEmpty ? [image] : [],
    });
    EasyLoading.dismiss();
    if (res['ok']) {
      EasyLoading.showSuccess(res['msg']);
      Navigator.pop(context);
      widget.onConfirm();
    } else {
      EasyLoading.showError(res['msg']);
    }
  }

  onUploadImg() async {
    ImageUpload.imagePicker(
      context: context,
      onSuccessCallback: (img) async {
        setState(() {
          image = img;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText(
              str: '延长拼团天数'.ts,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            AppGaps.vGap15,
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  chooseImgCell(),
                  AppGaps.hGap15,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.bgGray,
                      ),
                      child: BaseInput(
                        board: true,
                        controller: _remarkController,
                        focusNode: _remarkNode,
                        autoShowRemove: false,
                        maxLines: 4,
                        maxLength: 300,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        hintText: '请输入团长的要求和团员们需要注意的事项，以便拼团顺利的进行',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppGaps.vGap20,
            SizedBox(
              height: 45,
              child: BeeButton(
                text: '确认',
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseImgCell() {
    return GestureDetector(
      onTap: onUploadImg,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.bgGray,
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ImgItem(
                    'Group/group-5',
                    width: 28,
                  ),
                  AppText(
                    str: '上传图片'.ts,
                    color: AppColors.textGrayC,
                  ),
                ],
              )
            : ImgItem(
                image!,
                width: 100,
              ),
      ),
    );
  }
}
