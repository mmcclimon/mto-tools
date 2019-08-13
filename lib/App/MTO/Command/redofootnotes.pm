package App::MTO::Command::redofootnotes;
# ABSTRACT: redo footnote numbering

use App::MTO -command;
use v5.24;
use warnings;
use experimental 'signatures';

sub usage_desc { "%c redo-footnotes FILE" }

sub command_names { 'redo-footnotes' }

sub opt_spec { }

sub validate_args ($self, $opt, $args) {
  print $self->usage_error('no file given') unless @$args == 1;
}

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  my $fn = shift @$args;
  my $path = Path::Tiny::path($fn);

  # do footnotes
  say "will edit $path in-place...";
  my $fn_num = 1;
  $path->edit_lines(sub { s/fnXX/"fn" . $fn_num++/ge });
  say "done";
}

1;