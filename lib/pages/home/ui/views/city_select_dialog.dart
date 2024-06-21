
import 'package:flutter/material.dart';

/// shows a dialog that enables you to select one item from a list of items
/// [context] the build context
/// [items] the items to be shown
/// [onSelect] a call back function that will be called when an item is clicked
void showCitySelectDialog(BuildContext context, List<String> items, void Function(int) onSelect) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select your location'),
        content: SizedBox(
          height: 200,
          width: 300,
          child: ListView(
            children: items.map((e) => ListTile(
              title: Text(e),
              onTap: () {
                Navigator.of(context).pop();
                onSelect(items.indexOf(e));
              },
            )).toList(),
          ),
        ),
      );
    },
  );
}
