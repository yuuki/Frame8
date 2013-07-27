package Argyle::Proxy::Test::Mechanize;
use utf8;
use strict;
use warnings;
use lib 'lib';
use parent qw(Test::WWW::Mechanize::PSGI);

BEGIN {
    $ENV{PLACK_ENV} = 'test';
}

use Scope::Container;
use Class::Accessor::Lite(
    ro => [ qw(context env) ],
);

use Argyle::Proxy;

sub new {
    my ($class, $user) = @_;

    my $self;
    my $app = sub {
        my $env = shift;
        $self->{env} = $env;

        my $scope = start_scope_container;
        my $res = Argyle::Proxy->handle_request($env);
        $self->{context} = scope_container('context');

        return $res;
    };

    $self = $class->SUPER::new(app => $app);
    return $self;
}

sub json {
    my $self = shift;

    require JSON::XS;
    return JSON::XS::decode_json($self->content);
}

1;
