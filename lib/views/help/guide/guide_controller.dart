import 'package:huanting_shop/config/base_conctroller.dart';

class GuideController extends GlobalLogic {
  List<Map<String, String>> processList = [
    {'icon': 'ico_vip', 'title': '注册成为会员', 'subTitle': '成为 HAIOU SAAS 会员'},
    {'icon': 'ico_decfk', 'title': '第一次付款', 'subTitle': '在线支付代购商品费用'},
    {'icon': 'ico_yhrk', 'title': '验货入库', 'subTitle': '质量检查与代购商品描述是否一样'},
    {'icon': 'ico_dycfk', 'title': '第二次付款', 'subTitle': '支付国际运费坐等收货'},
  ];
  List<Map<String, dynamic>> protocolList = [
    {
      'icon': 'ico_fwfw',
      'title': '服务范围',
      'subTitle': '我们提供指定第三方平台商品的代购服务，但不承担第三方平台商品的风险',
      'contents': [
        '我们仅为您提供所指定第三方平台商品的代购服务，并不承担商品本身所存在的侵权、质量、数量不对等风险及相关责任。我们的采购员将依据您的订单需求进行人工采购、 沟通确认及售后协调来保护您的利益。如果需要更保障的方式可提前进行验货检查，我们仓库可依据您的要求拆包、拍照、点算数量、加固包装等，需额外收取服务费。'
      ],
    },
    {
      'icon': 'ico_gwlc',
      'title': '购物流程',
      'subTitle': '购物分为代购和寄送两个阶段，有两次支付。下单前建议先做国际运费评估',
      'contents': [
        '【阶段一】您需要支付商品费用以及商品在中国境内的物流费用，我们将为您代购。下单 购买的商品会被寄送到Superbuy中转仓库暂存。商品入库后可以免费暂存90天。您可以累积购买商品并组合打包再进行国际寄送，更省钱。',
        '【阶段二】组合在库商品生成包裹订单，支付该订单的国际物流费用，之后包裹才能进行 跨境运输。',
      ],
    },
    {
      'icon': 'ico_wlfx',
      'title': '物流风险',
      'subTitle': '包裹由第三方物流商承运,受海关政策限制且可能存在物流风险，需要自行评估并承担',
      'contents': [
        '我们作为服务平台，集成众多第三方国际物流商为您提供代购商品和包裹寄送服务，但并不 承担由于海关政策和跨境物流中不可控因素造成的风险，如罚没、损坏、丢件、高峰期寄送 延迟等。 我们将通过提供及时的风险提醒和不断完善的物流保险等措施来辅助您进行风险预估，降低损失概率。'
      ],
    },
  ];
}
