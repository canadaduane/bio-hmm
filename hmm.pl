#!/usr/bin/perl

use List::Util qw[min max];  #this allows us to use max function

# Command-line Arguments:

    # 1. The number of nucleotides in the "window"
    $window = shift;    #variable to read in window size from command line 
    # 2. The threshold (in %) of the CpG Island
    $cpg_island_threshold = shift;
    # 3. The filename containing the nucleotide sequence
    $filename = shift;

# Global Variables:
    
    # An array of the nucleotide sequence
    @sequence = ();
    # An array of states, e.g. 0 for non-CpG and 1 for CpG state
    @state_values = ();

# Global Constants:

    # Non CpG Island state:
    $no_cpg_state = 0;
    # CpG Island state:
    $cpg_state = 1;
    # Look-up table for p_state_given_state
    %sstate = (
        0 => {0 => 0.7, 1 => 0.3},
        1 => {0 => 0.5, 1 => 0.5}
    );
    # Look-up table for p_state_given_nucleotide
    %nstate = (
        0 => {'a' => 0.251, 't' => 0.400, 'c' => 0.098, 'g' => 0.251},
        1 => {'a' => 0.250, 't' => 0.250, 'c' => 0.250, 'g' => 0.250}
    );


# Here we'll each write our own code to actually use all of the methods
print "Hi: " . p_state_given_state(0, 1);
print "\nBye: " . p_state_given_nucleotide(0, 'a');

# and this method will loop through the sequence
# giving the probabilityOf method the current base and
# next base?
sub get_states() {
    $probability = 1.0;
    
    # Assume we're not in the middle of an island for starters
    $current_state = $no_cpg_state;
    
    foreach( 0..@sequence-1 ) {
        $p1 = p_state_given_nucleotide($cpg_state, $sequence[$_]);
        $p2 = p_state_given_nucleotide($no_cpg_state, $sequence[$_]);
        if( $p1 > $p2 ) {
            $current_state = $cpg_state;
        }
        else {
            $current_state = $no_cpg_state;
        }
        push (@state_values, $current_state);
        $probability = $probability + log(max($p1, $p2));
    }
}

# Reads in a text file containing pure nucleotide sequences
# (should we have a read_fasta as well?)
sub read_nucleotides($filename) {
    open FILE, $filename or die $!;
    $tmp = FILE;
    @sequence = split(//,$tmp); # this should split every character
}

sub slider($window) { #so this method will just check the @state_values
                     #using a given threshold (the threshold will be a %?
                     # (percentage will be held in $cpg_island_threshold)
}

# this is the "beginning state" probability table
sub p_initial_state() {
    return 0.5;
}

# this is the "state given a current state" probability table
sub p_state_given_state() {
    my $s1 = shift;
    my $s2 = shift;
    # if ( !exists($sstate{ $s1 }) ) {
    #     die "(p_state_given_state): unknown states $s1, $s2";
    # }
    return $sstate{ $s1 }{ $s2 };
}

# this is the "state given a nucleotide" probability table
sub p_state_given_nucleotide() {
    my $s1 = shift;
    my $n = shift;
    # if ( !exists($nstate{ $s1 }) ) {
    #     die "(p_state_given_nucleotide): unknown state $s1";
    # }
    # elsif( !exists($nstate{ $s1 }{ $n }) ) {
    #     die "(p_state_given_nucleotide): unknown nucleotide $n";
    # }
    return $nstate{ $s1 }{ $n };
}

