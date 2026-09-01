import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agitha/ControllersFolder/CartController.dart';

class BottomCartBar extends StatelessWidget {
  final VoidCallback onViewCart;

  const BottomCartBar({super.key, required this.onViewCart});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

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
                margin: EdgeInsets.all(w * 0.04),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: w * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(w * 0.04),
                ),
                child: Row(
                  children: [
                    /// 🛒 TEXT
                    Expanded(
                      child: Text(
                        "$count ${count == 1 ? 'item' : 'items'} in cart",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.045, // auto scale
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(width: w * 0.03),

                    /// 👁️ VIEW CART
                    SizedBox(
                      height: w * 0.09,
                      child: ElevatedButton(
                        onPressed: onViewCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.05,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.03),
                          ),
                        ),
                        child: Text(
                          "View Cart",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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
