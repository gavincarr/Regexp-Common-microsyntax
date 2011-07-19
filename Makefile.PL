use inc::Module::Install;

name     'Regexp-Common-microsyntax';
all_from 'lib/Regexp/Common/microsyntax.pm';
author   q{Gavin Carr <gavin@openfusion.com.au>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

