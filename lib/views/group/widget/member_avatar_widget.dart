import 'package:flutter/material.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/group_model.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';

class MemberAvatarWidget extends StatelessWidget {
  const MemberAvatarWidget({
    Key? key,
    required this.member,
    this.right = 0,
    this.leaderFirst = false,
    this.showMemberTile = true,
  }) : super(key: key);
  final GroupMemberModel member;
  final double right;
  final bool leaderFirst;
  final bool showMemberTile;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: ImgItem(
            member.avatar!,
            width: 55,
            height: 55,
          ),
        ),
        (member.isGroupLeader! == 1 || member.isSubmitted == 1)
            ? Positioned(
                top: -5,
                right: right,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.white),
                    color: (member.isGroupLeader! == 1 &&
                            (member.isSubmitted == 0 || leaderFirst))
                        ? AppColors.primary
                        : AppColors.green,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: AppText(
                    str: (member.isGroupLeader! == 1 &&
                            (member.isSubmitted == 0 || leaderFirst))
                        ? '团长'.ts
                        : '已提交'.ts,
                    fontSize: 10,
                    color: (member.isGroupLeader! == 1 &&
                            (member.isSubmitted == 0 || leaderFirst))
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              )
            : AppGaps.empty,
      ],
    );
  }
}
