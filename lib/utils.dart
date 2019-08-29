import 'dart:math';
import 'package:crypto/crypto.dart';

class Utils {
  
  static String randomHexString(int length){
    Random random = Random.secure();
    List a = List.generate(length,(ids)=>random.nextInt(256));
    return sha256.convert(a).toString();
  }
}

