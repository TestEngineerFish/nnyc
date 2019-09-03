#!/bin/bash

line=$(cat .git/HEAD)
branch_name=${line:16:100}
echo '------------------------------------------------------------------'
echo ' '
echo '           当前分支为 '$branch_name
echo ' '
echo '将提交至对应的服务器分支，请按回车或者空格确认！按其它键不会提交!'
echo ' '
echo "输入空格或者回车确认提交至 refs/for/$branch_name 分支:"
read -s -n1 input
echo ' '

failed_count=0
if [ -z $input ]; then
  echo '正在提交，请稍候...'
  echo '------------------------------------------------------------------'
  for ((i=0; i<10; i++))
  do
  	failed_count=0
    git push origin HEAD:refs/for/$branch_name || let "failed_count=1"
    if [ $failed_count == 0 ]
    then
      break
    fi
  done
else
  echo "你取消了本次提交"
  echo ' ' 
  echo '------------------------------------------------------------------'
fi 

