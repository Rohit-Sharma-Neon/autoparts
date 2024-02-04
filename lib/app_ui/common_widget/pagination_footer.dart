import 'package:flutter/material.dart';

paginationFooter({isLoading, hasNextPage, isDismiss}) {
  return Column(
    children: [
      if (isLoading)
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()),
          ),
        ),

      // When nothing else to load
      if (hasNextPage == false && isDismiss)
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green,
          child: const Center(
            child: Text('You have seen all the content available',
                style: TextStyle(color: Colors.white)),
          ),
        )
    ],
  );
}
