
import 'package:flutter/material.dart';

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
              )).toList()
          ),
        ),
      );
    },
  );
}
