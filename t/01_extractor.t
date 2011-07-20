# Test with twitter-text-conformance extractor test data

use strict;
use Test::More;
use Test::Deep;
use YAML qw(LoadFile Dump);
use Encode qw(encode decode);

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
  my @got = ();
  while ($t->{text} =~ m/$RE{microsyntax}{hashtag}/go) {
#   my $got = substr($1, 1);
    my $got = substr("$1", 1);  # TODO: why does this fail if $1 is unquoted?!
#   print "got2: " . encode('UTF-8', $got) . "\n";
    push @got, $got;
  }
  cmp_deeply(\@got, $t->{expected}, $t->{description});

  last if $count and ++$c >= $count;
}

done_testing;

