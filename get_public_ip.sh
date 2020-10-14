#!/bin/sh
cat /tmp/droplet.json | jq -r '.[].networks.v4[] | select(.type == "public") | .ip_address'
