package App::MTO::Command::generate;
# ABSTRACT: generate a shell directory structure

use App::MTO -command;
use v5.36;

sub usage_desc { "%c gen AUTHOR" }

sub command_names { return ('gen', 'generate') }

sub opt_spec { }

sub validate_args ($self, $opt, $args) {
  print $self->usage_error('no author given') unless @$args == 1;
}

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  chdir $self->mto_home;

  my $author = shift @$args;

  print "Issue number: ";
  chomp(my $issue = <STDIN>);
  die "Issue must be in VV.N format.\n" unless $issue =~ /^\d\d[.]\d$/;

  # year is the volume number minus six
  my ($vol_num) = $issue =~ /^(\d\d)/;
  my $year = $vol_num - 6;

  # make dir if needed
  my $dir = Path::Tiny::path("$issue/$author");
  $dir->mkpath({verbose => 1});

  # sub in placeholders in article template
  my $article_template = Path::Tiny::path("templates/mto.YY.V.N.author.php");
  my $article = $dir->child("mto.$year.$issue.$author.php");

  for my $line ($article_template->lines) {
    if ($line =~ /AUTHOR_info.php/) {
      $line =~ s/AUTHOR/$author/;
    }

    $article->append($line);
  }

  say "Created $article";

  my $info_template = Path::Tiny::path("templates/author_info.php");
  my $info = $dir->child("${author}_info.php");

  for my $line ($info_template->lines) {
    if ($line =~ /VOLUME/) {
      $line =~ s/VOLUME/$issue/;
    } elsif ($line =~ /YEAR/) {
      $line =~ s/YEAR/20$year/;
    } elsif ($line =~ /preparer = "NAME"/) {
      $line =~ s/NAME/Michael McClimon/;
    } elsif ($line =~ /preparerTitle = "TITLE"/) {
      $line =~ s/TITLE/Senior Editorial Assistant/;
    } elsif ($line =~ /AUTHOR_example_info/) {
      $line =~ s/AUTHOR/$author/;
    }

    $info->append($line);
  }

  say "Created $info";
}

1;
