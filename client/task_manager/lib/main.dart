import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/core/managers/general/app_manager.dart';
import 'package:task_manager/features/tasks/presentation/bloc/bloc_exports.dart';

import 'app.dart';
import 'flavors.dart';

Future<void> main() async {
  F.appFlavor = Flavor.values.firstWhere((element) => element.name == appFlavor);
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await AppManager.initialise();
  runApp(const App());
}
