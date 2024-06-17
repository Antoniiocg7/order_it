// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:order_it/controllers/user_controller.dart';
import 'package:order_it/models/usuario.dart' as order_it;
import 'package:order_it/services/supabase_api.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key, required this.title});

  final String title;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final UserController userController = UserController();
  final SupabaseApi supabaseApi = SupabaseApi();

  late Future<order_it.User> user;

  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    user = userController.getUser();
    user.then((userData) {
      nombreController = TextEditingController(text: userData.nombre);
      apellidoController = TextEditingController(text: userData.apellido_1);
      emailController = TextEditingController(text: userData.email);
      telefonoController = TextEditingController(text: userData.telefono);
      passwordController = TextEditingController();
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    final updatedUser = order_it.User(
      id: (await user).id,
      nombre: nombreController.text,
      apellido_1: apellidoController.text,
      email: emailController.text,
      telefono: telefonoController.text,
      // Agrega cualquier otro campo necesario
    );

    try {
      await supabaseApi.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
      ),
      body: FutureBuilder<order_it.User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Acción tras la cámara
                              },
                              icon: const Icon(Icons.camera_alt),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Nombre',
                        prefixIcon: const Icon(Icons.person_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: apellidoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Apellido',
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Correo',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color.fromARGB(255, 27, 26, 26),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: telefonoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Telefono',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.fingerprint),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 136, 219),
                          padding: const EdgeInsets.symmetric(horizontal: 31),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text(
                          'Confirmar Cambios',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Row(children: [
                      Text(
                        'Se unió el 31 de Octubre 2022',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 34, 34, 34)),
                      ),
                      SizedBox(width: 106),
                    ]),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No se encontró el usuario.'));
          }
        },
      ),
    );
  }
}
