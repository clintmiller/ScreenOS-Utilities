#!/usr/bin/env perl

use strict;

use Data::Validate::IP qw(is_ipv4);

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
	printf("[%d] Please enter an IP to blacklist or ^D when done: ", $elems + 1);
	chomp(my $ip = <>);
	return 0 if not defined $ip;
	$uniqIPs{$ip} = 1 if is_ipv4($ip);
	return 1;
}

while (&gatherIP) { }

if (scalar keys %uniqIPs eq 0) {
	print "\n\n";
	exit 1;
}

my $out = "";
while (my ($ip, $dummy) = each %uniqIPs) {
	$out .= "set addr $AddrZone BL($ip) $ip/32\n";
	$out .= "set group addr $AddrZone $BlacklistGroup add BL($ip)\n";
}
$out .= "save\n";

if (length($pbcopy) gt 0) {
	system("echo '$out' | $pbcopy");
}

print "\n\n/** ScreenOS config **/\n\n";
print $out;
print "\n/**END ScreenOS config **/\n\n";
