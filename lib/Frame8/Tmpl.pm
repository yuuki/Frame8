package Frame8::Tmpl;
use utf8;
use strict;
use warnings;
use v5.14;

our $VERSION = "0.01";

use Carp ();
use Module::Load ();
use Scalar::Util qw(blessed);
use Scope::Container;
use Try::Tiny;

use Frame8::Tmpl::Context;
use Frame8::Tmpl::Error;
use Frame8::Tmpl::Logger;

sub to_app {
    my $class = shift;
    return sub {
        my $env = shift;
        return $class->handle_request($env);
    };
}

sub handle_request {
    my ($class, $env) = @_;

    my $context = Frame8::Tmpl::Context->from_env($env);
    scope_container context => $context if in_scope_container;

    my $route = $context->route;

    my ($engine, $action) = split /\s+/, $route->{action};

    try {
        $class->before_dispatch($context);

        unless ($engine->can($action)) {
            $context->error(404 => "Not Found action. $action");
        }
        Module::Load::load $engine;

        $engine->$action($context);

        $class->after_dispatch($context);
    } catch {
        my $e = $_;

        if (blessed $e && $e->isa('Frame8::Tmpl::Error')) {
            my $res = $context->response;
            $res->code($e->{code});
            $res->header('X-Error-Message' => $e->{message}) if $e->{message};
            $res->content_type('text/plain');

            if (defined $e->{location}) {
                $res->header('Location' => $e->{location});
            }

            unless (defined $res->content) {
                $res->content($e->{message});

                eval {
                    my $name = $e->{html} || $e->{code} . '.html';
                    $context->html($name,
                        message => $e->{message},
                        %{ $e->{stash} || {} }
                    );
                };
                if ($@) {
                    WARN $@;
                }
            }

            $res->headers->header(X_Dispatch => $engine);

            return $res->finalize;
        }
        else {
            CRIT "%s", $e;
            die $e;
        }
    };

    my $res = $context->response;

    $res->headers->header(X_Dispatch => $engine);

    return $res->finalize;
}

sub before_dispatch {
    my ($class, $c) = @_;
}

sub after_dispatch {
    my ($class, $c) = @_;
}

1;
__END__

=encoding utf-8

=head1 NAME

Frame8::Tmpl - My WAF templates

=head1 SYNOPSIS

    dim init app

=head1 DESCRIPTION

Frame8::Tmpl is my original WAF templates for Dist::Maker.

Frame8::Tmpl doesn't has library implementation and has only template implementation expanded to your project directory.

=over 4

=item Frame8::Tmpl                : Web request handling from Plack env.

=item Frame8::Tmpl::Config        : Application global config by Config::ENV.

=item Frame8::Tmpl::Config::Route : Routing config by Router::Simple.

=item Frame8::Tmpl::Context       : Web and CUI common object.

=item Frame8::Tmpl::Views         : Text::Xslate and my utility.

=item Frame8::Tmpl::Engine        : Controller.

=item Frame8::Tmpl::Service       : SQL execution and wrap with Model.

=item Frame8::Tmpl::Model         : Model doesn't execute SQL.

=item Frame8::Tmpl::DBManager     : DBI wrapper

=back

=head1 LICENSE

Copyright (C) y_uuki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

y_uuki E<lt>yuuki@cpan.orgE<gt>

=cut

