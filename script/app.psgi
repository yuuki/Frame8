use utf8;
use strict;
use warnings;
use v5.14;
use lib 'lib';

use DBI;
use Path::Class qw(file);
use Plack::Builder;
use Plack::Session::Store::DBI;

use Frame8::Tmpl;
use Frame8::Tmpl::Config;

my $root = Frame8::Tmpl::Config->root;

builder {
    enable 'ReverseProxy';

    enable 'Static', path => qr<^/(?:images|js|css|file)/>, root => $root->subdir('static')->stringify;
    enable 'Static', path => qr<^/favicon\.ico$>, root => $root->subdir('static', 'images')->stringify;

    enable 'AccessLog::Timed',
        format => join("\t",
            "time:%t",
            "host:%h",
            "req:%r",
            "status:%>s",
            "size:%b",
            "referer:%{Referer}i",
            "ua:%{User-Agent}i",
            "taken:%D",
            "runtime:%{X-Runtime}o",
        );

    enable 'Scope::Container';

    enable 'Session', (
        store => Plack::Session::Store::DBI->new(
            get_dbh => sub {
                DBI->connect(
                    Frame8::Tmpl::Config->param('db.frame8_tmpl'),
                    'nobody',
                    'nobody',
                );
            },
            table_name => 'plack_session',
        )
    );

    Frame8::Tmpl->to_app;
};
