use strict;
use warnings;
package App::MTO::Command;

use base 'App::Cmd::Command';

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

sub mto_home { '/Users/michael/code/mto' }
