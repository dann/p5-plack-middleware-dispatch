use inc::Module::Install;
name 'Plack-Middleware-Dispatch';
all_from 'lib/Plack/Middleware/Dispatch.pm';

requires(
    'Plack' => 0,
);

test_requires(
    'Test::More'                   => 0,
    'Test::LoadAllModules'         => 0,
);

use_test_base;
auto_include;
WriteAll;
