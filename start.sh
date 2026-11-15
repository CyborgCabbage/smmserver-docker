#!/bin/sh
./caddy/caddy
./coredns/coredns -dns.port=53 
python NintendoClients/example_smm_server.py 
python NintendoClients/example_friend_server.py 
python -m http.server 9988
