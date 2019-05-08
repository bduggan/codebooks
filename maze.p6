class Cell {
  has @.neighbors;
  has $.n;
  has $.s;
  has $.e;
  has $.w;
}
class Grid {
  has $.rows;
  has $.cols;
  has @.cells;
  method TWEAK {
    for ^$.rows -> $r {
      for ^$.cols -> $c {
        @!cells[$r][$c] = Cell.new;
      }
    }
  }
}

my $g = Grid.new(:5rows, :5cols);

say $g;
