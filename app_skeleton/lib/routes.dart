import 'package:flutter/material.dart';

import 'data/book_repository.dart';
import 'pages/detail_page.dart';
import 'pages/home_page.dart';
import 'pages/list_page.dart';

/// 命名路由常量 + 路由表（全部跳转均走命名式）。
class AppRoutes {
  static const String home = '/';
  static const String list = '/list';
  static const String detail = '/detail';

  static Map<String, WidgetBuilder> table(BookRepository repo) {
    return <String, WidgetBuilder>{
      home: (_) => HomePage(repo: repo),
      list: (_) => ListPage(repo: repo),
      detail: (_) => DetailPage(repo: repo),
    };
  }
}
