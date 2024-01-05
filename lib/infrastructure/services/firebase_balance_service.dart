
import '../../domain/models/vesta_user.dart';
import '../../domain/services/users_service.dart';
import 'firebase_crud_service.dart';

class FirebaseVestaUserService extends FirebaseCrudService<VestaUser>
    implements UsersService {
  FirebaseVestaUserService() : super('vesta_users', VestaUser.fromJson);
}
