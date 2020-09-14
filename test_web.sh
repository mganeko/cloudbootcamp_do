#!/bin/sh
# curlを使ってWebページにアクセスし、内容をチェックするスクリプト

# -- default target --
TEST_HOST=$TARGET
TEST_SERVERNAME="WebServer by script"

# --- check arg  ---
if [ $# -eq 0 ]; then
  echo "Please specify WebServer Name (1 arg)." 1>&2
  exit 1
fi

# --- 1st arg is TEST_SERVERNAME ---
if [ $# -ge 1 ]; then
  TEST_SERVERNAME=$1
fi

# --- 2nd arg is TEST_HOST ---
if [ $# -ge 2 ]; then
  TEST_HOST=$2
fi

echo "test target IP=$TEST_HOST, test string=$TEST_SERVERNAME"

# 簡易テストとして、指定したWebサーバー名が含まれているかを確認
# --- test hello.html ---
CHECK_RESULT=`curl http://$TEST_HOST/hello.html | grep "$TEST_SERVERNAME" | wc -l`

echo "Check result=$CHECK_RESULT lines"

if test $CHECK_RESULT -gt 0
then
  echo "test OK"
else
  echo "test NG"
  exit 1
fi

exit 0
