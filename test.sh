#!/usr/bin/env bash

# for now, just make sure the furniture is
# bolted down?

lasttestnum="$(mktemp)"
echo 0 > $lasttestnum

yallfile(){
	local testfile="$1"
	local testbase="${testfile/tests\//}"
	local testmod="${testbase/.yallfile/}"
	cat - tests/helpers.bash "$1" <<-PROLOGUE
		testfile="${testfile}" testbase="${testbase}" testmod="${testmod}" lasttestnum="$lasttestnum"
PROLOGUE
}

tap_status(){
	code=0
	while read -r line; do
		case "$line" in
			"not ok "*)
				code=1
				;;
		esac
		echo $line
	done
	return $code
}

run_tests(){
	for yall in tests/*.yall; do
		yallback <(yallfile "$yall") < tests/gotools.stdout
	done
}

tap_status < <(run_tests)
