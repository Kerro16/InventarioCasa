import 'package:flutter/material.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class ComidaListPage extends StatefulWidget {
  const ComidaListPage({super.key});

  @override
  State<ComidaListPage> createState() => _ComidaListPageState();
}

class _ComidaListPageState extends State<ComidaListPage> {
  final ComidaService comidaService = ComidaService();

  void _eliminarComida(int id) async {
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
                setState(() {});
              },
              child: const Text('Eliminar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Comidas')),
      body: FutureBuilder<List<Comida>>(
        future: comidaService.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final comidas = snapshot.data!;
          if (comidas.isEmpty) {
            return const Center(child: Text('No hay alimentos registrados.'));
          }
          return ListView.builder(
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              final comida = comidas[index];
              return ListTile(
                title: Text(comida.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${comida.categoria} • Cantidad: ${comida.cantidad}'),
                    Text('Caduca: ${comida.fechaCaducidad}'),
                    Text('Precio: \$${comida.precio.toStringAsFixed(2)}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editar', arguments: comida)
                            .then((_) => setState(() {}));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarComida(comida.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/agregar').then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}