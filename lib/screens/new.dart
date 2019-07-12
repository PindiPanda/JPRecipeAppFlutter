import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jp_recipes/model/recipe.dart';
import 'package:jp_recipes/util/dbhelper.dart';

import 'dart:io';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

DbHelper helper = DbHelper();


class RecipeView extends StatefulWidget {
  final Recipe recipe;
  RecipeView(this.recipe);
  @override
  State<StatefulWidget> createState() => RecipeViewState(recipe);
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
              trailing: CupertinoButton(
                padding: EdgeInsets.all(0.0),
                child: Text('Edit', style: CupertinoTheme.of(context).textTheme.actionTextStyle), 
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecipeEdit(recipe),
                      fullscreenDialog: true,
                    ),
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
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.width - 30,
                          child: Hero(tag: 'image'+recipe.id.toString(), child: ClipRRect(
                            child: recipe.largeImage,
                            borderRadius: BorderRadius.circular(5),
                          )),
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

TextEditingController titleController;
TextEditingController instructionController;
ScrollController scrollController;

class RecipeEdit extends StatefulWidget {
  final Recipe recipe;
  RecipeEdit(this.recipe);
  @override
  State<StatefulWidget> createState(){
    titleController = new TextEditingController(
      text: recipe.title,
    );
    instructionController = new TextEditingController(
      text: recipe.instructions,
    );
    scrollController = ScrollController();
    return RecipeEditState(recipe, recipe.largeImage);
  } 
}

class RecipeEditState extends State{
  Recipe recipe;
  File imageFile;
  Image largeImage;
  Image smallImage;
  RecipeEditState(this.recipe, this.largeImage);
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: <Widget>[
        SizedBox(
          height: 140,
          child: Stack(
            children: <Widget>[
              Container(color: CupertinoTheme.of(context).barBackgroundColor),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 92.5, right: 15.0, bottom: 10.0),
                  child: Text(
                  recipe.id != null? "Edit" : "New",
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                  ),
              ),
              Align(
                alignment: Alignment(0.91, -.04),
                  child: 
                  CupertinoButton(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(CupertinoIcons.clear_thick_circled, size: 30.0, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ) 
              ),

            ]
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 15.0, right: 15.0),
          child: CupertinoTextField(
            controller: titleController,
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            onChanged: (value) {},
            textCapitalization: TextCapitalization.words,
            placeholder: 'Recipe',
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0), 
          child: Row(
            children: [
              largeImage == null ? 
              Expanded(
                child:CupertinoButton(
                  color: CupertinoColors.inactiveGray,
                  child: Icon(CupertinoIcons.photo_camera),
                  onPressed: getImage,
                )
              )
              : Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.width - 30,
                        child: ClipRRect(
                          child: largeImage,
                          borderRadius: BorderRadius.circular(5),
                        ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        CupertinoIcons.photo_camera_solid,
                        size: 76,
                      ),
                      onPressed: () => getImage(),
                    ),
                  ],
                ),
            ]
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: CupertinoTextField(
            controller: instructionController,
            style: CupertinoTheme.of(context).textTheme.textStyle,
            //onChanged: (value){scrollController.jumpTo(scrollController.position.ensureVisible());},
            placeholder: 'Instructions',
            minLines: null,
            maxLines: null,
            expands: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0), 
          child: Row(children: [
            Expanded(child:CupertinoButton(
              color: CupertinoColors.activeBlue,
              child: Text("Save"),
              onPressed: saveRecipe(recipe, imageFile),
            ))
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left:15, right: 15),
          child: Row(children: [
            Expanded(child:CupertinoButton(
              disabledColor: Colors.transparent,
              color: CupertinoColors.destructiveRed,
              child: Text("Delete"),
              onPressed: deleteRecipe(recipe),
            )),
          ])
        ),
        Container(height: MediaQuery.of(context).viewInsets.bottom + 25),
      ])
    ));
  }
  saveRecipe(Recipe recipe, File imageFile){
    return() async{
      recipe.title = titleController.text;
      recipe.instructions = instructionController.text;
      recipe.largeImage = largeImage;
      recipe.smallImage = smallImage;
      if(recipe.id != null){
        if (imageFile != null){
          final Directory dir = await getApplicationDocumentsDirectory();
          final String imageName = 'Image'+recipe.id.toString();
          //imageCache.clear();
          imageCache.evict(FileImage(File(p.join(dir.path, imageName))));
          final File newImage = await imageFile.copy(p.join(dir.path, imageName));
          recipe.imagePath = newImage.path;
        }
        helper.updateRecipe(recipe);
      }else {
        if (imageFile != null){
          final int recipeId = await helper.insertRecipe(recipe);
          final Directory dir = await getApplicationDocumentsDirectory();
          final String imageName = 'Image'+recipeId.toString();
          final File newImage = await imageFile.copy(p.join(dir.path, imageName));
          recipe.id = recipeId;
          recipe.imagePath = newImage.path;
          helper.updateRecipe(recipe);
        } else {
          await helper.insertRecipe(recipe);
        }
      }
      CupertinoAlertDialog alertDialog = CupertinoAlertDialog(
        title: Text("Recipe Saved"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      );
      showCupertinoDialog(
          context: context,
          builder: (_) => alertDialog,
        );
    };
  }
  deleteRecipe(Recipe recipe){
    if(recipe.id == null){
      return null;
    }else{
      return(){
        CupertinoAlertDialog alertDialog = CupertinoAlertDialog(
          //title: Text("Delete Recipe"),
          title: Text("Are you sure you would like to delete this recipe?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Delete"),
              isDestructiveAction: true,
              onPressed: (){
                if(recipe.imagePath != null){
                  Directory(recipe.imagePath).delete();
                }
                helper.deleteRecipe(recipe.id);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )],
        );
        showCupertinoDialog(
          context: context,
          builder: (_) => alertDialog,
        );
      };
    }
  }
  Future getImage() async {
    final File newImageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    if (newImageFile != null){
      setState((){
        largeImage = Image.file(
          newImageFile,
          fit: BoxFit.cover,
          width: 500,
          height: 500,
        );
        smallImage = Image.file(
          newImageFile,
          fit: BoxFit.cover,
          width: 76,
          height: 76,
        );
        imageFile = newImageFile;
      });
    }
  }
}
