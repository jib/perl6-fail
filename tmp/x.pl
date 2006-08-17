use Perl6::Fail;

use fatal;
use Data::Dumper;

{   no fatal;
    $x = eval { f->() };
    print "x = $x, eval = $@\n";

    print 'defined' if $x;
    #print 'true' if $x eq 'foo';
    print 'list' if f->();

    print join $/, map { $x->$_ } qw[message shortmess longmess];
}    
    
{   use fatal;
    $x = eval { f->() };
    print "x = $x, eval = $@\n";
}    
    
sub f { fail 'foo' }    
