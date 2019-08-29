
import 'dart:convert';
import 'dart:io';

import '../core/block.dart';
import '../core/blockchain.dart';

abstract class CaurisServerProps{

  void handleNewBlock(HttpRequest request);
  void getLastBlock(HttpRequest request);
  void getPeers(HttpRequest request);
  void submitTransaction(HttpRequest request);
}

class CaurisServer  implements CaurisServerProps {
  BlockChain blockChain;

  CaurisServer({this.blockChain});

  serve(InternetAddress address,int port){
    HttpServer.bind(address, port)
    .then((HttpServer server){
      server.listen(handleRequest);
    });
  }


  handleRequest(HttpRequest request){
    ///Keep Track of the peers that have contacted us;
    blockChain.addPeer(request.headers.host);

    request.response.headers.contentType=ContentType('application','json',charset: 'utf-8');

    List<String> segments = request.requestedUri.pathSegments;
    if(segments.length<=0){
      getLastBlock(request);
    }

    switch(segments[0]){
      case "new_block":{
        handleNewBlock(request);
        break;
      }
      case "last_block":{
        getLastBlock(request);
        break;
      }
      case "get_peers":{
        getPeers(request);
        break;
      }
      case "submit_transaction":{
        submitTransaction(request);
        break;
      }
      default:{
        getLastBlock(request);
        break;
      }
    }
  }

  @override
  void getLastBlock(HttpRequest request)async{
    request.response.write(blockChain.last.toJson());
    request.response.close();
  }

  @override
  void getPeers(HttpRequest request)async{
    request.response.write(jsonEncode(blockChain.peers.toList()));
    request.response.close();
  }

  @override
  void handleNewBlock(HttpRequest request)async{
    blockChain.newBlock('');
    request.response.write(jsonEncode("{\'success\':\'true\'}"));
    request.response.close();
  }

  @override
  void submitTransaction(HttpRequest request)async{
    var dat = await Utf8Decoder().bind(request).join();
    Map<String,dynamic> map = jsonDecode(dat);
    Transaction trans = Transaction.fromMap(map);
    blockChain.addTransaction(trans);
    request.response.write(jsonEncode("{\'success\':\'true\'}"));
    request.response.close();
  }
}