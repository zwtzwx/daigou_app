import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/user/agent/agent_apply_instruction/controller.dart';

class AgentApplyInstructionView
    extends GetView<AgentApplyInstructionController> {
  const AgentApplyInstructionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: LoadAssetImage(
              'Transport/agent-promt',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 14.w,
            top: ScreenUtil().statusBarHeight + 10.h,
            child: const BackButton(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF58AEFF),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          child: SizedBox(
            height: 38.h,
            child: BeeButton(
              text: '申请成为代理',
              backgroundColor: const Color(0xFF3FA2FF),
              onPressed: () {
                BeeNav.push(BeeNav.agentApply);
              },
            ),
          ),
        ),
      ),
    );
  }
}
