import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/log_service.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  LogService.appStart();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppState())],
      child: const PremiumHubApp(),
    ),
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class PremiumHubApp extends StatelessWidget {
  const PremiumHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      scrollBehavior: MyCustomScrollBehavior(),
      home: const LoginScreen(),
    );
  }
}

class AppState extends ChangeNotifier {
  int _navigationIndex = 0;
  int get navigationIndex => _navigationIndex;

  void setNavigationIndex(int index) {
    _navigationIndex = index;
    notifyListeners();
  }
}
