import 'package:event_bus/event_bus.dart';

class ApplicationEvent {
  static ApplicationEvent? _instance;

  late EventBus event;

  //私有构造函数
  ApplicationEvent._internal();

  //保存单例
  static final ApplicationEvent _singleton = ApplicationEvent._internal();

  //工厂构造函数
  factory ApplicationEvent() => _singleton;

  static ApplicationEvent getInstance() {
    _instance ??= ApplicationEvent._internal();

    return _instance!;
  }
}
