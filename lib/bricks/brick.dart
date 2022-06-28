import 'package:flutter/material.dart';

typedef BrickBuilderJson = Brick Function(Map<String, dynamic> json);

enum BrickType {
  undefined,
  button,
  link,
  links,
  rate,
  text,
}

abstract class Brick extends StatelessWidget {
  const Brick({super.key});
}
