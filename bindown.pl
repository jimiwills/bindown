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
	
	my $blockid = 0;
	foreach(@blocks){
		$blockid ++;
		if(/^( {0,3})\S/m){
			# text
		}
		else {
			my $err = "ERR:\n$_\n======";
			# code
			s/;.*$//gm; # comments with ;
			$err .= "\ncomments removed\n$_\n======";
			s/h\b//g;
			$err .= "\nh removed\n$_\n======";
			s/\b0x//g;
			$err .= "\n0x removed\n$_\n======";
			s/\s+//g;
			$err .= "\nspace removed\n$_\n======";
			die "$err\n\n$fn: illegal characters in block $blockid"
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

