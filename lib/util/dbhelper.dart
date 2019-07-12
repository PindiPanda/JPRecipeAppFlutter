import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:jp_recipes/model/recipe.dart';
import 'package:flutter/cupertino.dart';

class DbHelper{
  static final DbHelper _dbHelper = DbHelper.internal();

  String tblRecipe = "recipe";
  String colId = "id";
  String colTitle = "title";
  String colInstructions = "instructions";
  String colImagePath = "imagePath";

  DbHelper.internal();

  factory DbHelper(){
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }
  
  Future<Database> initializeDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "recipes.db");
    var dbRecipes = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbRecipes;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblRecipe($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
      "$colInstructions TEXT, $colImagePath TEXT)"
    );
  }

  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await this.db;
    var result = await db.insert(tblRecipe, await recipe.toMap());
    return result;
  }

  Future<List> getRecipes() async{
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblRecipe");
    return result;
  }

  Future<int> updateRecipe(Recipe recipe) async{
    var db = await this.db;
    var result = await db.update(tblRecipe, await recipe.toMap(),
    where: "$colId = ?", whereArgs: [recipe.id]);
    return result;
  }

  Future<int> deleteRecipe(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblRecipe WHERE $colId = $id");
    return result;
  }
}