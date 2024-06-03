import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:order_it/models/user.dart';

class TestHive extends StatelessWidget {
  const TestHive({super.key});

  void addToHive() {
    Usuario usuario = Usuario(
      email: "segura@gmail.com",
      password: "123456",
    );

    final usuarioBox = Hive.box<Usuario>("userBox");
    //usuarioBox.getAt(0);

    usuarioBox.add(usuario);

    print(usuarioBox.getAt(0)!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              width: 200,
              height: 75,
              decoration: const BoxDecoration(color: Colors.amber),
              child: const Text("Agregar a Hive"),
            ),
            onTap: () => addToHive(),
          )
        ],
      ),
    );
  }
}
