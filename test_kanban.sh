#!/bin/sh

# -- default target --
TEST_HOST=$TARGET

# --- 1st arg is TEST_HOST ---
if [ $# -ge 1 ]; then
  TEST_HOST=$1
fi

echo "test target IP=$TEST_HOST"

# --- test GraphQL ---
echo "get http://$TEST_HOST:8080/"
wget http://$TEST_HOST:8080/ -O /tmp/grapql_index.html
GRAPHQL_EXIT_CODE=$?
if [ $GRAPHQL_EXIT_CODE -ne 0 ]; then
  echo "GraphQL ERROR"
  exit 1
fi

# --- test Kanban Front ---
echo "get http://$TEST_HOST:3000/kanban/"
wget http://$TEST_HOST:3000/kanban/ -O /tmp/front_index.html
KANBAN_EXIT_CODE=$?
if [ $KANBAN_EXIT_CODE -ne 0 ]; then
  echo "Kanban Front ERROR"
  exit 2
fi

# -- OK ---
echo "test OK"
exit 0
