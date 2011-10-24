#!perl -w

#use Test::More qw(no_plan);
use Test::More tests => 37;

use File::Slurp;
use File::Temp qw/ tempfile /;

#-----------------------------------------------------------------
# Return a fully qualified name of the given file in the test
# directory "t/data" - if such file really exists. With no arguments,
# it returns the path of the test directory itself.
# -----------------------------------------------------------------
use FindBin qw( $Bin );
use File::Spec;
sub test_file {
    my $file = File::Spec->catfile ('t', 'data', @_);
    return $file if -e $file;
    $file = File::Spec->catfile ($Bin, 'data', @_);
    return $file if -e $file;
    return File::Spec->catfile (@_);
}

#-----------------------------------------------------------------
# Return a configuration extracted from the given file.
# -----------------------------------------------------------------
sub get_config {
    my $filename = shift;
    my $config_file = test_file ($filename);
    my $config = Monitor::Simple::Config->get_config ($config_file);
    ok ($config, "Failed configuration taken from '$config_file'");
    return $config;
}

# -----------------------------------------------------------------
# Tests start here...
# -----------------------------------------------------------------
ok(1);
use Monitor::Simple;
diag( "Testing external plugins" );

my $config = get_config ('plugins.xml');
my $config_file = test_file ('plugins.xml');

# report and exit (one by one); filter as SCALAR
{
    my $report_tests = {
	ok       => 0,
	warning  => 1,
	critical => 2,
	unknown  => 3,
    };
    
    foreach my $service (keys %$report_tests) {
	my ($fh, $filename) = tempfile();
	my $args = {
	    config_file => $config_file,
	    filter      => $service,
	    outputter   => Monitor::Simple::Output->new (outfile  => $filename,
							 'format' => 'tsv',
							 config   => $config),
	};
	Monitor::Simple->check_services ($args);
	my @fields = split (/\t/, read_file ($filename), 4);
	is ($fields[1], $service,                  "Plugin returns: service name");
	is ($fields[2], $report_tests->{$service}, "Plugin returns: return code");
	ok ($fields[3] =~ m{\U$service\E},         "Plugin returns: message");
	unlink $filename;
    }
}

# report and exit (in parallel); filters as HASH
{
    my ($fh, $filename) = tempfile();
    my $filters = {
    	ok       => 0,
    	warning  => 1,
    	critical => 2,
    	unknown  => 3,
    };
    my $args = {
	config_file => $config_file,
	filter      => $filters,
	outputter   => Monitor::Simple::Output->new (outfile  => $filename,
						     'format' => 'tsv',
						     config   => $config),
    };
    Monitor::Simple->check_services ($args);
    my @lines = read_file ($filename);
    is (scalar @lines, 4, "Number of parallel service checks");
    foreach my $line (@lines) {
	my @fields = split (/\t/, $line, 4);
	my $service = $fields[1];
	ok (exists $filters->{$service}, "Lost service?");
	is ($fields[2], $filters->{$service}, "Plugin returns 2: return code");
	ok ($fields[3] =~ m{\U$service\E}, "Plugin returns 2: message");
    }
    unlink $filename;
}

# report and exit (in parallel); filters as ARRAY
{
    my ($fh, $filename) = tempfile();
    my $filters = ['ok', 'warning', 'critical', 'unknown'];
    my $args = {
	config_file => $config_file,
	filter      => $filters,
	outputter   => Monitor::Simple::Output->new (outfile  => $filename,
						     'format' => 'tsv',
						     config   => $config),
    };
    Monitor::Simple->check_services ($args);
    my @lines = read_file ($filename);
    is (scalar @lines, 4, "Number of parallel service checks");
    foreach my $line (@lines) {
	my @fields = split (/\t/, $line, 4);
	my $service = $fields[1];
	ok ($fields[3] =~ m{\U$service\E}, "Plugin returns 3: message");
    }
    unlink $filename;
}

# plugin: check-prg.pl
{
    my ($fh, $filename) = tempfile();
    my $filters = {
    	prg     => 0,
    	prgbad  => 3,
    };
    my $outputter = Monitor::Simple::Output->new (outfile  => $filename,
						  'format' => 'tsv',
						  config   => $config);
    my $args = {
	config_file => $config_file,
	filter      => $filters,
	outputter   => $outputter,
    };
    Monitor::Simple->check_services ($args);
    $outputter->close();
    my @lines = read_file ($filename);
    is (scalar @lines, 2, "Number of check-prg checks");
    foreach my $line (@lines) {
	my @fields = split (/\t/, $line, 4);
	my $service = $fields[1];
	ok (exists $filters->{$service}, "Lost service? [$line]");
	is ($fields[2], $filters->{$service}, "check-prg: return code [$line]");
    }
    unlink $filename;
}

__END__
