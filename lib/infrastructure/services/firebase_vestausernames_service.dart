import '../../domain/models/vesta_usernames.dart';
import '../../domain/services/usernames_service.dart';
import 'firebase_crud_service.dart';

class FirebaseVestaUserNamesService extends FirebaseCrudService<VestaUserName>
    implements UserNamesService {
  FirebaseVestaUserNamesService()
      : super(
          'vesta_user_names',
          VestaUserName.fromJson,
        );
}
