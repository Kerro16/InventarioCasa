import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final ComidaService comidaService = ComidaService();
  late Future<Map<String, List<Comida>>> _comidasPorCategoriaFuture;

  @override
  void initState() {
    super.initState();
    _comidasPorCategoriaFuture = _fetchComidasPorCategoria();
  }

  Future<Map<String, List<Comida>>> _fetchComidasPorCategoria() async {
    final lista = await comidaService.listar();
    final agrupadas = <String, List<Comida>>{};
    for (final comida in lista) {
      agrupadas.putIfAbsent(comida.categoria, () => []).add(comida);
    }
    return agrupadas;
  }

  Future<void> _recargar() async {
    setState(() {
      _comidasPorCategoriaFuture = _fetchComidasPorCategoria();
    });
  }

  String _formatearFecha(String fecha) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(fecha));
    } catch (_) {
      return fecha;
    }
  }

  Future<void> _eliminar(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar comida?'),
        content: const Text('Esta acción no se puede deshacer'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await comidaService.eliminar(id);
      await _recargar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comida eliminada exitosamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
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
            Icon(Icons.category, size: 28, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Por Categoría",
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        toolbarHeight: 70,
      ),
      body: FutureBuilder<Map<String, List<Comida>>>(
        future: _comidasPorCategoriaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 18),
                  const Text(
                    "No hay comidas registradas.",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/agregar').then((_) => _recargar());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Agregar comida"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          final comidasPorCategoria = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            children: comidasPorCategoria.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  children: entry.value.map((comida) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                      title: Text(
                        comida.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cantidad: ${comida.cantidad}'),
                          Text('Caduca: ${_formatearFecha(comida.fechaCaducidad)}'),
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
                                  .then((_) => _recargar());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminar(comida.id),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/agregar').then((_) => _recargar());
        },
        icon: const Icon(Icons.add),
        label: const Text("Agregar"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}