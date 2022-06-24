import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/comment_model.dart';
import 'package:jiyun_app_client/services/comment_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';

class CommentCell extends StatefulWidget {
  const CommentCell({Key? key}) : super(key: key);

  @override
  State<CommentCell> createState() => _CommentCellState();
}

class _CommentCellState extends State<CommentCell>
    with AutomaticKeepAliveClientMixin {
  late List<CommentModel> list;
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    getList();
  }

  getList() async {
    var data = await CommentService.getList({'size': 6});
    setState(() {
      list = data['dataList'] ?? [];
      _isLoading = true;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(
        bottom: 30,
        left: 10,
        right: 10,
      ),
      child: _isLoading
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
              ),
              itemBuilder: buildCommentItem,
              itemCount: list.length,
            )
          : Gaps.empty,
    );
  }

  Widget buildCommentItem(BuildContext context, int index) {
    CommentModel model = list[index];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadImage(
            model.images.isNotEmpty ? model.images.first : '',
            fit: BoxFit.cover,
            width: ScreenUtil().screenWidth - 55,
            height: ScreenUtil().setHeight(70),
          ),
          Gaps.vGap10,
          Expanded(
            child: Caption(
              str: model.content,
              fontSize: 12,
              lines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: LoadImage(
                      model.user?.avatar ?? '',
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Gaps.hGap5,
                  SizedBox(
                    width: 50,
                    child: Caption(
                      str: model.country,
                      color: ColorConfig.main,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Caption(
                str: model.createdAt.split(' ').first,
                color: ColorConfig.main,
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
