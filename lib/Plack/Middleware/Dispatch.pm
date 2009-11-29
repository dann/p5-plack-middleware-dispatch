package Plack::Middleware::Dispatch;
use strict;
use warnings;
our $VERSION = '0.01';
use parent qw(Plack::Middleware);
__PACKAGE__->mk_accessors(qw(mounts));

sub call {
    my $self = shift;
    my $env  = shift;

    my $script    = $env->{'PATH_INFO'};
    my $path_info = '';
    my $app;
    while ( $script =~ m{/} ) {
        if ( $app = $self->mounts->{$script} ) {
            $self->app($app);
            last;
        }
        my @items = split '/', $script;
        $script = join '/', @items[ 0 .. @items - 2 ];
        $path_info = "/" . $items[-1] . $path_info;
    }

    unless ($app) {
        $app
            = $self->mounts->{$script}
            ? $self->mounts->{$script}
            : $self->app;
        $self->app($app);
    }

    my $original_script_name = $env->{SCRIPT_NAME} ? $env->{SCRIPT_NAME} : '';
    $env->{'SCRIPT_NAME'} = $original_script_name . $script;
    $env->{'PATH_INFO'}   = $path_info;

    $self->app->($env);
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Dispatch - mount middlewares or application in a WSGI application. 

=head1 SYNOPSIS

  use Plack::Builder;
  builder {
      enable "Plack::Middleware::Dispatch",
          app => $app, 
          mounts => {
              '/app2' => $app2,
              '/app3' => $app3,
          };
  };

=head1 DESCRIPTION

Plack::Middleware::Dispatch allows one to mount middlewares or application 
in a WSGI application. This is useful if you want to combine multiple 
WSGI applications

=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 CONTRIBUTORS


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
