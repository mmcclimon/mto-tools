#!/usr/bin/env perl
use warnings;
use strict;
use v5.14;

use File::Path qw(make_path);
use File::Copy;

my $author = shift @ARGV;
die "Usage:\n\t $0 AUTHOR_NAME\n" unless $author;

print "Issue number: ";
chomp(my $issue = <>);
die "Issue must be in VV.N format.\n" unless $issue =~ /^\d\d[.]\d$/;

# year is the volume number minus six
my ($volNum) = $issue =~ /^(\d\d)/;
my $year = $volNum - 6;

my $dir = "$issue/$author";

# make dir if needed
make_path($dir, {verbose => 1});

# sub in placeholders in article template
my $filePath = "$dir/mto.$year.$issue.$author.php";

open my $template, "<", "templates/mto.YY.V.N.author.php" or die "couldn't open template: $!";
open my $outFile, ">", $filePath or die "couldn't open $filePath for writing: $!";
for my $line (<$template>) {
    if ($line =~ /AUTHOR_info.php/) {
        $line =~ s/AUTHOR/$author/;
    }
    print $outFile $line;
}

say "Created $filePath";
close $template;
close $outFile;

my $infoPath = "$dir/${author}_info.php";
open $template, "<", "templates/author_info.php" or die "couldn't open template: $!";
open $outFile, ">", $infoPath or die "couldn't open $filePath for writing: $!";

for my $line (<$template>) {
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

    print $outFile $line;
}

say "Created $infoPath";
