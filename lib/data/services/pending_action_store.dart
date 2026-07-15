import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../domain/models/pending_action.dart';

/// Локальное SQLite-хранилище отложенных действий (офлайн-очередь).
///
/// Таблица `pending_actions` хранит действия до фоновой синхронизации.
class PendingActionStore {
  PendingActionStore._();
  static final PendingActionStore instance = PendingActionStore._();

  Database? _db;

  static const _table = 'pending_actions';
  static const _colId = 'id';
  static const _colType = 'type';
  static const _colPayload = 'payload';
  static const _colRetry = 'retry_count';
  static const _colStatus = 'status';
  static const _colCreatedAt = 'created_at';

  Future<Database> _database() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'smarttracker.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colType TEXT NOT NULL,
            $_colPayload TEXT NOT NULL,
            $_colRetry INTEGER NOT NULL DEFAULT 0,
            $_colStatus TEXT NOT NULL DEFAULT 'pending',
            $_colCreatedAt INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  /// Добавить действие в очередь.
  Future<int> enqueue(PendingAction action) async {
    final db = await _database();
    return db.insert(_table, {
      _colType: action.type.name,
      _colPayload: jsonEncode(action.payload),
      _colRetry: action.retryCount,
      _colStatus: action.status.name,
      _colCreatedAt:
          (action.createdAt ?? DateTime.now()).millisecondsSinceEpoch,
    });
  }

  /// Прочитать все ожидающие действия (старые первыми).
  Future<List<PendingAction>> readPending({int limit = 50}) async {
    final db = await _database();
    final rows = await db.query(
      _table,
      where: '$_colStatus = ?',
      whereArgs: [PendingActionStatus.pending.name],
      orderBy: '$_colCreatedAt ASC',
      limit: limit,
    );
    return rows.map(_fromRow).toList(growable: false);
  }

  /// Увеличить счётчик попыток; при превышении — пометить failed.
  Future<void> markFailedAttempt(int id) async {
    final db = await _database();
    final rows = await db.query(_table,
        where: '$_colId = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return;
    final retry = (rows.first[_colRetry] as int) + 1;
    if (retry >= PendingAction.maxRetries) {
      await db.update(
        _table,
        {_colStatus: PendingActionStatus.failed.name, _colRetry: retry},
        where: '$_colId = ?',
        whereArgs: [id],
      );
    } else {
      await db.update(
        _table,
        {_colRetry: retry},
        where: '$_colId = ?',
        whereArgs: [id],
      );
    }
  }

  /// Удалить действие (после успешной отправки).
  Future<void> remove(int id) async {
    final db = await _database();
    await db.delete(_table, where: '$_colId = ?', whereArgs: [id]);
  }

  /// Удалить несколько действий (после успешной пакетной отправки).
  Future<void> removeAll(Iterable<int> ids) async {
    if (ids.isEmpty) return;
    final db = await _database();
    final batch = db.batch();
    for (final id in ids) {
      batch.delete(_table, where: '$_colId = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  /// Закрыть соединение с базой (для тестов и явного освобождения ресурсов).
  Future<void> close() async {
    final db = _db;
    _db = null;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }

  PendingAction _fromRow(Map<String, dynamic> row) {
    return PendingAction(
      id: row[_colId] as int,
      type: PendingActionType.values.byName(row[_colType] as String),
      payload:
          jsonDecode(row[_colPayload] as String) as Map<String, dynamic>,
      retryCount: row[_colRetry] as int,
      status: PendingActionStatus.values.byName(row[_colStatus] as String),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          row[_colCreatedAt] as int),
    );
  }
}
