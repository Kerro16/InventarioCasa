import 'package:flutter/material.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class AgregarComidaPage extends StatefulWidget {
  const AgregarComidaPage({super.key});

  @override
  State<AgregarComidaPage> createState() => _AgregarComidaPageState();
}

class _AgregarComidaPageState extends State<AgregarComidaPage> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final cantidadController = TextEditingController();
  final fechaController = TextEditingController();
  final ubicacionController = TextEditingController();
  final precioController = TextEditingController();

  final List<String> categorias = [
    'LACTEOS',
    'CARNES',
    'VERDURAS',
    'FRUTAS',
    'SNACKS',
    'BEBIDAS',
    'CEREALES',
    'CONGELADOS',
    'OTROS',
  ];

  String? categoriaSeleccionada;
  final ComidaService comidaService = ComidaService();

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        fechaController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  void _guardarComida() async {
    if (_formKey.currentState!.validate() && categoriaSeleccionada != null) {
      final nueva = Comida(
        id: 0,
        nombre: nombreController.text.trim(),
        categoria: categoriaSeleccionada!,
        cantidad: double.parse(cantidadController.text),
        fechaCaducidad: fechaController.text.trim(),
        ubicacion: ubicacionController.text.trim(),
        precio: double.parse(precioController.text),
      );

      final jsonSinId = nueva.toJson()..remove('id');

      try {
        await comidaService.agregarDesdeJson(jsonSinId);
        Navigator.pop(context); // Regresa y refresca lista
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    cantidadController.dispose();
    fechaController.dispose();
    ubicacionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar comida')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoría'),
                value: categoriaSeleccionada,
                items: categorias
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (valor) =>
                    setState(() => categoriaSeleccionada = valor),
                validator: (v) =>
                v == null ? 'Seleccioná una categoría' : null,
              ),
              TextFormField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de caducidad',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _seleccionarFecha(context),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: ubicacionController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: precioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$',
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarComida,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}