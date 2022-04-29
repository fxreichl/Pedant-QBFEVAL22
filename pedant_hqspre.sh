#!/bin/bash

HQSPRECOMMAND="${MPATH}/hqspre"
PEDANTCOMMAND="${MPATH}/pedant"

FORMULA=$1

PREPROCESSED=$(mktemp -t)
trap "rm $PREPROCESSED" EXIT

HQSPRE_OPTIONS="--bce 0 --bia 0  --bla 0 --ble 1 --contra 1 --covered 0 --equiv_gates 1 --hec 0 --hidden 1 --hse 0 --ic 0 --preserve_gates 1 --substitute 0 --univ_exp 0"
PEDANT_OPTIONS=""

$HQSPRECOMMAND $HQSPRE_OPTIONS $FORMULA -o $PREPROCESSED --timeout 300

RES=$?
if [ $RES == 10 ]
then
	echo "Solved by HQSpre"
	echo "SATISFIABLE"
	exit 10
elif [ $RES == 20 ]
then
	echo "Solved by HQSpre"
	echo "UNSATISFIABLE"
	exit 20
fi

$PEDANTCOMMAND $PEDANT_OPTIONS $PREPROCESSED
