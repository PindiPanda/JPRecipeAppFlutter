import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/recipe.dart';
import 'package:jp_recipes/screens/new.dart';



class RecipeRowItem extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final bool lastItem;

  const RecipeRowItem({
    this.recipe,
    this.index,
    this.lastItem
  });

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: CupertinoButton(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(1),
      onPressed: (){
        //debugPrint(recipe.title);
        Navigator.push(
          context,
          SizeRoute(
            page: RecipeView(recipe)
          )
        );
      },
      child: Row(
        children: <Widget>[
          recipe.smallImage != null?
          Hero(
            tag:'image'+recipe.id.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: recipe.smallImage
            )
          )
          : Icon(
            CupertinoIcons.photo_camera,
            size: 72,
            color: CupertinoColors.inactiveGray,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    recipe.title,
                    style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    recipe.instructions,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      )
    );
    if (lastItem) {
      return row;
    }
    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: CupertinoColors.lightBackgroundGray,
          ),
        ),
      ],
    );
  }
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;
  SizeRoute({this.page}) : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) => page, transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset (0,2),
        end: Offset.zero
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.linearToEaseOut,
        ),
      ),
      child: child,
    )
  );
}
