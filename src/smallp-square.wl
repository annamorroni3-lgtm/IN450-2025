(* =========================
   small-p-square (functional)
   no For/Do: Nest / Fold only
   ========================= *)

ClearAll[
  MakeSparseParams, RoundFn, InitFn,
  ApplyRoundsNest, ApplyRoundsFold,
  OutputFn, SmallPSquareEvalNest, SmallPSquareEvalFold,
  KeyScheduleConst, KeyScheduleWithRoundKeys
];

(* Params container: sparse linear forms + bias *)
MakeSparseParams[n_Integer, neigh_List, coeffs_List, bias_List] := Association[
  "n" -> n,
  "neigh" -> neigh,
  "coeffs" -> coeffs,
  "bias" -> bias
];

(* One-round function generator: returns (S -> T) *)
RoundFn[p_Integer, params_Association] := Module[
  { n = params["n"], 
    neigh = params["neigh"], 
    coeffs = params["coeffs"], 
    bias = params["bias"]
    },
  Function[{S},
    Mod[
      MapIndexed[
        Function[{dummy, idx},
          Module[{i = idx[[1]], L},
            L = bias[[i]] + Total[coeffs[[i]] * S[[neigh[[i]]]]];
            L*L
          ]
        ],
        ConstantArray[0, n]
      ],
      p
    ]
  ]
];

(* Init function generator: returns (K,V -> S0) without loops *)
InitFn[p_Integer, n_Integer] := Function[{K, V},
  Module[{k = Length[K], m = Length[V], S},
    If[k + m > n, Throw["KeyLength + IVLength must be <= n"]];
    S = Join[Mod[K, p], Mod[V, p], ConstantArray[0, n - k - m]];
    S
  ]
];

(* Apply R identical rounds using Nest *)
ApplyRoundsNest[round_Function, S0_List, R_Integer] := Nest[round, S0, R];

(* Apply a list of round-functions using Fold *)
ApplyRoundsFold[roundFns_List, S0_List] := Fold[#2[#1] &, S0, roundFns];

(* Output function generator: returns (S -> z) *)
OutputFn[p_Integer, outIdx_List, outCoeff_List] := Module[{},
  If[Length[outIdx] =!= Length[outCoeff], Throw["outIdx and outCoeff lengths differ"]];
  Function[{S}, Mod[Total[outCoeff * S[[outIdx]]], p]]
];

(* Keyschedule: constant rounds (all identical) => list of same function, or just use Nest *)
KeyScheduleConst[round_Function, R_Integer] := ConstantArray[round, R];

(* Keyschedule with explicit round keys: each round has its own bias vector (or similar)
   Here: roundKeys is a list of bias-vectors; we inject it into params and build one round-fn per round.
*)
KeyScheduleWithRoundKeys[p_Integer, params_Association, roundBiases_List] := Module[
  {base = params, mk},
  mk[bias_] := RoundFn[p, AssociateTo[Association[base], "bias" -> bias]];
  mk /@ roundBiases
];

(* Full eval with Nest: init-mixing with Nest, then stream rounds with Nest *)
SmallPSquareEvalNest[
  K_List, V_List, p_Integer,
  params_Association,
  Rinit_Integer, R_Integer,
  outIdx_List, outCoeff_List
] := Module[{round = RoundFn[p, params], init = InitFn[p, params["n"]], out = OutputFn[p, outIdx, outCoeff], S0, S1, S2},
  S0 = init[K, V];
  S1 = Nest[round, S0, Rinit];
  S2 = Nest[round, S1, R];
  out[S2]
];

(* Full eval with Fold + keyschedule: init-mixing with Fold, then stream with Fold *)
SmallPSquareEvalFold[
  K_List, V_List, p_Integer,
  roundFnsInit_List, roundFnsMain_List,
  n_Integer,
  outIdx_List, outCoeff_List
] := Module[{init = InitFn[p, n], out = OutputFn[p, outIdx, outCoeff], S0, S1, S2},
  S0 = init[K, V];
  S1 = ApplyRoundsFold[roundFnsInit, S0];
  S2 = ApplyRoundsFold[roundFnsMain, S1];
  out[S2]
];

(* =========================
   Example usage
   ========================= *)

p = 5;
n = 16;
Rinit = 10;
R = 20;

neigh = Table[Mod[{i, i + 1, i + 2} - 1, n] + 1, {i, 1, n}];
coeffs = Table[{1, 2, 3}, {i, 1, n}];
bias = Table[1, {i, 1, n}];

params = MakeSparseParams[n, neigh, coeffs, bias];

outIdx = {1, 4, 7, 10, 13, 16};
outCoeff = {1, 1, 2, 3, 4, 1};

K = Range[6];
V = {4, 0, 1, 3};

(* Versione Nest (round costante) *)
zNest = SmallPSquareEvalNest[K, V, p, params, Rinit, R, outIdx, outCoeff];

(* Versione Fold (keyschedule come lista di funzioni) *)
round = RoundFn[p, params];
ksInit = KeyScheduleConst[round, Rinit];
ksMain = KeyScheduleConst[round, R];

zFold = SmallPSquareEvalFold[K, V, p, ksInit, ksMain, n, outIdx, outCoeff];

{zNest, zFold}