class WelementOrderCounter {
  static const startCounter = 1000;

  static int _orderCounter = startCounter;

  int next() => --_orderCounter;
}
