use strict;
use warnings;
#use 5.010;

use experimental 'signatures';

sub func ($param1, $param2 = 1, @rest) {
    print "You passed me $param1 and $param2 and these: @rest";
}

func("Hello", "World", 1, 2, 3);
