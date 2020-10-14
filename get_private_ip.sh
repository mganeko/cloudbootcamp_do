#!/bin/sh
cat /tmp/droplet.json | jq -r '.[].networks.v4[] | select(.type == "private") | .ip_address'
