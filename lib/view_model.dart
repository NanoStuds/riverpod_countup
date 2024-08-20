import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/logic/button_animation_logic.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';
import 'package:riverpod_countup/logic/logic.dart';
import 'package:riverpod_countup/logic/shared_preferences_logic.dart';
import 'package:riverpod_countup/logic/sound_logic.dart';
import 'package:riverpod_countup/provider.dart';

class ViewModel {
  final Logic _logic = Logic();

  final SoundLogic _soundLogic = SoundLogic();
  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    _ref = ref;

    conditionPlus(CountData oldValue, CountData newValue) {
      return oldValue.countUp + 1 == newValue.countUp;
    }

    ValueChangedCondition valueChangedConditionPlus = conditionPlus;

    _buttonAnimationLogicPlus =
        ButtonAnimationLogic(tickerProvider, valueChangedConditionPlus);
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider,
        (CountData oldValue, CountData newValue) {
      return oldValue.countDown + 1 == newValue.countDown;
    });
    _buttonAnimationLogicReset = ButtonAnimationLogic(
        tickerProvider,
        (oldValue, newValue) =>
            newValue.countUp == 0 && newValue.countDown == 0);
    _soundLogic.load();

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset,
      SharedPreferencesLogic(),
    ];

    SharedPreferencesLogic.read().then((value) => {
          _logic.init(value),
          update(),
        });
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlusCombination =>
      _buttonAnimationLogicPlus.animationCombination;

  get animationMinusCombination =>
      _buttonAnimationLogicMinus.animationCombination;

  get animationResetCombination =>
      _buttonAnimationLogicReset.animationCombination;

  void onIncrease() {
    _logic.increase();
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();

    update();
  }

  void update() {
    CountData oldValue = _ref.read(countDataProvider);
    _ref.watch(countDataProvider.notifier).state = _logic.countData;
    CountData newValue = _ref.read(countDataProvider);

    for (var element in notifiers) {
      element.valueChanged(oldValue, newValue);
    }
  }
}
