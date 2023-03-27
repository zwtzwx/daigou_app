import 'dart:convert';
import 'dart:typed_data';

const decoder = Base64Decoder();

class CaptchaModel {
  late Uint8List img;
  late String key;
  CaptchaModel({
    required this.img,
    required this.key,
  });
  CaptchaModel.formJson(Map<String, dynamic> json) {
    img =
        decoder.convert(json['img'].replaceFirst('data:image/png;base64,', ''));
    key = json['key'];
  }
}
