import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar alimento?'),
        content: const Text('Esta acción no se puede deshacer. ¿Seguro que deseas eliminarlo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await comidaService.eliminar(id);
                setState(() {});
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  String _formatearFecha(String fecha) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(fecha));
    } catch (_) {
      return fecha;
    }
  }

  Widget _buildComidaCard(Comida comida) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          child: const Icon(Icons.fastfood, color: Colors.green),
        ),
        title: Text(
          comida.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${comida.categoria}  •  Cant: ${comida.cantidad}'),
            Text('Caduca: ${_formatearFecha(comida.fechaCaducidad)}', style: const TextStyle(fontSize: 13)),
            Text('Precio: \$${comida.precio.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: 'Editar',
              onPressed: () {
                Navigator.pushNamed(context, '/editar', arguments: comida)
                    .then((_) => setState(() {}));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Eliminar',
              onPressed: () => _eliminarComida(comida.id),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detalle', arguments: comida);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Icon(
              Icons.list_alt,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            const Text(
              "Lista de alimentos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
                color: Colors.white,
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
      body: FutureBuilder<List<Comida>>(
        future: comidaService.listar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Manejo especial para respuesta vacía (API 204 o lista vacía)
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, color: Colors.green.shade200, size: 70),
                  const SizedBox(height: 18),
                  const Text(
                    'No hay productos agregados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toca el botón + para agregar el primero.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ],
              ),
            );
          }
          final comidas = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Toca un alimento para ver su detalle o editarlo.",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              ...comidas.map(_buildComidaCard).toList(),
              const SizedBox(height: 90)
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/agregar').then((_) => setState(() {}));
        },
        icon: const Icon(Icons.add),
        label: const Text(""),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}