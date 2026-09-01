import 'package:agitha/ControllersFolder/DecorationController.dart';
import 'package:agitha/viewfolder/SubCompany/DecorationFolder.dart/DecorationFormPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DecorationListPage extends StatefulWidget {
  const DecorationListPage({super.key});

  @override
  State<DecorationListPage> createState() => _DecorationListPageState();
}

class _DecorationListPageState extends State<DecorationListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DecorationProvider>(context, listen: false)
          .fetchDecorations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DecorationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Decoration Details"),
        centerTitle: true,
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const DecorationFormPage()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),

      body: provider.decorations.isEmpty
          ? const Center(child: Text("No Decorations"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.decorations.length,
              itemBuilder: (context, index) {
                final item = provider.decorations[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Theme(
                        data: Theme.of(context).copyWith(
                         dividerColor: Colors.transparent, // ✅ remove line
                         splashColor: Colors.transparent,
                         highlightColor: Colors.transparent,
                       ),

                    child: ExpansionTile(
                      tilePadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            const Icon(Icons.celebration, color: Colors.pink),
                      ),
                    
                      title: Text(
                        item.eventName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    
                      children: [
                    
                        /// Decoration Details
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.decorationDetails,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 10),
                    
                        /// Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                               style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DecorationFormPage(decoration: item),
                                  ),
                                );
                              },
                              child: const Text("Update"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                              onPressed: () {
                                _confirmDelete(context, provider, item.docId);
                              },
                             child: const Text("Delete"),
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
      BuildContext context, DecorationProvider provider, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Decoration"),
        content: const Text("Are you sure you want to delete this decoration?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
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
