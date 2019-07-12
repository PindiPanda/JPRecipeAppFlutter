import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jp_recipes/screens/new.dart';
import 'package:jp_recipes/screens/browse.dart';
import 'package:jp_recipes/screens/search.dart';
import 'package:jp_recipes/util/dbhelper.dart';
import 'package:jp_recipes/model/recipe.dart';

DbHelper helper = DbHelper();

void main() {
  /*Recipe recipe1 = new Recipe("testy 1", "hey");
  helper.insertRecipe(recipe1);
  Recipe recipe2 = new Recipe("testy 2", "hey you");
  helper.insertRecipe(recipe2);
  Recipe recipe3 = new Recipe("testy 3", "hey, hey you");
  helper.insertRecipe(recipe3);*/
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      //home: MyHomePage(),
      home: new SearchScreen(),
      //home: RecipeView(Recipe('Testy','Hey')),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add),
          title: Text('New'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.book),
          title: Text('Browse'),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          title: Text('Search'),
        ),
      ]), 
      tabBuilder: (context, index){
        if (index == 0){
          return(RecipeEdit(Recipe.withID(null, '','')));
        }else if (index == 1){
          return(BrowseScreen());
        }else{
          return(SearchScreen());
       }
      },
    );
  }
}
