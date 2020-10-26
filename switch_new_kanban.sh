#!/bin/bash

# Droplet起動からkanbanのデブロイまで通しで行うスクリプト
# arg1  Dropletの名前
# arg2  バーの色

# -- default target --
DROPLET_NAME="new-kanban"

# --- 1st arg is DROPLET_NAME ---
if [ $# -ge 1 ]; then
  DROPLET_NAME=$1
fi

# --- 2nd arg is FRONT_BAR_COLOR ---
export FRONT_BAR_COLOR="red"
if [ $# -ge 2 ]; then
  export FRONT_BAR_COLOR="$2"
fi

# --- create droplet ---
if [ -e ~/ansible/inventory/new_kanban ]; then
  echo "-- SKIP creating droplet --"
  export TARGET=`tail -n 1 ~/ansible/inventory/new_kanban`
  echo " continue setup of $TARGET"
else
  echo "-- create droplet --"
  export TARGET=`sh create_droplet_vpc.sh $DROPLET_NAME`

  # --- prepare inventory ---
  cp ~/ansible/template/kanban.tmpl ~/ansible/inventory/new_kanban
  echo $TARGET >> ~/ansible/inventory/new_kanban
fi

# --- (add firewall) ---
#export DROPLET_ID=`sh get_droplet_id.sh`
#sh add_firewall_private.sh $DROPLET_ID

# --- setup with Ansible ---
echo "-- sleep until ssh ready --"
sleep 15  # wait until ssh port ready

echo "-- setup with ansible --"
ansible-playbook -i ~/ansible/inventory/new_kanban ~/ansible/playbook/kanban.yml
KANBAN_CODE=$?

if [ $KANBAN_CODE -ne 0 ]; then
  echo "=== setup with kanban.yml ERROR ==="
  exit 5
fi

echo "-- enable service with ansible --"
ansible-playbook -i ~/ansible/inventory/new_kanban ~/ansible/playbook/service.yml
SERVICE_CODE=$?

if [ $SERVICE_CODE -ne 0 ]; then
  echo "=== setup with service.yml ERROR ==="
  exit 6
fi


# ---- test ----
echo "-- sleep until service ready --"
sleep 10  # wait until service ready

echo "-- test kanban --"
sh test_kanban.sh $TARGET
TEST_CODE=$?

# --- report ---
if [ $TEST_CODE -ne 0 ]; then
  echo "=== Kanban Setup ERROR ==="
  exit $TEST_CODE
else
  echo "--- OK ---"
  cp ~/ansible/inventory/new_kanban ~/ansible/inventory/new_kanban.done
  rm ~/ansible/inventory/new_kanban
fi

# --- switch proxy ----
ansible-playbook -i ~/ansible/inventory/proxy ~/ansible/playbook/proxy_kanban.yml

# -- exit --
exit $?

