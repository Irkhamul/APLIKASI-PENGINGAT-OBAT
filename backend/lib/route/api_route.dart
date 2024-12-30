import 'package:backend/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';
import 'package:backend/app/http/controllers/auth_controller.dart';
import 'package:backend/app/http/controllers/medicine_controller.dart';
import 'package:backend/app/http/controllers/reminders_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    //autentikasi
    Router.post('register', authController.register);
    Router.post('login', authController.login);
    Router.get('me', authController.me).middleware([AuthenticateMiddleware()]);

    // medicine
    Router.post('medicine', medicineController.create).middleware([AuthenticateMiddleware()]);
    Router.get('medicine', medicineController.show).middleware([AuthenticateMiddleware()]);
    Router.get('medicine/{id}', medicineController.get).middleware([AuthenticateMiddleware()]);
    Router.put('medicine/{id}', medicineController.update).middleware([AuthenticateMiddleware()]);
    Router.delete('medicine/{id}', medicineController.delete).middleware([AuthenticateMiddleware()]);

    //reminders
    Router.post('reminders', remindersController.create).middleware([AuthenticateMiddleware()]);
    Router.get('reminders', remindersController.show).middleware([AuthenticateMiddleware()]);
    // Router.get('reminders/{id}', remindersController.show).middleware([AuthenticateMiddleware()]);
    Router.put('reminders/{id}', remindersController.update).middleware([AuthenticateMiddleware()]);
    Router.delete('reminders/{id}', remindersController.delete).middleware([AuthenticateMiddleware()]);
  }
}