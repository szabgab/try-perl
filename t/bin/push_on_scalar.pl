use strict;
use warnings;

my $names = [qw(Foo Bar)];
push $names, 'Moo';
print "@$names\n";
