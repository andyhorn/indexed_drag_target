import 'dart:async';

import 'package:flutter/foundation.dart';

final class Debounce {
  Debounce(this.milliseconds);

  final int milliseconds;

  Timer? _timer;

  void run(VoidCallback callback) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}
