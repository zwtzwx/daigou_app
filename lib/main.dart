import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/provider/language_provider.dart';
import 'package:jiyun_app_client/storage/language_storage.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/home/home_page.dart';
import 'package:jiyun_app_client/views/main_controller.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  WidgetsFlutterBinding.ensureInitialized();

  //传入可能的登录用户
  var userInfo = await UserStorage.getUserInfo();
  var token = await UserStorage.getToken();
  var language = await LanguageStore.getLanguage();
  await dotenv.load(fileName: ".env");
  // 初始化 Firebase
  await Firebase.initializeApp();
  runApp(MyApp(
    token: token,
    userInfo: userInfo,
    language: language,
  ));

  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
  }
}

class MyApp extends StatefulWidget {
  final String token;
  final UserModel? userInfo;
  final String language;

  const MyApp({
    Key? key,
    this.token = '',
    this.userInfo,
    this.language = 'zh_CN',
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Model(
            widget.token,
            widget.userInfo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(
            widget.language,
          ),
        ),
      ],
      child: Consumer<Model>(
        builder: (context, model, widget) {
          //加载尺寸长度之类的信息
          model.loadLocalization();
          // 加载翻译
          context.read<LanguageProvider>().loadTranslations();
          // 加载翻译
          return ScreenUtilInit(
              designSize: const Size(375, 667),
              builder: (context, child) => MaterialApp(
                    color: Colors.white,
                    theme: ThemeData(
                      pageTransitionsTheme: PageTransitionsTheme(
                        builders: <TargetPlatform, PageTransitionsBuilder>{
                          TargetPlatform.iOS: createTransition(),
                          TargetPlatform.android: createTransition(),
                        },
                      ),
                      primaryColor: ColorConfig.primary,
                      backgroundColor: ColorConfig.bgGray,
                      canvasColor: Colors.white,
                    ),
                    // 监听路由跳转
                    onGenerateRoute: (RouteSettings settings) {
                      return Routers.run(settings);
                    },
                    showSemanticsDebugger: false,
                    debugShowCheckedModeBanner: false,
                    home: const MainController(),
                    builder: EasyLoading.init(),
                    routes: <String, WidgetBuilder>{
                      '/main': (BuildContext context) => const HomePage(),
                    },
                  ));
        },
      ),
    );
  }
}
