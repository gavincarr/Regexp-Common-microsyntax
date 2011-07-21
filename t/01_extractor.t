# Test with twitter-text-conformance extractor test data

use strict;
use Test::More;
use Test::Deep;
use YAML qw(LoadFile Dump);
use Encode qw(encode decode);
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Regexp::Common qw(microsyntax);

my $count = shift @ARGV;

# Mark Test::More's output fh's as utf8
# http://www.effectiveperlprogramming.com/blog/1226
binmode Test::More->builder->$_(), ':encoding(UTF-8)' for qw(output failure_output);

my ($data, $tests, $hashtag_tests);

ok($data = LoadFile("$Bin/twitter-text-conformance/extract.yml"),
  'extract.yml loaded ok');
ok($tests = $data->{tests},
  'tests found');

# Hashtag tests
ok($hashtag_tests = $tests->{hashtags},
  'hashtag tests found');
ok(ref $hashtag_tests eq 'ARRAY' && @$hashtag_tests > 0,
  'number of hashtag tests > 0: ' . scalar @$hashtag_tests);

#print encode('UTF-8', $RE{microsyntax}{hashtag}) . "\n";
my $c = 4;
for my $t (@$hashtag_tests) {
  my (@got, @got2);
  while ($t->{text} =~ m/$RE{microsyntax}{hashtag}{-keep => 1}/go) {
#   push @got, substr($1, 1);
    push @got, substr("$1", 1); # TODO: why does this fail if $1 is unquoted?!
    push @got2, $3;
    like($2, qr/^[#＃]$/, '$2 is a hash');
  }
  cmp_deeply(\@got,  $t->{expected}, "$t->{description} via \$1");
  cmp_deeply(\@got2, $t->{expected}, "$t->{description} via \$3");

  last if $count and ++$c >= $count;
}

done_testing;

