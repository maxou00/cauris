import 'package:crypto/crypto.dart';
import 'dart:convert';


abstract class BlockProps{
  ///Generates the hash of the current block based on the previous hash
  String generateHash(); 
}

class Block<T extends String > implements BlockProps {
  int index;
  int timestamp;
  T data;
  String hash;
  String previousHash;

  Block({this.index,this.timestamp,this.data,this.previousHash}){
    this.hash = generateHash();
  }

  @override
  String generateHash() {
    String str = '$index$previousHash$timestamp$data';
    var encrypted = sha256.convert(utf8.encode(this.data));
    return encrypted.toString();
  }


  Map<String,dynamic> toMap(){
    return {
      'index':index,
      'timestamp':timestamp,
      'previousHash':previousHash,
      'hash':hash,
      'data':data,
    };
  }

  String toJson(){
    return json.encode(this.toMap());
  }
}