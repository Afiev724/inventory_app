import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/firestore_service.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key, this.existingItem});

  final Item? existingItem;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    if (item != null) {
      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _priceController.text = item.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final quantity = int.parse(_quantityController.text.trim());
    final price = double.parse(_priceController.text.trim());

    if (widget.existingItem == null) {
      await _firestoreService.addItem(
        Item(id: '', name: name, quantity: quantity, price: price),
      );
    } else {
      await _firestoreService.updateItem(
        Item(
          id: widget.existingItem!.id,
          name: name,
          quantity: quantity,
          price: price,
        ),
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingItem != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Item' : 'Add Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Quantity required';
                  }
                  final parsedValue = int.tryParse(value.trim());
                  if (parsedValue == null) {
                    return 'Must be a whole number';
                  }
                  if (parsedValue <= 0) {
                    return 'Must be greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price required';
                  }
                  final parsedValue = double.tryParse(value.trim());
                  if (parsedValue == null) {
                    return 'Must be a number';
                  }
                  if (parsedValue <= 0) {
                    return 'Must be greater than 0';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: Text(isEdit ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}