import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/firestore_service.dart';
import 'item_form.dart';

class ItemList extends StatelessWidget {
  ItemList({super.key, required this.searchText});

  final FirestoreService firestoreService = FirestoreService();
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: firestoreService.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load items: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;
        final normalizedSearch = searchText.trim().toLowerCase();
        final filteredItems = items
            .where(
              (item) => item.name.toLowerCase().contains(normalizedSearch),
            )
            .toList();
        final totalInventoryValue = items.fold<double>(0, (sum, item) {
          return sum + (item.price * item.quantity);
        });

        if (items.isEmpty) {
          return const Center(
            child: Text('No items yet. Tap + to add one.'),
          );
        }

        if (filteredItems.isEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.paid),
                    title: const Text('Total Inventory Value'),
                    subtitle: Text('\$${totalInventoryValue.toStringAsFixed(2)}'),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text('No matching items found.'),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.paid),
                  title: const Text('Total Inventory Value'),
                  subtitle: Text('\$${totalInventoryValue.toStringAsFixed(2)}'),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];

                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'Qty: ${item.quantity} | \$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) => ItemForm(existingItem: item),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            firestoreService.deleteItem(item.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}