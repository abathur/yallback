buffet="$(mktemp)"
let startdepth=${#BASH_SOURCE[@]}+1

context(){
	local stack
	printf -v stack "%s < " "${FUNCNAME[@]:1:${#FUNCNAME[@]}-$startdepth}"
	echo "$testfile: ${stack:0:-3}: $@"
} 1>&2
fin(){
	local result="$1"
	shift
	context "$@"
	echo "$result $(get_testnum) $testmod ${FUNCNAME[-$startdepth]} $@"
}
pass(){
	fin "ok" "$@"
	return 0
} 2>/dev/null
fail(){
	fin "not ok" "$@"
	return 1
}
expect_rulename(){
	if [[ "$1" != "$2" ]]; then
		fail "verify rulename (expected $2, got $1)"
	else
		pass "verify rulename"
	fi
}
expect_rulename_each(){
	if [[ "$1" != "$2" ]]; then
		fail "verify rulename (expected $2, got $1)"
	fi
}
expect_stdin(){
	if diff -u - "${testfile/yall/}$1.expected"; then
		pass $1: stdin matches expectation
	else
		fail $1: unexpected stdin
	fi
}

# 1 == $1 from rule callback; 2 == expected rulename
expect_rulename_all(){
	expect_rulename "$1" "$2" && expect_stdin "$2"
}

ensure_all_rules_were_called(){
	expect_stdin "$1" < "${buffet}"
}

get_testnum(){
	read -r testnum < $lasttestnum
	((testnum++))
	echo $testnum > $lasttestnum
	echo $testnum
}
