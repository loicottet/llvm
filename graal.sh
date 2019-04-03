#! /bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: graal.sh <llvm directory>"
	exit -1
fi

script=$(readlink -f "$0")
basepath=$(dirname "$script")

$basepath/graal-x86.sh $1
