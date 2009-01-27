#!bin/usr/perl

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


# Here we'll each write our own code to actually use all of the methods


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
sub p_state_given_state($s1, $s2) {
    # non-CpG -> non-CpG state transition
    if ($s1 == $no_cpg_state &&
        $s2 == $no_cpg_state) {
        return 0.7;
    }
    # non-CpG -> CpG state transition
    elsif ($s1 == $no_cpg_state &&
        $s2 == $cpg_state) {
        return 0.3;
    }
    # CpG -> non-CpG state transition
    elsif ($s1 == $cpg_state &&
        $s2 == $no_cpg_state) {
        return 0.5;
    }
    # CpG -> CpG state transition
    elsif ($s1 == $cpg_state &&
        $s2 == $cpg_state) {
        return 0.5;
    }
    else {
        die "(p_state_given_state): unknown states $s1, $s2";
    }
}

# this is the "state given a nucleotide" probability table
sub p_state_given_nucleotide($s1, $n) {
    # non-CpG state
    if ($s1 == $no_cpg_state) {
        if ($n == 'a') {
            return 0.251;
        }
        elsif ($n == 't') {
            return 0.40;
        }
        elsif ($n == 'c') {
            return 0.098;
        }
        elsif ($n == 'g') {
            return 0.251;
        }
        else {
            die "(p_state_given_nucleotide): unknown nucleotide $n";
        }
    }
    elsif ($s1 == $cpg_state) {
        if ($n == 'a') {
            return 0.25;
        }
        elsif ($n == 't') {
            return 0.25;
        }
        elsif ($n == 'c') {
            return 0.25;
        }
        elsif ($n == 'g') {
            return 0.25;
        }
        else {
            die "(p_state_given_nucleotide): unknown nucleotide $n";
        }
    }
    else {
        die "(p_state_given_nucleotide): unknown state $s1";
    }
}

