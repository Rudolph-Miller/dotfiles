#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set private.app_sequelpro_control_h_to_backspace 1
/bin/echo -n .
$cli set remap.delete2forwarddelete 1
/bin/echo -n .
$cli set remap.jis_command2eisuukana_prefer_command 1
/bin/echo -n .
$cli set remap.qwerty2dvorak 1
/bin/echo -n .
$cli set remap.swap_number_and_symbol 1
/bin/echo -n .
$cli set repeat.initial_wait 250
/bin/echo -n .
$cli set repeat.wait 33
/bin/echo -n .
/bin/echo
