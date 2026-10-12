
import 'package:flutter/material.dart';

void main() {
runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
const ShoppingListApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Shopping List',
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.green,
),
useMaterial3: true,
),
home: const ShoppingListPage(),
);
}
}

class ShoppingItem {
String name;
bool isBought;

ShoppingItem({
required this.name,
this.isBought = false,
});
}

class ShoppingListPage extends StatefulWidget {
const ShoppingListPage({super.key});

@override
State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
final TextEditingController itemController = TextEditingController();

final List<ShoppingItem> shoppingItems = [];

void addItem() {
String itemName = itemController.text.trim();

if (itemName.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter an item name.'),
),
);
return;
}

setState(() {
shoppingItems.add(
ShoppingItem(name: itemName),
);
});

itemController.clear();
}

void toggleItem(int index) {
setState(() {
shoppingItems[index].isBought =
!shoppingItems[index].isBought;
});
}

void deleteItem(int index) {
String deletedName = shoppingItems[index].name;

setState(() {
shoppingItems.removeAt(index);
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('$deletedName deleted.'),
),
);
}

void clearBoughtItems() {
setState(() {
shoppingItems.removeWhere(
(item) => item.isBought,
);
});
}

@override
void dispose() {
itemController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
int totalItems = shoppingItems.length;

int boughtItems = shoppingItems
    .where((item) => item.isBought)
    .length;

return Scaffold(
appBar: AppBar(
title: const Text('My Shopping List'),
centerTitle: true,
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
Row(
children: [
Expanded(
child: TextField(
controller: itemController,
textCapitalization:
TextCapitalization.sentences,
decoration: const InputDecoration(
labelText: 'Shopping item',
hintText: 'e.g. Milk, Bread, Eggs',
border: OutlineInputBorder(),
),
onSubmitted: (_) => addItem(),
),
),
const SizedBox(width: 8),
IconButton.filled(
onPressed: addItem,
icon: const Icon(Icons.add),
tooltip: 'Add item',
),
],
),

const SizedBox(height: 16),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Text(
'Total: $totalItems',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
Text(
'Bought: $boughtItems',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
],
),

const SizedBox(height: 8),

SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
onPressed: boughtItems > 0
? clearBoughtItems
    : null,
icon: const Icon(Icons.cleaning_services),
label: const Text('Clear Bought Items'),
),
),

const Divider(height: 24),

Expanded(
child: shoppingItems.isEmpty
? const Center(
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Icon(
Icons.shopping_cart_outlined,
size: 70,
color: Colors.grey,
),
SizedBox(height: 12),
Text(
'Your shopping list is empty.',
style: TextStyle(
fontSize: 18,
color: Colors.grey,
),
),
SizedBox(height: 8),
Text(
'Add your first shopping item!',
style: TextStyle(
color: Colors.grey,
),
),
],
),
)
    : ListView.builder(
itemCount: shoppingItems.length,
itemBuilder: (context, index) {
final item = shoppingItems[index];

return Card(
margin: const EdgeInsets.only(
bottom: 8,
),
child: ListTile(
leading: Checkbox(
value: item.isBought,
onChanged: (_) {
toggleItem(index);
},
),
title: Text(
item.name,
style: TextStyle(
decoration: item.isBought
? TextDecoration.lineThrough
    : TextDecoration.none,
color: item.isBought
? Colors.grey
    : null,
),
),
trailing: IconButton(
icon: const Icon(
Icons.delete_outline,
color: Colors.red,
),
tooltip: 'Delete item',
onPressed: () {
deleteItem(index);
},
),
onTap: () {
toggleItem(index);
},
),
);
},
),
),
],
),
),
);
}
}

