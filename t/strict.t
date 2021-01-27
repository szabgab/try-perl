use strict;
use warnings;
use Test::More;

my $tests;

plan tests => $tests;

use lib '.';
use t::MyTools qw(capture);

diag "Perl Version '$]'";

{
    my ($out, $err, $exit) = capture("$^X t/bin/stricture.pl");
    #diag $err;
    if ($] >= '5.022') {
        is $exit, 255;
        is index($err, q{Global symbol "$x" requires explicit package name (did you forget to declare "my $x"?)}), 0, 'stderr';
    } elsif ($] >= '5.012') {
        is $exit, 255;
        is index($err, q{Global symbol "$x" requires explicit package name}), 0, 'stderr';
    } else {
        is $exit, 9;
        is index($err, q{Perl v5.12.0 required--this is only v5.10.}), 0, 'stderr';
    }

    is $out, '', 'STDOUT is empty';
    BEGIN { $tests = 3; }
}


