#!/usr/bin/perl
use warnings;
use strict;
use charnames ':full';
use v5.10;

my $file = shift;
#my $stamp = time();
#system "cp $file $file.bak_$stamp";  #create timestamped copy of old file
open my $fh, "<", $file or die "Can't open $file: $!\n";
chomp (my @lines = <$fh>);
close $fh;
#open NEWFILE, "> $file.new" or die "Can't write to $file.new: $!\n";
#select NEWFILE; #prints output to new file rather than to terminal


# do footnotes
my $fn_num = 1;
for my $line (@lines) {
	if ($line =~ s/(fn)XX/$1$fn_num/) {
		$fn_num++;
		redo;
	}
}


# replace special characters
for (@lines) {

	s/ & / &amp; /g;
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
	s/…/.&nbsp;.&nbsp;. /g;


	# angle brackets not part of <? ?> tags
#	s/<([^?])/&lt;$1/g;
#	s/([^?])>/$1&gt;/g;

	say;
}

