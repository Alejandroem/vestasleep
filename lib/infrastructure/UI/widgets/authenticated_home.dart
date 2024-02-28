import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/bottom_navigation_cubit.dart';
import 'alarm_flow.dart';
import 'dashboard.dart';
import 'settings.dart';

class AuthenticatedHome extends StatelessWidget {
  const AuthenticatedHome({super.key});

  final Color selectedColor = const Color(0xff37A2E7);
  final Color unselectedColor = const Color(0xff282454);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<BottomNavigationCubit, SelectedTab>(
          builder: (context, state) {
        return BottomNavigationBar(
          onTap: (index) {
            if (index == 0) {
              context.read<BottomNavigationCubit>().updateSelectedTab(
                    SelectedTab.home,
                  );
            } else {
              context.read<BottomNavigationCubit>().updateSelectedTab(
                    SelectedTab.settings,
                  );
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home_icon.svg',
                colorFilter: ColorFilter.mode(
                  state == SelectedTab.home ? selectedColor : unselectedColor,
                  BlendMode.srcIn,
                ),
              ),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/gear_icon.svg',
                colorFilter: ColorFilter.mode(
                  state == SelectedTab.settings
                      ? selectedColor
                      : unselectedColor,
                  BlendMode.srcIn,
                ),
              ),
              label: ' ',
            ),
          ],
        );
      }),
      backgroundColor: const Color(0xff1B1464),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [
              Color(0xFF14103F),
              Color(0x02161B26),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AlarmFlow(),
                BlocBuilder<BottomNavigationCubit, SelectedTab>(
                  builder: (context, state) {
                    if (state == SelectedTab.home) {
                      return const Dashboard();
                    }
                    if (state == SelectedTab.settings) {
                      return const Settings();
                    }
                    return const Placeholder();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
