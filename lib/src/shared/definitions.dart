import 'dart:math' show Point;

import 'package:flutter/widgets.dart';

typedef OnWillAcceptCallback<T extends Object> =
    bool Function(T item, int index);
typedef OnAcceptCallback<T extends Object> = void Function(T item, int index);
typedef OnWillAcceptPointCallback<T extends Object> =
    bool Function(T item, Point point);
typedef OnAcceptPointCallback<T extends Object> =
    void Function(T item, Point point);
typedef IndicatorBuilder = Widget Function(BuildContext, Point);
