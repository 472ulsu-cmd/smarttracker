/// Статус заявки (значение `order_status` из API).
enum OrderStatus {
  /// Новая заявка (1).
  newRequest(1, 'Новая заявка'),

  /// В работе (2).
  inProgress(2, 'В работе'),

  /// Отказ (3).
  rejected(3, 'Отказ'),

  /// Завершена (4).
  completed(4, 'Завершена'),

  /// Погружен (5).
  loaded(5, 'Погружен');

  const OrderStatus(this.id, this.label);

  final int id;
  final String label;

  /// Разбор статуса по id. Неизвестные → null (отображаются как «Неизвестный статус»).
  static OrderStatus? fromId(int? id) {
    if (id == null) return null;
    for (final s in OrderStatus.values) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Человек-понятная метка для неизвестного статуса.
  static String labelForId(int? id) => fromId(id)?.label ?? 'Неизвестный статус';

  /// Метка, применяемая в списке заявок.
  /// По ТЗ статус «Новая заявка» намеренно не показывается.
  static String? listLabelForId(int? id) {
    final s = fromId(id);
    if (s == null) return 'Неизвестный статус';
    if (s == OrderStatus.newRequest) return null;
    return s.label;
  }

  /// Относится ли заявка к вкладке «В работе» (2 или 5).
  bool get isInProgressActive =>
      this == OrderStatus.inProgress || this == OrderStatus.loaded;
}
