class instapayModelProd {
  String id = '';
  String transactionType = '';
  String status = '';
  String reasonCode = '';
  String description = '';
  String localInstrument = '';
  String instructionId = '';
  String transactionId = '';
  String referenceId = '';
  String senderBic = '';
  String senderName = '';
  String senderAccount = '';
  String currency = '';
  double amount = 0.0;
  String receivingBic = '';
  String receivingName = '';
  String receivingAccount = '';
  String transactionDate = '';



  instapayModelProd({
    this.id = '',
    this.transactionType = '',
    this.status = '',
    this.reasonCode = '',
    this.description = '',
    this.localInstrument = '',
    this.instructionId = '',
    this.transactionId = '',
    this.referenceId = '',
    this.senderBic = '',
    this.senderName = '',
    this.senderAccount = '',
    this.currency = '',
    this.amount = 0.0,
    this.receivingBic = '',
    this.receivingName = '',
    this.receivingAccount = '',
    required this.transactionDate, // Ensure transactionDatetime is required
  });

  instapayModelProd.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    transactionType = json['transactionType'] ?? '';
    status = json['status'] ?? '';
    reasonCode = json['reasonCode'] ?? '';
    description = json['description'] ?? '';
    localInstrument = json['localInstrument'] ?? '';
    instructionId = json['instructionId'] ?? '';
    transactionId = json['transactionId'] ?? '';
    referenceId = json['referenceId'] ?? '';
    senderBic = json['senderBic'] ?? '';
    senderName = json['senderName'] ?? '';
    senderAccount = json['senderAccount'] ?? '';
    currency = json['currency'] ?? '';
    amount = (json['amount'] ?? 0.0).toDouble(); // Ensure amount is parsed as double
    receivingBic = json['receivingBic'] ?? '';
    receivingName = json['receivingName'] ?? '';
    receivingAccount = json['receivingAccount'] ?? '';
    transactionDate = json['transactionDatetime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transactionType'] = transactionType;
    data['status'] = status;
    data['reasonCode'] = reasonCode;
    data['description'] = description;
    data['localInstrument'] = localInstrument;
    data['instructionId'] = instructionId;
    data['transactionId'] = transactionId;
    data['referenceId'] = referenceId;
    data['senderBic'] = senderBic;
    data['senderName'] = senderName;
    data['senderAccount'] = senderAccount;
    data['currency'] = currency;
    data['amount'] = amount;
    data['receivingBic'] = receivingBic;
    data['receivingName'] = receivingName;
    data['receivingAccount'] = receivingAccount;
    data['transactionDatetime'] = transactionDate;
    return data;
  }

  @override
  String toString() {
    return 'instapayModel{id: $id, transactionType: $transactionType, status: $status, reasonCode: $reasonCode, description: $description, localInstrument: $localInstrument, instructionId: $instructionId, transactionId: $transactionId, referenceId: $referenceId, senderBic: $senderBic, senderName: $senderName, senderAccount: $senderAccount, currency: $currency, amount: $amount, receivingBic: $receivingBic, receivingName: $receivingName, receivingAccount: $receivingAccount, transactionDatetime: $transactionDate}';
  }
}