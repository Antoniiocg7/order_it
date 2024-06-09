import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_it/controllers/user_controller.dart';
import 'package:order_it/models/usuario.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key, required this.title});

  final String title;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final UserController userController = UserController();
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    user = userController.getUser("segurajoaquinm@gmail.com");
    if (kDebugMode) {
      print(user);
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
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
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
                                // Handle camera action
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
                      controller: TextEditingController(text: userData.nombre),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Nombre',
                        prefixIcon: const Icon(Icons.person_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          TextEditingController(text: userData.apellido_1),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Apellido',
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: userData.email),
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
                      controller:
                          TextEditingController(text: userData.telefono),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Telefono',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.fingerprint),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
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
                        'Joined 31 October 2022',
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
