h:neg hopen `:localhost:5010 /connect to tickerplant 5010
syms:`MSFT`IBM`AAPL`AMZN`META`TSLA /stocks
exs:syms!("NASDAQ";"NYSE";"NASDAQ";"NASDAQ";"NASDAQ";"NASDAQ")
prices:syms!403.15 182.10 192.50 128.04 341.30 242.51 /starting prices
n:2 /number of rows per update
flag:1 /generate 10% of updates for trade and 90% for quote

getmovement:{[s] rand[0.0001]*prices[s]} /get a random price movement
getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]} 
getbid:{[s] prices[s]-getmovement[s]} /generate bid price
getask:{[s] prices[s]+getmovement[s]} /generate ask price

.z.ts:{
 s:n?syms;
 $[0<flag mod 10;
    h(`.u.upd;`quote;(n#.z.N;
                        s;
                        getbid'[s];
                        getask'[s];
                        n?1000;
                        n?1000;
                        n?.Q.A;
                        n#"G" /exs[s]
                        ));
    h(`.u.upd;`trade;(n#.z.N;
                        s;
                        getprice'[s];
                        n?1000;
                        n#0b;
                        n#"G";
                        n#"G" /exs[s]
                        ))
 ]
 flag+:1;
    }

\t 1000
