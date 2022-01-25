import 'package:firebase_helpers/firebase_helpers.dart';

class UsersModel {
  final String nom;
  final String prenom;

  UsersModel({this.nom, this.prenom});
  UsersModel.fromDS(String id, Map<String, dynamic> data)
      : nom = data['nom'],
        prenom = data['prenom'];

  Map<String, dynamic> toMap() => {
        "nom": nom,
        "prenom": prenom,
      };
}

DatabaseService<UsersModel> usersModelDb = DatabaseService<UsersModel>(
    "UsersModel",
    fromDS: (id, data) => UsersModel.fromDS(id, data),
    toMap: (eventModel) => eventModel.toMap());

UsersModel userModel = UsersModel(
  nom: " ",
  prenom: " ",
);
