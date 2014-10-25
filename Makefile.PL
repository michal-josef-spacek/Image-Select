# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Perl class for creating image from images directory.';
author 'Michal Spacek <skim@cpan.org>';
license 'bsd';
name 'Image-Select';
readme_from 'Select.pm';
requires 'Class::Utils' => 0.03;
requires 'Error::Pure' => 0.11;
requires 'File::Find::Rule' => 0;
requires 'File::Find::Rule::MMagic' => 0;
requires 'File::Basename' => 0;
requires 'Imager' => 0;
requires 'List::MoreUtils' => 0;
requires 'perl' => '5.6.0';
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Image-Select';
resources 'homepage' => 'https://github.com/tupinek/Image-Select';
resources 'repository' => 'git://github.com/tupinek/Image-Select';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.05;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
