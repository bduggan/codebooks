#!/usr/bin/env perl6

use lib '.';

use Log::Async;
use Cell;
use Grid;

unit sub MAIN(
  Bool :d(:$debug) = False,
  Bool :x(:$show-distances),
  Str  :a(:$algorithm) = 'binary',
  Int  :r($rows) = 9,
  Int  :c($cols) = 9,
);

my $level = INFO;
$level = DEBUG if $debug;
logger.send-to($*ERR, :$level);

my $g = Grid.new(:$rows, :$cols, :$show-distances);

given $algorithm {
  when 'binary' {
    $g.each-cell: -> $c {
      my @cells = grep *.defined, ( $c.n, $c.e );
      my $link = @cells.pick;
      $c.link($link) if $link;
      die "failed to link" if $link && not $c.linked($link);
    }
  }
  when 'alduous' {
    my $seen = 1;
    my $cell = $g.random-cell;
    my $want = $rows * $cols;
    debug "generating";
    while $seen < $want {
      debug "count: $seen < $want";
      my $next = $cell.neighbors.pick;
      unless $next.links > 0 {
        $cell.link($next);
        $seen++;
      }
      $cell = $next;
    }
  }
  default {
    exit note "unknown algorithm $algorithm";
  }
}

$g.choose-start-and-end;

$g.analyze;

$g.solve;
put $g;
