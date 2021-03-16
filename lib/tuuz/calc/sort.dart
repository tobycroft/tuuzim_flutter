class Sort {
  static List sort(List data, String key) {
    data.sort((left, right) => right[key].compareTo(left[key]));
    return data;
  }

  static List sort_desc(List data, String key) {
    data.sort((left, right) => left[key].compareTo(right[key]));
    return data;
  }
}
