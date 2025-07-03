import 'package:flutter/material.dart';
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
      theme: ThemeData(primarySwatch: Colors.green),
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