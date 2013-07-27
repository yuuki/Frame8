package Frame8::Tmpl::DBManager;
use utf8;
use strict;
use warnings;

use Carp;
use UNIVERSAL::require;
use Scope::Container::DBI;
use Class::Accessor::Lite::Lazy new => 1;

use Argyle::Proxy::DBI;
use Frame8::Tmpl::Util;

sub dbh {
    my ($self, $name) = @_;
    my $dbh = Argyle::Proxy::DBI->connect($name);
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

sub query {
    my ($self, %opts) = @_;

    ($opts{sql}, $opts{bind}) = Argyle::Proxy::Util::bind_named($opts{sql}, $opts{bind} || {});

    $self->query_nonamed(%opts);
}

sub query_nonamed {
    my ($self, %opts) = @_;

    my $sql  = $opts{sql};
    my $bind = $opts{bind};

    $self->dbh($opts{db})->prepare_cached($sql)->execute(@$bind);
}

1;
