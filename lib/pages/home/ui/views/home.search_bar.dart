

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slash_task/shared/values.dart';

/// a function that generates the home search bar
/// [context] current build context
/// [controller] the text editing controller for the text field
/// [filtersEnabled] weather or not to expand the filters menu
/// [onFiltersClicked] a call back when the filter button is clicked
/// [onSearchSubmit] a call back when input text is submitted
Widget getHomeSearchBar({
  required BuildContext context,
  required TextEditingController controller,
  required bool filtersEnabled,
  required void Function() onFiltersClicked,
  required void Function(String?) onSearchSubmit,
}){
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(4.0).copyWith(left: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.search,
                      size: 34,
                    ),

                    const SizedBox(width: 8,),
                    Expanded(
                      child: TextField(
                        onSubmitted: onSearchSubmit,
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Search here.",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.3)
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0).copyWith(right: 0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                ),
                child: InkWell(
                  onTap: onFiltersClicked,
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                  ),
                  child: const Icon(Icons.tune_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
      AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        opacity: filtersEnabled ? 1 : 0,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            height: filtersEnabled ? null : 0,
            child: Column(
              children: [
                const SizedBox(height: 16,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Year: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox() , flex: 2,),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                            ),
                            child: const Text("1999",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Expanded(flex: 1,child: SizedBox() ,),

                          const Text(" To ",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const Expanded(flex: 1,child: SizedBox() ,),


                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                            ),
                            child: const Text("2024",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Expanded(flex: 2,child: SizedBox() ,),

                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4,),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Price: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox() , flex: 2,),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                            ),
                            child: const Text("12\$",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Expanded(flex: 1,child: SizedBox() ,),

                          const Text(" To ",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const Expanded(flex: 1,child: SizedBox() ,),


                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS),
                            ),
                            child: const Text("200\$",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const Expanded(flex: 2,child: SizedBox() ,),

                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4,),
                const Text("Other filters could be added, but it was not mentioned in the task paper..")
              ],
            ),
          ),
        ),
      )
    ],

  );
}