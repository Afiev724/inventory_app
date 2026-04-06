import 'package:flutter/material.dart';

import '../widgets/item_form.dart';
import '../widgets/item_list.dart';

class HomePage extends StatefulWidget {
	const HomePage({
		super.key,
		required this.isDarkMode,
		required this.onToggleTheme,
	});

	final bool isDarkMode;
	final VoidCallback onToggleTheme;

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	String _searchText = '';

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Inventory'),
				actions: [
					IconButton(
						tooltip: widget.isDarkMode
								? 'Switch to light mode'
								: 'Switch to dark mode',
						onPressed: widget.onToggleTheme,
						icon: Icon(
							widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
						),
					),
				],
			),
			body: Column(
				children: [
					Padding(
						padding: const EdgeInsets.all(12),
						child: TextField(
							decoration: const InputDecoration(
								labelText: 'Search items',
								prefixIcon: Icon(Icons.search),
								border: OutlineInputBorder(),
							),
							onChanged: (value) {
								setState(() {
									_searchText = value;
								});
							},
						),
					),
					Expanded(
						child: ItemList(searchText: _searchText),
					),
				],
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					showDialog<void>(
						context: context,
						builder: (_) => const ItemForm(),
					);
				},
				child: const Icon(Icons.add),
			),
		);
	}
}