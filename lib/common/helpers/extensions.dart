extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T item) {
    List<T> list = [];
    list.add(item);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}
