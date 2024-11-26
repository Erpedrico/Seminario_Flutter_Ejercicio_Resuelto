import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/screen/edit.dart';
import '../models/userModel.dart'; // Ajusta la ruta si tu modelo está en otra carpeta

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.mail),
            const SizedBox(height: 8),
            Text(user.comment ?? "Sin comentarios"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(() => EditPage(user: user));
              },
              child: Text("Editar Usuario"),
            ),
          ],
        ),
      ),
    );
  }
}
