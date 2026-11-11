import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/data/repositories/auth_repository.dart';
import 'features/authentication/data/services/auth_service.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.setEnvironment(Environment.development);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF151321),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final apiClient = ApiClient();
  final authService = AuthService(apiClient);
  final authRepository = AuthRepository(
    authService: authService,
    apiClient: apiClient,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
      ],
      child: const MemoryWarsApp(),
    ),
  );
}

class MemoryWarsApp extends StatelessWidget {
  const MemoryWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Wars',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
