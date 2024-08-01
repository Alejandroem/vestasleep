import '../../domain/models/vesta_user.dart';
import '../../domain/services/users_service.dart';
import 'firebase_crud_service.dart';

class FirebaseVestaUsersService extends FirebaseCrudService<VestaUser>
    implements UsersService {
  FirebaseVestaUsersService() : super('vesta_users', VestaUser.fromJson);
}
