#!/usr/bin/env perl

use strict;
use warnings;

use autodie;
use Config::General;
use Data::Dumper;
use Test::More;
use Test::Exception;

use App::DreamObjects;

my $configfile = "./.default_test_config_file";
unlink $configfile if -e $configfile;

my $do = App::DreamObjects->new();

throws_ok {
    $do->parse_options( "-configfile" , $configfile );
    $do->run();
} qr/config/, "config file does not exists";

# Bootstrap the configuration
{
    open my $fh , ">", $configfile;
    while(<DATA>){
        print $fh $_;
    }
    close $fh;
}

my $doconf = App::DreamObjects->new();

$doconf->parse_options( "-configfile" , $configfile );
$doconf->load_config();

is( $doconf->{ config }{ access_key }, "seed", "access key value ok" );
is( $doconf->{ config }{ secret_key }, "plant", "secret key value ok" );

throws_ok {
    $doconf->run();
}qr/argument/ , "No file to upload passed as argument";

done_testing;

=head1

my $confobj = Config::General->new( $configfile );

my %config = $confobj->getall;

ok(1,"Just to pass the test");

diag Dumper \%config;

=cut



__DATA__
access_key seed
secret_key plant
