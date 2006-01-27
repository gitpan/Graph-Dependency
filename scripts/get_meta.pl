#!/usr/bin/perl -w

use strict;

my $module = shift;

die ("Need a module name") unless $module;

# turn "Foo::Bar" into "Foo-Bar"
$module =~ s/::/-/g;

# return early if the META.yml file already exists

exit if -f "tmp/$module-META.yml";

my $url = "http://search.cpan.org/search?query=$module&mode=dist";

# search for the module to get the author name
my $rc = `wget '$url' -o /tmp/wget.log -O tmp/index.html`;

# grep for the module
$rc = `grep 'author.*$module' tmp/index.html`;
$rc =~ /\/author\/(\w+)\//; my $author = $1;

if (!defined $author)
  {
  # try again with: "<p><a href="/author/PMQS/"
  $rc = `grep '\/author\/' tmp/index.html`;
  $rc =~ /\/author\/(\w+)\//; $author = $1;
  }

die ("Couldn't find author for module $module") unless $author;

unlink 'tmp/index.html';

print "Found author $author for module $module.\n";

# get the meta file
$rc = `perl scripts/get.pl '$module' '$author'`;

