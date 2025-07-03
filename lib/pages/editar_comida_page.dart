import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final DateFormat formatoLatam = DateFormat('dd/MM/yyyy');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    comida = ModalRoute.of(context)!.settings.arguments as Comida;

    nombreController.text = comida.nombre;
    cantidadController.text = comida.cantidad.toString();
    // Convierte ISO a formato latino
    try {
      fechaController.text = formatoLatam.format(DateTime.parse(comida.fechaCaducidad));
    } catch (_) {
      fechaController.text = comida.fechaCaducidad;
    }
    ubicacionController.text = comida.ubicacion;
    categoriaSeleccionada = comida.categoria;
    precioController.text = comida.precio.toString();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = formatoLatam.parse(fechaController.text);
    } catch (_) {
      initialDate = DateTime.now();
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
      locale: const Locale('es', ''),
    );
    if (picked != null) {
      setState(() {
        fechaController.text = formatoLatam.format(picked);
      });
    }
  }

  void _actualizar() async {
    if (_formKey.currentState!.validate() && categoriaSeleccionada != null) {
      // Convierte la fecha al formato ISO antes de guardar
      final DateTime fecha = formatoLatam.parse(fechaController.text.trim());
      final actualizada = Comida(
        id: comida.id,
        nombre: nombreController.text.trim(),
        categoria: categoriaSeleccionada!,
        cantidad: double.parse(cantidadController.text),
        fechaCaducidad: fecha.toIso8601String().substring(0, 10),
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
            Icon(Icons.edit, size: 28, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              "Editar alimento",
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
      backgroundColor: const Color(0xFFF0F2F5), // Mismo fondo moderno
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        prefixIcon: Icon(Icons.fastfood),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      value: categoriaSeleccionada,
                      items: categorias
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (valor) => setState(() => categoriaSeleccionada = valor),
                      validator: (v) => v == null ? 'Seleccioná una categoría' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: cantidadController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        prefixIcon: Icon(Icons.numbers),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: fechaController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de caducidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      onTap: () => _seleccionarFecha(context),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: ubicacionController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        prefixIcon: Icon(Icons.location_on),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        prefixText: '\$',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        prefixIcon: Icon(Icons.attach_money),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        onPressed: _actualizar,
                        label: const Text('Actualizar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}