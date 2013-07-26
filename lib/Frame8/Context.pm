package Frame8::Context;
use utf8;
use strict;
use warnings;
use v5.14;

use Plack::Session;

use Frame8::Config;
use Frame8::DBManager;
use Frame8::Request;
use Frame8::Views;

use Class::Accessor::Lite::Lazy (
    new => 1,
    ro => [ 'env' ],
    ro_lazy => [qw(
        request
        response
        route
        db
        session
    )],
    rw_lazy => [ qw() ],
);

*req = \&request;
*res = \&response;

sub from_env {
    my ($class, $env) = @_;
    return $class->new(env => $env);
}

sub _build_request {
    my $self = shift;
    return Frame8::Request->new($self->env);
}

sub _build_response {
    my $self = shift;
    return $self->request->new_response(200);
}

sub _build_route {
    my $self = shift;
    return Frame8::Config->router->match($self->env);
}

sub _build_session {
    my $self = shift;
    return Plack::Session->new($self->env);
}

sub _build_db {
    return Frame8::DBManager->new;
}

sub dbh {
    my $self = shift;
    return $self->db->dbh(@_);
}

sub error {
    my ($self, $code, $message, %opts) = @_;
    Frame8::Error->throw(code => $code, message => $message, %opts);
}

sub redirect {
    my ($self, $location, %opts) = @_;
    Frame8::Error->throw(code => 302, location => $location, %opts);
}

1;
