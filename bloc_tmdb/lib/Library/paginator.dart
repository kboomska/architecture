class PaginatorLoadResult<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;

  PaginatorLoadResult({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });
}

typedef PaginatorLoad<T> = Future<PaginatorLoadResult<T>> Function(int);

class Paginator<T> {
  final _data = <T>[];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  final PaginatorLoad<T> load;

  List<T> get data => _data;

  Paginator(this.load);

  Future<void> reset() async {
    _currentPage = 0;
    _totalPage = 1;
    _data.clear();
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final response = await load(nextPage);
      _data.addAll(response.data);
      _currentPage = response.currentPage;
      _totalPage = response.totalPages;
      _isLoadingInProgress = false;
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }
}
