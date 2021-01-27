use strict;
use warnings;
use Test::More tests => 2;

my ($out, $err, $exit) = capture("$^X t/bin/stricture.pl > out 2> err");
is $exit, 255;
is index($err, q{Global symbol "$x" requires explicit package name (did you forget to declare "my $x"?)}), 0;
#diag index($err, q{Execution of t/stricture.pl aborted due to compilation errors.});

sub capture {
    my ($cmd) = @_;
    my $exit = system $cmd;

    local $/ = undef;

    open my $fherr, '<', 'err' or die;
    my $err = <$fherr>;
    close $fherr;

    open my $fhout, '<', 'out' or die;
    my $out = <$fhout>;
    close $fhout;
    return $out, $err, $exit/256;
}


