import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/repositories/feedback_repository.dart';

class FeedbackViewModel extends ChangeNotifier {
  FeedbackViewModel(this._repository);

  final FeedbackRepository _repository;

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _sent = false;
  bool get sent => _sent;

  Future<bool> send(String message) async {
    if (message.trim().isEmpty) {
      _errorMessage = 'Введите сообщение.';
      notifyListeners();
      return false;
    }
    _isSending = true;
    _errorMessage = null;
    _sent = false;
    notifyListeners();

    try {
      await _repository.sendFeedback(message.trim());
      _sent = true;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось отправить сообщение.';
      notifyListeners();
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
