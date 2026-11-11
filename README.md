# mapping7 · app_skeleton

第 9 周课堂作业七：可滚动组件与多页面结构（GridView / ListView.builder / 命名路由 / 参数与返回值 / 组件抽取）。

- 工程目录：`app_skeleton/`
- 运行方式：`cd app_skeleton && flutter pub get && flutter run -d chrome`
- 环境：Flutter 3.47.9 / Dart 3.13.7，`flutter analyze` 无告警，`flutter test` 3 个用例全部通过。

## 1. 目录结构

```
app_skeleton/
├─ assets/books.json              # 24 本模拟图书数据
├─ lib/
│  ├─ main.dart                   # MaterialApp + 主题 + 路由表挂载
│  ├─ routes.dart                 # 命名路由常量与路由表（5 条）
│  ├─ data/book_repository.dart   # 数据加载与筛选
│  ├─ models/book.dart            # Book / BookQuery / FilterResult
│  ├─ pages/
│  │  ├─ home_page.dart           # 首页：GridView 分类入口 + 回传值展示
│  │  ├─ list_page.dart           # 列表页：ListView.builder + 长按筛选回传
│  │  ├─ detail_page.dart         # 详情页：强类型 Book 参数 + 返回值
│  │  ├─ paged_list_page.dart     # 分页加载实验室（每次 +20）
│  │  └─ about_page.dart          # 路由表 / 组件抽取 / AI 标注说明
│  └─ widgets/
│     ├─ category_card.dart       # 复用组件 1
│     ├─ book_tile.dart           # 复用组件 2
│     └─ stat_chip.dart           # 复用组件 3
└─ test/widget_test.dart          # 模型、仓库、首页跳转 3 个用例
```

## 2. 路由表（5 条，全部命名式跳转）

| 路由 | 页面 | 参数 / 返回值 |
| --- | --- | --- |
| `/` | HomePage | 无 |
| `/list` | ListPage | 去程 `BookQuery(category)`；回程 `FilterResult` |
| `/detail` | DetailPage | 去程 `Book`；回程 `String`（借阅结果） |
| `/paged` | PagedListPage | 无 |
| `/about` | AboutPage | 无 |

未注册路由由 `onUnknownRoute` 兜底，避免出现 `could not find a generator for route` 红屏。

## 3. 检查点对应

| 检查点 | 实现位置 | 证据截图 |
| --- | --- | --- |
| 三页闭环 | `home_page.dart` → `list_page.dart` → `detail_page.dart` | 01、02、03 |
| 列表页 builder | `list_page.dart` 的 `ListView.builder` | 02 |
| 强类型参数 | `Navigator.pushNamed(..., arguments: Book)`，详情页 `arguments is Book` 判断 | 03（调试信息卡片） |
| 返回值生效 | 详情页「借阅」返回后列表页 `SnackBar` 提示 | 04 |
| 长按回传首页 | 列表页长按 → 底部弹层 → `Navigator.pop(context, FilterResult(...))`，首页 AppBar 副标题显示 | 05、06 |
| 分页追加 | `paged_list_page.dart` 每次追加 20 条 | 07、08 |
| 路由表 ≥ 4 | `routes.dart` 共 5 条，`about_page.dart` 内可视化 | 09 |

## 4. 自主实践任务

1. **列表分页模拟**：`PagedListPage` 用 `ListView.builder` 懒构建，底部「加载更多（+20）」每次追加 20 条，最多 100 条；`ScrollController` 监听滚动，滚过一屏显示「回到顶部」。
2. **命名路由表**：`AppRoutes` 定义 5 条路由，全部通过 `Navigator.pushNamed` 跳转。
3. **参数与返回值**：去程传 `BookQuery` / `Book` 强类型对象，回程传 `FilterResult` / `String`；详情页展示 `arguments 类型：Book（强类型模型，转换成功）` 作为运行时证据。
4. **组件抽取**：`CategoryCard`（4 个样式入参 + onTap 回调）、`BookTile`（数据 + 点击/长按回调 + 可选 trailing）、`StatChip`（icon/label/value/color）。
5. **AI 使用标注**：见第 5 节。

## 5. AI 使用标注

开发过程使用 TraeCode（AI 编程助手）辅助，使用方式与人工核对记录如下：

| 环节 | AI 提供 | 我的处理与验证 |
| --- | --- | --- |
| 工程脚手架 | `flutter create` 参数、`pubspec.yaml` 资源声明 | 手动执行命令，确认 `assets/books.json` 打包进 `build/web/assets` |
| 页面结构 | 三个页面的 Widget 骨架、`ListView.builder` 写法 | 逐段阅读后改写为强类型 `Book` 传参，删除不必要的占位代码 |
| 路由 | `AppRoutes` 常量与 `Map<String, WidgetBuilder>` 写法 | 自行补充 `onUnknownRoute` 兜底，并在 about 页展示路由表 |
| 字体与渲染 | 排查 Web 端中文缺字（Noto 字体分片加载失败） | 重新加载页面验证，最终移除无效的 `fontFamily` 覆盖 |
| 调试 | Edge CDP 截图/点击脚本 | 仅作为运行验证工具，未进入工程代码 |
| 代码审查 | 提示 `withOpacity` 已废弃等 | 改为 `withValues(alpha: ...)`，`flutter analyze` 零告警 |

所有 AI 生成的代码均经过运行验证（`flutter analyze`、`flutter test`、Web 端手工点击走查），截图见 `screenshots/`。

## 6. 运行证据

`screenshots/` 目录：

1. `01-home-grid.png` 首页分类网格
2. `02-list-mobile.png` 移动开发分类列表（6 本）
3. `03-detail.png` 详情页与参数调试信息
4. `04-return-value.png` 借阅后回传值的 SnackBar
5. `05-filter-sheet.png` 长按/筛选按钮弹出的筛选弹层
6. `06-home-pop-result.png` 首页 AppBar 副标题显示回传结果
7. `07-paged-20.png` 分页实验室初始 20 条与「加载更多」
8. `08-paged-40.png` 追加到 40 条（第 2 批）
9. `09-about.png` 路由表与 AI 使用标注
