#!/usr/bin/perl

use strict;
use warnings;

my $START_FILE = 'final.bin';
my $DECODE_FILE = 'decode.bin';

my $start;
open (my $START, $START_FILE) or die 'Unable to open file: ', $!, "\n";
{
    local $/ = undef;    # turn off readline
    $start  = <$START>;   # with readline off we can slurp the whole file at once
}
close $start;

#warn 'length of data: ', length($data), "\n";
warn 'length of start: ', length($start), "\n";


my $file_cmd = 'file IN.bin';
my $unxz_cmd = 'xz -d -c < IN.bin > OUT.bin';
my $ungz_cmd = 'gzip -d -c < IN.bin > OUT.bin';
my $move_cmd = 'mv OUT.bin IN.bin';
my $copy_cmd = "cp $START_FILE OUT.bin";

my @bits = ();
my $c = 0;

my $cp = `$copy_cmd`;
while (1 == 1) {

    my $mv = `$move_cmd`;

    if ($c % 1000 == 0) {
	warn 'doing layer ', $c, "\n";
	warn 'size has shrunk to ', `ls -la IN.bin`, "\n";
    }
    $c++;

    my $fileout = `$file_cmd`;

    if ($fileout =~ m/XZ/) {
	my $ret = `$unxz_cmd`;

	push @bits, 0;
    }
    elsif ($fileout =~ m/gzip/) {
	my $ret = `$ungz_cmd`;

	push @bits, 1;
    }
    else {
	warn 'got to end', "\n";
	last;
    }

}


warn 'got ', scalar(@bits), ' bits', "\n";

open(my $DECODE, '>', $DECODE_FILE) or die 'Unable to open file: ', $!, "\n";

print $DECODE pack('B*', join('', @bits));

close($DECODE);
