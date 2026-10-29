// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MasterDataCacheTableTable extends MasterDataCacheTable
    with TableInfo<$MasterDataCacheTableTable, MasterDataCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasterDataCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonDataMeta = const VerificationMeta(
    'jsonData',
  );
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
    'json_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cacheKey, jsonData, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'master_data_cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasterDataCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('json_data')) {
      context.handle(
        _jsonDataMeta,
        jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  MasterDataCacheTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasterDataCacheTableData(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      jsonData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_data'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $MasterDataCacheTableTable createAlias(String alias) {
    return $MasterDataCacheTableTable(attachedDatabase, alias);
  }
}

class MasterDataCacheTableData extends DataClass
    implements Insertable<MasterDataCacheTableData> {
  final String cacheKey;
  final String jsonData;
  final DateTime cachedAt;
  const MasterDataCacheTableData({
    required this.cacheKey,
    required this.jsonData,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['json_data'] = Variable<String>(jsonData);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MasterDataCacheTableCompanion toCompanion(bool nullToAbsent) {
    return MasterDataCacheTableCompanion(
      cacheKey: Value(cacheKey),
      jsonData: Value(jsonData),
      cachedAt: Value(cachedAt),
    );
  }

  factory MasterDataCacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasterDataCacheTableData(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'jsonData': serializer.toJson<String>(jsonData),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  MasterDataCacheTableData copyWith({
    String? cacheKey,
    String? jsonData,
    DateTime? cachedAt,
  }) => MasterDataCacheTableData(
    cacheKey: cacheKey ?? this.cacheKey,
    jsonData: jsonData ?? this.jsonData,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  MasterDataCacheTableData copyWithCompanion(
    MasterDataCacheTableCompanion data,
  ) {
    return MasterDataCacheTableData(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      jsonData: data.jsonData.present ? data.jsonData.value : this.jsonData,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasterDataCacheTableData(')
          ..write('cacheKey: $cacheKey, ')
          ..write('jsonData: $jsonData, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, jsonData, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasterDataCacheTableData &&
          other.cacheKey == this.cacheKey &&
          other.jsonData == this.jsonData &&
          other.cachedAt == this.cachedAt);
}

class MasterDataCacheTableCompanion
    extends UpdateCompanion<MasterDataCacheTableData> {
  final Value<String> cacheKey;
  final Value<String> jsonData;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const MasterDataCacheTableCompanion({
    this.cacheKey = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasterDataCacheTableCompanion.insert({
    required String cacheKey,
    required String jsonData,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       jsonData = Value(jsonData),
       cachedAt = Value(cachedAt);
  static Insertable<MasterDataCacheTableData> custom({
    Expression<String>? cacheKey,
    Expression<String>? jsonData,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (jsonData != null) 'json_data': jsonData,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasterDataCacheTableCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? jsonData,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return MasterDataCacheTableCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      jsonData: jsonData ?? this.jsonData,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasterDataCacheTableCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('jsonData: $jsonData, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HeldOrdersTableTable extends HeldOrdersTable
    with TableInfo<$HeldOrdersTableTable, HeldOrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeldOrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cartItemsJsonMeta = const VerificationMeta(
    'cartItemsJson',
  );
  @override
  late final GeneratedColumn<String> cartItemsJson = GeneratedColumn<String>(
    'cart_items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cartDiscountTypeMeta = const VerificationMeta(
    'cartDiscountType',
  );
  @override
  late final GeneratedColumn<String> cartDiscountType = GeneratedColumn<String>(
    'cart_discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cartDiscountValueMeta = const VerificationMeta(
    'cartDiscountValue',
  );
  @override
  late final GeneratedColumn<String> cartDiscountValue =
      GeneratedColumn<String>(
        'cart_discount_value',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _itemCountMeta = const VerificationMeta(
    'itemCount',
  );
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<String> totalAmount = GeneratedColumn<String>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    createdAt,
    cartItemsJson,
    customerId,
    customerName,
    cartDiscountType,
    cartDiscountValue,
    itemCount,
    totalAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'held_orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeldOrdersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('cart_items_json')) {
      context.handle(
        _cartItemsJsonMeta,
        cartItemsJson.isAcceptableOrUnknown(
          data['cart_items_json']!,
          _cartItemsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cartItemsJsonMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('cart_discount_type')) {
      context.handle(
        _cartDiscountTypeMeta,
        cartDiscountType.isAcceptableOrUnknown(
          data['cart_discount_type']!,
          _cartDiscountTypeMeta,
        ),
      );
    }
    if (data.containsKey('cart_discount_value')) {
      context.handle(
        _cartDiscountValueMeta,
        cartDiscountValue.isAcceptableOrUnknown(
          data['cart_discount_value']!,
          _cartDiscountValueMeta,
        ),
      );
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeldOrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeldOrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cartItemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_items_json'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      cartDiscountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_discount_type'],
      ),
      cartDiscountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_discount_value'],
      ),
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_amount'],
      )!,
    );
  }

  @override
  $HeldOrdersTableTable createAlias(String alias) {
    return $HeldOrdersTableTable(attachedDatabase, alias);
  }
}

class HeldOrdersTableData extends DataClass
    implements Insertable<HeldOrdersTableData> {
  final String id;
  final String label;
  final DateTime createdAt;
  final String cartItemsJson;
  final String? customerId;
  final String? customerName;
  final String? cartDiscountType;
  final String? cartDiscountValue;
  final int itemCount;
  final String totalAmount;
  const HeldOrdersTableData({
    required this.id,
    required this.label,
    required this.createdAt,
    required this.cartItemsJson,
    this.customerId,
    this.customerName,
    this.cartDiscountType,
    this.cartDiscountValue,
    required this.itemCount,
    required this.totalAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cart_items_json'] = Variable<String>(cartItemsJson);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || cartDiscountType != null) {
      map['cart_discount_type'] = Variable<String>(cartDiscountType);
    }
    if (!nullToAbsent || cartDiscountValue != null) {
      map['cart_discount_value'] = Variable<String>(cartDiscountValue);
    }
    map['item_count'] = Variable<int>(itemCount);
    map['total_amount'] = Variable<String>(totalAmount);
    return map;
  }

  HeldOrdersTableCompanion toCompanion(bool nullToAbsent) {
    return HeldOrdersTableCompanion(
      id: Value(id),
      label: Value(label),
      createdAt: Value(createdAt),
      cartItemsJson: Value(cartItemsJson),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      cartDiscountType: cartDiscountType == null && nullToAbsent
          ? const Value.absent()
          : Value(cartDiscountType),
      cartDiscountValue: cartDiscountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(cartDiscountValue),
      itemCount: Value(itemCount),
      totalAmount: Value(totalAmount),
    );
  }

  factory HeldOrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeldOrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cartItemsJson: serializer.fromJson<String>(json['cartItemsJson']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      cartDiscountType: serializer.fromJson<String?>(json['cartDiscountType']),
      cartDiscountValue: serializer.fromJson<String?>(
        json['cartDiscountValue'],
      ),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      totalAmount: serializer.fromJson<String>(json['totalAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cartItemsJson': serializer.toJson<String>(cartItemsJson),
      'customerId': serializer.toJson<String?>(customerId),
      'customerName': serializer.toJson<String?>(customerName),
      'cartDiscountType': serializer.toJson<String?>(cartDiscountType),
      'cartDiscountValue': serializer.toJson<String?>(cartDiscountValue),
      'itemCount': serializer.toJson<int>(itemCount),
      'totalAmount': serializer.toJson<String>(totalAmount),
    };
  }

  HeldOrdersTableData copyWith({
    String? id,
    String? label,
    DateTime? createdAt,
    String? cartItemsJson,
    Value<String?> customerId = const Value.absent(),
    Value<String?> customerName = const Value.absent(),
    Value<String?> cartDiscountType = const Value.absent(),
    Value<String?> cartDiscountValue = const Value.absent(),
    int? itemCount,
    String? totalAmount,
  }) => HeldOrdersTableData(
    id: id ?? this.id,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
    cartItemsJson: cartItemsJson ?? this.cartItemsJson,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName.present ? customerName.value : this.customerName,
    cartDiscountType: cartDiscountType.present
        ? cartDiscountType.value
        : this.cartDiscountType,
    cartDiscountValue: cartDiscountValue.present
        ? cartDiscountValue.value
        : this.cartDiscountValue,
    itemCount: itemCount ?? this.itemCount,
    totalAmount: totalAmount ?? this.totalAmount,
  );
  HeldOrdersTableData copyWithCompanion(HeldOrdersTableCompanion data) {
    return HeldOrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cartItemsJson: data.cartItemsJson.present
          ? data.cartItemsJson.value
          : this.cartItemsJson,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      cartDiscountType: data.cartDiscountType.present
          ? data.cartDiscountType.value
          : this.cartDiscountType,
      cartDiscountValue: data.cartDiscountValue.present
          ? data.cartDiscountValue.value
          : this.cartDiscountValue,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeldOrdersTableData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('cartItemsJson: $cartItemsJson, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('cartDiscountType: $cartDiscountType, ')
          ..write('cartDiscountValue: $cartDiscountValue, ')
          ..write('itemCount: $itemCount, ')
          ..write('totalAmount: $totalAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    createdAt,
    cartItemsJson,
    customerId,
    customerName,
    cartDiscountType,
    cartDiscountValue,
    itemCount,
    totalAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeldOrdersTableData &&
          other.id == this.id &&
          other.label == this.label &&
          other.createdAt == this.createdAt &&
          other.cartItemsJson == this.cartItemsJson &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.cartDiscountType == this.cartDiscountType &&
          other.cartDiscountValue == this.cartDiscountValue &&
          other.itemCount == this.itemCount &&
          other.totalAmount == this.totalAmount);
}

class HeldOrdersTableCompanion extends UpdateCompanion<HeldOrdersTableData> {
  final Value<String> id;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<String> cartItemsJson;
  final Value<String?> customerId;
  final Value<String?> customerName;
  final Value<String?> cartDiscountType;
  final Value<String?> cartDiscountValue;
  final Value<int> itemCount;
  final Value<String> totalAmount;
  final Value<int> rowid;
  const HeldOrdersTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cartItemsJson = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.cartDiscountType = const Value.absent(),
    this.cartDiscountValue = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HeldOrdersTableCompanion.insert({
    required String id,
    required String label,
    required DateTime createdAt,
    required String cartItemsJson,
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.cartDiscountType = const Value.absent(),
    this.cartDiscountValue = const Value.absent(),
    required int itemCount,
    required String totalAmount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       createdAt = Value(createdAt),
       cartItemsJson = Value(cartItemsJson),
       itemCount = Value(itemCount),
       totalAmount = Value(totalAmount);
  static Insertable<HeldOrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<String>? cartItemsJson,
    Expression<String>? customerId,
    Expression<String>? customerName,
    Expression<String>? cartDiscountType,
    Expression<String>? cartDiscountValue,
    Expression<int>? itemCount,
    Expression<String>? totalAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (cartItemsJson != null) 'cart_items_json': cartItemsJson,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (cartDiscountType != null) 'cart_discount_type': cartDiscountType,
      if (cartDiscountValue != null) 'cart_discount_value': cartDiscountValue,
      if (itemCount != null) 'item_count': itemCount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HeldOrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<DateTime>? createdAt,
    Value<String>? cartItemsJson,
    Value<String?>? customerId,
    Value<String?>? customerName,
    Value<String?>? cartDiscountType,
    Value<String?>? cartDiscountValue,
    Value<int>? itemCount,
    Value<String>? totalAmount,
    Value<int>? rowid,
  }) {
    return HeldOrdersTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      cartItemsJson: cartItemsJson ?? this.cartItemsJson,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      cartDiscountType: cartDiscountType ?? this.cartDiscountType,
      cartDiscountValue: cartDiscountValue ?? this.cartDiscountValue,
      itemCount: itemCount ?? this.itemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cartItemsJson.present) {
      map['cart_items_json'] = Variable<String>(cartItemsJson.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (cartDiscountType.present) {
      map['cart_discount_type'] = Variable<String>(cartDiscountType.value);
    }
    if (cartDiscountValue.present) {
      map['cart_discount_value'] = Variable<String>(cartDiscountValue.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<String>(totalAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeldOrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('cartItemsJson: $cartItemsJson, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('cartDiscountType: $cartDiscountType, ')
          ..write('cartDiscountValue: $cartDiscountValue, ')
          ..write('itemCount: $itemCount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessSlugMeta = const VerificationMeta(
    'businessSlug',
  );
  @override
  late final GeneratedColumn<String> businessSlug = GeneratedColumn<String>(
    'business_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rolesJsonMeta = const VerificationMeta(
    'rolesJson',
  );
  @override
  late final GeneratedColumn<String> rolesJson = GeneratedColumn<String>(
    'roles_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionKeysJsonMeta =
      const VerificationMeta('permissionKeysJson');
  @override
  late final GeneratedColumn<String> permissionKeysJson =
      GeneratedColumn<String>(
        'permission_keys_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    name,
    role,
    businessId,
    branchId,
    businessSlug,
    rolesJson,
    permissionKeysJson,
    pinHash,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    }
    if (data.containsKey('business_slug')) {
      context.handle(
        _businessSlugMeta,
        businessSlug.isAcceptableOrUnknown(
          data['business_slug']!,
          _businessSlugMeta,
        ),
      );
    }
    if (data.containsKey('roles_json')) {
      context.handle(
        _rolesJsonMeta,
        rolesJson.isAcceptableOrUnknown(data['roles_json']!, _rolesJsonMeta),
      );
    }
    if (data.containsKey('permission_keys_json')) {
      context.handle(
        _permissionKeysJsonMeta,
        permissionKeysJson.isAcceptableOrUnknown(
          data['permission_keys_json']!,
          _permissionKeysJsonMeta,
        ),
      );
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      ),
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      ),
      businessSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_slug'],
      ),
      rolesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roles_json'],
      ),
      permissionKeysJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permission_keys_json'],
      ),
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? businessId;
  final String? branchId;
  final String? businessSlug;
  final String? rolesJson;
  final String? permissionKeysJson;
  final String? pinHash;
  final DateTime updatedAt;
  const UsersTableData({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.businessId,
    this.branchId,
    this.businessSlug,
    this.rolesJson,
    this.permissionKeysJson,
    this.pinHash,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || businessId != null) {
      map['business_id'] = Variable<String>(businessId);
    }
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<String>(branchId);
    }
    if (!nullToAbsent || businessSlug != null) {
      map['business_slug'] = Variable<String>(businessSlug);
    }
    if (!nullToAbsent || rolesJson != null) {
      map['roles_json'] = Variable<String>(rolesJson);
    }
    if (!nullToAbsent || permissionKeysJson != null) {
      map['permission_keys_json'] = Variable<String>(permissionKeysJson);
    }
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      email: Value(email),
      name: Value(name),
      role: Value(role),
      businessId: businessId == null && nullToAbsent
          ? const Value.absent()
          : Value(businessId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      businessSlug: businessSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(businessSlug),
      rolesJson: rolesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rolesJson),
      permissionKeysJson: permissionKeysJson == null && nullToAbsent
          ? const Value.absent()
          : Value(permissionKeysJson),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      updatedAt: Value(updatedAt),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      businessId: serializer.fromJson<String?>(json['businessId']),
      branchId: serializer.fromJson<String?>(json['branchId']),
      businessSlug: serializer.fromJson<String?>(json['businessSlug']),
      rolesJson: serializer.fromJson<String?>(json['rolesJson']),
      permissionKeysJson: serializer.fromJson<String?>(
        json['permissionKeysJson'],
      ),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'businessId': serializer.toJson<String?>(businessId),
      'branchId': serializer.toJson<String?>(branchId),
      'businessSlug': serializer.toJson<String?>(businessSlug),
      'rolesJson': serializer.toJson<String?>(rolesJson),
      'permissionKeysJson': serializer.toJson<String?>(permissionKeysJson),
      'pinHash': serializer.toJson<String?>(pinHash),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UsersTableData copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    Value<String?> businessId = const Value.absent(),
    Value<String?> branchId = const Value.absent(),
    Value<String?> businessSlug = const Value.absent(),
    Value<String?> rolesJson = const Value.absent(),
    Value<String?> permissionKeysJson = const Value.absent(),
    Value<String?> pinHash = const Value.absent(),
    DateTime? updatedAt,
  }) => UsersTableData(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    role: role ?? this.role,
    businessId: businessId.present ? businessId.value : this.businessId,
    branchId: branchId.present ? branchId.value : this.branchId,
    businessSlug: businessSlug.present ? businessSlug.value : this.businessSlug,
    rolesJson: rolesJson.present ? rolesJson.value : this.rolesJson,
    permissionKeysJson: permissionKeysJson.present
        ? permissionKeysJson.value
        : this.permissionKeysJson,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      businessSlug: data.businessSlug.present
          ? data.businessSlug.value
          : this.businessSlug,
      rolesJson: data.rolesJson.present ? data.rolesJson.value : this.rolesJson,
      permissionKeysJson: data.permissionKeysJson.present
          ? data.permissionKeysJson.value
          : this.permissionKeysJson,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('businessId: $businessId, ')
          ..write('branchId: $branchId, ')
          ..write('businessSlug: $businessSlug, ')
          ..write('rolesJson: $rolesJson, ')
          ..write('permissionKeysJson: $permissionKeysJson, ')
          ..write('pinHash: $pinHash, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    name,
    role,
    businessId,
    branchId,
    businessSlug,
    rolesJson,
    permissionKeysJson,
    pinHash,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.email == this.email &&
          other.name == this.name &&
          other.role == this.role &&
          other.businessId == this.businessId &&
          other.branchId == this.branchId &&
          other.businessSlug == this.businessSlug &&
          other.rolesJson == this.rolesJson &&
          other.permissionKeysJson == this.permissionKeysJson &&
          other.pinHash == this.pinHash &&
          other.updatedAt == this.updatedAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> name;
  final Value<String> role;
  final Value<String?> businessId;
  final Value<String?> branchId;
  final Value<String?> businessSlug;
  final Value<String?> rolesJson;
  final Value<String?> permissionKeysJson;
  final Value<String?> pinHash;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.businessId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.businessSlug = const Value.absent(),
    this.rolesJson = const Value.absent(),
    this.permissionKeysJson = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String email,
    required String name,
    required String role,
    this.businessId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.businessSlug = const Value.absent(),
    this.rolesJson = const Value.absent(),
    this.permissionKeysJson = const Value.absent(),
    this.pinHash = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       name = Value(name),
       role = Value(role),
       updatedAt = Value(updatedAt);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? businessId,
    Expression<String>? branchId,
    Expression<String>? businessSlug,
    Expression<String>? rolesJson,
    Expression<String>? permissionKeysJson,
    Expression<String>? pinHash,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (businessId != null) 'business_id': businessId,
      if (branchId != null) 'branch_id': branchId,
      if (businessSlug != null) 'business_slug': businessSlug,
      if (rolesJson != null) 'roles_json': rolesJson,
      if (permissionKeysJson != null)
        'permission_keys_json': permissionKeysJson,
      if (pinHash != null) 'pin_hash': pinHash,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? name,
    Value<String>? role,
    Value<String?>? businessId,
    Value<String?>? branchId,
    Value<String?>? businessSlug,
    Value<String?>? rolesJson,
    Value<String?>? permissionKeysJson,
    Value<String?>? pinHash,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      businessId: businessId ?? this.businessId,
      branchId: branchId ?? this.branchId,
      businessSlug: businessSlug ?? this.businessSlug,
      rolesJson: rolesJson ?? this.rolesJson,
      permissionKeysJson: permissionKeysJson ?? this.permissionKeysJson,
      pinHash: pinHash ?? this.pinHash,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (businessSlug.present) {
      map['business_slug'] = Variable<String>(businessSlug.value);
    }
    if (rolesJson.present) {
      map['roles_json'] = Variable<String>(rolesJson.value);
    }
    if (permissionKeysJson.present) {
      map['permission_keys_json'] = Variable<String>(permissionKeysJson.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('businessId: $businessId, ')
          ..write('branchId: $branchId, ')
          ..write('businessSlug: $businessSlug, ')
          ..write('rolesJson: $rolesJson, ')
          ..write('permissionKeysJson: $permissionKeysJson, ')
          ..write('pinHash: $pinHash, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MasterDataCacheTableTable masterDataCacheTable =
      $MasterDataCacheTableTable(this);
  late final $HeldOrdersTableTable heldOrdersTable = $HeldOrdersTableTable(
    this,
  );
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final MasterDataCacheDao masterDataCacheDao = MasterDataCacheDao(
    this as AppDatabase,
  );
  late final HeldOrdersDao heldOrdersDao = HeldOrdersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    masterDataCacheTable,
    heldOrdersTable,
    usersTable,
  ];
}

typedef $$MasterDataCacheTableTableCreateCompanionBuilder =
    MasterDataCacheTableCompanion Function({
      required String cacheKey,
      required String jsonData,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$MasterDataCacheTableTableUpdateCompanionBuilder =
    MasterDataCacheTableCompanion Function({
      Value<String> cacheKey,
      Value<String> jsonData,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$MasterDataCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $MasterDataCacheTableTable> {
  $$MasterDataCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonData => $composableBuilder(
    column: $table.jsonData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MasterDataCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MasterDataCacheTableTable> {
  $$MasterDataCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonData => $composableBuilder(
    column: $table.jsonData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MasterDataCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasterDataCacheTableTable> {
  $$MasterDataCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get jsonData =>
      $composableBuilder(column: $table.jsonData, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$MasterDataCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MasterDataCacheTableTable,
          MasterDataCacheTableData,
          $$MasterDataCacheTableTableFilterComposer,
          $$MasterDataCacheTableTableOrderingComposer,
          $$MasterDataCacheTableTableAnnotationComposer,
          $$MasterDataCacheTableTableCreateCompanionBuilder,
          $$MasterDataCacheTableTableUpdateCompanionBuilder,
          (
            MasterDataCacheTableData,
            BaseReferences<
              _$AppDatabase,
              $MasterDataCacheTableTable,
              MasterDataCacheTableData
            >,
          ),
          MasterDataCacheTableData,
          PrefetchHooks Function()
        > {
  $$MasterDataCacheTableTableTableManager(
    _$AppDatabase db,
    $MasterDataCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasterDataCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasterDataCacheTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MasterDataCacheTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> jsonData = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasterDataCacheTableCompanion(
                cacheKey: cacheKey,
                jsonData: jsonData,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String jsonData,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => MasterDataCacheTableCompanion.insert(
                cacheKey: cacheKey,
                jsonData: jsonData,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MasterDataCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MasterDataCacheTableTable,
      MasterDataCacheTableData,
      $$MasterDataCacheTableTableFilterComposer,
      $$MasterDataCacheTableTableOrderingComposer,
      $$MasterDataCacheTableTableAnnotationComposer,
      $$MasterDataCacheTableTableCreateCompanionBuilder,
      $$MasterDataCacheTableTableUpdateCompanionBuilder,
      (
        MasterDataCacheTableData,
        BaseReferences<
          _$AppDatabase,
          $MasterDataCacheTableTable,
          MasterDataCacheTableData
        >,
      ),
      MasterDataCacheTableData,
      PrefetchHooks Function()
    >;
typedef $$HeldOrdersTableTableCreateCompanionBuilder =
    HeldOrdersTableCompanion Function({
      required String id,
      required String label,
      required DateTime createdAt,
      required String cartItemsJson,
      Value<String?> customerId,
      Value<String?> customerName,
      Value<String?> cartDiscountType,
      Value<String?> cartDiscountValue,
      required int itemCount,
      required String totalAmount,
      Value<int> rowid,
    });
typedef $$HeldOrdersTableTableUpdateCompanionBuilder =
    HeldOrdersTableCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<DateTime> createdAt,
      Value<String> cartItemsJson,
      Value<String?> customerId,
      Value<String?> customerName,
      Value<String?> cartDiscountType,
      Value<String?> cartDiscountValue,
      Value<int> itemCount,
      Value<String> totalAmount,
      Value<int> rowid,
    });

class $$HeldOrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $HeldOrdersTableTable> {
  $$HeldOrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartItemsJson => $composableBuilder(
    column: $table.cartItemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartDiscountType => $composableBuilder(
    column: $table.cartDiscountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartDiscountValue => $composableBuilder(
    column: $table.cartDiscountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeldOrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HeldOrdersTableTable> {
  $$HeldOrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartItemsJson => $composableBuilder(
    column: $table.cartItemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartDiscountType => $composableBuilder(
    column: $table.cartDiscountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartDiscountValue => $composableBuilder(
    column: $table.cartDiscountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeldOrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeldOrdersTableTable> {
  $$HeldOrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get cartItemsJson => $composableBuilder(
    column: $table.cartItemsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cartDiscountType => $composableBuilder(
    column: $table.cartDiscountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cartDiscountValue => $composableBuilder(
    column: $table.cartDiscountValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );
}

class $$HeldOrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeldOrdersTableTable,
          HeldOrdersTableData,
          $$HeldOrdersTableTableFilterComposer,
          $$HeldOrdersTableTableOrderingComposer,
          $$HeldOrdersTableTableAnnotationComposer,
          $$HeldOrdersTableTableCreateCompanionBuilder,
          $$HeldOrdersTableTableUpdateCompanionBuilder,
          (
            HeldOrdersTableData,
            BaseReferences<
              _$AppDatabase,
              $HeldOrdersTableTable,
              HeldOrdersTableData
            >,
          ),
          HeldOrdersTableData,
          PrefetchHooks Function()
        > {
  $$HeldOrdersTableTableTableManager(
    _$AppDatabase db,
    $HeldOrdersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeldOrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeldOrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeldOrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> cartItemsJson = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> cartDiscountType = const Value.absent(),
                Value<String?> cartDiscountValue = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<String> totalAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HeldOrdersTableCompanion(
                id: id,
                label: label,
                createdAt: createdAt,
                cartItemsJson: cartItemsJson,
                customerId: customerId,
                customerName: customerName,
                cartDiscountType: cartDiscountType,
                cartDiscountValue: cartDiscountValue,
                itemCount: itemCount,
                totalAmount: totalAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                required DateTime createdAt,
                required String cartItemsJson,
                Value<String?> customerId = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<String?> cartDiscountType = const Value.absent(),
                Value<String?> cartDiscountValue = const Value.absent(),
                required int itemCount,
                required String totalAmount,
                Value<int> rowid = const Value.absent(),
              }) => HeldOrdersTableCompanion.insert(
                id: id,
                label: label,
                createdAt: createdAt,
                cartItemsJson: cartItemsJson,
                customerId: customerId,
                customerName: customerName,
                cartDiscountType: cartDiscountType,
                cartDiscountValue: cartDiscountValue,
                itemCount: itemCount,
                totalAmount: totalAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeldOrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeldOrdersTableTable,
      HeldOrdersTableData,
      $$HeldOrdersTableTableFilterComposer,
      $$HeldOrdersTableTableOrderingComposer,
      $$HeldOrdersTableTableAnnotationComposer,
      $$HeldOrdersTableTableCreateCompanionBuilder,
      $$HeldOrdersTableTableUpdateCompanionBuilder,
      (
        HeldOrdersTableData,
        BaseReferences<
          _$AppDatabase,
          $HeldOrdersTableTable,
          HeldOrdersTableData
        >,
      ),
      HeldOrdersTableData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      required String email,
      required String name,
      required String role,
      Value<String?> businessId,
      Value<String?> branchId,
      Value<String?> businessSlug,
      Value<String?> rolesJson,
      Value<String?> permissionKeysJson,
      Value<String?> pinHash,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> name,
      Value<String> role,
      Value<String?> businessId,
      Value<String?> branchId,
      Value<String?> businessSlug,
      Value<String?> rolesJson,
      Value<String?> permissionKeysJson,
      Value<String?> pinHash,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessSlug => $composableBuilder(
    column: $table.businessSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rolesJson => $composableBuilder(
    column: $table.rolesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissionKeysJson => $composableBuilder(
    column: $table.permissionKeysJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessSlug => $composableBuilder(
    column: $table.businessSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rolesJson => $composableBuilder(
    column: $table.rolesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissionKeysJson => $composableBuilder(
    column: $table.permissionKeysJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get businessSlug => $composableBuilder(
    column: $table.businessSlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rolesJson =>
      $composableBuilder(column: $table.rolesJson, builder: (column) => column);

  GeneratedColumn<String> get permissionKeysJson => $composableBuilder(
    column: $table.permissionKeysJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UsersTableData,
            BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
          ),
          UsersTableData,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> businessId = const Value.absent(),
                Value<String?> branchId = const Value.absent(),
                Value<String?> businessSlug = const Value.absent(),
                Value<String?> rolesJson = const Value.absent(),
                Value<String?> permissionKeysJson = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                email: email,
                name: name,
                role: role,
                businessId: businessId,
                branchId: branchId,
                businessSlug: businessSlug,
                rolesJson: rolesJson,
                permissionKeysJson: permissionKeysJson,
                pinHash: pinHash,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String name,
                required String role,
                Value<String?> businessId = const Value.absent(),
                Value<String?> branchId = const Value.absent(),
                Value<String?> businessSlug = const Value.absent(),
                Value<String?> rolesJson = const Value.absent(),
                Value<String?> permissionKeysJson = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                email: email,
                name: name,
                role: role,
                businessId: businessId,
                branchId: branchId,
                businessSlug: businessSlug,
                rolesJson: rolesJson,
                permissionKeysJson: permissionKeysJson,
                pinHash: pinHash,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UsersTableData,
        BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData>,
      ),
      UsersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MasterDataCacheTableTableTableManager get masterDataCacheTable =>
      $$MasterDataCacheTableTableTableManager(_db, _db.masterDataCacheTable);
  $$HeldOrdersTableTableTableManager get heldOrdersTable =>
      $$HeldOrdersTableTableTableManager(_db, _db.heldOrdersTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
}
