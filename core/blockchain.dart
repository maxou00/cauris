
import 'dart:convert';

import 'block.dart';

abstract class BlockChainProps {

  ///Generates the Genesis Block 
  Block generateGenesisBlock();

  ///Generates a new Blockchain with the genesis block inserted
  List<Block> chainWithGenesis();

  ///Adds a new block to the chain 
  void addBlock(String data);

  bool isBlockValid(Block b);
}

class BlockChain implements BlockChainProps{
  List<Block> chain ;

  BlockChain(){
    chain= this.chainWithGenesis();
  }

  @override
  Block<String> generateGenesisBlock() {
    return Block(index: 0,timestamp:DateTime.now().millisecondsSinceEpoch,data: "{}",previousHash: "0");
  }

  @override
  List<Block<String>> chainWithGenesis() {
    return [this.generateGenesisBlock()];
  }

  @override
  bool isBlockValid(Block<String> newBlock) {
    Block previous = chain.last;

    if(newBlock.previousHash != previous.hash){
      return false;
    }
    if(previous.index+1 != newBlock.index){
      return false;
    }
    if(newBlock.hash != newBlock.generateHash()){
      return false;
    }
    return true;
  }


  @override
  void addBlock(String data) {

    Block b = Block(
      data: data,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      index: chain.length,
      previousHash: chain.last.hash
    );

    if(isBlockValid(b)){
      chain.add(b);
    }
  }

  String toJson(){
    return jsonEncode(this.chain);
  }
}