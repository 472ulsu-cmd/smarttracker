/// Типы отложенных действий, выполняемых фоновой синхронизацией.
enum PendingActionType {
  /// Смена статуса заявки: `POST /orders/{id}/status/{statusId}`.
  statusChange,

  /// Загрузка фото: `POST /orders/.../photo...`.
  photoUpload,

  /// Отправка координат: `POST /coordinates`.
  coordinates,
}

/// Запись в таблице `pending_actions` (офлайн-очередь).
class PendingAction {
  PendingAction({
    this.id,
    required this.type,
    required this.payload,
    this.retryCount = 0,
    this.status = PendingActionStatus.pending,
    this.createdAt,
  });

  final int? id;
  final PendingActionType type;
  final Map<String, dynamic> payload;
  int retryCount;
  PendingActionStatus status;
  final DateTime? createdAt;

  /// После 5 неудачных попыток действие помечается failed.
  static const int maxRetries = 5;
}

/// Статус записи в очереди.
enum PendingActionStatus {
  /// Ожидает отправки.
  pending,

  /// Завершено неудачей (превышен лимит попыток).
  failed,
}
