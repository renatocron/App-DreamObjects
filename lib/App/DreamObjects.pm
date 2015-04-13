package App::DreamObjects;

use strict;
use warnings;

use Amazon::S3;
use Config::General;
use File::Details;
use Getopt::Long;

# ABSTRACT: Simple command line client to Dreamhost objects

sub new {
    my ( $class ) = @_;

    return bless { }, $class;
}

sub load_config {
    my ( $self, $filename ) = @_;

    return if $self->{ config };

    if ( ! $self->{ configfile } ) {
        $self->{ configfile } = $ENV{ HOME } . "/" . ".dobjconfig";
    }

    $self->{ configfile } = $filename if ( $filename );

    if ( -e $self->{ configfile }  ){
        my $config = Config::General->new( $self->{ configfile } );
        $self->{ config } = { $config->getall };
    }else{
        die "config file does not exists";
    }
}

sub run {
    my ( $self ) = @_;

    $self->load_config();

    $self->connect();

    $self->upload( $self->{ filename } );
}

sub parse_options {
    my ( $self, @arguments ) = @_;

    local @ARGV = @arguments;

    GetOptions(
        'c|configfile=s'  => \$self->{ configfile },
    );

    if ( $ARGV[-1] ) {
        $self->{ filename } = $ARGV[-1];
    }
}

sub connect {
    my ( $self ) = @_;

    $self->{ connection } = Amazon::S3->new({
        aws_access_key_id       => $self->{ config }{ access_key },
        aws_secret_access_key   => $self->{ config }{ secret_key },
        host                    => "objects.dreamhost.com",
        retry                   => 1,
    });

    # by default it takes the last bucket
    my $buckets = $self->{ connection }->buckets();
    $self->{ bucket } = $buckets->{ buckets }[-1];
}

sub upload {
    my ( $self, $filename ) = @_;

    if ( !$filename ){
        die "No file to upload passed as argument";
    }
    if ( ! -e $filename ){
        die "File $filename does not exists";
    }
    my $details = File::Details->new( $filename );

    $self->{ bucket }->add_key_filename( $details->abspath(), $details->abspath(), { "X-agent" => "Perl dobj" });
}

sub exists {
    ...
}



1;
