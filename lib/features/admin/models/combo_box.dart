class ComboBox {
  final int? id;
  final String? documentId;
  final String type;
  final String name;
  final String? valueStr;
  final int? valueInt;

  ComboBox({
    this.id,
    this.documentId,
    required this.type,
    required this.name,
    this.valueStr,
    this.valueInt,
  });

  factory ComboBox.fromJson(Map<String, dynamic> json) {
    return ComboBox(
      id: json['id'] as int?,
      documentId: json['documentId'] as String?,
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      valueStr: json['valueStr'] as String?,
      valueInt: json['valueInt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      if (valueStr != null) 'valueStr': valueStr,
      if (valueInt != null) 'valueInt': valueInt,
    };
  }

  ComboBox copyWith({
    int? id,
    String? documentId,
    String? type,
    String? name,
    String? valueStr,
    int? valueInt,
  }) {
    return ComboBox(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      type: type ?? this.type,
      name: name ?? this.name,
      valueStr: valueStr ?? this.valueStr,
      valueInt: valueInt ?? this.valueInt,
    );
  }
}
