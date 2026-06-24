 (* parte libreria di dichiarazioni *)
 
 Enc[key_, x_] := Mod[x + key, 26];
 Dec[key_, y_] := Mod[y - key, 26];
 AlphaTest[x_]:=97<=x<=122
 ToCode[text_]:=Select[ToCharacterCode[ToLowerCase[text]],AlphaTest]-97;
 MessageEncryption[key_,textcode_]:=Map[ Enc[key,#]&, textcode];

ITA=Import["http://www.corriere.it"];
dita=AlphaDistribution[ToCode[ITA]];

AlphaDistribution[text_]:=Map[N[Count[text,#]]&,Range[0,25]]/Length[text];
CoincidenceIndex[distribution_]:=Apply[Plus,distribution^2];
MutualCoincidenceIndex[distribution1_,distribution2_]:=Apply[Plus,distribution1  distribution2];

(* esecuzione del programma *)

msg=Import["http://www.repubblica.it"];
Export["histo-ciphertext.png",Histogram[Y,26,"Probability"],"PNG"];
Export["histo-plaintext.png",Histogram[ToCode[ITA],26,"Probability"],"PNG"];
X=ToCode[msg];
Y=MessageEncryption[21,X];
dctx=AlphaDistribution[Y];
argmaxctx=Position[dctx,Max[dctx]][[1,1]]-1;
argmaxITA=Position[dita,Max[dita]][[1,1]]-1;
keyguess= k /. Solve[argmaxctx==k+argmaxITA,k,Modulus->26][[1]];
test=Table[MutualCoincidenceIndex[dita,RotateLeft[dctx,k]],{k,0,25}];
Export["mutual-coincidence.png",ListLinePlot[test,PlotRange->All], "PNG"];