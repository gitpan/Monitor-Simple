use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Monitor::Simple',
    AUTHOR              => q{Martin Senger <martin.senger@gmail.com>},
    VERSION_FROM        => 'lib/Monitor/Simple.pm',
    ABSTRACT_FROM       => 'lib/Monitor/Simple.pm',
    EXE_FILES           => ['bin/smonitor'],
    PL_FILES            => {},
    PREREQ_PM => {
	'version'               => 0.77,
        'Test::More'            => 0,
	'File::Basename'        => 0,
	'File::Spec'            => 0,
	'Log::Log4perl'         => 0,
	'Getopt::Long'          => 0,
	'Pod::Usage'            => 0,
	'Parallel::ForkManager' => 0,
	'IO::CaptureOutput'     => 0,
	'Time::HiRes'           => 0,
	'XML::Simple'           => 0,
	'Fcntl'                 => 0,
	'LWP::UserAgent'        => 0,
	'File::Temp'            => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Monitor-Simple-*' },
);
