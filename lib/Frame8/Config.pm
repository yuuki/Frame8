package Frame8::Config;
use utf8;
use strict;
use warnings;

use Config::ENV 'PLACK_ENV';
use Path::Class qw(file);

use Frame8::Config::Route;

my $ROOT   = file(__FILE__)->parent->parent->parent->absolute,
my $ROUTER = $Frame8::Config::Route::Router;

sub root {
    my ($self) = @_;
    $self->param('root');
}

sub router {
    my ($self) = @_;
    $self->param('router');
}

common +{
    root   => $ROOT,
    router => $ROUTER,
    service_name => 'Frame8',
};

config development => +{
    'db.frame8' => {
        dsn    => 'dbi:mysql:dbname=frame8;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

config test => +{
    'db.frame8' => {
        dsn    => 'dbi:mysql:dbname=frame8_test;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

config production => +{
    'db.frame8' => {
        dsn    => 'dbi:mysql:dbname=frame8;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

1;
