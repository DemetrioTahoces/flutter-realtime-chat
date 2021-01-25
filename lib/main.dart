import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/routes/routes.dart';
import 'package:realtime_chat/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RealTime Chat',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
