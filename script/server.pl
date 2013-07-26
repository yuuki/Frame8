#!/usr/bin/env perl
use strict;
use warnings;

use lib 'lib';

use Getopt::Long qw(:config no_ignore_case pass_through);
use Proclet;

GetOptions(
    \my %opts, qw(
        enable-kyt-prof
    )
);

$ENV{DEBUG} = 1 unless defined $ENV{DEBUG};
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;
$ENV{FRAME8_TMPL_ACCESS_LOG} = 'log/access_log';
$ENV{FRAME8_TMPL_ERROR_LOG}  = 'log/error_log';

if ($opts{'enable-kyt-prof'}) {
    require Devel::KYTProf;
    Devel::KYTProf->namespace_regex(qr/^Frame8::Tmpl?/);
}

our $runner = Proclet->new(color => 1);


$runner->service(
    code => sub {
        my $plack_runner = Plack::Runner::Frame8::Tmpl->new;
        $plack_runner->parse_options(
            '--port' => 3000,
            '--app' => 'script/app.psgi',
            '--Reload' => join(',', glob 'lib modules/*/lib'),

            '--server' => 'Starlet',
            '--max-workers' => 10,

            @ARGV,
        );
        $ENV{RIDGE_ENV} = $plack_runner->{env}; # -E は RIDGE_ENV に伝播
        $plack_runner->{env}  = 'development'; # PLACK_ENV は development 固定 (このスクリプトは開発時にしか使わないので)

        my $options = +{ @{ $plack_runner->{options} } };
        $ENV{SERVER_PORT} = $options->{port};
        $plack_runner->run;
    },
    tag => 'web',
);

$runner->run;


package Plack::Runner::Frame8::Tmpl;
use strict;
use warnings;
use parent 'Plack::Runner';
use Plack::Runner;
use Plack::Builder;

sub prepare_devel {
    my ($self, $app) = @_;

    $app = Plack::Runner::build {
        my $app = shift;

        builder {
            enable 'Lint';
            enable 'StackTrace';

            mount '/'   => $app;
        };
    } $app;

    push @{$self->{options}}, server_ready => sub {
        my($args) = @_;
        my $name  = $args->{server_software} || ref($args); # $args is $server
        my $host  = $args->{host} || 0;
        my $proto = $args->{proto} || 'http';
        print STDERR "$name: Accepting connections at $proto://$host:$args->{port}/\n";
    };

    $app;
}
