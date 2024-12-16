class KPlusModel {
  int? id;
  int? trnId;
  String? trnType;
  double? amount;
  String? status;
  String? trnDate;
  String? lastUpdate;
  String? accountNumber;
  int? cid;
  String? refId;
  String? url;
  String? source;
  String? target;
  String? sourceStatus;
  String? sourceTarget;
  int? totalFee;
  int? agentFee;
  int? bankFee;
  PaymentDetails? paymentDetails;
  String? targetCid;
  String? sourceCid;
  String? janusRefId;

  KPlusModel(
      {this.id,
        this.trnId,
        this.trnType,
        this.amount,
        this.status,
        this.trnDate,
        this.lastUpdate,
        this.accountNumber,
        this.cid,
        this.refId,
        this.url,
        this.source,
        this.target,
        this.sourceStatus,
        this.sourceTarget,
        this.totalFee,
        this.agentFee,
        this.bankFee,
        this.paymentDetails,
        this.targetCid,
        this.sourceCid,
        this.janusRefId});

  KPlusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trnId = json['trn_id'];
    trnType = json['trn_type'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : null;
    status = json['status'];
    trnDate = json['trn_date'];
    lastUpdate = json['last_update'];
    accountNumber = json['account_number'];
    cid = json['cid'];
    refId = json['ref_id'];
    url = json['url'];
    source = json['source'];
    target = json['target'];
    sourceStatus = json['source_status'];
    sourceTarget = json['source_target'];
    totalFee = json['total_fee'];
    agentFee = json['agent_fee'];
    bankFee = json['bank_fee'];
    paymentDetails = json['payment_details'] != null
        ? PaymentDetails.fromJson(json['payment_details'])
        : null;
    targetCid = json['target_cid'];
    sourceCid = json['source_cid'];
    janusRefId = json['janus_ref_id'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trn_id'] = trnId;
    data['trn_type'] = trnType;
    data['amount'] = amount;
    data['status'] = status;
    data['trn_date'] = trnDate;
    data['last_update'] = lastUpdate;
    data['account_number'] = accountNumber;
    data['cid'] = cid;
    data['ref_id'] = refId;
    data['url'] = url;
    data['source'] = source;
    data['target'] = target;
    data['source_status'] = sourceStatus;
    data['source_target'] = sourceTarget;
    data['total_fee'] = totalFee;
    data['agent_fee'] = agentFee;
    data['bank_fee'] = bankFee;
    if (paymentDetails != null) {
      data['payment_details'] = paymentDetails!.toJson();
    }
    data['target_cid'] = targetCid;
    data['source_cid'] = sourceCid;
    data['janus_ref_id'] = janusRefId;
    return data;
  }
}

class PaymentDetails {
  Request? request;
  Response? response;

  PaymentDetails({this.request, this.response});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    request =
    json['Request'] != null ? Request.fromJson(json['Request']) : null;
    response = json['Response'] != null
        ? Response.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (request != null) {
      data['Request'] = request!.toJson();
    }
    if (response != null) {
      data['Response'] = response!.toJson();
    }
    return data;
  }
}

class Request {
  String? referenceNumber;
  String? debitAccount;
  String? debitBranchCode;
  String? targetBankCode;
  String? targetBankName;
  String? targetAccountNumber;
  String? ibftReference;
  String? description;
  String? currency;
  double? amount;
  String? adminFee;

  Request(
      {this.referenceNumber,
        this.debitAccount,
        this.debitBranchCode,
        this.targetBankCode,
        this.targetBankName,
        this.targetAccountNumber,
        this.ibftReference,
        this.description,
        this.currency,
        this.amount,
        this.adminFee});

  Request.fromJson(Map<String, dynamic> json) {
    referenceNumber = json['referenceNumber'];
    debitAccount = json['debitAccount'];
    debitBranchCode = json['debitBranchCode'];
    targetBankCode = json['targetBankCode'];
    targetBankName = json['targetBankName'];
    targetAccountNumber = json['targetAccountNumber'];
    ibftReference = json['ibftReference'];
    description = json['description'];
    currency = json['currency'];
    amount = json['amount'];
    adminFee = json['adminFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referenceNumber'] = referenceNumber;
    data['debitAccount'] = debitAccount;
    data['debitBranchCode'] = debitBranchCode;
    data['targetBankCode'] = targetBankCode;
    data['targetBankName'] = targetBankName;
    data['targetAccountNumber'] = targetAccountNumber;
    data['ibftReference'] = ibftReference;
    data['description'] = description;
    data['currency'] = currency;
    data['amount'] = amount;
    data['adminFee'] = adminFee;
    return data;
  }
}

class Response {
  String? responseCode;
  String? referenceNumber;
  String? debitAccount;
  String? debitAccountName;
  String? creditAccount;
  double? amount;
  int? adminFee;
  String? transReference;
  String? coreReference;
  String? debitBranchCode;
  double? debitAvailBalance;
  String? debitNarrative;
  String? arNumber;

  Response(
      {this.responseCode,
        this.referenceNumber,
        this.debitAccount,
        this.debitAccountName,
        this.creditAccount,
        this.amount,
        this.adminFee,
        this.transReference,
        this.coreReference,
        this.debitBranchCode,
        this.debitAvailBalance,
        this.debitNarrative,
        this.arNumber});

  Response.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    referenceNumber = json['referenceNumber'];
    debitAccount = json['debitAccount'];
    debitAccountName = json['debitAccountName'];
    creditAccount = json['creditAccount'];
    amount = json['amount'];
    adminFee = json['adminFee'];
    transReference = json['transReference'];
    coreReference = json['coreReference'];
    debitBranchCode = json['debitBranchCode'];
    debitAvailBalance = json['debitAvailBalance'];
    debitNarrative = json['debitNarrative'];
    arNumber = json['arNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['referenceNumber'] = referenceNumber;
    data['debitAccount'] = debitAccount;
    data['debitAccountName'] = debitAccountName;
    data['creditAccount'] = creditAccount;
    data['amount'] = amount;
    data['adminFee'] = adminFee;
    data['transReference'] = transReference;
    data['coreReference'] = coreReference;
    data['debitBranchCode'] = debitBranchCode;
    data['debitAvailBalance'] = debitAvailBalance;
    data['debitNarrative'] = debitNarrative;
    data['arNumber'] = arNumber;
    return data;
  }
}