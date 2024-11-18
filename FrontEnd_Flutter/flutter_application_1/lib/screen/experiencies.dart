import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/experience.dart';
import 'package:flutter_application_1/controllers/experiencesListController.dart';
import 'package:flutter_application_1/controllers/experiencesController.dart';
import 'package:flutter_application_1/models/experienceModel.dart';
import 'package:get/get.dart';

class ExperienciesPage extends StatefulWidget {
  @override
  _ExperienciesPageState createState() => _ExperienciesPageState();
}

class _ExperienciesPageState extends State<ExperienciesPage> {
  final ExperienceController experienceController = Get.put(ExperienceController());
  final ExperienceListController experienceListController = Get.put(ExperienceListController());

  @override
  void initState() {
    super.initState();
    experienceListController.fetchExperiences(); // Asegúrate de obtener experiencias al iniciar la página.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Experiencias')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Lista de experiencias
            Expanded(
              child: Obx(() {
                if (experienceListController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (experienceListController.experienceList.isEmpty) {
                  return Center(child: Text("No hay experiencias disponibles"));
                } else {
                  return ListView.builder(
                    itemCount: experienceListController.experienceList.length,
                    itemBuilder: (context, index) {
                      final experience = experienceListController.experienceList[index];
                      return ExperienceCard(
                        experience: experience,
                        onDelete: () => experienceListController.deleteExperienceByDescription(experience.description),
                      );
                    },
                  );
                }
              }),
            ),
            SizedBox(width: 20),
            // Formulario de registro de experiencia
            Expanded(
              flex: 2,
              child: ExperienceForm(experienceController: experienceController),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para el formulario de experiencia
class ExperienceForm extends StatelessWidget {
  final ExperienceController experienceController;

  const ExperienceForm({Key? key, required this.experienceController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crear Nueva Experiencia',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: experienceController.ownerController,
          decoration: InputDecoration(
            labelText: 'Propietario',
            errorText: experienceController.ownerError.value,
          ),
        ),
        TextField(
          controller: experienceController.participantsController,
          decoration: InputDecoration(
            labelText: 'Participantes',
            errorText: experienceController.participantsError.value,
          ),
        ),
        TextField(
          controller: experienceController.descriptionController,
          decoration: InputDecoration(
            labelText: 'Descripción',
            errorText: experienceController.descriptionError.value,
          ),
        ),
        SizedBox(height: 16),
        Obx(() {
          if (experienceController.isLoading.value) {
            return CircularProgressIndicator();
          } else {
            return ElevatedButton(
              onPressed: () {
                experienceController.createExperience();
              },
              child: Text('Crear Experiencia'),
            );
          }
        }),
      ],
    );
  }
}

// Widget reutilizable para mostrar una tarjeta de experiencia
class ExperienceCard extends StatelessWidget {
  final ExperienceModel experience;
  final VoidCallback onDelete;

  const ExperienceCard({Key? key, required this.experience, required this.onDelete}) : super(key: key);

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
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(experience.description),
            const SizedBox(height: 16),
            Text(
              'Propietario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Nombre: ${experience.owner}'),
            const SizedBox(height: 8),
            Text(
              'Participantes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(experience.participants),
            const SizedBox(height: 16),
            // Botón para eliminar experiencia
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
