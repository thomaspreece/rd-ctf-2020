#!/usr/bin/perl

use strict;
use warnings;

use IPC::Run qw(run);


my $FLAG_FILE = 'flag.bin';
#my $START_FILE = 'flag.zpaq';
my $END_FILE = 'out.bin';
my $SCRIPT_FILE = 'encode.sh';

my $data;
open (my $IN, $FLAG_FILE) or die 'Unable to open file: ', $!, "\n";
{
    local $/ = undef; # turn off readline
    $data  = <$IN>;   # with readline off we can slurp the whole file at once
}
close $IN;

#my $start;
#open (my $START, $START_FILE) or die 'Unable to open file: ', $!, "\n";
#{
#    local $/ = undef;    # turn off readline
#    $start  = <$START>;   # with readline off we can slurp the whole file at once
#}
#close $start;

warn 'length of data: ', length($data), "\n";
#warn 'length of start: ', length($start), "\n";

my @bits = reverse split(//, unpack('B*', $data));

warn 'number of bits: ', scalar(@bits), "\n";

#my @zero_cmd = ('xz', '-1', '-c', '-z');
#my @one_cmd  = ('gzip', '-1', '-c');

my $zero_cmd = 'xz -1 -c -z < IN.bin > OUT.bin';
my $one_cmd  = 'gzip -1 -c < IN.bin > OUT.bin';
my $move_cmd = 'mv OUT.bin IN.bin';

open(my $ENC, '>', $SCRIPT_FILE) or die 'Unable to open file: ', $!, "\n";

my $c = 0;
print $ENC '#!/bin/bash', "\n";
foreach my $b (@bits) {

    if ($c % 1000 == 0) {
	print $ENC 'echo "Doing layer ', $c, '"', "\n";
	print $ENC 'ls -la IN.bin', "\n";

	#if ($c == 5000) {
	 #   exit 0;
	#}
    }
    $c++;

    if ($b == 0) {
	print $ENC $zero_cmd, "\n";
    }
    else {
	print $ENC $one_cmd, "\n";
    }
    print $ENC $move_cmd, "\n";
}

print $ENC 'mv IN.bin final.bin', "\n";

close $ENC;


# my $c = 0;
# my $input = \$start;
# my ($ccode, $err, $rcode);
# foreach my $b (@bits) {
#     my $output;

#     if ($c % 1000 == 0) {
# 	warn 'doing layer ', $c, "\n";
# 	warn 'size has grown to ', length($$input), "\n";

# 	if ($c == 5000) {
#  	    exit 0;
# 	}
#     }
#     $c++;

#     if ($b == 0) {
# 	run \@zero_cmd, $input, \$output, \$err;

# 	#die 'Did not get expected xz output!', "\n" unless (substr($output, 0, 2) eq "\xfd\x37");

# 	$input = \$output;
#     }
#     else {
# 	run \@one_cmd, $input, \$output, \$err;

# 	#die 'Did not get expected gzip output!', "\n" unless (substr($output, 0, 2) eq "\x1f\x8b");

# 	$input = \$output;
#     }
# }


# open(my $OUT, '>', $END_FILE) or die 'Unable to open file: ', $!, "\n";

# print $OUT $$input;

# close($OUT);
