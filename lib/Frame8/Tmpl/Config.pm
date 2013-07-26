package Frame8::Tmpl::Config;
use utf8;
use strict;
use warnings;

use Config::ENV 'PLACK_ENV';
use Path::Class qw(file);

use Frame8::Tmpl::Config::Route;

my $ROOT   = file(__FILE__)->parent->parent->parent->absolute,
my $ROUTER = $Frame8::Tmpl::Config::Route::Router;

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
    service_name => 'Frame8::Tmpl',
};

config development => +{
    'db.frame8tmpl' => {
        dsn    => 'dbi:mysql:dbname=frame8tmpl;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

config test => +{
    'db.frame8tmpl' => {
        dsn    => 'dbi:mysql:dbname=frame8tmpl_test;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

config production => +{
    'db.frame8tmpl' => {
        dsn    => 'dbi:mysql:dbname=frame8tmpl;host=localhost',
        user   => 'nobody',
        passwd => 'nobody',
    },
};

1;
