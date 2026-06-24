
AlphaTest[x_] := 97 <= x <= 122 ;
ToCode[text_] := Select[ToCharacterCode[ToLowerCase[text]], AlphaTest] - 97;
FromCode[code_] := FromCharacterCode[code + 65];

MessageEncryption[key_, textcode_] := Map[ Enc[key, #] &, textcode];
MessageDecryption[key_, ctx_] := Map[ Dec[key, #] &, ctx];  


(* let us fix a key and implicitly the blocksize *)

K = {{14, 5}, {11, 24}};
m = Length[K];

InvertibilityTest[key_] := GCD[Det[K, Modulus -> 26], 26] == 1
Print@If[InvertibilityTest[K], "invertible key", 
   "non invertible : change the key!"]; 


Enc[key_, x_] := Mod[x . key, 26];
Dec[key_, y_] := Mod[y . Inverse[key, Modulus -> 26], 26];

(* Known-Plaintext Attack *)

X = Partition[ToCode["OfJuly"], m];
Y = MessageEncryption[K, X];

(* Generate traffic *)
Traffic[] = Transpose[{X, Y}];

Print["Encrypted message: ", 
    FromCode[
        Flatten[
            Transpose[Traffic[]][[2]]
        ]
    ]
];

(* random sampling an invertible matrix of plain-texts *)
R = RandomSample[Traffic[], m];
{X, Y} = Transpose[R];
While[GCD[Det[X, Modulus -> 26], 26] != 1,
 (
  R = RandomSample[Traffic[], m];
  {X, Y} = Transpose[R];
  )]
XINV = Inverse[X, Modulus -> 26];
Print["Inverse plaintext matrix: ", XINV // MatrixForm];


Print["key guess :",
 Kg = Mod[XINV . Y, 26];
 Kg // MatrixForm]

Print["decrypted message : ",
FromCode[Flatten@MessageDecryption[Kg, Transpose[Traffic[]][[2]]]]
];

