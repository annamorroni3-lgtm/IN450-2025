# Progetti di crittoanalisi in Wolfram Mathematica
## Classificazione A, B e A*

**Ambiente di lavoro:** Wolfram Mathematica, in un notebook autonomo e riproducibile, e/o file .wl "di libreria".

## Convenzione della classificazione

- **A — progetto chiuso e riproducibile.**  
  Implementazione di una primitiva parametrica a round ridotto, costruzione delle tabelle o delle strutture necessarie all’attacco, verifica sperimentale e recupero di una porzione limitata della sottochiave quando previsto.

- **B — progetto avanzato.**  
  Richiede una componente aggiuntiva di modellazione, ricerca automatica, filtraggio statistico, boomerang, meet-in-the-middle, analisi related-key o confronto sistematico fra classi di chiavi. Rimane però realizzabile integralmente in Mathematica su parametri ridotti.

- **A* — progetto con profilo da tesi.**  
  Oltre alla riproduzione di una versione ridotta dell’attacco, richiede un’estensione ben delimitata: confronto fra modelli, nuova euristica, automazione di una fase, studio sperimentale di parametri, o adattamento dell’attacco a una variante della primitiva. La classificazione **A*** non implica che il problema sia già una tesi definita, ma che può costituire una base adeguata per proporla.

## Requisiti comuni del notebook

Ogni progetto deve contenere:

1. implementazione verificata della primitiva, con numero di round parametrico;
2. test di cifratura/decifratura o di permutazione, con vettori di prova quando disponibili;
3. implementazione esplicita del distinguisher o dell’attacco su parametri ridotti;
4. verifica sperimentale: probabilità, correlazioni, conteggi, ranking di sottochiavi, tempi o gradi polinomiali;
5. una sezione conclusiva che confronti l’esperimento con l’affermazione teorica del lavoro di riferimento;
6. codice interamente eseguibile in Mathematica, senza dipendenze necessarie da SageMath, CLAASP, OR-Tools o PySAT.

---

# Classe A — Progetti chiusi e riproducibili

