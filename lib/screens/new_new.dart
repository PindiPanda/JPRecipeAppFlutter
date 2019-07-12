import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jp_recipes/model/recipe.dart';
import 'package:jp_recipes/util/dbhelper.dart';
import 'package:jp_recipes/screens/new.dart';

DbHelper helper = DbHelper();
TextEditingController recipeController;

class RecipeView extends StatefulWidget {
  final Recipe recipe;
  RecipeView(this.recipe);

  @override
  State<StatefulWidget> createState(){
    recipeController = new TextEditingController(
      text: recipe.instructions
    );
    return RecipeViewState(recipe);
  }
}

class RecipeViewState extends State{
  Recipe recipe;
  RecipeViewState(this.recipe);
  @override
  Widget build(BuildContext context){
    return(
      CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(recipe.title),
              trailing: GestureDetector(
                child: Text('Edit', style: CupertinoTheme.of(context).textTheme.actionTextStyle), 
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => RecipeEdit(recipe)
                    )
                  );
                },
              ),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    recipe.largeImage != null?
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: ClipRRect(
                          child: recipe.largeImage,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        )
                      )
                      : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.extraLightBackgroundGray),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 7.5, right: 7.5),
                            child: Text(
                            recipe.instructions,
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}