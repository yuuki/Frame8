package Frame8::Tmpl::DBI;
use utf8;
use strict;
use warnings;
use parent qw(Scope::Container::DBI);

use Frame8::Tmpl::Config;

sub connect {
    my ($class, $name) = @_;

    my $dsn = Frame8::Tmpl::Config->param("db.$name");
    my $dbh = $class->SUPER::connect($dsn, $user, $pass,
        RaiseError => 1, mysql_enable_utf8 => 1
    );
    $dbh->{private_dsn_name} = $name;
    $dbh->{private_time_zone} = AppConfig->time_zone($name);
    return $dbh;
}

1;
