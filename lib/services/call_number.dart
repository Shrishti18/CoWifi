import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  static void call(String number) => launch("tel:$number");
}

void set() {
  GetIt.instance.registerSingleton(CallService());
}
