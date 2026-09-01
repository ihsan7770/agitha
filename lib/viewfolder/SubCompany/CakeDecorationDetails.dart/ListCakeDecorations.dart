import 'package:agitha/ControllersFolder/CakeDecorationController.dart';
import 'package:agitha/viewfolder/SubCompany/CakeDecorationDetails.dart/CakeDecorationForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CakeDecorationListPage extends StatefulWidget {
  const CakeDecorationListPage({super.key});

  @override
  State<CakeDecorationListPage> createState() => _CakeDecorationListPageState();
}

class _CakeDecorationListPageState extends State<CakeDecorationListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CakeDecorationProvider>(context, listen: false)
          .fetchDecorations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CakeDecorationProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.13;
    final titleSize = screenWidth * 0.045;
    final priceSize = screenWidth * 0.038;
    final paddingSize = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cake Decorations",
          // style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
      ),
      body: provider.decorations.isEmpty
          ? const Center(child: Text("No Cake Decorations"))
          : ListView.builder(
              padding: EdgeInsets.all(paddingSize),
              itemCount: provider.decorations.length,
              itemBuilder: (context, index) {
                final item = provider.decorations[index];

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: paddingSize),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: Row(
                      children: [
                        /// Thumbnail
                        Container(
                          height: iconSize,
                          width: iconSize,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.cake,
                            color: Colors.orange,
                            size: iconSize * 0.6,
                          ),
                        ),
                        SizedBox(width: paddingSize),

                        /// Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.decorationDetails,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleSize,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: paddingSize * 0.3),
                              Text(
                                "Price: ₹${item.decorationPrice}",
                                style: TextStyle(fontSize: priceSize),
                              ),
                            ],
                          ),
                        ),

                        /// Actions
                        Row(
                          children: [
                            IconButton(
                              iconSize: screenWidth * 0.055,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CakeDecorationFormPage(decoration: item),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              iconSize: screenWidth * 0.055,
                              onPressed: () {
                                _confirmDelete(
                                    context, provider, item.docId);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(
      BuildContext context, CakeDecorationProvider provider, String docId) {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Delete Cake Decoration",
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
        content: Text(
          "Are you sure you want to delete this cake decoration?",
          style: TextStyle(fontSize: screenWidth * 0.038),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              provider.deleteDecoration(docId);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
