import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/common/widgets/app_bottom_nav.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/dashboard/presentation/pages/dash_content.dart';
import 'package:notepada/features/favourites/presentation/pages/favourite.dart';
import 'package:notepada/features/note/presentation/pages/note_list.dart';
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
    return appBottomNav(
      context: context,
      onTap: (index) => setState(() {
        context.read<SelectedIndexCubit>().updateSelectedIndex(index);
      }),
    );
  }
}
