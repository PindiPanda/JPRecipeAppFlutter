import 'package:flutter/cupertino.dart';

class SearchBar extends StatelessWidget{
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchBar({
    @required this.controller,
    @required this.focusNode,
  });
  @override
  Widget build(BuildContext context){
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.lightBackgroundGray),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              CupertinoIcons.search,
              color: CupertinoColors.black,
            ),
            Expanded(
              child: CupertinoTextField(
                decoration: BoxDecoration(),
                controller: controller,
                focusNode: focusNode,
                style: CupertinoTheme.of(context).textTheme.textStyle,
                cursorColor: CupertinoColors.activeBlue,
              ),
            ),
            GestureDetector(
              onTap: controller.clear,
              child: const Icon(
                CupertinoIcons.clear_thick_circled,
                color: CupertinoColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}