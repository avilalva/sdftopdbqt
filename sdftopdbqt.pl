#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

# Specify the input and output directories
my $input_directory  = "Path/where/sdf/files/present";
my $output_directory = "path/to/output/pdbqt/files";  # Create a separate directory for PDBQT files

# Get a list of all SDF files in the input directory
my @sdf_files = glob("$input_directory/*.sdf");

# Loop through each SDF file and convert it to PDBQT
foreach my $sdf_file (@sdf_files) {
    # Extract the filename without the path and extension
    my ($filename, $directories) = fileparse($sdf_file, qr/\.[^.]*/);

    # Build the output PDBQT filename by replacing the extension
    my $pdbqt_file = "$output_directory/$filename.pdbqt";

    # Run Open Babel to convert SDF to PDBQT
    my $command = "obabel -isdf $sdf_file -opdbqt -O $pdbqt_file";
    system($command);

    # Check for errors in the conversion process
    if ($? == -1) {
        die "Error: Failed to execute Open Babel: $!\n";
    } elsif ($? & 127) {
        die "Error: Open Babel died with signal " . ($? & 127) . "\n";
    } else {
        my $exit_code = $? >> 8;
        if ($exit_code != 0) {
            die "Error: Open Babel exited with non-zero status $exit_code\n";
        }
    }

    print "Conversion successful: $sdf_file -> $pdbqt_file\n";
}

print "All conversions completed.\n";
