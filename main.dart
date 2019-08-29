import 'dart:io';

import 'core/blockchain.dart';
import 'server/cauris_server.dart';

void main(List<String> args) {
  
  var address = InternetAddress.anyIPv4;
  const port = 2600;
  print("------------------------Creating BlockChain---------------------------");
  BlockChain chain = BlockChain();
  CaurisServer server = CaurisServer(blockChain: chain);
  print("------------------------Starting Server on ${address.host} $port---------------------------------------");
  server.serve(address,port);

}