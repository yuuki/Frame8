package Frame8::Tmpl::DBManager;
use utf8;
use strict;
use warnings;

use Carp;
use UNIVERSAL::require;
use Scope::Container::DBI;
use Class::Accessor::Lite::Lazy new => 1;

use Frame8::Tmpl::Config;
use Frame8::Tmpl::Util;

sub dbh {
    my ($self, $name) = @_;
    my $dbconfig = Frame8::Tmpl::Config->param("db.$name") or croak "Not found db config: $name";
    my $dsn  = $dbconfig->{dsn}    or croak 'Not found dsn';
    my $user = $dbconfig->{user}   or croak 'Not found user';
    my $pass = $dbconfig->{passwd} or croak 'Not found passwd';

    my $dbh = Scope::Container::DBI->connect($dsn, $user, $pass, {});
    $dbh;
}

sub single {
    my ($self, %opts) = @_;

    ($opts{sql}, $opts{bind}) = Frame8::Tmpl::Util::bind_named($opts{sql}, $opts{bind} || {});

    $self->single_nonamed(%opts);
}

sub single_nonamed {
    my ($self, %opts) = @_;
    $opts{class}->require or die $@ if $opts{class};

    my $sql = $opts{sql};
    my $bind = $opts{bind};

    my $res = $self->dbh($opts{db})->selectrow_hashref($sql, {}, @$bind);
    $res or return '';

    if ($opts{class}) {
        bless $res, $opts{class};
    } else {
        $res;
    }
}

sub search {
    my ($self, %opts) = @_;

    ($opts{sql}, $opts{bind}) = Frame8::Tmpl::Util::bind_named($opts{sql}, $opts{bind} || {});

    $self->search_nonamed(%opts);
}

sub search_nonamed {
    my ($self, %opts) = @_;
    $opts{class}->require or die $@ if $opts{class};

    my $sql  = $opts{sql};
    my $bind = $opts{bind};

    my $res = $self->dbh($opts{db})->selectall_arrayref($sql, { Slice => {} }, @$bind);
    if ($opts{class}) {
        [
            map {
                bless $_, $opts{class};
            }
            @$res
        ]
    } else {
        $res;
    }
}

1;
