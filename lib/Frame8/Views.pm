package Frame8::Views;
use utf8;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(
    html
    json
    render
    render_string
    template
    html_template
);

use Text::Xslate qw(mark_raw html_escape);
use JSON::XS;
use Encode qw(encode_utf8);
use Path::Class;

use Frame8::Config;

my $XSLATE = Text::Xslate->new(
    syntax => 'TTerse',
    cache  => 1,
    path   => [
        Frame8::Config->root->subdir('templates')
    ],
    module => [
        'Text::Xslate::Bridge::TT2Like'
    ],
    html_builder_module => [
        'HTML::FillInForm::Lite' => [qw(fillinform)]
    ],
);

sub render {
    my ($self, $file, $vars) = @_;

    $vars ||= {};
    $vars->{c} = $self;
    return $XSLATE->render($file, $vars);
}

sub render_string {
    my ($self, $string, $vars) = @_;

    $vars ||= {};
    $vars->{c} = $self;
    return $XSLATE->render_string($string, $vars);
}

sub html {
    my ($self, $file, $vars) = @_;

    my $content = $self->render($file, $vars);
    $self->res->content_type('text/html; charset=utf-8');
    $self->res->content(encode_utf8 $content);
}

sub json {
    my ($self, $vars, %opts) = @_;

    my $body = JSON::XS->new->ascii(1)->encode($vars);
    $self->res->content_type('application/json; charset=utf-8');
    $self->res->content($body);
}

1;
