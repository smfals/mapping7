import 'package:flutter/material.dart';

import 'data/book_repository.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await BookRepository.loadFromAsset();
  runApp(BookApp(repo: repo));
}

class BookApp extends StatelessWidget {
  final BookRepository repo;

  const BookApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '图书漂流 · app_skeleton',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F6BFF),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.table(repo),
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('路由未注册')),
            body: Center(
              child: Text('could not find a generator for route ${settings.name}'),
            ),
          ),
        );
      },
    );
  }
}
