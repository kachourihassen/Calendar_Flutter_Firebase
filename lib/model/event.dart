import 'package:firebase_helpers/firebase_helpers.dart';

class TasksModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String catigorie;
  final String color;
  final String location;
  final bool isChecked;
  final String iduser;
  TasksModel(
      {this.id,
      this.catigorie,
      this.title,
      this.description,
      this.color,
      this.date,
      this.location,
      this.iduser,
      this.isChecked});
  TasksModel.fromDS(String id, Map<String, dynamic> data)
      : id = id,
        iduser = data['iduser'], //FirebaseAuth.instance.currentUser.uid,
        catigorie = data['catigorie'],
        title = data['title'],
        description = data['description'],
        color = data['color'],
        date = data['date']?.toDate(),
        location = data['location'],
        isChecked = data['isChecked'];
  Map<String, dynamic> toMap() => {
        "catigorie": catigorie,
        "title": title,
        "description": description,
        "color": color,
        "date": date,
        "location": location,
        "isChecked": isChecked,
        "iduser": iduser
      };
}

DatabaseService<TasksModel> tasksModelDb = DatabaseService<TasksModel>(
    "tasksModel",
    fromDS: (id, data) => TasksModel.fromDS(id, data),
    toMap: (eventModel) => eventModel.toMap());

TasksModel eventModel = TasksModel(
  title: "Hello TasksModel",
  description: "This is TasksModel description",
);
