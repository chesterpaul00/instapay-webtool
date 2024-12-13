class IpsParticipant {
  final String name;
  final String displayName;
  final String bankCode;
  final String bic;
  final String mnemonic;
  final String connectionType;
  final String type;

  IpsParticipant({
    required this.name,
    required this.displayName,
    required this.bankCode,
    required this.bic,
    required this.mnemonic,
    required this.connectionType,
    required this.type,
  });

  factory IpsParticipant.fromJson(Map<String, dynamic> json) {
    return IpsParticipant(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bic: json['bic'] ?? '',
      mnemonic: json['mnemonic'] ?? '',
      connectionType: json['connectionType'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
