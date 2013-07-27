package t::frame8test;
use v5.14;
use utf8;
use strict;
use warnings;
use lib lib => 't/lib';

BEGIN {
    unless ($ENV{PLACK_ENV}) {
        $ENV{PLACK_ENV} = 'test';
    }
    if ($ENV{PLACK_ENV} eq 'production') {
        die "Do not run a test script on production environment";
    }
}

use Exporter::Lite;
use Scope::Container;
use Test::More 0.98;

use Frame8::Tmpl::Context;
use Frame8::Tmpl::Model::Backend;
use Frame8::Tmpl::Model::Rrdfile;

our @EXPORT = qw(
    context
    mech
    create_backend
    create_rrdfile
);


sub import {
    feature->import(':5.14');
    utf8->import;
    strict->import;
    warnings->import;

    my ($class, @opts) = @_;
    my ($pkg, $file) = caller;
    my $code = qq[
        package $pkg;
        use parent 'Test::Class';
        use Test::Deep qw(cmp_deeply);
        use Test::Differences;
        use Test::Fatal qw(lives_ok dies_ok exception);
        use Test::More;

        END {
            if (\$0 eq "$file") {
                $pkg->runtests;
            }
        }
    ];

    eval $code;
    die $@ if $@;

    our $ScopeContainer = start_scope_container;

    @_ = ($class, @opts);
    goto &Exporter::Lite::import;
}

sub context () {
    unless (scope_container 'context') {
        require Frame8::Tmpl::Context;
        scope_container context => Frame8::Tmpl::Context->new;
    }
    return scope_container 'context';
}

sub mech (;$%) {
    require Frame8::Tmpl::Test::Mechanize;

    state $mech = Frame8::Tmpl::Test::Mechanize->new;
    return $mech;
}

1;
