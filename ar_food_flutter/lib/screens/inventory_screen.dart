import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _inventoryItems = [
    {'name': 'Classic Burger', 'emoji': '🍔', 'rarity': 'COMMON', 'xp': '+50 XP', 'category': 'Burgers', 'color': Colors.grey},
    {'name': 'Golden Fries', 'emoji': '🍟', 'rarity': 'COMMON', 'xp': '+30 XP', 'category': 'Burgers', 'color': Colors.grey},
    {'name': 'Golden Ticket', 'emoji': '🎟️', 'rarity': 'RARE', 'xp': '+200 XP', 'category': 'Dessert', 'color': Colors.orange},
    {'name': 'Diamond', 'emoji': '💎', 'rarity': 'LEGENDARY', 'xp': '+500 XP', 'category': 'Dessert', 'color': Colors.purple},
    {'name': 'Ice Cream', 'emoji': '🍦', 'rarity': 'COMMON', 'xp': '+35 XP', 'category': 'Dessert', 'color': Colors.grey},
    {'name': 'Cupcake', 'emoji': '🧁', 'rarity': 'RARE', 'xp': '+150 XP', 'category': 'Dessert', 'color': Colors.orange},
    {'name': 'Pepperoni Pizza', 'emoji': '🍕', 'rarity': 'COMMON', 'xp': '+40 XP', 'category': 'Pizza', 'color': Colors.grey},
    {'name': 'Margherita', 'emoji': '🍕', 'rarity': 'RARE', 'xp': '+180 XP', 'category': 'Pizza', 'color': Colors.orange},
    {'name': 'Espresso', 'emoji': '☕', 'rarity': 'COMMON', 'xp': '+25 XP', 'category': 'Coffee', 'color': Colors.grey},
    {'name': 'Latte', 'emoji': '☕', 'rarity': 'RARE', 'xp': '+120 XP', 'category': 'Coffee', 'color': Colors.orange},
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var items = _inventoryItems;
    
    // Apply category filter
    if (_selectedFilter != 'All') {
      items = items.where((item) => item['category'] == _selectedFilter).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) => 
        item['name'].toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(
            icon: Icon(_searchQuery.isEmpty ? Icons.search : Icons.close),
            onPressed: () {
              setState(() {
                if (_searchQuery.isNotEmpty) {
                  _searchQuery = '';
                } else {
                  // Show search dialog
                  showSearch(
                    context: context,
                    delegate: _InventorySearchDelegate(_inventoryItems, _selectedFilter, (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    }),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar (when search is active)
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.glassDecoration(context).color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _searchQuery,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Burgers'),
                _buildFilterChip('Pizza'),
                _buildFilterChip('Dessert'),
                _buildFilterChip('Coffee'),
              ],
            ),
          ),
          
          // Grid
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? AppTheme.darkTextMuted 
                              : AppTheme.lightTextMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? AppTheme.darkTextMuted 
                                : AppTheme.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: _filteredItems.map((item) => _buildInventoryItem(
                      item['name'],
                      item['emoji'],
                      item['rarity'],
                      item['xp'],
                      item['color'],
                    )).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _selectedFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withOpacity(0.2) : AppTheme.glassDecoration(context).color,
          border: Border.all(color: isActive ? AppTheme.primary : (isDark ? Colors.white12 : Colors.black12)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isActive ? AppTheme.primary : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary), fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildInventoryItem(String name, String emoji, String rarity, String xp, Color rarityColor) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 4, width: double.infinity, color: rarityColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: rarityColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text(rarity, style: TextStyle(color: rarityColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Text(xp, style: const TextStyle(color: AppTheme.tertiary, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventorySearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> items;
  final String selectedFilter;
  final Function(String) onSearch;

  _InventorySearchDelegate(this.items, this.selectedFilter, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredItems = items.where((item) {
      bool matchesFilter = selectedFilter == 'All' || item['category'] == selectedFilter;
      bool matchesSearch = item['name'].toLowerCase().contains(query.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No results found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          leading: Text(item['emoji'], style: const TextStyle(fontSize: 32)),
          title: Text(item['name']),
          subtitle: Text('${item['rarity']} - ${item['xp']}'),
          onTap: () {
            onSearch(query);
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items.where((item) {
      bool matchesFilter = selectedFilter == 'All' || item['category'] == selectedFilter;
      bool matchesSearch = item['name'].toLowerCase().contains(query.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          leading: Text(item['emoji'], style: const TextStyle(fontSize: 32)),
          title: Text(item['name']),
          subtitle: Text('${item['rarity']} - ${item['xp']}'),
          onTap: () {
            onSearch(query);
            close(context, query);
          },
        );
      },
    );
  }
}
