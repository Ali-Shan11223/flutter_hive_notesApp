import 'package:hive/hive.dart';
import 'package:hive_notes_app/Model/notes_model.dart';

class Boxes {
  static Box<NotesModel> getBox() => Hive.box<NotesModel>('notes');
}
