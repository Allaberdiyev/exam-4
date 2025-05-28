import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/presentation/viewmodels/notification_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(firestore: getIt<FirebaseFirestore>()),
  );

  // View Models
  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(getIt<AuthRepository>()),
  );
  getIt.registerFactory<NotificationViewModel>(
    () => NotificationViewModel(getIt<NotificationRepository>()),
  );
}
