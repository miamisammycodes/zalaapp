import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _curSlider = 0;
  bool _catLoading = true;
  bool _secLoading = true;
  bool _sliderLoading = true;
  bool _offerLoading = true;
  bool _mostLikeLoading = true;
  bool _showBars = true;
  late AnimationController _animationController;
  get getBars => _showBars;
  get catLoading => _catLoading;
  get curSlider => _curSlider;
  get secLoading => _secLoading;
  get sliderLoading => _sliderLoading;
  get offerLoading => _offerLoading;
  get mostLikeLoading => _mostLikeLoading;
  AnimationController get animationController => _animationController;
  showBars({required bool value}) {
    _showBars = value;
    notifyListeners();
  }

  void setAnimationController(AnimationController animationController) {
    _animationController = animationController;
    notifyListeners();
  }

  setCurSlider(int pos) {
    _curSlider = pos;
    notifyListeners();
  }

  setOfferLoading({required bool loading}) {
    _offerLoading = loading;
    notifyListeners();
  }

  setSliderLoading({required bool loading}) {
    _sliderLoading = loading;
    notifyListeners();
  }

  setSecLoading({required bool loading}) {
    _secLoading = loading;
    notifyListeners();
  }

  setCatLoading({required bool loading}) {
    _catLoading = loading;
    notifyListeners();
  }

  setMostLikeLoading({required bool loading}) {
    _mostLikeLoading = loading;
    notifyListeners();
  }
}
