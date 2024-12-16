import 'package:flutter/material.dart';

import '../utils/styles.dart';

class CategoryBox extends StatefulWidget {
  final String? restorationId;
  final List<Widget> children;
  final callback;
  final Widget? suffix;
  final String title;
  final String bgColor;
  final Color tColor;

  // final List<DataRow> dataRowChildren;
  // final List<DataColumn> dataColumnChildren;

  const CategoryBox(
      {super.key,
        this.suffix,
        required this.children,
        required this.title,
        required this.bgColor,
        required this.tColor,
        this.restorationId,
        this.callback});

  @override
  State<CategoryBox> createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(int.parse(widget.bgColor)),
        borderRadius: Styles.defaultBorderRadius,
      ),
      child: Column(
        children: [
          // DataTable(columns: dataColumnChildren, rows: dataRowChildren),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Styles.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: widget.tColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...widget.children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}