import 'package:flutter/material.dart';

//Widget That describes what is seen in the sliding up panel

class PanelWidget extends StatelessWidget {
  final ScrollController controller;

  const PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 36),
          buildAboutText(),
          const SizedBox(
            height: 24,
          ),
        ],
      );

  Widget buildAboutText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                'New York City is one of the most known cities-s',
              )
            ]),
      );
}
