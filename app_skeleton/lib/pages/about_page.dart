import 'package:flutter/material.dart';

import '../routes.dart';

/// 关于页：展示路由表、组件抽取清单与 AI 使用标注。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<List<String>> _routes = <List<String>>[
    <String>['/', 'HomePage', 'GridView 分类入口'],
    <String>['/list', 'ListPage', 'Builder 列表 + 长按筛选回传'],
    <String>['/detail', 'DetailPage', '强类型 Book 参数'],
    <String>['/paged', 'PagedListPage', '分页加载实验室'],
    <String>['/about', 'AboutPage', '项目说明'],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('关于本项目', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text('app_skeleton', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('第 9 周 · 可滚动组件与多页面结构', style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          Text('命名路由表（5 条）', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ..._routes.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 74,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(row[0], style: theme.textTheme.labelMedium),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row[1], style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text(row[2], style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('组件抽取（lib/widgets/）', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'CategoryCard（首页分类卡，4 个样式入参 + onTap 回调）\n'
            'BookTile（列表项，book 数据 + onTap/onLongPress + 可选 trailing）\n'
            'StatChip（指标标签，icon/label/value/color）',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
          ),
          const SizedBox(height: 20),
          Text('AI 使用标注', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            '本项目在 TraeCode（AI 编程助手）辅助下完成：AI 提供代码骨架与 API 用法提示，'
            '本人逐段阅读、手动修改并在 Chrome/Edge 中运行验证，'
            '关键修改点在 README 的「AI 使用标注」中逐条记录。',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
          ),
          const SizedBox(height: 20),
          Text('返回方式', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('所有页面跳转均使用命名式：Navigator.pushNamed(context, AppRoutes.xxx, arguments: ...)',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Center(child: Text(AppRoutes.about, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
