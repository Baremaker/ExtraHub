import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'firebase_options.dart';

/// Entry point do ExtraHub.
///
/// Antes de pintar qualquer pixel:
///   1. Garante que o binding do Flutter está pronto (necessário para
///      operações async antes do `runApp`).
///   2. Inicializa o Firebase usando as opções geradas pelo `flutterfire`.
///   3. Envolve o app em `ProviderScope` (raiz do Riverpod).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: ExtraHubApp(),
    ),
  );
}
