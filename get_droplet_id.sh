#!/bin/sh
cat /tmp/droplet.json | jq -r '.[].id'
