#!/usr/bin/env perl6

use lib '.';

use Log::Async;
use Cell;
use Grid;

unit sub MAIN(
  Bool :d(:$debug) = False,
  Bool :x(:$show-distances)
);

my $level = WARNING;
$level = DEBUG if $debug;
logger.send-to($*ERR, :$level);

my $g = Grid.new(:9rows, :9cols, :$show-distances);

$g.each-cell: -> $c {
  my @cells = grep *.defined, ( $c.n, $c.e );
  my $link = @cells.pick;
  $c.link($link) if $link;
  die "failed to link" if $link && not $c.linked($link);
}

$g.choose-start-and-end;

$g.analyze;

put $g;
