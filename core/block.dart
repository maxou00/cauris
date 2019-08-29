import 'package:crypto/crypto.dart';
import 'dart:convert';


abstract class BlockProps{
  ///Generates the hash of the current block based on the previous hash
  String generateHash(); 
}

class Block implements BlockProps {
  int index;
  int timestamp;
  List<String> data;
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
      'transactions':this.data
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
      'transactions':data,
    };
  }

  String toJson(){
    return json.encode(this.toMap());
  }
}