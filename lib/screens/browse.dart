import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:jp_recipes/model/recipe.dart';
import 'package:jp_recipes/util/dbhelper.dart';
import 'package:jp_recipes/screens/new.dart';
import 'package:jp_recipes/recipe_row_item.dart';

class BrowseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipeListState();
}

class RecipeListState extends State {
  DbHelper helper = DbHelper();
  List<Recipe> recipes = List<Recipe>();
  int count = 0;
  Widget build(BuildContext context) {
    getData();
    return CupertinoPageScaffold(
      child: recipeList(),
    );
  }
  Widget recipeList(){
    return CustomScrollView(
      semanticChildCount: recipes.length,
      slivers: <Widget>[
        const CupertinoSliverNavigationBar(
          largeTitle: Text('Browse'),
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < recipes.length) {
                  return RecipeRowItem(
                    index: index, 
                    recipe: recipes[index],
                    lastItem: index == recipes.length-1,
                  );
                }
                return null;
              },
            ),
          ),
        )
      ],
    );
  }

  void getData(){
    final dbFuture = helper.initializeDb();
    dbFuture.then((result){
      final recipesFuture = helper.getRecipes();
      recipesFuture.then((result){
        List<Recipe> recipeList = List<Recipe>();
        count = result.length;
        for (int i = 0; i<count; i++){
          recipeList.add(Recipe.fromObject(result[i]));
        }
        setState(() {
          this.count = count;
          recipes = recipeList;
        });
      });
    });
  }

  void navigateToDetail(Recipe recipe) async{
    bool result = await Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => RecipeView(recipe)),
    );
    if(result == true){
      getData();
    }
  }
}