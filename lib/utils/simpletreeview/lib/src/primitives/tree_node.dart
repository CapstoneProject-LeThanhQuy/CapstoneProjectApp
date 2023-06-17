import 'package:flutter/material.dart';

/// One node of a tree.
class TreeNode {
  final List<TreeNode>? children;
  final Widget content;
  final Key? key;
  final Color color;

  TreeNode({this.key, this.children, Widget? content,required this.color})
      : content = content ??
            const SizedBox(
              width: 0,
              height: 0,
            );
}
