# Inventory App

Flutter + Firebase inventory manager with real-time CRUD operations.

## Features

- Add, update, delete inventory items using Cloud Firestore
- Real-time item updates with `StreamBuilder`
- Form validation for required and numeric fields

## Enhanced Features

### 1. Search Filter

Items are filtered by name using:

```dart
items.where((item) => item.name.contains(searchText)).toList();
```

In the app, search is case-insensitive and updates live as you type.

### 2. Total Inventory Value

The app calculates total inventory value with:

```dart
double total = items.fold(0, (sum, item) {
	return sum + (item.price * item.quantity);
});
```

The total is displayed above the item list.

### 3. Dark Mode Toggle

A dark/light mode toggle is available in the top app bar.

## Getting Started

1. Install dependencies:

```bash
flutter pub get
```

2. Configure Firebase for your platforms.

3. Run the app:

```bash
flutter run
```
