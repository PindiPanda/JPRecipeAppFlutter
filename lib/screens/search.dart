import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jp_recipes/model/recipe.dart';
import 'package:jp_recipes/util/dbhelper.dart';
import 'package:jp_recipes/recipe_row_item.dart';
import 'package:jp_recipes/search_bar.dart';
import 'package:jp_recipes/screens/new.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipeListState();
}

class RecipeListState extends State{
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';
  DbHelper helper = DbHelper();
  List<Recipe> recipes = List<Recipe>();
  int count = 0;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }
  @override 
  void dispose(){
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
  void _onTextChanged(){
    setState(() {
      _terms = _controller.text;
    });
  }
  Widget _buildSearchBox(){
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    getData();
    final results = search(_terms);
    return CupertinoPageScaffold(
      child:CustomScrollView(
      semanticChildCount: results.length + 1,
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text("JP's Recipes"),
          trailing: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Icon(CupertinoIcons.add, size: 35,),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeEdit(Recipe('','')),
                  fullscreenDialog: true,
                )
              );
            },
          )
        ),
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 8),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0){
                  return _buildSearchBox();
                }
                if (index < results.length+1) {
                  return RecipeRowItem(
                    index: index-1, 
                    recipe: results[index-1],
                    lastItem: index-1 == results.length-1,
                  );
                }
                return null;
              },
            ),
          ),
        )
      ],
    ));
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
  List<Recipe> search(String searchTerms){
    return recipes.where((recipe){
      return recipe.title.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }
}