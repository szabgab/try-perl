package t::MyTools;
use strict;
use warnings;

use File::Temp qw(tempdir);
use File::Spec::Functions qw(catfile);
use Exporter qw(import);

our @EXPORT_OK = qw(capture);

sub capture {
    my ($cmd) = @_;

    my $dir = tempdir( CLEANUP => 1 );
    my $outfile = catfile($dir, 'out');
    my $errfile = catfile($dir, 'err');
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


1;


