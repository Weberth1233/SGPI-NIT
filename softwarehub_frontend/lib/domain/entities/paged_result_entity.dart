class PagedResultEntity<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  PagedResultEntity({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.first,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
  });
}
