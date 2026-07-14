/// Контракт репозитория обратной связи.
abstract class FeedbackRepository {
  /// Отправить сообщение обратной связи (`PUT /feedback`).
  Future<void> sendFeedback(String message);
}
