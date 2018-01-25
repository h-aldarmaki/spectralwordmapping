#---------------------------------------------------------
# perl index2lex.pl input_file source_vocab target_vocab
#
# Replace indices with  lexicons from source and target
#    vocab lists
# Input file must be a space separated lexicon, one entry
#    per line:
#    source_index targt_index
# OOV words will cause an error
#---------------------------------------------------------

use strict;
use warnings;

die "Usage: perl index2lex.pl input_file s_vocab_file t_vocab_file" if (@ARGV < 3);
my $input_file = $ARGV[0];
my $output_file = $input_file.".lex";
my $s_vocab_file = $ARGV[1];
my $t_vocab_file = $ARGV[2];

#read vocab file (one word per line)
my %s_vocab;
open(V, $s_vocab_file) || die "Cannot open $s_vocab_file\n";
while (my $str = <V>) {
    $str =~ s/\s+$//;
    my @words = split(/\s+/, $str);
    my $tmp=keys %s_vocab;
    $s_vocab{$tmp+1} = $words[0]; #indices start from 1
} 
close(V);

my %t_vocab;
open(V, $t_vocab_file) || die "Cannot open $t_vocab_file\n";
while (my $str = <V>) {
    $str =~ s/\s+$//;
    my @words = split(/\s+/, $str);
    my $tmp=keys %t_vocab;
    $t_vocab{$tmp+1} = $words[0]; #indices start from 1
} 
close(V);

#read input file and replace words with indices
open(In, $input_file) || die "Cannot open $input_file\n";
open(Out, ">$output_file") || die "Cannot open $output_file\n";

while (my $str = <In>) {
    $str =~ s/\s+$//;
    my @words = split(/\s+/, $str);
    if (exists $s_vocab{$words[0]} and exists $t_vocab{$words[1]}) {
        print Out "$s_vocab{$words[0]} $t_vocab{$words[1]}";
    }else{
       die "ERROR OOV word\n";
    }
    print Out "\n";
}

close (In);
close (Out);

