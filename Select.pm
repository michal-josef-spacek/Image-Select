package Image::Select;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use File::Basename qw(fileparse);
use File::Find::Rule;
use Imager;
use List::MoreUtils qw(none);

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Path to images.
	$self->{'path_to_images'} = undef;

	# Image type.
	$self->{'type'} = 'bmp';

	# Sizes.
	$self->{'height'} = 1080;
	$self->{'width'} = 1920;

	# Process params.
	set_params($self, @params);

	# Check type.
	if (defined $self->{'type'}) {
		$self->_check_type($self->{'type'});
	}

	# Load images.
	$self->{'_images_to_select'} = [
		File::Find::Rule->file->in($self->{'path_to_images'}),
	];
	$self->{'_images_index'} = 0;

	# Object.
	return $self;
}

# Create image.
sub create {
	my ($self, $path) = @_;

	# Load next image.
	my $i = Imager->new;
	# TODO Check if file exists.
	$i->read('file' => $self->{'_images_to_select'}->[$self->{'_images_index'}]);
	$self->{'_images_index'}++;

	# Get type.
	my $suffix;
	if (! defined $self->{'type'}) {

		# Get suffix.
		(my $name, undef, $suffix) = fileparse($path, qr/\.[^.]*/ms);
		$suffix =~ s/^\.//ms;

		# Jpeg.
		if ($suffix eq 'jpg') {
			$suffix = 'jpeg';
		}

		# Check type.
		$self->_check_type($suffix);
	} else {
		$suffix = $self->{'type'};
	}

	# TODO Resize.
#		'xsize' => $self->{'width'},
#		'ysize' => $self->{'height'},

	# Save.
	my $ret = $i->write(
		'file' => $path,
		'type' => $suffix,
	);
	if (! $ret) {
		err "Cannot write file to '$path'.",
			'Error', Imager->errstr;
	}

	return $suffix;
}

# Set/Get image sizes.
sub sizes {
	my ($self, $width, $height) = @_;
	if ($width && $height) {
		$self->{'width'} = $width;
		$self->{'height'} = $height;
	}
	return ($self->{'width'}, $self->{'height'});
}

# Set/Get image type.
sub type {
	my ($self, $type) = @_;
	if ($type) {
		$self->_check_type($type);
		$self->{'type'} = $type;
	}
	return $self->{'type'};
}

# Check supported image type.
sub _check_type {
	my ($self, $type) = @_;
	
	# Check type.
	if (none { $type eq $_ } ('bmp', 'gif', 'jpeg', 'png',
		'pnm', 'raw', 'sgi', 'tga', 'tiff')) {

		err "Suffix '$type' doesn't supported.";
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Image::Select - Perl class for creating random image.

=head1 SYNOPSIS

 use Image::Select;
 my $obj = Image::Select->new(%parameters);
 my $type = $obj->create($output_path);
 my ($width, $height) = $obj->sizes($new_width, $new_height);
 my $type = $obj->type($new_type);

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<height>

 Height of image.
 Default value is 1920.

=item * C<path_to_images>

 Path to images.
 Default value is undef.

=item * C<type>

 Image type.
 List of supported types: bmp, gif, jpeg, png, pnm, raw, sgi, tga, tiff
 Default value is undef.

=item * C<width>

 Width of image.
 Default value is 1080.

=back

=item C<create($path)>

 Create image.
 Returns scalar value of supported file type.

=item C<sizes([$width, $height])>

 Set/Get image sizes.
 Returns actual width and height.

=item C<type([$type])>

 Set/Get image type.
 Returns actual type of image.

=back

=head1 ERRORS

 new():
         Suffix '%s' doesn't supported.
         Class::Utils:
                 Unknown parameter '%s'.

 create():
         Cannot write file to '$path'.
                 Error, %s
         Suffix '%s' doesn't supported.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use File::Spec::Functions qw(catfile);
 use File::Temp qw(tempfile tempdir);
 use Image::Select;
 use Image::Random;

 # Temporary directory to random images.
 my $tempdir = tempdir(CLEANUP => 1);

 # Create temporary images.
 my $rand = Image::Random->new;
 for my $i (1 .. 5) {
         $rand->create(catfile($tempdir, $i.'.png'));
 }

 # Object.
 my $obj = Image::Select->new(
         'path_to_images' => $tempdir,
 );

 # Temporary file.
 my (undef, $temp) = tempfile();

 # Create image.
 my $type = $obj->create($temp);

 # Print out type.
 print $type."\n";

 # Unlink file.
 unlink $temp;

 # Output:
 # bmp

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<File::Basename>,
L<Imager>,
L<List::MoreUtils>.

=head1 SEE ALSO

L<Image::Random>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
