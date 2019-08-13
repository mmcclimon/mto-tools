#!/usr/bin/perl
use warnings;
no warnings qw(uninitialized);
use strict;

chomp (my @lines = <>);

my $last = '';
for (@lines) {
	next if /^$/;

	m/^(\w*),/;
	my $author = $1;
	
	m/.\s(\d{4}[a-f]?).*?\./;
	my $year = $1;
	
	m/^(.*?)\./;
	my $seen = ($1 eq $last);
	$last = $1;
	
	my $short = "$author $year";
	my $var = lc $author . "_$year";

	printf "%s\t%s\t%s\t%s\n\n", $var, ($seen ? 'true' : 'false'), $short, $_;
}