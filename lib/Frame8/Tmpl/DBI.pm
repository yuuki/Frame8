package Frame8::Tmpl::DBI;
use utf8;
use strict;
use warnings;
use parent qw(Scope::Container::DBI);
use Carp qw(croak);

use Frame8::Tmpl::Config;

sub connect {
    my ($class, $name) = @_;

    my $dbconfig = Frame8::Tmpl::Config->param("db.$name")
        or croak "Not found db config: $name";
    my $dsn  = $dbconfig->{dsn}    or croak 'Not found dsn';
    my $user = $dbconfig->{user}   or croak 'Not found user';
    my $pass = $dbconfig->{passwd} or croak 'Not found passwd';

    my $dbh = $class->SUPER::connect($dsn, $user, $pass,
        {
            RootClass           => 'DBIx::Sunny',
            RaiseError          => 1,
            PrintError          => 0,
            ShowErrorStatement  => 1,
            AutoInactiveDestroy => 1,
            mysql_enable_utf8   => 1,
        }
    );
    return $dbh;
}

1;
