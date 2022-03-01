
#Compile Circuits
circom circuit.circom --r1cs --wasm --sym --c

#Compute Witness
cd circuit_js
node generate_witness.js circuit.wasm ../input.json witness.wtns
cp witness.wtns ../witness.wtns
cd ..

##Trusted Cermony
#PHASE 1
snarkjs powersoftau new bn128 20 pot_0000.ptau -v
snarkjs powersoftau contribute pot_0000.ptau pot_0001.ptau --name="First contribution" -v

#PHASE 2
snarkjs powersoftau prepare phase2 pot_0001.ptau pot_final.ptau -v
snarkjs groth16 setup circuit.r1cs pot_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

#EXPORT THE VERIFICATION KEY
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json

#GENERATE PROOF
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

