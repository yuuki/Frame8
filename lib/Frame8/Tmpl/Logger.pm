package Frame8::Tmpl::Logger;
use utf8;
use strict;
use warnings;

use Log::Minimal ();
use Exporter::Lite;

our $PRINT ||= sub {
    my ( $time, $type, $message, $trace, $raw_message) = @_;
    warn "$time [$type] $message @ $trace\n";
};

$Log::Minimal::PRINT = sub { goto $PRINT };
$Log::Minimal::ENV_DEBUG = 'FRAME8_TMPL_DEBUG';
$Log::Minimal::AUTODUMP  = 1;

our @EXPORT = qw(DEBUG INFO WARN CRIT CROAK);

for my $level (@EXPORT) {
    no strict 'refs';
    *$level = Log::Minimal->can(lc $level . 'f');
}

1;
