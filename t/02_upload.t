#!/usr/bin/env perl

use strict;
use warnings;

use autodie;
use Config::General;
use Data::Dumper;
use Test::More;

use App::DreamObjects;

my $configfile = "./.default_test_config_file";
die if ! -e $configfile;

my $do = App::DreamObjects->new();

$do->load_config( $configfile  );
$do->connect();

SKIP: {
    skip "Need credentials to connect to dreamobjects", 1
        if !$do->{ bucket };

    my $filename = "/home/todo_devel/devel/DreamObjects/dist.ini" ;
    ok($do->upload( $filename ));

}

done_testing;


