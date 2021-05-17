package App::MTO::Command::sub;
# ABSTRACT: munge article text

use App::MTO -command;
use v5.24;
use warnings;
use experimental 'signatures';
use utf8;

sub usage_desc { "%c sub FILE" }

sub opt_spec {
  [ 'utf',    'leave most special chars' ],
  [ 'angles', 'replace non-php-tag < and >' ],
}

sub validate_args ($self, $opt, $args) {
  $self->usage_error('no file given') unless @$args == 1;
}

sub execute ($self, $opt, $args) {
  require Path::Tiny;
  my $fn = shift @$args;
  my $path = Path::Tiny::path($fn);

  my $fn_num = 1;
  for ($path->lines_utf8) {
    # footnotes
    s/fnXX/"fn" . $fn_num++/ge;

    # raw ampersands
    s/ & / &amp; /g;

    unless ($opt->utf) {
      # accented characters
      s/á/&aacute;/g;
      s/é/&eacute;/g;
      s/í/&iacute;/g;
      s/ó/&oacute;/g;
      s/ú/&uacute;/g;

      s/Á/&Aacute;/g;
      s/É/&Eacute;/g;
      s/Í/&Iacute;/g;
      s/Ó/&Oacute;/g;
      s/Ú/&Uacute;/g;

      s/à/&agrave;/g;
      s/è/&egrave;/g;
      s/ù/&ugrave;/g;
      s/ç/&ccedil;/g;

      s/ä/&auml;/g;
      s/ë/&euml;/g;
      s/ï/&iuml;/g;
      s/ö/&ouml;/g;
      s/ü/&uuml;/g;

      s/Ä/&Auml;/g;
      s/Ë/&Euml;/g;
      s/Ï/&Iuml;/g;
      s/Ö/&Ouml;/g;
      s/Ü/&Uuml;/g;

      s/ß/&szlig;/g;
      s/ê/&ecirc;/g;
      s/ĭ/&#301;/g; # i with breve

      # dashes & quotes
      s/‘/&#8216;/g;
      s/’/&#8217;/g;
      s/“/&#8220;/g;
      s/”/&#8221;/g;
      s/–/&#8211;/g; #en-dash
      s/—/&#8212;/g; #em-dash
    }

    s/ …/&nbsp;.&nbsp;.&nbsp;. /g;
    s/…/.&nbsp;.&nbsp;. /g;
    s/ \. \. \./&nbsp;.&nbsp;.&nbsp;./g;

    if ($opt->angles) {
      # angle brackets not part of <? ?> tags
      s/<([^?])/&lt;$1/g;
      s/([^?])>/$1&gt;/g;
    }

    print;
  }
}

1;
