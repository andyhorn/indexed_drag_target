typedef OnAcceptCallback<T extends Object> = void Function(T item, int index);
typedef OnWillAcceptCallback<T extends Object> =
    bool Function(T item, int index);
