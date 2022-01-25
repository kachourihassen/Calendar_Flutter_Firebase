import 'package:firebase_helpers/firebase_helpers.dart';
import '../model/event.dart';

DatabaseService<TasksModel> eventDBS = DatabaseService<TasksModel>("Tasks",
    fromDS: (id, data) => TasksModel.fromDS(id, data),
    toMap: (event) => event.toMap());
