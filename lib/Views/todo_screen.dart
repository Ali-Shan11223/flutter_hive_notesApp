import 'package:flutter/material.dart';
import 'package:hive_notes_app/Boxes/box.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_notes_app/Model/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: Boxes.getBox().listenable(),
          builder: (context, box, child) {
            final data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                        title: Text(
                          data[index].title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data[index].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                editNotes(data[index], data[index].title,
                                    data[index].description);
                              },
                              child: const Icon(Icons.edit),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                deleteNotes(data[index]);
                              },
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteNotes(NotesModel notesModel) async {
    await notesModel.delete();
  }

  void editNotes(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      hintText: 'Enter title', border: InputBorder.none),
                ),
                TextField(
                  controller: descController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      hintText: 'Enter description', border: InputBorder.none),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    notesModel.title = titleController.text;
                    notesModel.description = descController.text;
                    notesModel.save();
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          );
        });
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      hintText: 'Enter title', border: InputBorder.none),
                ),
                TextField(
                  controller: descController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      hintText: 'Enter description', border: InputBorder.none),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descController.text);
                    final box = Boxes.getBox();
                    box.add(data);
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          );
        });
  }
}
