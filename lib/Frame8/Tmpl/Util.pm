package Frame8::Tmpl::Util;
use utf8;
use strict;
use warnings;

use DateTime;
use DateTime::Format::MySQL;
use DateTime::Format::W3CDTF;
use SQL::NamedPlaceholder qw(bind_named);

our $DATABASE_TIME_ZONE = 'Asia/Tokyo';

sub now () {
    my $now = DateTime->now(time_zone => $DATABASE_TIME_ZONE);
    $now->set_formatter( DateTime::Format::MySQL->new );
    $now;
}

sub hash_by {
    my ($key, $array) = @_;

    my $code;
    if (ref $key eq 'CODE') {
        $code = $key;
    } else {
        $code = sub { $_->$key };
    }

    return +{
        map { +( $code->() => $_ ) } @$array
    };
}

1;
