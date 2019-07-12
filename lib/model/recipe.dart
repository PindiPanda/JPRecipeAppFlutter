import 'dart:io';
import 'package:flutter/cupertino.dart';


class Recipe{
  
  int id;
  String title;
  String instructions;
  Image largeImage;
  Image smallImage;
  String imagePath;

  Recipe(this.title, this.instructions);
  Recipe.withID(this.id, this.title, this.instructions);

  Future<Map<String,dynamic>> toMap() async{
    Map map = Map<String, dynamic>();
    map = Map<String, dynamic>();
    map["title"] = title;
    map["instructions"] = instructions;
    if (id != null){
      map["id"] = id;
    }
    if (imagePath != null){
      map["imagePath"] = imagePath;
    }
    return map;
  }

  Recipe.fromObject(dynamic object){
    id = object["id"];
    title = object["title"];
    instructions = object["instructions"];
    if (object["imagePath"] != null){
      this.imagePath = object["imagePath"];
      largeImage = Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 500,
        height: 500,
      );
      smallImage = Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 76,
        height: 76,
      );
    }
  }
}