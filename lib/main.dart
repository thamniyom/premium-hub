import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/log_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LogService.appStart();
  detectPlatform();
  // Initialize services
  if (Platform.isAndroid || Platform.isIOS) {
    await NotificationService().init();
  }

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

//Function
void detectPlatform() {
  // ignore: prefer_interpolation_to_compose_strings
  LogService.info("detectPlatform Platform=" + Platform.operatingSystem);
  if (Platform.isWindows) {
    LogService.info("Running on Windows");
  } else if (Platform.isAndroid) {
    LogService.info("Running on Android");
  } else if (Platform.isIOS) {
    LogService.info("Running on iOS");
  }
}
