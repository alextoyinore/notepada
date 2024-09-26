import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/dashboard/presentation/pages/dash_content.dart';
import 'package:notepada/features/favourites/presentation/pages/favourite.dart';
import 'package:notepada/features/home/presentation/pages/home.dart';
import 'package:notepada/features/listen/presentation/pages/listen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  static final List<Widget> _pages = <Widget>[
    const Notes(),
    const Favourites(),
    const DashContent(),
    const Listen(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[context.read<DashBoardCubit>().state],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        useLegacyColorScheme: false,
        onTap: (index) => setState(() {
          context.read<DashBoardCubit>().updateSelectedIndex(index);
        }),
        elevation: 0,
        currentIndex: context.read<DashBoardCubit>().state,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.midGrey
            : AppColors.grey,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundLight
            : AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headphones),
            label: 'Listen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
