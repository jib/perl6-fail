package Perl6::Fail;

use strict;
use vars qw[$VERSION @EXPORT];

use Filter::Simple;
require Carp;

use base 'Exporter'; 
@EXPORT = qw[fail];

FILTER_ONLY executable => sub {
    s|(use fatal)|my \$___perl6_fail = Perl6::Fail->on|g;
    s|(no fatal)|my \$___perl6_fail = Perl6::Fail->off|g;
    
    print;
};

{   my $fatal = 0;
    
    sub on  { $fatal = 1; bless sub { 0 }, __PACKAGE__ }
    sub off { $fatal = 0; bless sub { 1 }, __PACKAGE__ }
    
    sub is_fatal { $fatal }
    sub DESTROY  { $fatal = $_[0]->() }

    sub fail { $fatal ? Carp::croak $_[0] : __PACKAGE__->_undef( $_[0] ) }
}    

sub _undef {
    my $class   = shift;
    my $msg     = shift;
   
    my $undef   = Perl6::Fail::Undef->new;
    
    local $Carp::CarpLevel = $Carp::CarpLevel + 2;
    
    $undef->message(    $msg                        );
    $undef->longmess(   _clean( Carp::longmess() )  );
    $undef->shortmess(  _clean( Carp::shortmess() ) );
    
    return $undef;
}    
    
sub _clean { map { s/\s*//; chomp; $_ } shift; }


package Perl6::Fail::Undef;

use base 'Class::Accessor';
use overload
    bool    => \&_undef,
    '""'    => \&_undef,
    '0+'    => \&_undef;


__PACKAGE__->mk_accessors(qw[message longmess shortmess]);
sub _undef { print "GOT HERE"; wantarray ? () : undef }

sub _clean { map { s/\s*//; chomp; $_ } shift; }

1;
