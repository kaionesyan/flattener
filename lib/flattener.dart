Map<String, dynamic> flatten(Map<String, dynamic> target,
    [String prefix = '']) {
  final Map<String, dynamic> result = {};

  target.forEach((key, value) {
    if (value is List) {
      final Map<String, dynamic> tmp = {};

      value.asMap().forEach((index, value) {
        tmp['$key.$index'] = value;
      });

      result.addAll(flatten(tmp, prefix));
    } else if (value is Map) {
      dynamic newPrefix = '';
      newPrefix = '$prefix$key$newPrefix.';

      result.addAll(flatten(value, newPrefix));
    } else {
      result['$prefix$key'] = value;
    }
  });

  return result;
}

Map<String, dynamic> unflatten(Map<String, dynamic> target) {
  dynamic result = {};
  dynamic cur, prop, idx, last, temp;

  target.forEach((key, value) {
    cur = result;
    prop = '';
    last = 0;
    do {
      idx = key.indexOf('.', last);
      temp = key.substring(last, idx != -1 ? idx : null);
      if (cur is List) {
        if (cur.length <= int.parse(prop)) {
          cur.add(null);
        }
        cur = cur[int.parse(prop)] ??
            (cur[int.parse(prop)] = (int.tryParse(temp) != null ? [] : {}));
      } else {
        cur = cur[prop] ?? (cur[prop] = (int.tryParse(temp) != null ? [] : {}));
      }
      prop = temp;
      last = idx + 1;
    } while (idx >= 0);
    if (cur is List) {
      if (cur.length <= int.parse(prop)) {
        cur.add(null);
      }
      cur[int.parse(prop)] = value;
    } else {
      cur[prop] = value;
    }
  });

  return Map<String, dynamic>.from(result['']);
}
