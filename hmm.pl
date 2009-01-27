#!bin/usr/perl

use List::Util qw[min max];  #this allows us to use max function

#variables that we'll need
#read in the parameters from a file
        #state probabilities
        
$window = shift;    #variable to read in window size from command line 
$cpg_island_threshold = shift;
$filename = shift;

@sequence = ();
@state_values = ();
$cpg_state = 1;
$no_cpg_state = 0;


#Here we'll each write our own code to actually use all of the methods


sub get_states(){    #and this method will loop through the sequence
                     #giving the probabilityOf method the current base and
                      #next base?
    
    $probability = 1.0;
    $currentState = pInitialState();
    push @state_values,$currentState; #is this right? 
    foreach( 0..@sequence-1 ){
        $p1 = p_state_given_nucleotide($cpg_state, $sequence[$_]);
        $p2 = p_state_given_nucleotide($no_cpg_state, $sequence[$_]);
        if( $p1 > $p2 ){
            push (@state_values, $cpg_state);
        }
        else{
            push ($state_values, $no_cpg_state);
        }
        $probability = $probability + log(max($p1, $p2));
    }
}

#method to return the state given the current base and next base


# Reads in a text file containing pure nucleotide sequences
# (should we have a readFasta as well?)
sub read_nucleotides($filename) {
    open FILE, $filename or die $!;
    $tmp = FILE;
    @sequence = split(//,$tmp); #this should split every character
}

sub slider($window) { #so this method will just check the @state_values
                     #using a given threshold (the threshold will be a %?
                     # (percentage will be held in $cpg_island_threshold)
}

# this is the "beginning state" probability table
sub p_initial_state(s) {
    return 0.5;
}

# this is the "state given a current state" probability table
sub p_state_given_state(s1, s2) {
}

# this is the "state given a nucleotide" probability table
sub p_state_given_nucleotide(s1, n) {
}

