import 'package:flutter/material.dart';
import '../services/comida_service.dart';
import '../models/comida.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final comidaService = ComidaService();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Casa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Ver todo el inventario'),
              onPressed: () => Navigator.pushNamed(context, '/comidas'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.category),
              label: const Text('Ver por categoría'),
              onPressed: () => Navigator.pushNamed(context, '/porCategoria'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 32),

            Autocomplete<String>(
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
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/agregar'),
        child: const Icon(Icons.add),
      ),
    );
  }
}