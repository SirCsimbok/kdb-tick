/q tick/rdb.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]

if[not "w"=first string .z.o;
    system "sleep 1"];

upd:insert; /insert or upsert?

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{
    t:tables`.;
    t@:where `g=attr each t@\:`sym;
    .Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
    @[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{
    (.[;();:;].)each x;
    if[null first y;:()];
    // -11!y;system "cd ",(0N!)1_-10_string first reverse y
    -11!y;system "cd hdb"
    };
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
.u.rep .(0N!)(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";
