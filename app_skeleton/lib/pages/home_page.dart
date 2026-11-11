import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../routes.dart';
import '../widgets/category_card.dart';

/// 首页：GridView 分类入口 + 回传值展示。
class HomePage extends StatefulWidget {
  final BookRepository repo;

  const HomePage({super.key, required this.repo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _subtitle = '未筛选 · 点击分类进入列表';

  static const Map<String, IconData> _icons = <String, IconData>{
    '移动开发': Icons.phone_iphone,
    '计算机基础': Icons.memory,
    '文学': Icons.auto_stories,
    '历史': Icons.account_balance,
    '科学': Icons.science,
    '艺术': Icons.palette,
  };

  static const List<Color> _colors = <Color>[
    Color(0xFF2F6BFF),
    Color(0xFF00897B),
    Color(0xFFEF6C00),
    Color(0xFF6A4BC4),
    Color(0xFF00838F),
    Color(0xFFC2185B),
  ];

  Future<void> _openList(String category) async {
    // 去程：命名路由 + 强类型参数 BookQuery
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.list,
      arguments: BookQuery(category: category),
    );
    if (!mounted) return;
    if (result is FilterResult) {
      // 回程：强类型返回值 FilterResult，显示在 AppBar 副标题
      setState(() => _subtitle = '回传：${result.label} · ${result.count} 本');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = widget.repo.categories;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('图书漂流', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(
              _subtitle,
              key: const ValueKey('home-subtitle'),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F6BFF), Color(0xFF5B8CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日推荐 · 闭架借阅',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '共 ${widget.repo.books.length} 册藏书，'
                    '高借阅 ${widget.repo.countHot()} 册',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '点击分类查看列表，长按列表项可回传筛选结果',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('分类浏览', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category,
                  count: widget.repo.countOf(category),
                  icon: _icons[category] ?? Icons.book,
                  color: _colors[index % _colors.length],
                  onTap: () => _openList(category),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('实验室', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _entryTile(
              icon: Icons.sync,
              title: '分页加载实验室',
              subtitle: 'ListView.builder + 加载更多，每次追加 20 条',
              route: AppRoutes.paged,
            ),
            const SizedBox(height: 10),
            _entryTile(
              icon: Icons.info_outline,
              title: '关于本项目',
              subtitle: '路由表、组件抽取与 AI 使用标注',
              route: AppRoutes.about,
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
