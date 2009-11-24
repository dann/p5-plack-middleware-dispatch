use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plack::Middleware::Dispatch/],
    style   => 'light';
ok_dependencies();
