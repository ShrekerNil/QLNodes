#!/bin/bash

function show_green() {
  content=$1
  echo -e "\033[32m$content\033[0m"
}
 
function show_red() {
  content=$1
  echo -e "\033[31m$content\033[0m"
}

function judgement() {
  cmd=$1
  result_code=$2
  output=$3
  
  if [[ $result_code -ne 0 ]]; then
  echo RESULT_CODE: $2
  fi
  if [[ ${#output} -gt 0 ]]; then
  echo "${output}"
  fi

  if [[ $result_code -eq 0 ]]; then
    show_green "COMMAND OF \"$cmd\" EXECUTED SUCCESSFULLY."
  else
    if [[ $result_code -eq 1 ]]; then
      if [[ $3 =~ "Your branch is up to date" ]]; then
          echo ""
      else
          show_red "ERROR: 通用未知错误"
      fi
    else
      if [[ $result_code -eq 2 ]]; then
        show_red "ERROR: 误用shell命令"
      elif [[ $result_code -eq 126 ]]; then
        show_red "ERROR: 命令不可执行"
      elif [[ $result_code -eq 127 ]]; then
        show_red "ERROR: 没找到命令"
      elif [[ $result_code -eq 128 ]]; then
        show_red "ERROR: 无效退出参数"
      elif [[ $result_code -eq "128+x Linux" ]]; then
        show_red "ERROR: 信号x的严重错误"
      elif [[ $result_code -eq "128+x" ]]; then
        show_red "ERROR: Linux信号2的严重错误，即命令通过SIGINT（Ctrl＋Ｃ）终止"
      elif [[ $result_code -eq "255" ]]; then
        show_red "ERROR: 退出状态码越界"
      else
        show_red "UNEXPECTED CODE: "$result_code
      fi
      show_red "COMMAND OF \"$cmd\" EXECUTED FAILURE. PLEASE TRY AFTER CHECKING IT."
      read -p "PRESSING ENTER TO EXIT ... "
      exit $result_code
    fi
  fi
}

#read -p "PLEASE ENTER THE MESSAGE: " message
#while [ ! $message ]
#do
#  read -p "PLEASE ENTER THE MESSAGE: " message
#done

function print_start_line() {
  show_green ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

function print_end_line() {
  show_green ------------------------------------------------------------
}

function new_line() {
  echo -e "\n"
}

print_start_line
show_green "*                  BACKING UP ALL FILES                    *"
print_start_line
new_line
print_start_line
cur_folder=`pwd`
show_green "Changing Directory to Current: $cur_folder"
print_end_line
cd $cur_folder
judgement "cd $cur_folder" $?

new_line
print_start_line
show_green "Getting And Listing Status Before Update..."
print_end_line
result=`git status`
judgement "git status" $? "$result"

new_line
print_start_line
show_green "Pulling New Code..."
print_end_line
result=`git pull`
judgement "git pull" $? "$result"

# new_line
# read -p "PRESSING ENTER TO EXIT ... "
