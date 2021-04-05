import 'package:flutter/material.dart';
import 'package:qr_reader/src/pages/home_page.dart';
import 'package:qr_reader/src/pages/mapa_page.dart';

import 'package:provider/provider.dart';
import 'package:qr_reader/src/providers/scan_list_provider.dart';
import 'package:qr_reader/src/providers/ui_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// `MultiProvider`
    return MultiProvider(
      providers: [
        // Cuando no hay una instancia del provider creado
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => ScanListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'mapa': (_) => MapaPage(),
        },
        theme: ThemeData(
            primaryColor: Colors.amberAccent,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.amber)),
      ),
    );
  }
}
