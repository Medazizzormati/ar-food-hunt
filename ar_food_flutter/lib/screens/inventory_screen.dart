import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip(context, 'All', true),
                _buildFilterChip(context, 'Burgers', false),
                _buildFilterChip(context, 'Pizza', false),
                _buildFilterChip(context, 'Dessert', false),
                _buildFilterChip(context, 'Coffee', false),
              ],
            ),
          ),
          
          // Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildInventoryItem('Classic Burger', '🍔', 'COMMON', '+50 XP', Colors.grey),
                _buildInventoryItem('Golden Fries', '🍟', 'COMMON', '+30 XP', Colors.grey),
                _buildInventoryItem('Golden Ticket', '🎟️', 'RARE', '+200 XP', Colors.orange),
                _buildInventoryItem('Diamond', '💎', 'LEGENDARY', '+500 XP', Colors.purple),
                _buildInventoryItem('Ice Cream', '🍦', 'COMMON', '+35 XP', Colors.grey),
                _buildInventoryItem('Cupcake', '🧁', 'RARE', '+150 XP', Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primary.withOpacity(0.2) : AppTheme.glassDecoration(context).color,
        border: Border.all(color: isActive ? AppTheme.primary : (isDark ? Colors.white12 : Colors.black12)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isActive ? AppTheme.primary : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary), fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
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
