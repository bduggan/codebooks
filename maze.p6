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
      @!cells[$r] = [ Cell.new xx $.cols ]
    }
  }
  method gist {
    "$.rows x $.cols";
  }
}

my $g = Grid.new(:5rows, :5cols);

say $g;
