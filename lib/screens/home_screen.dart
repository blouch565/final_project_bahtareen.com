import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Services
  final ProductService _productService = ProductService();

  // Controllers
  final PageController _carouselController = PageController(initialPage: 0);
  late AnimationController _animationController;

  // State variables
  String _selectedCategory = 'All';
  int _currentCarouselPage = 0;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _sortOption = 'Featured'; // Default sort option

  // Categories with icons
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Fashion', 'icon': Icons.shopping_bag},
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Groceries', 'icon': Icons.local_grocery_store},
    {'name': 'Furniture', 'icon': Icons.chair},
    {'name': 'Cosmetics', 'icon': Icons.face},
    {'name': 'Toys', 'icon': Icons.toys},
  ];

  // Carousel images with category and title
  final List<Map<String, dynamic>> _carouselImages = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1581591524083-f2df5d54e3a5?q=80&w=2070',
      'category': 'Electronics',
      'title': 'Latest Tech Gadgets'
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=2070',
      'category': 'Fashion',
      'title': 'New Season Arrivals'
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=2070',
      'category': 'Furniture',
      'title': 'Modern Home Decor'
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1584623733011-9c755c864222?q=80&w=2070',
      'category': 'Toys',
      'title': 'Kids Favorites'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchProducts();

    _searchController.addListener(() {
      if (_searchController.text.isEmpty && _isSearching) {
        setState(() {
          _isSearching = false;
        });
      } else if (_searchController.text.isNotEmpty && !_isSearching) {
        setState(() {
          _isSearching = true;
        });
      }
      _filterProducts();
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      if (_searchController.text.isEmpty) {
        // If search is empty, just filter by category
        if (_selectedCategory == 'All') {
          _products = _products;
        } else {
          _products = _products.where((product) =>
          product['category'] == _selectedCategory).toList();
        }
      } else {
        // If searching, filter by both search term and category
        final searchQuery = _searchController.text.toLowerCase();
        if (_selectedCategory == 'All') {
          _products = _products.where((product) =>
              product['name'].toLowerCase().contains(searchQuery)).toList();
        } else {
          _products = _products.where((product) =>
          product['category'] == _selectedCategory &&
              product['name'].toLowerCase().contains(searchQuery)).toList();
        }
      }
    });
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);

    // In a real app, you would use ProductService to get products from Firestore
    // final products = await _productService.getProducts();

    // For now, using mock data
    await Future.delayed(const Duration(seconds: 1));
    final products = [
      {
        'id': '1',
        'name': 'Premium Wireless Earbuds',
        'price': 12999,
        'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=1932',
        'rating': 4.8,
        'category': 'Electronics',
        'description': 'Experience crystal-clear sound with these premium wireless earbuds. Features include active noise cancellation, 30-hour battery life, and water resistance.',
        'reviews': 128,
        'colors': ['Black', 'White', 'Blue'],
      },
      {
        'id': '2',
        'name': 'Stylish Leather Watch',
        'price': 8999,
        'imageUrl': 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?q=80&w=2068',
        'rating': 4.5,
        'category': 'Fashion',
        'description': 'Elegant leather watch with stainless steel case, Japanese quartz movement, and water resistance up to 30 meters.',
        'reviews': 96,
        'colors': ['Brown', 'Black', 'Tan'],
      },
      {
        'id': '3',
        'name': 'Smart Fitness Tracker',
        'price': 5999,
        'imageUrl': 'https://images.unsplash.com/photo-1576243345690-4e4b79b63288?q=80&w=2070',
        'rating': 4.7,
        'category': 'Electronics',
        'description': 'Track your fitness goals with this advanced smart tracker. Features heart rate monitoring, sleep tracking, and 7-day battery life.',
        'reviews': 203,
        'colors': ['Black', 'Blue', 'Red'],
      },
      {
        'id': '4',
        'name': 'Designer Backpack',
        'price': 7999,
        'imageUrl': 'https://images.unsplash.com/photo-1622560480654-d96214fdc887?q=80&w=1974',
        'rating': 4.6,
        'category': 'Fashion',
        'description': 'Stylish and functional backpack made from premium materials. Features multiple compartments, laptop sleeve, and water-resistant exterior.',
        'reviews': 78,
        'colors': ['Gray', 'Black', 'Navy'],
      },
      {
        'id': '5',
        'name': 'Bluetooth Speaker',
        'price': 4999,
        'imageUrl': 'https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=1964',
        'rating': 4.4,
        'category': 'Electronics',
        'description': 'Portable Bluetooth speaker with rich, immersive sound. Features 12-hour battery life, waterproof design, and built-in microphone for calls.',
        'reviews': 156,
        'colors': ['Black', 'Blue', 'Red', 'Green'],
      },
      {
        'id': '6',
        'name': 'Modern Coffee Table',
        'price': 19999,
        'imageUrl': 'https://images.unsplash.com/photo-1634712282287-14ed57b9cc89?q=80&w=2006',
        'rating': 4.9,
        'category': 'Furniture',
        'description': 'Elegant coffee table with solid wood construction and tempered glass top. Modern design fits perfectly in any living space.',
        'reviews': 42,
        'colors': ['Natural', 'Walnut', 'Black'],
      },
      {
        'id': '7',
        'name': 'Educational Robot Toy',
        'price': 6999,
        'imageUrl': 'https://images.unsplash.com/photo-1535378620166-273708d44e4c?q=80&w=2066',
        'rating': 4.7,
        'category': 'Toys',
        'description': 'Interactive robot toy that helps kids learn coding and problem-solving skills. Features voice recognition and multiple play modes.',
        'reviews': 89,
        'colors': ['Blue', 'Orange', 'Green'],
      },
      {
        'id': '8',
        'name': 'Luxury Makeup Set',
        'price': 9999,
        'imageUrl': 'https://images.unsplash.com/photo-1596704017254-9a89bd5d0e04?q=80&w=1974',
        'rating': 4.8,
        'category': 'Cosmetics',
        'description': 'Complete makeup set with premium quality products. Includes foundation, eyeshadow palette, mascara, lipsticks, and professional brushes.',
        'reviews': 124,
        'colors': ['Mixed'],
      },
      {
        'id': '9',
        'name': 'Organic Grocery Box',
        'price': 3999,
        'imageUrl': 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?q=80&w=2070',
        'rating': 4.6,
        'category': 'Groceries',
        'description': 'Weekly box of fresh organic produce. Contains seasonal vegetables, fruits, and herbs sourced from local farmers.',
        'reviews': 67,
        'colors': ['N/A'],
      },
    ];

    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _sortProducts(_products);
    }
    return _sortProducts(_products
        .where((product) => product['category'] == _selectedCategory)
        .toList());
  }

  List<Map<String, dynamic>> _sortProducts(
      List<Map<String, dynamic>> products) {
    switch (_sortOption) {
      case 'Price: Low to High':
        return List.from(products)
          ..sort((a, b) => a['price'].compareTo(b['price']));
      case 'Price: High to Low':
        return List.from(products)
          ..sort((a, b) => b['price'].compareTo(a['price']));
      case 'Rating':
        return List.from(products)
          ..sort((a, b) => b['rating'].compareTo(a['rating']));
      case 'Featured':
      default:
        return products; // No sorting, keep original order
    }
  }

  void _addToCart(Map<String, dynamic> productMap) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final product = Product.fromMap(productMap);
    cartProvider.addItem(product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E2A78),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen())
            );
          },
        ),
      ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductDetailScreen(
              product: product,
              onAddToCart: (product, quantity) {
                // Add to cart multiple times based on quantity
                for (var i = 0; i < quantity; i++) {
                  _addToCart(product);
                }
              },
            ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Text(
                    'Sort By',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(),
                _buildSortOption('Featured'),
                _buildSortOption('Price: Low to High'),
                _buildSortOption('Price: High to Low'),
                _buildSortOption('Rating'),
              ],
            ),
          ),
    );
  }

  Widget _buildSortOption(String option) {
    return ListTile(
      title: Text(
        option,
        style: GoogleFonts.poppins(
          fontWeight: _sortOption == option ? FontWeight.w600 : FontWeight
              .normal,
        ),
      ),
      trailing: _sortOption == option ? const Icon(
          Icons.check, color: Color(0xFF1E2A78)) : null,
      onTap: () {
        setState(() {
          _sortOption = option;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: const Color(0xFF1E2A78),
        onRefresh: _fetchProducts,
        child: _isLoading
            ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF1E2A78)))
            : CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Search bar
            SliverToBoxAdapter(child: _buildSearchBar()),

            // Carousel Slider
            SliverToBoxAdapter(child: _buildCarousel()),

            // Categories
            SliverToBoxAdapter(child: _buildCategories()),

            // Trending Products Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Products',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E2A78),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _showSortOptions,
                      icon: const Icon(Icons.sort, size: 16),
                      label: Text(_sortOption),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1E2A78),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            _filteredProducts.isEmpty
                ? const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No products found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            )
                : _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1E2A78)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFF1E2A78)),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _isSearching = false;
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Bahtareen',
        style: TextStyle(
          color: Color(0xFF1E2A78),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
              Icons.notifications_outlined, color: Color(0xFF1E2A78)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen())
            );
          },
        ),
        Consumer<CartProvider>(
          builder: (_, cart, __) =>
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 4, end: 4),
                badgeAnimation: const badges.BadgeAnimation.slide(),
                showBadge: cart.itemCount > 0,
                badgeContent: Text(
                  cart.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: IconButton(
                  icon: const Icon(
                      Icons.shopping_cart_outlined, color: Color(0xFF1E2A78)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen())
                    );
                  },
                ),
              ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        Container(
          height: 180,
          margin: const EdgeInsets.only(top: 8),
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselPage = index % _carouselImages.length;
              });
            },
            itemBuilder: (context, index) {
              final imageIndex = index % _carouselImages.length;
              final carouselItem = _carouselImages[imageIndex];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.network(
                        carouselItem['imageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1E2A78),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carouselItem['category'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                carouselItem['title'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_carouselImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselPage == index ? 16 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselPage == index
                    ? const Color(0xFF1E2A78)
                    : Colors.grey.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category['name'] == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category['name'];
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E2A78) : Colors
                          .white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      category['icon'],
                      color: isSelected ? Colors.white : const Color(
                          0xFF1E2A78),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight
                          .w500,
                      color: isSelected ? const Color(0xFF1E2A78) : Colors
                          .black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return _buildProductCard(product, index);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: Image.network(
                    product['imageUrl'],
                    height: index % 2 == 0 ? 140 : 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: index % 2 == 0 ? 140 : 180,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1E2A78),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        ' ${product['rating']} ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '(${product['reviews']})',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs ${product['price']}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E2A78),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2A78),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () => _addToCart(product),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
