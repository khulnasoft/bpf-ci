#!/bin/bash

set -xe

function run_selftest() {
  local RESULT_FILE=/tmp/selftest-`clang --version|head -n1|awk '{ print $1"-"$3}'|tr -d '\n'`_result.txt
  clang --version >> $RESULT_FILE
  llc --version >> $RESULT_FILE
  make
  sudo make run_tests >> $RESULT_FILE
  make clean
}

KDIR=$1 # Kernel tree
TEST_DIR=$KDIR/tools/testing/selftests/bpf/

if ! test -d $TEST_DIR; then
  echo "XXX: could not find BPF selftests at $TEST_DIR, maybe too old kernel?"
  echo "XXX: Aborting run selftest"
  exit 0
fi
cd $TEST_DIR

# Used the default version (3.8.1)
# run_selftest

#BACKUP_PATH="$PATH"
## Used the preinstalled ones from VM image
#CLANG_VERSIONS=("5.0.0" "4.0.0" "3.9.1" "3.9.0" "4.0.1")
#for c in ${CLANG_VERSIONS[@]}; do
#  export PATH="/usr/local/clang+llvm-$c/bin:$PATH"
#  run_selftest
#done
## Restore path
#export PATH="$BACKUP_PATH"

# Used development snapsnot
sudo rm /usr/local/clang/bin/llc /usr/bin/llc
sudo rm /usr/local/clang/bin/clang /usr/bin/clang
ln -s /usr/bin/llc-6.0 /usr/local/clang/bin/llc
ln -s /usr/bin/clang-6.0 /usr/local/clang/bin/clang
run_selftest
