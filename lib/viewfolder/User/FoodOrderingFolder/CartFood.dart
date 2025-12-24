import 'package:agitha/ControllersFolder/AddressController.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/ControllersFolder/UserOrderStatusController.dart';
import 'package:agitha/ModelsFoder/AddressModel.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/AddAddressPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/FoodPaymentPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderConfromationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({super.key});

  @override
  State<FoodCartPage> createState() => _FoodCartPageState();
}

class _FoodCartPageState extends State<FoodCartPage> {
  


  // void _showSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         title:
  //             const Icon(Icons.check_circle, color: Colors.green, size: 60),
  //         content: const Text(
  //           "Order Placed Successfully!",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => const FoodPaymentPage()));
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Theme.of(context).colorScheme.primary,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //             ),
  //             child: const Text("Ok"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _cartItem(BuildContext context, CartItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartController>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Slidable(
        key: ValueKey(item.dishName),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => cart.removeFromCart(item),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.dishPhoto,
                  width: screenWidth * 0.20,
                  height: screenWidth * 0.20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.dishName,
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${item.price}",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _qtyButton(Icons.remove, () => cart.decrementQty(item)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            item.quantity.toString(),
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _qtyButton(Icons.add, () => cart.incrementQty(item)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
   final orderController = Provider.of<OrderController>(context,listen: false);

  
  return Consumer<CartController>(builder: (context, cart, _) {
    final items = cart.cart;
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                "Your Cart is Empty",
                style: GoogleFonts.tinos(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Add items to continue",
                style: GoogleFonts.tinos(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    String restaurantName =
        items.isNotEmpty ? items.first.companyName : "Your Restaurant";

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
            
        //   },
        // ),
      ),
      body: Stack(
        children: [
          // Scrollable content
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0), // reserve space for button
            child: SingleChildScrollView(
              child: Column(
                children: [


                          
                    Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(restaurantName,
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ...items.map((item) => _cartItem(context, item)).toList(),
                  const Divider(color: Colors.grey, thickness: 1),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text("Total",
                            style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text("₹${cart.totalPrice.toStringAsFixed(2)}",
                            style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Delivery Address",
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
               StreamBuilder<AddressModel?>(
               stream: context.read<AddressProvider>().selectedAddressStream(),
       builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.only(left: 20),
        child: CircularProgressIndicator(),
      );
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          "No address selected",
          style: TextStyle(color: Colors.redAccent),
        ),
      );
    }

    final selectedAddress = snapshot.data!;

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              selectedAddress.housename,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10),
            child: Text(
              selectedAddress.address,
              textAlign: TextAlign.start,
              style: GoogleFonts.tinos(
                fontSize: 16,
                color: const Color.fromARGB(255, 123, 122, 122),
              ),
            ),
          ),
        ],
      ),
    );
  },
),





                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.primary, width: 1.5)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddAddressPage()));
                        },
                        child: const Text("Change"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

            StreamBuilder<bool>(
    stream: UserOrderStatusProvider().hasActiveOrderStream(),
    builder: (context, snapshot) {
  
      // 🔍 Debug logs
      print("ConnectionState: ${snapshot.connectionState}");
      print("Has Data: ${snapshot.hasData}");
      print("Snapshot Data: ${snapshot.data}");
      print("Error: ${snapshot.error}");
  
      // while loading
      if (snapshot.connectionState == ConnectionState.waiting) {
        print("⏳ Waiting for order status...");
        return const SizedBox(); // or loader
      }
  
      if (snapshot.hasError) {
        print("❌ Stream error");
        return const SizedBox();
      }
  
      final hasActiveOrder = snapshot.data ?? false;
      print(
        hasActiveOrder
            ? "✅ Active order available"
            : "❌ No active order"
      );
  
      return 
          Consumer<OrderController>(
         builder: (context, orderController, _) {
          return  Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: hasActiveOrder? 
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),),
                  
                  child:  Center(child: Text("You have an active order", style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),))):
                  
                 ElevatedButton(
       onPressed: cart.totalPrice <= 59 || orderController.isLoading
      ? null // ❌ disabled
      : () async {
          final orderController =
              Provider.of<OrderController>(context, listen: false);

          final userProfile =
              await orderController.currentUserProfileStream().first;
          final selectedAddress =
              await orderController.selectedAddressStream().first;

          await orderController.placeOrder(
            cartItems: items,
            userProfile: userProfile!,
            selectedAddress: selectedAddress!,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderConfromationPage(),
            ),
          );
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: cart.totalPrice <= 59
        ? Colors.grey
        : colorScheme.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: orderController.isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
      :cart.totalPrice <= 59 ? const Text("Minimum order amount should be ₹60 above"):
      
      
      
       const Text("Place Order"),
)

              ),
            ),
          );
  },
);

    },



    
  ),












          // Place Order button fixed at bottom
         
        ],
      ),
    );
  });
}}