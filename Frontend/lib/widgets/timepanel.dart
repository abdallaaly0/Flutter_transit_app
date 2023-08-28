import 'package:flutter/material.dart';

class TimePanel extends StatelessWidget {
  final ScrollController controller;

  const TimePanel({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 40,
          width: 5,
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black,
            width: 5,
          )),
        ),
      ],
    );
  }
}
