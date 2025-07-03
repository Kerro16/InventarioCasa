import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/comida.dart';

class DetalleComidaPage extends StatelessWidget {
  const DetalleComidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final comida = ModalRoute.of(context)!.settings.arguments as Comida;

    // Formateo latinoamericano para la fecha
    String fechaFormateada;
    try {
      fechaFormateada = DateFormat('dd/MM/yyyy').format(DateTime.parse(comida.fechaCaducidad));
    } catch (_) {
      fechaFormateada = comida.fechaCaducidad;
    }

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco limpio y moderno
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
            Icon(Icons.fastfood, size: 28, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Detalle del Alimento",
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono grande
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.green.shade100,
                    child: Icon(
                      Icons.fastfood,
                      color: Colors.green.shade700,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    comida.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32, thickness: 1.2),
                  _detalleDato(
                    icon: Icons.category,
                    label: 'Categoría',
                    value: comida.categoria,
                  ),
                  _detalleDato(
                    icon: Icons.inventory_2,
                    label: 'Cantidad',
                    value: comida.cantidad.toString(),
                  ),
                  _detalleDato(
                    icon: Icons.calendar_today,
                    label: 'Caducidad',
                    value: fechaFormateada,
                  ),
                  _detalleDato(
                    icon: Icons.location_on,
                    label: 'Ubicación',
                    value: comida.ubicacion,
                  ),
                  _detalleDato(
                    icon: Icons.attach_money,
                    label: 'Precio',
                    value: '\$${comida.precio.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 22),
                        label: const Text('Editar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/editar', arguments: comida),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back, size: 22),
                        label: const Text('Volver'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green.shade700,
                          side: BorderSide(color: Colors.green.shade700, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detalleDato({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 26),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}