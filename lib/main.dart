import 'dart:io';

import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/home/home_page.dart';
import 'package:jiyun_app_client/views/main_controller.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
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
  var environment = await UserStorage.getEnvironment();
  await dotenv.load(fileName: ".env");

  runApp(MyApp(
    token: token,
    userInfo: userInfo,
    environment: environment,
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
  final String? environment;

  const MyApp({
    Key? key,
    this.token = '',
    this.userInfo,
    this.environment,
    this.language = 'zh_CN',
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('zh', 'CN');

  _MyAppState() {
    //监听事件
    final eventBus = EventBus(sync: true);
    ApplicationEvent.getInstance().event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    _initLanguage();
    _initFluwx();
  }

  _initFluwx() async {
    await registerWxApi(
        appId: "wx32978f20cd6dd0b0",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://beegoplus.com/");
    var result = await isWeChatInstalled;
    if (kDebugMode) {
      print("is installed $result");
    }
  }

  _initLanguage() {
    var languageArr = widget.language.split('_');
    setState(() {
      locale = Locale(languageArr[0], languageArr[1]);
    });
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
            widget.environment!,
          ),
        ),
      ],
      child: Consumer<Model>(
        builder: (context, model, widget) {
          //加载尺寸长度之类的信息
          model.loadLocalization();
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
                      primaryColor: ColorConfig.warningText,
                      backgroundColor: Colors.white,
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
                      // '/OrderListPage': (BuildContext context) =>
                      //     OrderListPage(),
                    },
                    // locale: _locale,
                    localizationsDelegates: const [
                      // PickerLocalizationsDelegate.delegate,
                      // S.delegate,
                      // GlobalMaterialLocalizations.delegate,
                      // GlobalWidgetsLocalizations.delegate,
                      // GlobalCupertinoLocalizations.delegate,
                    ],
                    // supportedLocales: S.delegate.supportedLocales,
                  ));
        },
      ),
    );
  }
}
