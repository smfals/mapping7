import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../routes.dart';
import '../widgets/book_tile.dart';

/// 列表页：ListView.builder 渲染，长按可弹层选择「仅看高借阅量」并把结果 pop 回首页。
class ListPage extends StatefulWidget {
  final BookRepository repo;

  const ListPage({super.key, required this.repo});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late String _category = '全部';
  late List<Book> _books = const <Book>[];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // 接收去程参数：强类型 BookQuery
    final args = ModalRoute.of(context)?.settings.arguments;
    final query = args is BookQuery ? args : const BookQuery(category: '全部');
    _category = query.category;
    _books = widget.repo.byCategory(_category, highOnly: query.highOnly);
  }

  Future<void> _openDetail(Book book) async {
    // 去程带 Book 实例；回程接收 String
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.detail,
      arguments: book,
    );
    if (!mounted || result == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }

  /// 长按列表项：弹层选择「仅看高借阅量」，选择后把筛选结果回传首页。
  Future<void> _pickFilter() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('筛选列表', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.deepOrange),
                title: const Text('仅看高借阅量（≥30 次）'),
                subtitle: Text('当前分类共 ${widget.repo.countHot(category: _category)} 本'),
                onTap: () => Navigator.pop(sheetContext, 'high'),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('查看全部'),
                subtitle: Text('当前分类共 ${widget.repo.countOf(_category)} 本'),
                onTap: () => Navigator.pop(sheetContext, 'all'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (!mounted || choice == null) return;
    if (choice == 'high') {
      final count = widget.repo.countHot(category: _category);
      // 回程带值：pop 回首页并携带强类型 FilterResult
      Navigator.pop(context, FilterResult(label: '仅看高借阅量', count: count));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(
              '共 ${_books.length} 本 · 长按列表项可筛选',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '筛选',
            onPressed: _pickFilter,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _books.isEmpty
          ? const Center(child: Text('该分类暂无图书'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return BookTile(
                  book: book,
                  onTap: () => _openDetail(book),
                  onLongPress: _pickFilter,
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '提示：从详情页「借阅」返回会带回一条消息',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
