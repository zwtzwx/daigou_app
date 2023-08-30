import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/global_inject.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_binding.dart';

void main() async {
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  WidgetsFlutterBinding.ensureInitialized();

  //传入可能的登录用户
  await dotenv.load(fileName: ".env");
  await GlobalInject.init();
  // 初始化 Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());

  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    //监听事件
    final eventBus = EventBus(sync: true);
    ApplicationEvent.getInstance().event = eventBus;
  }

  @override
  void initState() {
    super.initState();
  }

  PageTransitionsBuilder createTransition() {
    return const CupertinoPageTransitionsBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: (context, child) => GetMaterialApp(
              color: Colors.white,
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.iOS: createTransition(),
                    TargetPlatform.android: createTransition(),
                  },
                ),
                primaryColor: BaseStylesConfig.primary,
                backgroundColor: BaseStylesConfig.bgGray,
                canvasColor: Colors.white,
              ),
              onGenerateRoute: (settings) => Routers.run(settings),
              showSemanticsDebugger: false,
              debugShowCheckedModeBanner: false,
              getPages: Routers.routes,
              initialRoute: Routers.home,
              initialBinding: TabbarBinding(),
              builder: EasyLoading.init(),
            ));
  }
}
