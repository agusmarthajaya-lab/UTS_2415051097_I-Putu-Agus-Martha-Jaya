import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_mate/main.dart';
import 'package:task_mate/providers/task_provider.dart';

void main() {
  testWidgets('TaskMate smoke test and app launch verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verifikasi bahwa layar login berhasil ditampilkan
    expect(find.text('TaskMate'), findsOneWidget);
    expect(find.text('Masuk ke Aplikasi'), findsOneWidget);
  });
}
