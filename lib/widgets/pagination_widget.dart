import 'package:flutter/material.dart';

import '../provider/user_provider.dart';

class PaginationWidget extends StatelessWidget {
  final UserProvider userProvider;

  const PaginationWidget(this.userProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (userProvider.page > 1) {
              userProvider.previousPage();
            }
          },
        ),
        Text('Page ${userProvider.page}'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            userProvider.nextPage();
          },
        ),
      ],
    );
  }
}
