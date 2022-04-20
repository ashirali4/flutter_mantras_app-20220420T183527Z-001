import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/pages/session_screen.dart';
import 'package:flutter_mantras_app/pages/splash_screen.dart';
import 'package:flutter_mantras_app/providers/app_provider.dart';
import 'package:flutter_mantras_app/providers/primary_data_provider.dart';
import 'package:provider/provider.dart';

class MantrasApp extends StatelessWidget {
  const MantrasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppProvider>(
            create: (_) => AppProvider(),
          ),
          ChangeNotifierProvider<ProviderDataProvider>(
            create: (_) => ProviderDataProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          routes: {
            '/session': (BuildContext context) => const SessionScreen(),
          },
          home: const SplashScreen(),
        ),
    );
  }
}
