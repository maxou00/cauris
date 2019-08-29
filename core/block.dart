import 'package:crypto/crypto.dart';
import 'dart:convert';

class Transaction{
  String txnID;
  String wallet;
  double amount;

  Transaction({this.txnID,this.wallet,this.amount});

  factory Transaction.fromMap(Map<String,dynamic> map){
    return Transaction(
      txnID: map['txnID'],
      wallet: map['wallet'],
      amount: double.tryParse("${map['amount']}")
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'txnID':this.txnID,
      'wallet':this.wallet,
      'amount':this.amount
    };
  }

  String toJson(){
    return jsonEncode(this.toMap());
  }
}

abstract class BlockProps{
  ///Generates the hash of the current block based on the previous hash
  String generateHash(); 
}

class Block implements BlockProps {
  int index;
  int timestamp;
  List<Transaction> data;
  String hash;
  String previousHash;
  String nonce;

  Block({this.index,this.timestamp,this.data,this.previousHash,this.nonce}){
    this.hash = generateHash();
  }

  @override
  String generateHash() {
    var toHash={
      'index':this.index,
      'nonce':this.nonce,
      'previousHash':this.previousHash,
      'timestamp':this.timestamp,
      'transactions':jsonEncode(this.data.map((trans)=>trans.toJson()).toList())
    };
    var encrypted = sha256.convert(utf8.encode(jsonEncode(toHash)));
    return encrypted.toString();
  }

  Map<String,dynamic> toMap(){
    return {
      'hash':hash,
      'index':index,
      'nonce':this.nonce,
      'previousHash':previousHash,
      'timestamp':timestamp,
      'transactions':data.map((trans)=>trans.toMap()).toList(),
    };
  }

  String toJson(){
    return json.encode(this.toMap());
  }
}