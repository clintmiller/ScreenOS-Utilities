#!/usr/bin/env perl

use strict;

print "\n";
print "****************************************\n";
print "** Welcome to ScreenOS IP Blacklister **\n";
print "****************************************\n\n";

my $AddrZone = "untrust";
my $BlacklistGroup = "Blacklist";
my $pbcopy = `which pbcopy`;

my %uniqIPs;

sub gatherIP {
	my $elems = scalar keys %uniqIPs;
	printf("[%d] Please enter an IP to blacklist: ", $elems + 1);
	chomp(my $ip = <>);
	my $retval = length($ip);
	if ($retval ne 0) {
		$uniqIPs{$ip} = 1;
	}
	$retval;
}

while (&gatherIP) { }

my $out = "";
while (my ($ip, $dummy) = each %uniqIPs) {
	$out .= "set addr $AddrZone BL($ip) $ip/32\n";
	$out .= "set group addr $AddrZone $BlacklistGroup add BL($ip)\n";
}
$out .= "save\n";

if (length($pbcopy) gt 0) {
	system("echo '$out' | $pbcopy");
}

print "\n/** ScreenOS config **/\n\n";
print $out;
print "\n/**END ScreenOS config **/\n\n";
