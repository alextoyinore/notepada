import 'package:flutter/material.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/auth/presentation/pages/secret_key.dart';
import 'package:notepada/features/dashboard/presentation/pages/dash_content.dart';
import 'package:notepada/features/dashboard/presentation/pages/dashboard.dart';
import 'package:notepada/features/favourites/presentation/pages/favourite.dart';
import 'package:notepada/features/listen/presentation/pages/listen.dart';
import 'package:notepada/features/note/presentation/pages/note_list.dart';
import 'package:notepada/features/secret/presentation/pages/secret_note.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

final List<Widget> _screens = <Widget>[
  const Notes(),
  const Favourites(),
  const DashContent(),
  const Listen(),
  const Profile(),
];

PersistentTabController _controller = PersistentTabController(initialIndex: 2);

ScrollController _scrollController1 = ScrollController();
ScrollController _scrollController2 = ScrollController();
ScrollController _scrollController3 = ScrollController();
ScrollController _scrollController4 = ScrollController();
ScrollController _scrollController5 = ScrollController();

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.notes),
      title: ("Notes"),
      activeColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.bright
          : AppColors.primary,
      inactiveColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.midGrey
          : AppColors.grey,
      scrollController: _scrollController1,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const Notes(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.star),
      title: ("Favourites"),
      activeColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.bright
          : AppColors.primary,
      inactiveColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.midGrey
          : AppColors.grey,
      scrollController: _scrollController2,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const Favourites(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.bright
          : AppColors.primary,
      inactiveColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.midGrey
          : AppColors.grey,
      scrollController: _scrollController3,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const DashContent(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.headphones),
      title: ("Listen"),
      activeColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.bright
          : AppColors.primary,
      inactiveColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.midGrey
          : AppColors.grey,
      scrollController: _scrollController4,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const Listen(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: ("Profile"),
      activeColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.bright
          : AppColors.primary,
      inactiveColorPrimary: Theme.of(context).brightness == Brightness.dark
          ? AppColors.midGrey
          : AppColors.grey,
      scrollController: _scrollController5,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/",
        routes: {
          "/first": (final context) => const Profile(),
        },
      ),
    ),
  ];
}

Widget appBottomNav({
  required BuildContext context,
  required Function(int) onTap,
}) {
  return PersistentTabView(
    context,
    controller: _controller,
    screens: _screens,
    items: _navBarsItems(context),
    handleAndroidBackButtonPress: true,
    resizeToAvoidBottomInset: true,
    stateManagement: true,
    hideNavigationBarWhenKeyboardAppears: true,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    isVisible: true,
    backgroundColor: Colors.transparent,
    decoration: NavBarDecoration(
      colorBehindNavBar: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
    ),
    navBarStyle: NavBarStyle.style1,
    navBarHeight: 70,
  );
}
