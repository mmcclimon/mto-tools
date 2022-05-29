use v5.36;
package App::MTO::Command;

use parent 'App::Cmd::Command';

binmode(STDIN, ":encoding(UTF-8)");
binmode(STDOUT, ":encoding(UTF-8)");

sub mto_home { '/Users/michael/code/mto' }
