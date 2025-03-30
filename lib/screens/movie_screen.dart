import 'package:flutter/material.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi'
  ];

  // Add state variables for search and filter
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSortOption = 'Latest';
  final List<String> _sortOptions = ['Latest', 'Popular', 'Top Rated'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }

  // Search methods
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Filter method
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...List.generate(_sortOptions.length, (index) {
                  final option = _sortOptions[index];
                  final isSelected = _selectedSortOption == option;

                  // Get appropriate icon for each option
                  IconData optionIcon;
                  switch (option) {
                    case 'Latest':
                      optionIcon = Icons.new_releases;
                      break;
                    case 'Popular':
                      optionIcon = Icons.trending_up;
                      break;
                    case 'Top Rated':
                      optionIcon = Icons.star;
                      break;
                    default:
                      optionIcon = Icons.sort;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedSortOption = option;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              optionIcon,
                              color: isSelected ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.red : Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.red,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      this.setState(() {
                        // Sort option was updated in the dialog
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Apply Filter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildMovieGrid(category);
        }).toList(),
      ),
    );
  }

  // Build AppBar with search functionality
  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
          ),
          onChanged: _handleSearchChanged,
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red.withOpacity(0.1),
          ),
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      );
    } else {
      return AppBar(
        title:
            const Text('Movies', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _startSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red.withOpacity(0.1),
          ),
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      );
    }
  }

  Widget _buildMovieGrid(String category) {
    // Generate mock data for demo purposes
    List<Map<String, String>> mockMovies = List.generate(10, (index) {
      return {
        'title': 'Movie ${index + 1}',
        'genre': category != 'All'
            ? category
            : ['Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi'][index % 5],
        'rating': '4.${index % 5 + 5}/5',
      };
    });

    // Filter by search query
    var filteredMovies = mockMovies;
    if (_searchQuery.isNotEmpty) {
      filteredMovies = mockMovies
          .where((movie) =>
              movie['title']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              movie['genre']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by category
    if (category != 'All') {
      filteredMovies =
          filteredMovies.where((movie) => movie['genre'] == category).toList();
    }

    // Apply sorting based on selected option
    if (_selectedSortOption == 'Popular') {
      // Sort by popularity (for demonstration, we'll reverse the list)
      filteredMovies = filteredMovies.reversed.toList();
    } else if (_selectedSortOption == 'Top Rated') {
      // Sort by rating
      filteredMovies.sort((a, b) => b['rating']!.compareTo(a['rating']!));
    }
    // For 'Latest' we'll use the default order

    return filteredMovies.isEmpty
        ? const Center(child: Text('No movies found'))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
              return _buildMovieItem(
                movie['title']!,
                'Genre: ${movie['genre']!}',
                movie['rating']!,
              );
            },
          );
  }

  Widget _buildMovieItem(String title, String genre, String rating) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey[300],
                child: Center(child: Text(title)),
                // In a real app, use:
                // Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            genre,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
