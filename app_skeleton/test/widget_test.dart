import 'package:app_skeleton/data/book_repository.dart';
import 'package:app_skeleton/main.dart';
import 'package:app_skeleton/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

const List<Book> _testBooks = <Book>[
  Book(
    id: 1,
    title: 'Flutter实战',
    author: '杜文',
    category: '移动开发',
    borrowCount: 72,
    stock: 3,
    summary: '测试数据',
  ),
  Book(
    id: 2,
    title: '活着',
    author: '余华',
    category: '文学',
    borrowCount: 68,
    stock: 5,
    summary: '测试数据',
  ),
  Book(
    id: 3,
    title: '边城',
    author: '沈从文',
    category: '文学',
    borrowCount: 16,
    stock: 4,
    summary: '测试数据',
  ),
];

void main() {
  test('高借阅量口径：borrowCount >= 30', () {
    expect(_testBooks[0].isHot, isTrue);
    expect(_testBooks[2].isHot, isFalse);
  });

  test('仓库按分类与热度筛选', () {
    final repo = BookRepository.fromBooks(_testBooks);
    expect(repo.categories, <String>['移动开发', '文学']);
    expect(repo.byCategory('文学').length, 2);
    expect(repo.byCategory('文学', highOnly: true).length, 1);
    expect(repo.countHot(), 2);
  });

  testWidgets('首页渲染分类网格，点击分类跳到列表页', (WidgetTester tester) async {
    final repo = BookRepository.fromBooks(_testBooks);
    await tester.pumpWidget(BookApp(repo: repo));

    expect(find.text('图书漂流'), findsOneWidget);
    expect(find.text('未筛选 · 点击分类进入列表'), findsOneWidget);
    expect(find.text('移动开发'), findsOneWidget);

    await tester.tap(find.text('文学'));
    await tester.pumpAndSettle();

    expect(find.text('共 2 本 · 长按列表项可筛选'), findsOneWidget);
    expect(find.text('活着'), findsOneWidget);
  });
}
