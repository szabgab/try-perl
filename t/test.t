use strict;
use warnings;
use Test::More;

use lib '.';
use t::MyTools qw(capture);

my $tests;
plan tests => $tests;
BEGIN { $tests += 0; }

diag "Perl Version '$]'";
diag "Test::More Version $Test::More::VERSION";

{
    my ($out, $err, $exit) = capture("$^X t/bin/stricture.pl");
    #diag $err;
    if ($] >= '5.022') {
        is $exit, 255, 'exit';
        is index($err, q{Global symbol "$x" requires explicit package name (did you forget to declare "my $x"?)}), 0, 'stderr';
    } elsif ($] >= '5.012') {
        is $exit, 255, 'exit';
        is index($err, q{Global symbol "$x" requires explicit package name}), 0, 'stderr';
    } else {
        is $exit, 9, 'exit';
        is index($err, q{Perl v5.12.0 required--this is only v5.10.}), 0, 'stderr';
    }

    is $out, '', 'STDOUT is empty';
    BEGIN { $tests += 3; }
}

{
    my ($out, $err, $exit) = capture("$^X t/bin/push_on_scalar.pl");
    #diag $err;
    if ($] >= '5.024') {
        is $out, '', 'stdout';
        is $exit, 255, 'exit';
        is index($err, q{Experimental push on scalar is now forbidden}), 0, 'stderr';
    } elsif ($] >= '5.020') {
        is $out, 'Foo Bar Moo', 'stdout';
        is $exit, 0, 'exit';
        is index($err, q{push on reference is experimental}), 0, 'stderr'; # looks like a warning
    } elsif ($] >= '5.014') {
        is $out, 'Foo Bar Moo', 'stdout';
        is $exit, 0, 'exit';
        is $err, '', 'stderr';
    } else {
        is $out, '', 'stdout';
        is $exit, 255, 'exit';
        is index($err, q{Type of arg 1 to push must be array (not private variable)}), 0, 'stderr';
    }
    BEGIN { $tests += 3; }
}

{
    my ($out, $err, $exit) = capture("$^X t/bin/signatures.pl");
    #diag $err;
    if ($] >= '5.020') {
        is $exit, 0, 'exit';
        is $err, '', 'stderr';
        is $out, 'You passed me Hello and World and these: 1 2 3', 'stdout';
    } else {
        is $exit, 2, 'exit';
        is index($err, q{Can't locate experimental.pm}), 0, 'stderr';
        is $out, '', 'stdout';
    }
    BEGIN { $tests += 3; }
}

{
    my ($out, $err, $exit) = capture("$^X t/bin/defined_array.pl");
    if ($] >= '5.022') {
        is $exit, 255, 'exit';
        is index($err, q{Can't use 'defined(@array)' (Maybe you should just omit the defined()?)}), 0, 'stderr';
        is $out, '', 'stdout';
    } else {
        is $exit, 0, 'exit';
        is index($err, q{defined(@array) is deprecated}), 'stderr';
        is $out, '', 'stdout';
    }
    #diag $err;
    BEGIN { $tests += 3; }
}

{
    my ($out, $err, $exit) = capture("$^X t/bin/defined_hash.pl");
    if ($] >= '5.022') {
        is $exit, 255, 'exit';
        is index($err, q{Can't use 'defined(%hash)' (Maybe you should just omit the defined()?)}), 0, 'stderr';
        is $out, '', 'stdout';
    } else {
        is $exit, 0, 'exit';
        is index($err, q{defined(%hash) is deprecated}), 'stderr';
        is $out, '', 'stdout';
    }
    #diag $err;
    BEGIN { $tests += 3; }
}

