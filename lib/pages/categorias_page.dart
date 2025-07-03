import 'package:flutter/material.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final ComidaService comidaService = ComidaService();
  Map<String, List<Comida>> comidasPorCategoria = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final lista = await comidaService.listar();
    final agrupadas = <String, List<Comida>>{};

    for (final comida in lista) {
      agrupadas.putIfAbsent(comida.categoria, () => []).add(comida);
    }

    setState(() {
      comidasPorCategoria = agrupadas;
    });
  }

  void _eliminar(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar comida?'),
        content: const Text('Esta acción no se puede deshacer'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await comidaService.eliminar(id);
                _cargarDatos();
              },
              child: const Text('Eliminar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Por Categoría')),
      body: comidasPorCategoria.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: comidasPorCategoria.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: entry.value.map((comida) {
              return ListTile(
                title: Text(comida.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cantidad: ${comida.cantidad}'),
                    Text('Caduca: ${comida.fechaCaducidad}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editar', arguments: comida)
                            .then((_) => _cargarDatos());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminar(comida.id),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/agregar').then((_) => _cargarDatos());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}