import 'package:flutter/material.dart';
import '../services/comida_service.dart';
import '../models/comida.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final comidaService = ComidaService();

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.green.shade700,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade700,
                Colors.green.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/fridge.png",
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text(
              "Inventario Casa",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                color: Colors.white,
                fontFamily: 'Montserrat', // Usa Montserrat si la tienes
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen decorativa o logo en el centro
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Image.asset(
                  "assets/fridge.png",
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "¡Bienvenido a tu Inventario del Hogar!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Organiza y controla los alimentos y productos de tu casa de manera fácil y visual.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.list, color: Colors.green, size: 32),
                    title: const Text('Ver todo el inventario', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Consulta la lista completa de tus alimentos.'),
                    onTap: () => Navigator.pushNamed(context, '/comidas'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.category, color: Colors.amber, size: 32),
                    title: const Text('Ver por categoría', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Explora los productos agrupados por tipo.'),
                    onTap: () => Navigator.pushNamed(context, '/porCategoria'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return await comidaService.autocompletar(textEditingValue.text);
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Buscar alimento',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) async {
                        final comidas = await comidaService.listar();
                        final match = comidas.firstWhere(
                              (c) => c.nombre.toLowerCase() == value.toLowerCase(),
                          orElse: () => Comida(
                            id: 0,
                            nombre: '',
                            categoria: '',
                            cantidad: 0,
                            fechaCaducidad: '',
                            ubicacion: '',
                            precio: 0,
                          ),
                        );
                        if (match.id != 0) {
                          Navigator.pushNamed(context, '/detalle', arguments: match);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alimento no encontrado')),
                          );
                        }
                      },
                    );
                  },
                  onSelected: (String seleccion) async {
                    final comidas = await comidaService.listar();
                    final match = comidas.firstWhere(
                          (c) => c.nombre.toLowerCase() == seleccion.toLowerCase(),
                      orElse: () => Comida(
                        id: 0,
                        nombre: '',
                        categoria: '',
                        cantidad: 0,
                        fechaCaducidad: '',
                        ubicacion: '',
                        precio: 0,
                      ),
                    );
                    if (match.id != 0) {
                      Navigator.pushNamed(context, '/detalle', arguments: match);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Alimento no encontrado')),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "¿No encuentras un alimento? ¡Agrégalo fácilmente!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/agregar'),
        icon: const Icon(Icons.add),
        label: const Text(""),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}