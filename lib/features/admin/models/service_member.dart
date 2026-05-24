class ServiceMember {
  final int? id;
  final String? documentId;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;
  final int? role;

  ServiceMember({
    this.id,
    this.documentId,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
    this.role = 3,
  });

  factory ServiceMember.fromJson(Map<String, dynamic> json) {
    return ServiceMember(
      id: json['id'] as int?,
      documentId: json['documentId'] as String?,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      confirmed: json['confirmed'] ?? false,
      blocked: json['blocked'] ?? false,
      role: json['role'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'confirmed': confirmed,
      'blocked': blocked,
      'role': role,
    };
  }

  ServiceMember copyWith({
    int? id,
    String? documentId,
    String? username,
    String? email,
    bool? confirmed,
    bool? blocked,
  }) {
    return ServiceMember(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      username: username ?? this.username,
      email: email ?? this.email,
      confirmed: confirmed ?? this.confirmed,
      blocked: blocked ?? this.blocked,
      role: role,
    );
  }
}
