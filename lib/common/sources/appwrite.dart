import 'package:appwrite/appwrite.dart';
import 'package:notepada/config/constants/constants.dart';

class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? database;

  AppwriteProvider() {
    client
        .setEndpoint(AppConstants.appwriteEndpoint)
        .setProject(AppConstants.appwriteProjectID)
        .setSelfSigned(status: true);
    account = Account(client);
    database = Databases(client);
  }
}

