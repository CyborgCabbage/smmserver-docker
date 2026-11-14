#!/bin/sh
./caddy/caddy &
COREDNS_PID1=$!

./coredns/coredns -dns.port=53 &
COREDNS_PID2=$!

python NintendoClients/example_smm_server.py &
COREDNS_PID3=$!

python NintendoClients/example_friend_server.py &
COREDNS_PID4=$!

python -m http.server &
COREDNS_PID5=$!

# Exit if EITHER process dies
wait -n
# kill $COREDNS_PID1 $COREDNS_PID2 2>/dev/null
kill $COREDNS_PID1 $COREDNS_PID2 $COREDNS_PID3 $COREDNS_PID4 $COREDNS_PID5 2>/dev/null
