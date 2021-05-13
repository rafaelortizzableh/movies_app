import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../env/env.dart';

final environmentProvider = Provider<EnvironmentConfig>(
  (ref) {
    return EnvironmentConfig();
  },
);
