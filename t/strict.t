use strict;
use warnings;
use Test::More tests => 3;
use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

diag "Perl Version '$]'";

my ($out, $err, $exit) = capture("$^X t/bin/stricture.pl");
is $exit, 255;
diag $err;
is index($err, q{Global symbol "$x" requires explicit package name (did you forget to declare "my $x"?)}), 0;
#diag index($err, q{Execution of t/stricture.pl aborted due to compilation errors.});
#
is $out, '', 'STDOUT is empty';

sub capture {
    my ($cmd) = @_;
    my $outfile = File::Spec->catfile($dir, 'out');
    my $errfile = File::Spec->catfile($dir, 'err');
    my $exit = system "$cmd > $outfile 2> $errfile";

    local $/ = undef;

    open my $fherr, '<', $errfile or die;
    my $err = <$fherr>;
    close $fherr;

    open my $fhout, '<', $outfile or die;
    my $out = <$fhout>;
    close $fhout;
    return $out, $err, $exit/256;
}


