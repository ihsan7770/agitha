import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomCartBar extends StatelessWidget {
  final VoidCallback onViewCart;

  const BottomCartBar({super.key, required this.onViewCart});

  @override
  Widget build(BuildContext context) {


    return Selector<CartController, int>(
     selector: (_, c) => c.uniqueItemsCount,

      builder: (context, count, _) {
        final visible = context.watch<CartController>().showCartBar;

        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: visible ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: visible ? 1 : 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      
                      "$count ${count == 1 ? 'item' : 'items'} in cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton(
                      onPressed: onViewCart,
                      child: Text("View Cart"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
