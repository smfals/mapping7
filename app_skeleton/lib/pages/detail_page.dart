import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../widgets/stat_chip.dart';

/// 详情页：接收列表页传来的强类型 Book 参数，并可把借阅结果 pop 回列表页。
class DetailPage extends StatelessWidget {
  final BookRepository repo;

  const DetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 接收参数：ModalRoute.of(context)!.settings.arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    final isBookArg = args is Book;
    final book = args is Book ? args : repo.books.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('图书详情', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (book.isHot)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_fire_department, size: 14, color: Colors.deepOrange),
                            SizedBox(width: 4),
                            Text('热门', style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${book.author} 著', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    StatChip(
                      icon: Icons.category_outlined,
                      label: '分类',
                      value: book.category,
                      color: const Color(0xFF2F6BFF),
                    ),
                    StatChip(
                      icon: Icons.repeat,
                      label: '借阅次数',
                      value: '${book.borrowCount}',
                      color: const Color(0xFFEF6C00),
                    ),
                    StatChip(
                      icon: Icons.inventory_2_outlined,
                      label: '在馆库存',
                      value: '${book.stock}',
                      color: const Color(0xFF00897B),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('内容简介', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(book.summary, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('参数接收（调试信息）',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('路由名：${ModalRoute.of(context)?.settings.name}',
                    style: theme.textTheme.bodySmall),
                Text(
                  isBookArg
                      ? 'arguments 类型：Book（强类型模型，转换成功）'
                      : 'arguments 类型：${args.runtimeType}（未传参，回退默认数据）',
                  style: theme.textTheme.bodySmall,
                ),
                Text('Book.id = ${book.id}', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  child: const Text('返回（无返回值）'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    '已借阅《${book.title}》，请到 3 楼自助机取书',
                  ),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  child: const Text('借阅这本书'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
