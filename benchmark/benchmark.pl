#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib';

use Benchmark qw (:all);
use Storable qw(dclone);
use Struct::Diff qw(diff);
use Structs;

my $cloned = dclone($Structs::STRUCT1);

my ($DD, $DC);
eval "use Data::Diff qw(Diff)";
$DD = 1 unless ($@);

eval "use Data::Compare";
$DC = 1 unless ($@);

for my $type ('AoA', 'HoH', 'MIX') {
    my $rivals = {};
    $rivals->{"SD_${type}"} = sub { diff($Structs::STRUCT1->{"${type}"}, $cloned->{"${type}"}) };
    $rivals->{"DD_${type}"} = sub { Diff($Structs::STRUCT1->{"${type}"}, $cloned->{"${type}"}) } if ($DD);
    $rivals->{"DC_${type}"} = sub { Compare($Structs::STRUCT1->{"${type}"}, $cloned->{"${type}"}) } if ($DC);
    cmpthese (50, $rivals);
}
