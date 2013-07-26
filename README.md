# NAME

Frame8 - My WAF templates

# SYNOPSIS

    dim init app

# DESCRIPTION

Frame8 is my original WAF templates for Dist::Maker.

Frame8 doesn't has library implementation and has only template implementation expanded to your project directory.

- Frame8                : Web request handling from Plack env.
- Frame8::Config        : Application global config by Config::ENV.
- Frame8::Config::Route : Routing config by Router::Simple.
- Frame8::Context       : Web and CUI common object.
- Frame8::Views         : Text::Xslate and my utility.
- Frame8::Engine        : Controller.
- Frame8::Service       : SQL execution and wrap with Model.
- Frame8::Model         : Model doesn't execute SQL.
- Frame8::DBManager     : DBI wrapper

# LICENSE

Copyright (C) y\_uuki.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

y\_uuki <yuuki@cpan.org>
