import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slash_task/shared/values.dart';

Widget getHomeAppBar({
  required bool hasNotification,
  required String city,
  required String location,
  required void Function() onSelectCity,
  required void Function() onNotificationClicked,
}){
  return Row(
    children: [
      const Text(
        "Slash.",
        style: AppTheme.headerTextStyle,
      ),

      const Expanded(child: SizedBox()),

      InkWell(
        onTap: onSelectCity,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimen.ROUNDED_CORNERS_RADIUS)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.location_solid,
                size: 34,
              ),

              const SizedBox(width: 8,),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location),
                  Text(
                    city,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Icon(
                Icons.keyboard_arrow_down,
                size: 34,
              ),
            ],
          ),
        ),
      ),

      const Expanded(child: SizedBox()),

      Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(
                  CupertinoIcons.bell,
                  size: 34,
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: hasNotification ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15 / 2 + 1),
                      color: Colors.white,
                    ),

                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15 / 2),
                          color: Colors.red
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: InkWell(
              onTap: onNotificationClicked,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          )
        ],
      )
    ],
  );
}