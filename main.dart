import 'core/blockchain.dart';

void main(List<String> args) {
  
  BlockChain chain = BlockChain();
  for(var i =0;i<10;i++){
    chain.addBlock("New Data : Bug bounty ${DateTime.now()} $i");
  }
  print(chain.toJson());
}