## A1. LELBC: caratteristica differenziale e recupero parziale di chiave
**Riferimento:** [Differential Cryptanalysis of a Lightweight Block Cipher LELBC, IACR ePrint 2024/448](https://eprint.iacr.org/2024/448)

**Risultato del lavoro.** L’articolo studia LELBC, cifrario lightweight per dispositivi IoT, e riporta una caratteristica differenziale di 9 round nel modello single-key e una di 12 round nel modello related-key.

**Tipo di progetto.** Implementazione di LELBC, costruzione della DDT dell’S-box, propagazione di differenze su 5–7 round, verifica empirica della probabilità della caratteristica e recupero di alcuni bit o nibble della sottochiave dell’ultimo round.

**Strumenti Mathematica.** Liste e associazioni per DDT, operazioni bitwise, enumerazione controllata, grafici logaritmici di frequenza.

---

## A2. BAKSHEESH: crittoanalisi integrale ridotta
**Riferimento:** [Cryptanalysis of BAKSHEESH Block Cipher, IACR ePrint 2024/1926](https://eprint.iacr.org/2024/1926)

**Risultato del lavoro.** Il lavoro propone, tra gli altri risultati, attacchi integrali pratici a 9–10 round, oltre a risultati differenziali e lineari a più round.

**Tipo di progetto.** Implementazione del cifrario e di una struttura integrale su 5–8 round. Verifica delle proprietà di bilanciamento e uso della somma XOR per filtrare candidati di sottochiave.

**Strumenti Mathematica.** Tabelle di strutture di plaintext, `BitXor`, aggregazioni per posizione di stato, visualizzazione del bilanciamento.

---

## A3. PRESENT: crittoanalisi lineare e trasformata di Walsh
**Riferimento:** [Improved Linear Key Recovery Attacks on PRESENT, IACR ePrint 2024/113](https://eprint.iacr.org/2024/113)

**Risultato del lavoro.** Il lavoro migliora gli attacchi lineari su PRESENT-80 e PRESENT-128 fino a 29 round tramite affine pruned Walsh transform e analisi statistica delle correlazioni.

**Tipo di progetto.** Costruzione della LAT dell’S-box di PRESENT, calcolo dello spettro di Walsh, selezione di approssimazioni lineari su 7–10 round e ranking di candidati per una sottochiave finale ridotta.

**Strumenti Mathematica.** `HadamardMatrix` o implementazione della trasformata di Walsh-Hadamard, matrici intere, ordinamenti statistici, istogrammi delle correlazioni.

---

## A4. GIFT-64: differenziali impossibili mediante representative sets
**Riferimento:** [Greedy Algorithm for Representative Sets: Applications to IVLBC and GIFT-64 in Impossible Differential Attack, IACR ePrint 2024/2054](https://eprint.iacr.org/2024/2054)

**Risultato del lavoro.** Il lavoro propone un algoritmo greedy per costruire representative sets e partition tables; lo applica a IVLBC e GIFT-64, trovando differenziali impossibili a 6 round.

**Tipo di progetto.** Implementazione del representative set dell’S-box a 4 bit, costruzione di partition tables e ricerca/verifica di un differenziale impossibile su 4–6 round di GIFT-64. Estensione opzionale con filtraggio di una sottochiave.

**Strumenti Mathematica.** Algoritmi greedy su insiemi, tabelle di copertura, matrici booleane, enumerazione delle differenze.

---

## A5. TWINE o WARP: distinguisher differenziale-lineare
**Riferimento:** [Revisiting Differential-Linear Attacks via a Boomerang Perspective With Application to AES, Ascon, CLEFIA, SKINNY, PRESENT, KNOT, TWINE, WARP, LBlock, Simeck, and SERPENT, IACR ePrint 2024/255](https://eprint.iacr.org/2024/255)

**Risultato del lavoro.** Il lavoro sviluppa un quadro automatico per distinguisher differenziale-lineari, tenendo conto della dipendenza fra parte differenziale e parte lineare, e lo applica a molte primitive, incluse TWINE e WARP.

**Tipo di progetto.** Implementazione di TWINE oppure WARP; calcolo di DDT, LAT e una versione ridotta delle tabelle differenziale-lineari; verifica empirica di un distinguisher su 5–8 round.

**Strumenti Mathematica.** DDT/LAT, prodotti matriciali, campionamento casuale riproducibile, stima di bias e intervalli di confidenza.

---

## A6. SIMON-32/64 o Simeck-32/64: differenziale impossibile
**Riferimento:** [Finding Complete Impossible Differential Attacks on AndRX Ciphers and Application to SIMON, SPECK, Simeck, ChaCha, Chaskey, LEA and SipHash, IACR ePrint 2024/1359](https://eprint.iacr.org/2024/1359)

**Risultato del lavoro.** L’articolo integra ricerca del distinguisher e costruzione del key recovery per cifrari AndRX, ottenendo nuovi o migliori risultati su varie primitive, incluse SIMON e Simeck.

**Tipo di progetto.** Implementazione di SIMON-32/64 o Simeck-32/64; ricerca per enumerazione guidata di un differenziale impossibile su 4–6 round; impiego del distinguisher come filtro per un piccolo spazio di sottochiavi.

**Strumenti Mathematica.** Operazioni AND, rotazioni e XOR, backtracking, `SatisfiabilityInstances` su formule ridotte, tabelle di eliminazione.

---

# Classe B — Progetti avanzati

## B1. ARADI: analisi automatica di distinguisher
**Riferimento:** [CLAASPing ARADI: Automated Analysis of the ARADI Block Cipher, IACR ePrint 2024/1324](https://eprint.iacr.org/2024/1324)

**Risultato del lavoro.** L’articolo analizza ARADI con CLAASP e presenta distinguisher differenziali, lineari, impossibili e algebrici fino a 9 dei 16 round.

**Tipo di progetto.** Implementazione parametrica della round function di ARADI e riproduzione di un solo filone: distinguisher differenziale, lineare oppure impossibile su 3–6 round. La parte automatica di CLAASP non viene replicata integralmente; viene sostituita da una ricerca esplicita in Mathematica.

**Strumenti Mathematica.** Operazioni bitwise, propagazione di maschere, ricerca euristica, tabelle delle transizioni.

---

## B2. ARADI: ZeroSum e Fast Hadamard Transform
**Riferimento:** [Improved Key-recovery Attacks on ARADI, IACR ePrint 2025/1227](https://eprint.iacr.org/2025/1227)

**Risultato del lavoro.** Il lavoro migliora il key recovery fino a 12 dei 16 round di ARADI sfruttando distinguisher ZeroSum, Fast Hadamard Transform e la diffusione debole del layer lineare.

**Tipo di progetto.** Costruzione di un distinguisher ZeroSum su 4–6 round e uso della trasformata di Hadamard su uno spazio ridotto di sottochiavi. Il risultato atteso è un confronto quantitativo tra enumerazione diretta e ranking accelerato.

**Strumenti Mathematica.** Trasformata di Hadamard, array sparsi, operazioni su vettori binari, benchmark temporali.

---

## B3. FUTURE: related-key differential e boomerang
**Riferimento:** [Related-Key Cryptanalysis of FUTURE, IACR ePrint 2024/1614](https://eprint.iacr.org/2024/1614)

**Risultato del lavoro.** Il lavoro presenta un distinguisher related-key a 8 round, un distinguisher boomerang full-round e un key recovery full-round nel modello related-key.

**Tipo di progetto.** Implementazione di FUTURE e della sua matrice MDS; fissazione di differenze di chiave controllate; verifica di un differenziale related-key o di un boomerang su 4–6 round.

**Strumenti Mathematica.** Algebra lineare su campi finiti, aritmetica di byte/nibble, generazione di quartetti boomerang, stima sperimentale delle probabilità.

---

## B4. GIFT: weak-key differential cryptanalysis
**Riferimento:** [Quasidifferential Saves Infeasible Differential: Improved Weak-Key Key-Recovery Attacks on Round-Reduced GIFT, IACR ePrint 2025/1031](https://eprint.iacr.org/2025/1031)

**Risultato del lavoro.** Il lavoro mostra che alcune caratteristiche differenziali di GIFT possono avere probabilità sensibilmente più alta sotto condizioni weak-key. Per GIFT-64 migliora una caratteristica di 13 round imponendo quattro condizioni di chiave.

**Tipo di progetto.** Confronto empirico della probabilità di una stessa caratteristica su chiavi casuali e su una famiglia di chiavi soggette a condizioni lineari. Il notebook deve quantificare l’effetto delle condizioni di chiave su un numero ridotto di round.

**Strumenti Mathematica.** Campionamento condizionato, algebra binaria, test statistici, grafici comparativi delle probabilità.

---

## B5. GIFT-64 o SKINNY-64: probabilità nel fixed-key model
**Riferimento:** [Related-Key Differential and Boomerang Cryptanalysis in the Fixed-Key Model, IACR ePrint 2025/402](https://eprint.iacr.org/2025/402)

**Risultato del lavoro.** Il lavoro estende le tecniche quasidifferential al contesto related-key e boomerang, mostrando che una probabilità media può nascondere forti variazioni tra sottoinsiemi di chiavi.

**Tipo di progetto.** Generazione di coppie o quartetti per GIFT-64 oppure SKINNY-64; stima della probabilità dello stesso distinguisher su molte chiavi; confronto tra media globale, distribuzione delle probabilità e casi di impossibilità.

**Strumenti Mathematica.** Simulazione Monte Carlo, clustering di chiavi per proprietà lineari, distribuzioni empiriche, test di ipotesi.

---

## B6. SAND-128: differenziali impossibili su AND-RX
**Riferimento:** [Impossible Differential Attack on SAND-128, IACR ePrint 2025/677](https://eprint.iacr.org/2025/677)

**Risultato del lavoro.** Il lavoro individua molti distinguisher impossibili a 14 round e costruisce un key recovery a 21 round sul cifrario lightweight AND-RX SAND-128.

**Tipo di progetto.** Implementazione della struttura AND-RX e ricerca di un differenziale impossibile su 5–7 round. L’attacco completo viene sostituito da un filtro di sottochiavi a dimensione controllata.

**Strumenti Mathematica.** Propagazione bitwise di vincoli, ricerca in avanti/all’indietro, algebra booleana, rappresentazioni sparse.

---

## B7. SPECK32/64: boomerang e programmazione dinamica
**Riferimento:** [SAT-aided Automatic Search of Boomerang Distinguishers for ARX Ciphers, IACR ePrint 2023/202](https://eprint.iacr.org/2023/202)

**Risultato del lavoro.** L’articolo sviluppa algoritmi di programmazione dinamica e modelli SAT per la ricerca di boomerang distinguers su cifrari ARX e ottiene risultati, tra gli altri, su SPECK32/64.

**Tipo di progetto.** Implementazione di SPECK32/64; costruzione della versione ridotta della boomerang connectivity analysis dell’addizione modulare; ricerca e verifica empirica di un boomerang su 4–6 round.

**Strumenti Mathematica.** Programmazione dinamica con memoization, operazioni modulari, tabelle di carry, eventuale uso di `SatisfiabilityInstances` su word size ridotte.

---

## B8. SKINNY: differential meet-in-the-middle
**Riferimento:** [Revisiting the Differential Meet-In-The-Middle Cryptanalysis, IACR ePrint 2023/1302](https://eprint.iacr.org/2023/1302)

**Risultato del lavoro.** Il lavoro riesamina il differential meet-in-the-middle e propone varianti applicate a SKINNY-128-384 e AES-256.

**Tipo di progetto.** Adattamento a SKINNY-64 con 4–6 round: propagazione forward/backward, costruzione di una tabella di match e confronto tra meet-in-the-middle classico e versione differenziale ridotta.

**Strumenti Mathematica.** Associazioni/hash map, enumerazione delle sottochiavi, rappresentazioni compatte dello stato, misure di tempo e memoria.

---

# Classe A* — Progetti con profilo da tesi

## A*1. Poseidon e Poseidon2: preimage CICO con risultanti
**Riferimento:** [Claiming bounties on small scale Poseidon and Poseidon2 instances using resultant-based algebraic attacks, IACR ePrint 2026/150](https://eprint.iacr.org/2026/150)

**Risultato del lavoro.** Il lavoro risolve challenge CICO su istanze small-scale di Poseidon e Poseidon2 mediante un attacco algebrico basato su eliminazione di variabili con risultanti.

**Tipo di progetto.** Implementazione di una permutazione Poseidon/Poseidon2 toy su un piccolo campo primo; traduzione di un problema CICO in un sistema polinomiale; eliminazione di variabili con `Resultant`; ricostruzione e verifica di una preimage. Possibile estensione: confronto tra ordine di eliminazione, numero di round, ampiezza dello stato e gradi dei polinomi.

**Strumenti Mathematica.** `Resultant`, `GroebnerBasis`, `Eliminate`, aritmetica modulare e polinomi su campi finiti.

**Nota di sicurezza.** Il progetto riguarda esplicitamente istanze ridotte/challenge; non costituisce un attacco alle parametrizzazioni standard di Poseidon o Poseidon2.

---

## A*2. Ascon: preimage e collisioni con modellazione algebrica
**Riferimento:** [Preimage and Collision Attacks on Reduced Ascon Using Algebraic Strategies, IACR ePrint 2023/1453](https://eprint.iacr.org/2023/1453)

**Risultato del lavoro.** Il lavoro studia preimage attacks su Ascon-XOF ridotto e collisioni free-start su Ascon-HASH ridotto mediante modellazione algebrica, linearizzazione e strategie di guessing.

**Tipo di progetto.** Costruzione di una versione a 1–3 round della permutazione; formulazione del sistema booleano/polinomiale per una preimage troncata o collisione; confronto fra linearizzazione, Gröbner basis e guessing di un piccolo insieme di variabili.

**Strumenti Mathematica.** Polinomi booleani, `GroebnerBasis`, `Solve`/`Reduce` su istanze piccole, sperimentazione con ordine monomiale e variabili eliminate.

---

## A*3. Ascon: cube attacks e recupero di superpolinomi
**Riferimento:** [Improved Key Recovery Attacks of Ascon, IACR ePrint 2025/1029](https://eprint.iacr.org/2025/1029)

**Risultato del lavoro.** Il lavoro migliora il recupero di chiave su Ascon ridotto con cube attacks e recupero di superpolinomi, senza compromettere la sicurezza delle 12 round complete.

**Tipo di progetto.** Scelta di cubi di dimensione contenuta, calcolo delle cube sums, ricostruzione di un superpolinomio con trasformata di Möbius e risoluzione delle equazioni risultanti per pochi bit di chiave. Possibile estensione: euristiche di scelta dei cubi o confronto fra 3, 4 e 5 round.

**Strumenti Mathematica.** Trasformata di Möbius implementata su array binari, ANF, operazioni GF(2), ricerca combinatoria.

---

## A*4. Ascon: conditional cube attack con strategia break-fix
**Riferimento:** [Improved Conditional Cube Attacks on Ascon AEADs in Nonce-Respecting Settings -- with a Break-Fix Strategy, IACR ePrint 2024/743](https://eprint.iacr.org/2024/743)

**Risultato del lavoro.** Il lavoro propone una strategia break-fix per conditional cube attacks su Ascon ridotto, con condizioni di chiave che ripristinano il grado atteso.

**Tipo di progetto.** Implementazione di una versione toy della strategia break-fix: scelta di un cubo, misura sperimentale del grado/algebraic normal form di output selezionati, imposizione e verifica di condizioni di chiave che modificano il comportamento del cubo.

**Strumenti Mathematica.** ANF, Möbius transform, sistemi lineari su GF(2), ricerca di condizioni simboliche e sperimentazione su chiavi.

---

## A*5. AndRX: modello automatico per differential meet-in-the-middle
**Riferimento:** [An Automated Model to Search For Differential Meet-In-The-Middle Attacks: Applications to AndRX Ciphers, IACR ePrint 2025/1249](https://eprint.iacr.org/2025/1249)

**Risultato del lavoro.** Il lavoro propone un modello di constraint programming per trovare differential meet-in-the-middle attacks su cifrari AndRX, con applicazioni a SIMON e Simeck.

**Tipo di progetto.** Realizzazione in Mathematica di un modello ridotto per SIMON-32/64 o Simeck-32/64: ricerca di trail differenziali forward/backward, scelta automatica del matching state e valutazione della complessità. Possibile estensione: euristica di pruning o confronto tra differenti punti di incontro.

**Strumenti Mathematica.** `SatisfiabilityInstances`, trasformazione in CNF su word size piccole, ricerca branch-and-bound, tabelle di transizione.

---

## A*6. Ricerca automatica di attacchi integrali, ID e zero-correlation
**Riferimento:** [Improved Search for Integral, Impossible-Differential and Zero-Correlation Attacks: Application to Ascon, ForkSKINNY, SKINNY, MANTIS, PRESENT and QARMAv2, IACR ePrint 2023/1701](https://eprint.iacr.org/2023/1701)

**Risultato del lavoro.** Il lavoro propone modelli CP migliorati, anche bitwise, per distinguisher integrali, impossibili e zero-correlation; include applicazioni ad Ascon, SKINNY, ForkSKINNY, PRESENT e QARMAv2.

**Tipo di progetto.** Costruzione di un framework Mathematica parametrico per una classe di distinguisher, applicato inizialmente a PRESENT o SKINNY a round ridotti. Possibile estensione: confronto fra modello cell-wise e bit-wise, oppure automazione del partial-sum filtering.

**Strumenti Mathematica.** Formule booleane, `SatisfiabilityInstances`, `BooleanConvert`, grafi di dipendenza, generazione automatica di vincoli.

---

# Riepilogo numerico

| Classe | Numero di progetti | Tecniche principali |
|---|---:|---|
| A | 6 | differenziale, integrale, lineare, impossibile, differenziale-lineare |
| B | 8 | ZeroSum/FHT, related-key, weak-key, boomerang, fixed-key, MITM |
| A* | 6 | crittoanalisi algebrica, risultanti, Gröbner basis, cube attacks, modelli automatici |

## Indicazione operativa per la classificazione A*

Un progetto A* deve essere presentato con una breve proposta iniziale che identifichi:

- la riproduzione ridotta che costituisce la baseline;
- l’estensione proposta e la ragione tecnica della scelta;
- la metrica di confronto: round raggiunti, tempo, memoria, grado dei polinomi, dati richiesti, probabilità/correlazione o numero di candidati eliminati;
- la parte che resta pienamente eseguibile in Wolfram Mathematica;
- un rischio tecnico esplicito e un piano alternativo sperimentale.

