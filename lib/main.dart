import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FoodAdvisorApp());
}

class FoodAdvisorApp extends StatelessWidget {
  const FoodAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Advisor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainFoodPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  int _selectedIndex = 0;

  // Move suggestions to parent so user-added foods are shared
  final List<Map<String, String>> _breakfastSuggestions = [
    {
      'title': 'Oatmeal with Berries',
      'desc': 'A hearty bowl of oats topped with fresh berries and honey.',
      'calories': '250 kcal'
    },
    {
      'title': 'Greek Yogurt Parfait',
      'desc': 'Layers of Greek yogurt, granola, and fruit.',
      'calories': '220 kcal'
    },
    {
      'title': 'Avocado Toast',
      'desc': 'Whole grain toast with smashed avocado and a sprinkle of chili flakes.',
      'calories': '180 kcal'
    },
    {
      'title': 'Egg Muffins',
      'desc': 'Baked eggs with spinach, cheese, and tomatoes.',
      'calories': '160 kcal'
    },
  ];
  final List<Map<String, String>> _lunchSuggestions = [
    {
      'title': 'Chicken Caesar Salad',
      'desc': 'Grilled chicken breast with Caesar dressing.',
      'calories': '340 kcal'
    },
    {
      'title': 'Veggie Wrap',
      'desc': 'Whole wheat wrap with hummus, cucumber, and bell peppers.',
      'calories': '280 kcal'
    },
    {
      'title': 'Sushi Bowl',
      'desc': 'Rice, seaweed, salmon, avocado, and veggies.',
      'calories': '390 kcal'
    },
    {
      'title': 'Tomato Soup & Grilled Cheese',
      'desc': 'Classic combo for a cozy lunch.',
      'calories': '410 kcal'
    },
  ];
  final List<Map<String, String>> _dinnerSuggestions = [
    {
      'title': 'Grilled Salmon & Veggies',
      'desc': 'Rich in protein and omega-3.',
      'calories': '420 kcal'
    },
    {
      'title': 'Chicken Stir Fry',
      'desc': 'Lean chicken with colorful veggies and a light soy sauce. Quick, healthy, and filling.',
      'calories': '380 kcal'
    },
    {
      'title': 'Quinoa Salad',
      'desc': 'A plant-based option with quinoa, chickpeas, tomatoes, and avocado. Great for digestion.',
      'calories': '350 kcal'
    },
    {
      'title': 'Vegetable Soup',
      'desc': 'Warm, comforting, and low-calorie.',
      'calories': '220 kcal'
    },
    {
      'title': 'Turkey Wrap',
      'desc': 'Whole grain wrap with turkey, greens, and hummus.',
      'calories': '330 kcal'
    },
    {
      'title': 'Baked Sweet Potato',
      'desc': 'Top with cottage cheese and chives for a balanced, fiber-rich meal.',
      'calories': '290 kcal'
    },
    {
      'title': 'Shrimp Tacos',
      'desc': 'Corn tortillas, cabbage slaw, and a squeeze of lime.',
      'calories': '370 kcal'
    },
    {
      'title': 'Lentil Curry',
      'desc': 'Hearty, full of flavor, and packed with plant protein.',
      'calories': '410 kcal'
    },
  ];

  void _addCustomFood(int pageIndex, Map<String, String> food) {
    setState(() {
      if (pageIndex == 0) {
        _breakfastSuggestions.add(food);
      } else if (pageIndex == 1) {
        _lunchSuggestions.add(food);
      } else {
        _dinnerSuggestions.add(food);
      }
    });
  }

