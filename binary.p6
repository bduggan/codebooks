#!/usr/bin/env perl6

use lib '.';
use Cell;
use Grid;

my $g = Grid.new(:9rows, :9cols);

$g.each-cell: -> $c {
  my @cells = grep *.defined, ( $c.n, $c.e );
  my $link = @cells.pick;
  $c.link($link) if $link;
  die "failed to link" if $link && not $c.linked($link);
}

$g.random-cell.content = '🧀';
$g.random-cell.content = '🐁';
put $g;
