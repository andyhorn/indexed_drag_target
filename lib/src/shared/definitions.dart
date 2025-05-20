import 'package:flutter/widgets.dart';

typedef OnWillAcceptCallback<T extends Object> =
    bool Function(T item, int index);
typedef OnAcceptCallback<T extends Object> = void Function(T item, int index);
typedef IndicatorBuilder = Widget? Function(BuildContext context, int index);
