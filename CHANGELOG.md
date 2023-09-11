# Changelog

## September 14, 2023
Refactor Nix expressions and convert to flake.

## v0.2.0 (January 30, 2022)
- Apply unmatched-rule-callback fix from 2768b5d81f7f3086b8a1399779bf6e7d3844dfe4 to two additional contexts.
- Fix subshell that was causing some variable/state persistence problems.
- Refactor test suite

## v0.1.0 (September 22, 2021)
Initial versioned release.

## May 27, 2021
Fix recursion w/ no extra args (introduced in dfbc12e6155b21de74d09bf9d6e384ee16b71c03).

## May 25, 2021
Initially, yallback supported a single argument (the callback script). Now, additional arguments are accepted and passed to the source builtin.

You can use this to pass in information to adjust how your sourced script sets itself up, or even to pass it the name(s) of additional plugin scripts for it (i.e., your yallback script) to source.

## May 1, 2021
- Added a test suite.
- Made sort logic more explicit
- Fixed a bug when callbacks were provided for unmatched rules.

## Mar 31, 2021
Initial publication
