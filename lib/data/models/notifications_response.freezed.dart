// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationsResponseItem {
  int? get id;
  String? get message;
  String? get datetime;
  @JsonKey(name: 'status_id')
  int? get statusId;
  @JsonKey(name: 'order_id')
  int? get orderId;
  @JsonKey(name: 'route_photo_id')
  int? get routePhotoId;
  @JsonKey(name: 'route_photo_type_id')
  int? get routePhotoTypeId;

  /// Create a copy of NotificationsResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationsResponseItemCopyWith<NotificationsResponseItem> get copyWith =>
      _$NotificationsResponseItemCopyWithImpl<NotificationsResponseItem>(
          this as NotificationsResponseItem, _$identity);

  /// Serializes this NotificationsResponseItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationsResponseItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.routePhotoId, routePhotoId) ||
                other.routePhotoId == routePhotoId) &&
            (identical(other.routePhotoTypeId, routePhotoTypeId) ||
                other.routePhotoTypeId == routePhotoTypeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, message, datetime, statusId,
      orderId, routePhotoId, routePhotoTypeId);

  @override
  String toString() {
    return 'NotificationsResponseItem(id: $id, message: $message, datetime: $datetime, statusId: $statusId, orderId: $orderId, routePhotoId: $routePhotoId, routePhotoTypeId: $routePhotoTypeId)';
  }
}

/// @nodoc
abstract mixin class $NotificationsResponseItemCopyWith<$Res> {
  factory $NotificationsResponseItemCopyWith(NotificationsResponseItem value,
          $Res Function(NotificationsResponseItem) _then) =
      _$NotificationsResponseItemCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? message,
      String? datetime,
      @JsonKey(name: 'status_id') int? statusId,
      @JsonKey(name: 'order_id') int? orderId,
      @JsonKey(name: 'route_photo_id') int? routePhotoId,
      @JsonKey(name: 'route_photo_type_id') int? routePhotoTypeId});
}

/// @nodoc
class _$NotificationsResponseItemCopyWithImpl<$Res>
    implements $NotificationsResponseItemCopyWith<$Res> {
  _$NotificationsResponseItemCopyWithImpl(this._self, this._then);

  final NotificationsResponseItem _self;
  final $Res Function(NotificationsResponseItem) _then;

  /// Create a copy of NotificationsResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? datetime = freezed,
    Object? statusId = freezed,
    Object? orderId = freezed,
    Object? routePhotoId = freezed,
    Object? routePhotoTypeId = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      datetime: freezed == datetime
          ? _self.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: freezed == statusId
          ? _self.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      routePhotoId: freezed == routePhotoId
          ? _self.routePhotoId
          : routePhotoId // ignore: cast_nullable_to_non_nullable
              as int?,
      routePhotoTypeId: freezed == routePhotoTypeId
          ? _self.routePhotoTypeId
          : routePhotoTypeId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationsResponseItem implements NotificationsResponseItem {
  const _NotificationsResponseItem(
      {this.id,
      this.message,
      this.datetime,
      @JsonKey(name: 'status_id') this.statusId,
      @JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'route_photo_id') this.routePhotoId,
      @JsonKey(name: 'route_photo_type_id') this.routePhotoTypeId});
  factory _NotificationsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseItemFromJson(json);

  @override
  final int? id;
  @override
  final String? message;
  @override
  final String? datetime;
  @override
  @JsonKey(name: 'status_id')
  final int? statusId;
  @override
  @JsonKey(name: 'order_id')
  final int? orderId;
  @override
  @JsonKey(name: 'route_photo_id')
  final int? routePhotoId;
  @override
  @JsonKey(name: 'route_photo_type_id')
  final int? routePhotoTypeId;

  /// Create a copy of NotificationsResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationsResponseItemCopyWith<_NotificationsResponseItem>
      get copyWith =>
          __$NotificationsResponseItemCopyWithImpl<_NotificationsResponseItem>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationsResponseItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationsResponseItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.routePhotoId, routePhotoId) ||
                other.routePhotoId == routePhotoId) &&
            (identical(other.routePhotoTypeId, routePhotoTypeId) ||
                other.routePhotoTypeId == routePhotoTypeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, message, datetime, statusId,
      orderId, routePhotoId, routePhotoTypeId);

  @override
  String toString() {
    return 'NotificationsResponseItem(id: $id, message: $message, datetime: $datetime, statusId: $statusId, orderId: $orderId, routePhotoId: $routePhotoId, routePhotoTypeId: $routePhotoTypeId)';
  }
}

/// @nodoc
abstract mixin class _$NotificationsResponseItemCopyWith<$Res>
    implements $NotificationsResponseItemCopyWith<$Res> {
  factory _$NotificationsResponseItemCopyWith(_NotificationsResponseItem value,
          $Res Function(_NotificationsResponseItem) _then) =
      __$NotificationsResponseItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? message,
      String? datetime,
      @JsonKey(name: 'status_id') int? statusId,
      @JsonKey(name: 'order_id') int? orderId,
      @JsonKey(name: 'route_photo_id') int? routePhotoId,
      @JsonKey(name: 'route_photo_type_id') int? routePhotoTypeId});
}

/// @nodoc
class __$NotificationsResponseItemCopyWithImpl<$Res>
    implements _$NotificationsResponseItemCopyWith<$Res> {
  __$NotificationsResponseItemCopyWithImpl(this._self, this._then);

  final _NotificationsResponseItem _self;
  final $Res Function(_NotificationsResponseItem) _then;

  /// Create a copy of NotificationsResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? datetime = freezed,
    Object? statusId = freezed,
    Object? orderId = freezed,
    Object? routePhotoId = freezed,
    Object? routePhotoTypeId = freezed,
  }) {
    return _then(_NotificationsResponseItem(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      datetime: freezed == datetime
          ? _self.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as String?,
      statusId: freezed == statusId
          ? _self.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as int?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      routePhotoId: freezed == routePhotoId
          ? _self.routePhotoId
          : routePhotoId // ignore: cast_nullable_to_non_nullable
              as int?,
      routePhotoTypeId: freezed == routePhotoTypeId
          ? _self.routePhotoTypeId
          : routePhotoTypeId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
