import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';

/// 数据仓库：统一负责 books.json 的加载与按分类/热度筛选。
class BookRepository {
  final List<Book> books;

  BookRepository.fromBooks(List<Book> source) : books = List<Book>.unmodifiable(source);

  /// 从 assets/books.json 读取模拟数据。
  static Future<BookRepository> loadFromAsset({AssetBundle? bundle}) async {
    final raw = await (bundle ?? rootBundle).loadString('assets/books.json');
    final list = (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList();
    return BookRepository.fromBooks(list);
  }

  /// 首页网格用的分类列表（按数据出现顺序去重）。
  List<String> get categories {
    final seen = <String>[];
    for (final book in books) {
      if (!seen.contains(book.category)) {
        seen.add(book.category);
      }
    }
    return seen;
  }

  int countOf(String category) {
    return books.where((book) => book.category == category).length;
  }

  int countHot({String? category}) {
    return books
        .where((book) => (category == null || book.category == category) && book.isHot)
        .length;
  }

  /// 按分类筛选；category 为「全部」时返回全部图书。
  List<Book> byCategory(String category, {bool highOnly = false}) {
    return books
        .where((book) => category == '全部' || book.category == category)
        .where((book) => !highOnly || book.isHot)
        .toList();
  }

  Book byId(int id) => books.firstWhere((book) => book.id == id, orElse: () => books.first);
}
