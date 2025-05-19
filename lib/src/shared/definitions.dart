import 'package:flutter/widgets.dart';

typedef OnWillAcceptCallback<T extends Object> =
    bool Function(T item, int index);
typedef OnAcceptCallback<T extends Object> = void Function(T item, int index);
typedef WidgetBuilder = Widget? Function(BuildContext, int);
typedef IndicatorBuilder = Widget Function(BuildContext, int);
