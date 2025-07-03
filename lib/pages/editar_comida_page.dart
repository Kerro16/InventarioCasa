import 'package:flutter/material.dart';
import '../models/comida.dart';
import '../services/comida_service.dart';

class EditarComidaPage extends StatefulWidget {
  const EditarComidaPage({super.key});

  @override
  State<EditarComidaPage> createState() => _EditarComidaPageState();
}

class _EditarComidaPageState extends State<EditarComidaPage> {
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
  late Comida comida;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    comida = ModalRoute.of(context)!.settings.arguments as Comida;

    nombreController.text = comida.nombre;
    cantidadController.text = comida.cantidad.toString();
    fechaController.text = comida.fechaCaducidad;
    ubicacionController.text = comida.ubicacion;
    categoriaSeleccionada = comida.categoria;
    precioController.text = comida.precio.toString();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(fechaController.text) ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        fechaController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  void _actualizar() async {
    if (_formKey.currentState!.validate() && categoriaSeleccionada != null) {
      final actualizada = Comida(
        id: comida.id,
        nombre: nombreController.text.trim(),
        categoria: categoriaSeleccionada!,
        cantidad: double.parse(cantidadController.text),
        fechaCaducidad: fechaController.text.trim(),
        ubicacion: ubicacionController.text.trim(),
        precio: double.parse(precioController.text),
      );

      try {
        await comidaService.actualizar(actualizada);
        Navigator.pop(context); // Retorna y refresca lista
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
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
      appBar: AppBar(title: const Text('Editar comida')),
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
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
                onPressed: _actualizar,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}