import 'package:flutter/material.dart';

// Helper function to map icon_name strings to IconData
IconData getIcon(String iconName) {
  switch (iconName) {
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'restaurant':
      return Icons.restaurant;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'movie':
      return Icons.movie;
    case 'local_hospital':
      return Icons.local_hospital;
    case 'school':
      return Icons.school;
    case 'directions_car':
      return Icons.directions_car;
    case 'directions_subway':
      return Icons.directions_subway;
    case 'home':
      return Icons.home;
    case 'lightbulb':
      return Icons.lightbulb;
    case 'security':
      return Icons.security;
    case 'checkroom':
      return Icons.checkroom;
    case 'cleaning_services':
      return Icons.cleaning_services;
    case 'book':
      return Icons.book;
    case 'self_improvement':
      return Icons.self_improvement;
    case 'flight':
      return Icons.flight;
    case 'sports_esports':
      return Icons.sports_esports;
    case 'card_giftcard':
      return Icons.card_giftcard;
    case 'category':
      return Icons.category;
    case 'attach_money':
      return Icons.attach_money;
    case 'work':
      return Icons.work;
    case 'trending_up':
      return Icons.trending_up;
    case 'star':
      return Icons.star;
    case 'more_horiz':
      return Icons.more_horiz;
    case 'directions_subway':
      return Icons.directions_subway;
    default:
      return Icons.category; // Default icon if no match is found
  }
}
