import 'package:eat/categories.dart';
import 'package:eat/drawer.dart';
import 'package:eat/meal.dart';
import 'package:eat/meals.dart';
import 'package:eat/filter.dart';
import 'package:flutter/material.dart';

//import dummy_data.dart;
import 'data/dummy_data.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
  Filter.lactoseFree: false,
};

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedfilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
  //

  void _toggleFavorite(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite!');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) => FilterScreen(currentFilters: _selectedfilters,)),
      );

      setState(() {
        _selectedfilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) { // Filter meals, not categories
      if (_selectedfilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedfilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedfilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedfilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleFavorite, // Pass the function here
   availableMeals: availableMeals
   ,
    );
    var activepagetitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavorite, // Pass the function here
      );
      activepagetitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activepagetitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
