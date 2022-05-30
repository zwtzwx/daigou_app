import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProtocolPage extends StatelessWidget {
  const UserProtocolPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.5,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Caption(
          str: '集运用户协议',
          color: ColorConfig.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  child: Caption(
                    str: '集运用户协议',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gaps.vGap15,
                ...buildProtol(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildProtol() {
    List<String> textList = [
      '一、理赔标准',
      '理赔标准大体分为3类，为YDH渠道、BG渠道与第三方物流商渠道',
      '（1）包裹丢失理赔标准：',
      'YDH渠道：',
      '无保险服务',
      '1、退运费+ 赔偿物品申报价值（最高100元）',
      '2、遇到海关查验扣货等不可抗力因素，导致货物没失，不退还已收取的运费并且也无法理赔',
      'BG渠道：'
          '有保险服务',
      '1、未购买保险：退运费+赔偿物品申报价值（最高500元）',
      '2、购买保险：退运费+赔偿物品申报价值（最高1000元）',
      '3、遇到海关查验扣货等不可抗力因素，导致货物没失，不退还已收取的运费并且也无法理赔',
      '（2）内物丢失货或破损理赔标准：',
      'YDH渠道与第三方物流商渠道无任何理赔',
      'BG渠道',
      '1、外包装完好，无任何赔偿',
      '2、外包装破损，需要提供签收视频或提供包裹照片，包括箱子上的快递面单照片、包装破损的照片（3张：破损处、包装箱整体照片、内物剩余货物照片），内物缺失的明细以及价值证明，我们协助向物流公司索赔，具体理赔以物流公司的结果反馈为准',
      '3、不退还已收取的物流运费',
      '二、配送时效',
      '不同的渠道时效不同；在不同月份，时效也有很大差别；我司会每个月在付款界面-渠道选择下更新参考时效，以实际为准。',
      '注：参考时效是指航班正常、清关正常、派送正常的情况下的平均时效；若遇到航班延误，清关异常，派送异常，自然灾害导致时效延迟属于不可抗力事件。',
      '三、货物签收注意事项',
      '1、在签收前先检查货物外包装是否完好，箱子封口是否完好，重量是否有明显差别。',
      '2、若发现发现外包装有明显破损或者撕开过的痕迹，签收时需要拍视屏或拍照留底。',
      '3、包裹签收后，如有任何问题请在签收72小时内反馈给客服，逾期不再受理。',
      '4、箱子外包装完好，且在打包时没有对仓库提出加固要求，里面货品损坏，我司不给予赔偿。',
      '四、转运，集运及代购在海关的相关风险',
      '1、针对代购及转运的敏感品，在提交订单及审核时，我们会为您做出相应海关风险提示，商品寄到我司仓库后，我们也会根据商品实际属性及经验为您推荐风险较低的邮寄方式进行寄送，但仍会有千分之一的包裹会面临扣关的几率（很小机率的退包、罚没、缴税等），且是需要由您自行来承担的！',
      '2、关于申报，请客户如实填写商品信息及商品申报价值，用于出口及进口海关的清关。如因低报，漏报，瞒报等情况造成风险，需要客户自行承担，具体参考“各国关税起征点”，重量越重或者商品价格越高，海关征税的概率也越大，所以建议您尽量避免一个包裹太重或同一种类商品数量太多，以避免缴税，除BEEGOPLUS包税线外;对于最终您的包裹是否会被征税，我们不能给您做100%的保证，还望您能够理解。',
      '五、免责条款',
      '1、易碎品、易损品，无论选择是否加强包装，都只参与遗失索赔，不参与破损索赔。',
      '2、危险品及违禁品不参加索赔（例：压缩气体、液化气体、易燃液体、酸碱性腐蚀品等国家禁运品）。',
      '3、货物在运输途中由于恶劣气候、自然灾害所造成的全部或部分损失，不参与赔偿。',
      '4、货物由于天气、清关时效等不可抗力因素，而导致的过保质期、过保修期、超寄送周期等均不参与赔偿。',
      '5、因海关原因导致需要您配合协助相关操作（包括但不仅限于支付关税），但您拒绝配合使包裹无法按转运服务商承诺时效完成派送，所导致的损失，责任及后果均由您自行承担，转运物流商不承担任何责任。'
    ];
    List<Widget> list = [];
    textList.asMap().keys.forEach((key) {
      bool isTitile = [0, 17, 20, 25, 28].contains(key);
      if (isTitile) {
        list.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Color(0xffeaf1fa),
            border: Border(
              left: BorderSide(
                width: 3,
                color: Color(0xff187ac7),
              ),
            ),
          ),
          child: Text(
            textList[key],
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff187ac7),
            ),
          ),
        ));
      } else {
        list.add(Container(
          alignment: Alignment.centerLeft,
          child: Text(
            textList[key],
            style: const TextStyle(
              height: 1.7,
            ),
          ),
        ));
      }
    });
    return list;
  }
}
