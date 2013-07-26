package Frame8::Tmpl::Config::Route;
use utf8;
use strict;
use warnings;
use Router::Simple;

our $Router = Router::Simple->new;

sub route ($$;$) { $Router->connect(shift, { action => shift }, shift) }

# example
route '/' => 'Frame8::Tmpl::Engine::Index index';

1;
