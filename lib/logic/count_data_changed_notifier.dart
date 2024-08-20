import 'package:riverpod_countup/data/count_data.dart';

typedef ValueChangedCondition = bool Function(
    CountData oldValue, CountData newValue);

mixin class CountDataChangedNotifier {
  void valueChanged(CountData oldValue, CountData newValue) {
    // TODO: implement valueChanged
  }
}
