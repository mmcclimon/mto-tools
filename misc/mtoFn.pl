#!/usr/bin/perl
use warnings;
use strict;

chomp (my @lines = <>);
my $fn_num = 1;
for (@lines) {
	next if /^$/;
	my $format = qq{  \$fn%s =	array("%s", "%s");\n };
	printf $format, $fn_num, $fn_num, $_;
	$fn_num++;
}