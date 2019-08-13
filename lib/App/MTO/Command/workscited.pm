package App::MTO::Command::workscited;
# ABSTRACT: munge works cited

use App::MTO -command;
use v5.24;
use warnings;
use experimental 'signatures';

sub usage_desc { "%c wc %o FILE" }

sub command_names { return ('wc', 'works-cited') }

sub opt_spec {
  [ 'raw', 'munge raw text into intermediate format' ],
  [ 'final', 'munge intermediate format into final'  ],
}

sub validate_args ($self, $opt, $args) {
  $self->usage_error('no/incompatible options')
    unless $opt->raw xor $opt->final;

  $self->usage_error('no file given') unless @$args == 1;
}

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  my $fn = shift @$args;
  my $path = Path::Tiny::path($fn);

  return $self->_do_raw($path)   if $opt->raw;
  return $self->_do_final($path) if $opt->final;

  die "unreachable?";
}

sub _do_raw ($self, $path) {
  my $last = '';
  for my $line ($path->lines({ chomp => 1 })) {
    next if $line =~ /^\s*$/;

    my ($author)    = $line =~ /^(\w*),/;
    my ($year)      = $line =~ /.\s(\d{4}[a-f]?).*?\./;
    my ($full_auth) = $line =~ /^(.*?)\./;

    my $seen = $full_auth eq $last;
    $last = $full_auth;

    printf("\n%s_%s\t%s\t%s %s\t%s\n",
      lc $author, $year,
      ($seen ? 'true' : 'false'),
      $author, $year,
      $line,
    );
  }
}

sub _do_final ($self, $path) {
  my (@vars, @list);

  for my $line ($path->lines({ chomp => 1 })) {
    next if $line =~ /^\s*$/;
    my ($var, $seen, $short, $full)  = split /\t/, $line;

    push @vars, $var;
    push @list, sprintf(q{  $%s =  array(%s, "%s", "%s");\n},
      $var, $seen, $short, $full
    );
  }

  my $wc_list = sprintf('  $works_cited_array = array(%s);',
    join(q{, }, map {; qq{'$_'} } @vars),
  );

  say $wc_list, "\n";
  say for @list;
}

1;
