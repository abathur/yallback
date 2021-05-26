# yallback - dispatch YARA rule matches to shell functions

yallback enables you to handle [YARA](https://github.com/virustotal/yara) rule matches with simple shell function callbacks.

## Getting Started

Here's a very basic example, building on YARA's own ~hello-world example:

```bash
echo rule dummy { condition: true } > my_first_rule
echo 'yallback:rule:dummy:each(){ echo no, _you_ are the dummy! $@ ; }' > my_first_rodeo
yara my_first_rule my_first_rule | yallback my_first_rodeo
```

This example emits: `no, _you_ are the dummy! dummy my_first_rule`

## Usage

For now, `yallback` is pretty simple:

1. pipe/redirect output from yara to `yallback` on stdin. don't use any fancy output options; yallback doesn't (and may not) support them

2. `yallback` directly handles a single argument for now--a y'all-file. This is just a shell (bash) file that tells `yallback` which information you'd like to receive by defining functions to receive them:
    - `yallback:rule:<rulename>:all` - receive all rule matches in a single call
        - `$1` == `<rulename>` (this is a convenience, in case you want a single function to handle multiple rules)
        - matching files are passed on stdin, one per line
    - `yallback:rule:<rulename>:each` - receive one call per rule match
        - `$1` == `<rulename>`
        - `$2` == `<file>`
    - `yallback:done` called to return control to your script after calling the last callback

3. Any additional arguments passed when invoking `yallback` will be passed to your y'all-file when it is sourced.
