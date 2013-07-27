package Frame8::Tmpl::Engine::Index;
use utf8;
use strict;
use warnings;

sub index {
    my ($class, $c) = @_;

    $c->html('index.tt', {});
}

1;
