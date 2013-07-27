package Frame8::Tmpl::Types;
use utf8;
use strict;
use warnings;

use MouseX::Types -declare => [qw(
    UInt
)];
use MouseX::Types::Mouse qw(Num Int Str);

subtype UInt,
      as Int,
      where { $_ >= 0 },
      message { "$_ is not larger than equal 0" };

coerce UInt,
    from Num,
        via { 0+$_ };

1;
