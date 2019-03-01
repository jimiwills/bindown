#!/usr/local/bin/perl
#
use strict;
use warnings;

# might add some flags here later...

# get filenames
my @files = map {glob $_} @ARGV;

foreach (@files){
	bindown($_);
}

sub bindown {
	my ($fn) = @_;
	my $c = slurp($fn);
	
	my $hex = '';

	my @blocks = split /\n\s*\n/,$c;

	foreach(@blocks){
		if(/^( {0,3})\S/m){
			# text
		}
		else {
			# code
			s/;.*//g; # comments with ;
			s/h\b//g;
			s/\b0x//g;
			s/\s+//g;
			die "$fn: illegal characters in $_"
				if /[^a-fA-f0-9]/;
			$hex .= $_;
		}
	}

	open(my $fo, '>', "$fn.bin") or die "Could not write $fn.bin: $!";
	binmode($fo);
	print $fo pack 'H*', $hex;
	close($fo);
}


sub slurp {
	my ($fn) = @_;
	local $/;
	$/ = undef;
	open(my $fh, '<', $fn) or die "Could not read $fn: $!";
	my $file = <$fh>;
	close($fh);
	return $file;
}

