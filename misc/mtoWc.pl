#!/usr/bin/perl
use warnings;
use strict;
use v5.10;

chomp (my @lines = <>);

my @wcList;
my ($fh, $buffer);
open $fh, ">", \$buffer;

for (@lines) {
	next if /^$/;
	my @tmp = split /\t/, $_;

	push @wcList, $tmp[0];

	my $format = "  \$%s =	array(%s, \"%s\", \"%s\");\n";
	printf $fh $format, $tmp[0], $tmp[1], $tmp[2], $tmp[3];
}


my $list = '  $works_cited_array = array(';
$list .= "'$_', " for (@wcList);
substr($list, -2, 2) = ');';

say $list, "\n";
print $buffer;
