class SafeHandler {
  static T value<T>(T? value, {T? defaultValue}) {
    return value ?? (defaultValue ?? _getDefault<T>());
  }

  static T _getDefault<T>() {
    if (T == int) {
      return 0 as T;
    } else if (T == double) {
      return 0.0 as T;
    } else if (T == bool) {
      return false as T;
    } else if (T == String) {
      return '' as T;
    } else {
      return null as T;
    }
  }
}
