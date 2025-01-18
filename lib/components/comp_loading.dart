import 'package:flutter/material.dart';



class CompLoading extends StatelessWidget {
  const CompLoading({
    super.key,
    required this.message
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 55,
            height: 55,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            ),
          ),
          const SizedBox(height: 22),
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))
        ],
      )
    );
  }
}