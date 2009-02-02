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

    @cpg = ();
    @cpg_percentages = ();
    $threshold = .7;
    $window = 4;
    
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
read_nucleotides();
get_states();
slider();
print_islands();

# and this method will loop through the sequence
# giving the probabilityOf method the current base and
# next base?
sub get_states() {
    $probability = log(p_initial_state());
    
    # Assume we're not in the middle of an island for starters
    $current_state = $no_cpg_state;
    
    # print "sequence: @sequence\n";
    foreach( 0..@sequence-1 ) {
        # print "Nucleotide: $sequence[$_]\n";
        $p1 = p_state_given_nucleotide($cpg_state, lc($sequence[$_]));
        $p2 = p_state_given_nucleotide($no_cpg_state, lc($sequence[$_]));
        $trans_p1 = p_state_given_state($current_state, $cpg_state);
        $trans_p2 = p_state_given_state($current_state, $no_cpg_state);
        if( $p1*$trans_p1 > $p2*$trans_p2 ) {
            $current_state = $cpg_state;
        }
        else {
            $current_state = $no_cpg_state;
        }
        push (@state_values, $current_state);
        $probability = $probability + log(max($p1*$trans_p1, $p2*$trans_p2));
    }
}

# Reads in a text file containing pure nucleotide sequences
# (should we have a read_fasta as well?)
sub read_nucleotides() {
    open FILE, $filename or die $!;
    read(FILE, $tmp, -1);
    @sequence = split(//,$tmp); # this should split every character
}

sub slider {
    $size = @state_values;
    $win = $window;
    $win --;        #this alters the window size for an array (starts at 0)
    $size = $size-$win; # so if the $size is 100, and $win was 20, we get $size = 79 here
    for( 0 .. $size ){
        @tmp = @state_values[$_ .. $win+$_];
        $total = 0;
        ($total+=$_) for @tmp;
        $percent = $total/($win+1);
        # print "position: $_  Total: $total  Percentage: $percent\n";
        if($percent >= $threshold){
                push(@cpg, 1);
        }
        else {
                push(@cpg, 0);
        }
        push(@cpg_percentage, $percentage);
    }
}

sub print_islands() {
    print @state_values;
    print "\n";
    print @cpg;
    print "\n";
    print @cpg_percentage;
    print "\n";
    print "Threshold: $threshold  Window: $window\n";
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

