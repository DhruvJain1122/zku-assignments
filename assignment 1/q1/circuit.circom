pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/mimcsponge.circom";
template HashLeftRight() {
    signal input left;
    signal input right;
    signal output hash;

    component hasher = MiMCSponge(2,220, 1);
    hasher.ins[0] <== left;
    hasher.ins[1] <== right;
    hasher.k <== 0;
    hash <== hasher.outs[0];
}
template MerkleTree(num_leaves) {  

   // Declaration of signals.  
   var num_hash = num_leaves - 1;
   var num_first_hash = num_leaves/2;
   signal input leaves[num_leaves];  
   signal output root;
   component hash[num_hash];
   for(var i = 0;i < num_hash;i++){
      hash[i] = HashLeftRight();
   }
   for(var i = 0;i < num_first_hash;i++){
      hash[i].left <== leaves[i*2];
      hash[i].right <== leaves[i*2 +1];
   }

   var a = 0;
   for(var i = num_first_hash;i < num_hash;i++){
         hash[i].left <== hash[a*2].hash;
         hash[i].right <== hash[a*2 +1].hash;
         a++;
   }
   
   root <== hash[num_hash-1].hash;
}

component main {public [leaves]} = MerkleTree(16);
