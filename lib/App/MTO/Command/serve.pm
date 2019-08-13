package App::MTO::Command::serve;
# ABSTRACT: serve up a file

use App::MTO -command;
use v5.24;
use warnings;
use experimental 'signatures';

sub usage_desc { "%c serve" }

sub opt_spec { }

sub validate_args ($self, $opt, $args) { }

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  my $cd = Path::Tiny::path('.');
  my ($article, @rest) = grep { /^mto\.\d\d.*.php/ } $cd->children;
  die "no article file found\n" unless $article;
  die "too many article files found?\n" if @rest;

  my ($vol, $auth) = $article =~ /^mto\.\d\d\.(\d\d\.\d)\.(.*)\.php$/;
  say "available at http://localhost:4000/$vol/$auth/$article\n";

  chdir $self->mto_home;
  exec qw(php -S localhost:4000);
}

1;
