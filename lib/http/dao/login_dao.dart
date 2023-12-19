import 'package:fb_bili/db/hi_cache.dart';
import 'package:fb_bili/http/core/hi_net.dart';
import 'package:fb_bili/http/request/base_request.dart';
import 'package:fb_bili/http/request/login_request.dart';
import 'package:fb_bili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";
  static login(String userName, String passWord) {
    return _send(userName, passWord);
  }

  static registration(
      String userName, String passWord, String imoocId, String orderId) {
    return _send(userName, passWord, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String passWord, {imoocId, orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request
        .add('userName', userName)
        .add('password', passWord)
        .add('imoocId', imoocId ?? "")
        .add('orderId', orderId ?? "");
    var result = await HiNet.getInstance().fire(request);
    print(result);
    if (result['code'] == 0 && result['data'] != null) {
      //保存登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
