import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onProductSelected;

  const SearchScreen({Key? key, this.onProductSelected}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  // Mock product data for search
  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': '1',
      'name': 'Premium Wireless Earbuds',
      'price': 129.99,
      'imageUrl': 'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f37?q=80&w=2070',
      'rating': 4.8,
      'category': 'Electronics'
    },
    {
      'id': '2',
      'name': 'Stylish Leather Watch',
      'price': 89.99,
      'imageUrl': 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?q=80&w=2068',
      'rating': 4.5,
      'category': 'Fashion'
    },
    {
      'id': '3',
      'name': 'Smart Fitness Tracker',
      'price': 59.99,
      'imageUrl': 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?q=80&w=2088',
      'rating': 4.7,
      'category': 'Electronics'
    },
    // Add more products as needed
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allProducts
            .where((product) =>
        product['name'].toLowerCase().contains(query.toLowerCase()) ||
            product['category'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 16,
          ),
          onChanged: _performSearch,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2A78)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF1E2A78)),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _isSearching
          ? _searchResults.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _searchResults.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return _buildSearchResultItem(product);
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Search for products',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product['imageUrl'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          product['name'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              product['category'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product['price']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E2A78),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF1E2A78)),
          onPressed: () {
            // Show confirmation without navigation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product['name']} added to cart')),
            );
            // Optionally notify the parent screen if needed
            if (widget.onProductSelected != null) {
              widget.onProductSelected!(product);
            }
          },
        ),
        onTap: () {
          // Handle product selection without closing the search screen
          // Just show a message or navigate to a detail page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing ${product['name']}')),
          );

          // If you need to notify the parent screen:
          if (widget.onProductSelected != null) {
            widget.onProductSelected!(product);
          }
        },
      ),
    );
  }
}