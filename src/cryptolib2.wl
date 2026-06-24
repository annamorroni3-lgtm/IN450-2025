AlphaTest[x_] := 97 <= x <= 122
ToCode[text_] := 
 Select[ToCharacterCode@ToLowerCase[text], AlphaTest] - 97
FromCode[code_] := FromCharacterCode[code + 65]

(* schemi di cifratura SHIFT e VIGENERE *)
ShiftDec[key_, plaintext_] := Mod[plaintext - key, 26]
MessageShiftDecrypt[key_, msg_] := Map[ShiftDec[key, #] &, msg]
VigenereEnc[key_, plaintext_] := 
 Mod[Flatten@(Map[# + key &, Partition[plaintext, Length@key]]), 26]
VigenereDec[key_, plaintext_] := 
 Mod[Flatten@(Map[# - key &, Partition[plaintext, Length@key]]), 26]

(* frequenze alfabetiche e indicatori *)
Distribution[text_] := Map[Count[text, #] &, Range[0, 25]]/Length[text]
CoincidenceIndex[text_] := Apply[Plus, Distribution[text]^2]
MutualIncidence[text1_, text2_] := 
 N@Apply[Plus, Distribution[text1]*Distribution[text2]]

(* Kasiski Test per stimare la lunghezza della chiave *)

Distances[parted_, rep_] := Flatten@Position[parted, rep]

KasiskiTest[text_, len_] := Module[{parted, reps, dd},
  parted = Partition[text, len, 1];
  reps = SortBy[Select[Tally[parted], #[[2]] == 2 &], Last];
  dd = Sort@Map[Distances[parted, #[[1]]] &, reps];
       distanze = Flatten@Map[Drop[#, 1] - Drop[#, -1] &, dd];
  Apply[GCD, distanze]
  ];

TruncatedCoincidenceIndex[text_, t_, n_] := 
 Apply[Plus, 
        Take[
            Sort@N@Distribution[
                Take[text, Min[t, Length[text]]]
                ], -n
        ]^2
      ];

TruncatedCoincidenceIndex[text_, probe_, t_, n_] := 
 Module[{probed, longtxt, f, len},
  probed = 
   Take[SortBy[Transpose@{Range[0, 25], Distribution[Take[text, probe]]},
      Last], -n];
  longtxt = Take[text, len = Min[t, Length[text]]];
    f = Map[Count[longtxt, #[[1]]] &, probed];
    N[Plus @@ (f (f - 1)/(len (len - 1)))]
  ];

ITA = ToCode@Import["http://www.corriere.it"];
IcITA = N@CoincidenceIndex[ITA];
IcITA5 = N@TruncatedCoincidenceIndex[ITA, Length[ITA], 5];
IcITA7 = N@TruncatedCoincidenceIndex[ITA, Length[ITA], 7];
IcITA10 = N@TruncatedCoincidenceIndex[ITA, Length[ITA], 10];


ENG = ToCode@Import["http://www.nytimes.com"];
IcENG = N@CoincidenceIndex[ENG];
IcENG5 = N@TruncatedCoincidenceIndex[ENG, Length[ENG], 5];
IcENG7 = N@TruncatedCoincidenceIndex[ENG, Length[ENG], 7];
IcENG10 = N@TruncatedCoincidenceIndex[ENG, Length[ENG], 10];

IcRND = N@1/26;
IcRND5 = N@5/26^2;
IcRND7 = N@7/26^2;
IcRND10 = N@10/26^2;


deng = N@Distribution[ENG];
ArgMaxFreq[dita_] := Position[dita, Max[dita]] - 1;

(* calcolo la n-esima più frequente *)
ArgMaxFreq[dita_, n_] := Position[dita, Sort[dita][[-n]]] - 1

mfITA = ArgMaxFreq[Distribution[ITA]]
mfENG = ArgMaxFreq[Distribution[ENG]];

PlotDistribution[distribution_, color_] := 
  ListLinePlot[Transpose[{Range[0, 25], distribution}],
   PlotTheme -> "Business",
   Filling -> Automatic,
   InterpolationOrder -> 2,
   PlotStyle -> color
   ];

PlotText[text_, color_] := PlotDistribution[Distribution[text], color];

itaplot = PlotText[ITA, Blue];
engplot = PlotText[ENG, Magenta];

PlotBlock[blk_][key_] := PlotText[
  Map[ShiftDec[key, #] &, blocks[[blk]]], Orange]

BestKeyITA[blk_] := Module[{dctx, sortedkeys, i, key, treshold}, (
   dctx = Transpose@{Range[0, 25], Distribution[blk]};
   sortedkeys = 
    Map[({Mod[#[[1]] - mfITA, 26], #[[2]]}) &, 
     Reverse@SortBy[dctx, Last]];
   treshold = 5/8  CoincidenceIndex[blk]; Print[N@treshold];
   i = 1;
   While[
    MutualIncidence[ITA, 
      MessageShiftDecrypt[key = sortedkeys[[i, 1]], blk]] < treshold, 
    i++];
   key
   )]