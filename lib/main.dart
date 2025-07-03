import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inventario_casa/pages/detalle_comida_page.dart';
import 'pages/home_page.dart';
import 'pages/comida_list_page.dart';
import 'pages/agregar_comida_page.dart';
import 'pages/editar_comida_page.dart';
import 'pages/categorias_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Casa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF219653),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF27AE60),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            elevation: 1,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      home: const HomePage(),
      routes: {
        '/comidas': (_) => ComidaListPage(),
        '/agregar': (_) => AgregarComidaPage(),
        '/editar': (_) => EditarComidaPage(),
        '/porCategoria': (_) => CategoriasPage(),
        '/detalle': (_) => const DetalleComidaPage(),
      },
    );
  }
}