  void _showPlanDialog(BuildContext context) {
    final random = Random();
    final breakfast = _breakfastSuggestions[random.nextInt(_breakfastSuggestions.length)];
    final lunch = _lunchSuggestions[random.nextInt(_lunchSuggestions.length)];
    final dinner = _dinnerSuggestions[random.nextInt(_dinnerSuggestions.length)];
    int parseCalories(String? s) {
      if (s == null) return 0;
      final match = RegExp(r'(\d+)').firstMatch(s);
      return match != null ? int.parse(match.group(1)!) : 0;
    }
    final totalCalories = parseCalories(breakfast['calories']) +
        parseCalories(lunch['calories']) +
        parseCalories(dinner['calories']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Day Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Breakfast: ${breakfast['title']}\n${breakfast['desc']}\nCalories: ${breakfast['calories']}'),
            const SizedBox(height: 12),
            Text('Lunch: ${lunch['title']}\n${lunch['desc']}\nCalories: ${lunch['calories']}'),
            const SizedBox(height: 12),
            Text('Dinner: ${dinner['title']}\n${dinner['desc']}\nCalories: ${dinner['calories']}'),
            const SizedBox(height: 18),
            Text('Total Calories: $totalCalories kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FoodSuggestionPage(
            title: 'What to Eat for Breakfast?',
            icon: Icons.free_breakfast,
            suggestions: _breakfastSuggestions,
            onAddCustomFood: (food) => _addCustomFood(0, food),
            appBarActions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Create Plan for the Day',
                onPressed: () => _showPlanDialog(context),
              ),
            ],
          ),
          FoodSuggestionPage(
            title: 'What to Eat for Lunch?',
            icon: Icons.lunch_dining,
            suggestions: _lunchSuggestions,
            onAddCustomFood: (food) => _addCustomFood(1, food),
            appBarActions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Create Plan for the Day',
                onPressed: () => _showPlanDialog(context),
              ),
            ],
          ),
          FoodSuggestionPage(
            title: 'What to Eat for Dinner?',
            icon: Icons.restaurant_menu,
            suggestions: _dinnerSuggestions,
            onAddCustomFood: (food) => _addCustomFood(2, food),
            appBarActions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: 'Create Plan for the Day',
                onPressed: () => _showPlanDialog(context),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.free_breakfast),
            label: 'Breakfast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'Lunch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Dinner',
          ),
        ],
      ),
    );
  }
}

class FoodSuggestionPage extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Map<String, String>> suggestions;
  final void Function(Map<String, String>) onAddCustomFood;
  final List<Widget> appBarActions;
  const FoodSuggestionPage({super.key, required this.title, required this.icon, required this.suggestions, required this.onAddCustomFood, required this.appBarActions});

  @override
  State<FoodSuggestionPage> createState() => _FoodSuggestionPageState();
}

class _FoodSuggestionPageState extends State<FoodSuggestionPage> {
  int _currentIndex = 0;

  void _nextSuggestion() {
    setState(() {
      int newIndex;
      do {
        newIndex = Random().nextInt(widget.suggestions.length);
      } while (newIndex == _currentIndex && widget.suggestions.length > 1);
      _currentIndex = newIndex;
    });
  }

  void _showCalories() {
    final suggestion = widget.suggestions[_currentIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calorie Estimate'),
        content: Text('${suggestion['title']}\n\nEstimated Calories: ${suggestion['calories']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAllOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('All Options'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.suggestions.length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) {
              final food = widget.suggestions[i];
              return ListTile(
                title: Text(food['title'] ?? ''),
                subtitle: Text('${food['desc'] ?? ''}\nCalories: ${food['calories'] ?? ''}'),
                isThreeLine: true,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addCustomFood() async {
    String? title;
    String? desc;
    String? calories;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Your Own Food'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Food Name'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Short Description'),
                  onChanged: (value) => desc = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Calories (e.g. 300 kcal)'),
                  onChanged: (value) => calories = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title != null && title!.trim().isNotEmpty &&
                    desc != null && desc!.trim().isNotEmpty &&
                    calories != null && calories!.trim().isNotEmpty) {
                  widget.onAddCustomFood({
                    'title': title!,
                    'desc': desc!,
                    'calories': calories!,
                  });
                  setState(() {
                    _currentIndex = widget.suggestions.length - 1;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = widget.suggestions[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          ...widget.appBarActions,
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Show All Options',
            onPressed: _showAllOptions,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 48, color: Colors.teal[400]),
                  const SizedBox(height: 24),
                  Text(
                    suggestion['title']!,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    suggestion['desc']!,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: _showCalories,
                    icon: const Icon(Icons.local_fire_department, color: Colors.teal),
                    label: const Text('Show Calories', style: TextStyle(color: Colors.teal)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.teal),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 16),
              child: FloatingActionButton(
                heroTag: '${widget.title}_addCustomFood',
                onPressed: _addCustomFood,
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Your Own Food',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: FloatingActionButton(
                heroTag: '${widget.title}_refreshSuggestion',
                onPressed: _nextSuggestion,
                backgroundColor: Colors.teal,
                child: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Another Suggestion',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
