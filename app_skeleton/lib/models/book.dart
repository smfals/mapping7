/// 图书数据模型（第 4 课 Book 模型，本次作业复用并补充字段）。
class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final int borrowCount;
  final int stock;
  final String summary;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.borrowCount,
    required this.stock,
    required this.summary,
  });

  /// 高借阅量判定口径：借阅次数 >= 30。
  bool get isHot => borrowCount >= 30;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      borrowCount: json['borrowCount'] as int,
      stock: json['stock'] as int,
      summary: (json['summary'] as String?) ?? '',
    );
  }

  Book copyWith({int? id, String? title, int? borrowCount, int? stock}) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author,
      category: category,
      borrowCount: borrowCount ?? this.borrowCount,
      stock: stock ?? this.stock,
      summary: summary,
    );
  }

  @override
  String toString() => 'Book(id: $id, title: $title)';
}

/// 列表页的去程参数：分类 + 是否只看高借阅量。
class BookQuery {
  final String category;
  final bool highOnly;

  const BookQuery({required this.category, this.highOnly = false});

  @override
  String toString() => 'BookQuery(category: $category, highOnly: $highOnly)';
}

/// 列表页回传给首页的筛选结果（强类型返回值）。
class FilterResult {
  final String label;
  final int count;

  const FilterResult({required this.label, required this.count});

  @override
  String toString() => '$label · $count 本';
}
