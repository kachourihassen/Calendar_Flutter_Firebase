import 'package:firebase_helpers/firebase_helpers.dart';

class CategorieModel {
  final String categorie;
  final String color;

  CategorieModel({this.categorie, this.color});
  CategorieModel.fromDS(String id, Map<String, dynamic> data)
      : categorie = data['categorie'],
        color = data['color'];

  Map<String, dynamic> toMap() => {
        "categorie": categorie,
        "color": color,
      };
}

DatabaseService<CategorieModel> categorieModelDb =
    DatabaseService<CategorieModel>("CategorieModel",
        fromDS: (id, data) => CategorieModel.fromDS(id, data),
        toMap: (eventModel) => eventModel.toMap());

CategorieModel userModel = CategorieModel(
  categorie: " ",
  color: " ",
);
