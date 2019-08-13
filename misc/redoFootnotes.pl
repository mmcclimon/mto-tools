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
    say $line;
}
