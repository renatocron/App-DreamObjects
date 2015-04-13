#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Test::More;

use_ok( "App::DreamObjects" );

my $do = App::DreamObjects->new();
is( ref $do, 'App::DreamObjects', "It is a DreamObjects object" );

done_testing;

