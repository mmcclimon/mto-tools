package App::MTO::Command::footnotes;
# ABSTRACT: munge footnote text

use App::MTO -command;
use v5.24;
use warnings;
use experimental 'signatures';

sub usage_desc { "%c fn FILE" }

sub command_names { return ('fn', 'footnotes') }

sub opt_spec { }

sub validate_args ($self, $opt, $args) {
  print $self->usage_error('no file given') unless @$args == 1;
}

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  my $fn = shift @$args;
  my $path = Path::Tiny::path($fn);

  binmode(STDOUT, ':encoding(UTF-8)');

  my $fn_num = 1;
  for my $line ($path->lines_utf8({ chomp => 1 })) {
    next if $line =~ /^\s*$/;
    printf(qq{  \$fn%d =  array("%d", "%s");\n},
      $fn_num, $fn_num, $line
    );
    $fn_num++;
  }
}

1;
