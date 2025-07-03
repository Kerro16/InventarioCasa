import 'package:flutter/material.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class DetalleComidaPage extends StatelessWidget {
  const DetalleComidaPage({super.key});

  void _confirmarEliminacion(BuildContext context, int id) async {
    final servicio = ComidaService();
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar alimento?'),
        content: const Text('Esta acción no se puede deshacer'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await servicio.eliminar(id);
              Navigator.pop(context); // salir del detalle
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comida = ModalRoute.of(context)!.settings.arguments as Comida;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del alimento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comida.nombre, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Categoría: ${comida.categoria}'),
            Text('Cantidad: ${comida.cantidad}'),
            Text('Caduca: ${comida.fechaCaducidad}'),
            Text('Ubicación: ${comida.ubicacion}'),
            Text('Precio: \$${comida.precio.toStringAsFixed(2)}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/editar', arguments: comida)
                        .then((_) => Navigator.pop(context));
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => _confirmarEliminacion(context, comida.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}