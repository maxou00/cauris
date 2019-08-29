import 'dart:convert';
import 'package:Cauris/utils.dart';
import 'block.dart';

///The first Step of my Blockchain Mastering is to build a fully working 
///decentralized blockchain network with Proof Of Work (PoW)
///Next, I will learn other Consensus algorithm in order to reduce 
///time and energy consumption of my future crypto network

abstract class BlockChainProps {

  void addTransaction(Transaction transaction);
  ///Generates the Genesis Block 
  Block generateGenesisBlock();

  ///Generates a new Blockchain with the genesis block inserted
  List<Block> chainWithGenesis();

  ///Adds a new block containing to the chain
  void newBlock(String previousHash,{String nonce=''});

  ///Decentralization. Adds a peer to the network.
  addPeer(String host);

  void mine({Block blockToMine=null,int difficulty});

  bool isBlockValid(Block b);
}

class BlockChain implements BlockChainProps{

  List<Block> chain ;
  Set<String> peers;
  List<Transaction> pendingTransactions;

  BlockChain(){
    peers= Set();
    chain= this.chainWithGenesis();
    pendingTransactions=[];
  }

  ///Getter for the last block in the chain
  Block get last => chain.last;

  @override
  void addTransaction(Transaction transaction) {
    this.pendingTransactions.add(transaction);
  }

  @override
  Block generateGenesisBlock() {
    return Block(index: 0,timestamp:DateTime.now().millisecondsSinceEpoch,data:[],previousHash: "0");
  }

  @override
  List<Block> chainWithGenesis() {
    return [this.generateGenesisBlock()];
  }

  @override
  bool isBlockValid(Block newBlock) {
    Block previous = this.last;

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
  void newBlock(String previousHash,{String nonce=''}) {
    ///Create the block
    Block b = Block(
      data: this.pendingTransactions,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      index: chain.length,
      previousHash: chain.last.hash,
      nonce:nonce
    );
    
    ///Check the block validity
    if(isBlockValid(b)){
      ///Add it ti the chain
      chain.add(b);
      ///Free all pending transactions
      this.pendingTransactions=[];
      print("Created block ${b.index}");
      print(this.toJson());
    }
  }


  ///Checks if a hash starts with a difficulty number of 0s
  ///@see `Proof Of Work`.
  static bool isPowSufficient(String hashOfBlock,int difficulty){
    return hashOfBlock.substring(0,difficulty+1) == ('0' * difficulty);
  }

  ///Generates a 32 bytes string 
  ///@see `nonce`
  static String nonce(){
    return Utils.randomHexString(32);
  }

  ///Proof Of Work algorithm
  ///We hash the block with random string until the hash
  ///has begun with a `difficulty` number of 0
  ///@see `Proof Of Work` and `Consensus`
  void mine({Block blockToMine=null,int difficulty=4}){
    Block block = blockToMine ?? this.last;

    while (true){
      block.nonce= BlockChain.nonce();
      if(BlockChain.isPowSufficient(block.hash, difficulty)){
        print("We mined  block \n- Block Hash: ${block.hash} \n- Nonce: ${block.nonce}");
      }
    }
  }

  @override
  addPeer(String host) {
    peers.add(host);
  }

  String toJson(){
    return jsonEncode(this.chain.map((block)=>block.toJson()).toList());
  }
}