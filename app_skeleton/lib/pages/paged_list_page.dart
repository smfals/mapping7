import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';

/// 分页加载实验室：ListView.builder 懒构建 + 「加载更多」按钮每次追加 20 条；
/// ScrollController 用于监听滚动位置，滚过一屏后显示「回到顶部」。
class PagedListPage extends StatefulWidget {
  final BookRepository repo;

  const PagedListPage({super.key, required this.repo});

  @override
  State<PagedListPage> createState() => _PagedListPageState();
}

class _PagedListPageState extends State<PagedListPage> {
  static const int _pageSize = 20;
  static const int _maxItems = 100;

  final ScrollController _controller = ScrollController();
  final List<Book> _items = <Book>[];
  bool _loading = false;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _appendPage();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final shouldShow = _controller.offset > 480;
    if (shouldShow != _showBackToTop) {
      setState(() => _showBackToTop = shouldShow);
    }
  }

  bool get _hasMore => _items.length < _maxItems;

  Future<void> _appendPage() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    // 模拟网络请求耗时
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final start = _items.length;
    final base = widget.repo.books;
    final next = List<Book>.generate(_pageSize, (index) {
      final serial = start + index;
      final source = base[serial % base.length];
      return source.copyWith(
        id: serial + 1,
        title: '${source.title}（第 ${serial ~/ base.length + 1} 批）',
        borrowCount: source.borrowCount + serial,
      );
    });
    setState(() {
      _items.addAll(next);
      _loading = false;
    });
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
            const Text('分页加载实验室', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(
              '已加载 ${_items.length} / $_maxItems 条 · 每页 $_pageSize 条',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        controller: _controller,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _buildFooter();
          }
          final book = _items[index];
          return BookTile(
            book: book,
            onTap: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('第 ${index + 1} 条：${book.title}'))),
          );
        },
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              tooltip: '回到顶部',
              onPressed: () => _controller.animateTo(
                0,
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOut,
              ),
              child: const Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }

  Widget _buildFooter() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
            )
          else if (_hasMore)
            OutlinedButton.icon(
              onPressed: _appendPage,
              icon: const Icon(Icons.expand_more),
              label: const Text('加载更多（+20）'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            )
          else
            Text('没有更多了 · 共 $_maxItems 条', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            '懒构建：只有滚入视口的条目才会被 itemBuilder 创建',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
