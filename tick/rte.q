// Real Time Engine
// Create a file rte.q which creates a new q process on another free port
// The RTE process should load schema.q.
// The process should open a connection and subscribe to the TP process for both Trade and Quote tables.
// When a message is received, the process should upsert the new information to the appropriate table.
// Update the logic within this process to create new tables called lastTrade and lastQuote, 
// which should store the last record for each Trade/Quote table by each symbol.


/q tick/rte.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]



if[not "w"=first string .z.o;
    system "sleep 1"];

upd:{[t;x]
        if[0=type x; x: flip(cols get t)!x;];
        t insert x;
        (`$"last",@[string t;0;upper]) upsert `sym xkey x;
    };

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{
    t:tables`.;
    t@:where `g=attr each t@\:`sym;
    // .Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
    @[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{
    (.[;();:;].)each x;
    if[null first y;:()];
    -11!y;
    // system "cd ",1_-10_string first reverse y
    };
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

lastTrade: select by sym from trade ;
lastQuote: select by sym from quote ;