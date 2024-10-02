import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/common/sources/local/feature_item.dart';
import 'package:notepada/common/widgets/appbar.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';

class DashContent extends StatefulWidget {
  const DashContent({super.key});

  @override
  State<DashContent> createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  final _searchController = TextEditingController();

  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGaps.v10,
            _storageService.getValue(StorageKeys.firstName) != null
                ? Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    '${AppStrings.hello}, ' +
                        _storageService.getValue(StorageKeys.firstName),
                    style: const TextStyle(
                      fontSize: 30,
                      // color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Text(
                    AppStrings.hello,
                    style: TextStyle(
                      fontSize: 30,
                      // color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            AppGaps.v10,
            Text(
              toHumanReadableDate(DateTime.now().toIso8601String()),
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            AppGaps.v30,
            const Text(
              AppStrings.createNew,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGaps.v10,
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: context
                  .read<DashboardAppsCubit>()
                  .state
                  .map(
                    (e) => appItem(
                      context: context,
                      title: e['title'],
                      description: e['description'],
                      icon: e['icon'],
                      color: e['color'],
                      routeName: e['routeName'],
                    ),
                  )
                  .toList(),
            ),
            AppGaps.v20,
            const Text(
              AppStrings.today,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGaps.v10,
          ],
        ),
      ),
    );
  }
}
