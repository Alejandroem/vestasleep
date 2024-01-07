import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';

class VestaHome extends StatelessWidget {
  const VestaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vesta'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Vesta'),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationCubit>().logOut();
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
