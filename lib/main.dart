import 'package:firebase_core/firebase_core.dart';
import 'package:health/health.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

import 'infrastructure/UI/widgets/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Health().configure(useHealthConnectIfAvailable: true);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://29df93cf8b9055ab16b68bb3de9a98a8@o1188065.ingest.us.sentry.io/4506935340957696';
      options.tracesSampleRate = 1.0;
      options.addIntegration(
        LoggingIntegration(),
      );
    },
    appRunner: () => runApp(const App()),
  );
}
