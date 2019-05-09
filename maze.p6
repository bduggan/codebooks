class Cell {
  has ($.row, $.col);
  has ($.n, $.s, $.e, $.w ) is rw;
  has SetHash $!links;
  method link(Cell $other, Bool :$bidi = True) {
    $!links{ $other } = True;
    $other.link(:!bidi);
  }
  method unlink(Cell $other, Bool :$bidi = True) {
    $.links{ $other } = False;
    $other.unlink(:!bidi);
  }
  method links { $!.links.keys }
  multi method linked(Cell:D $x) { $!.links{$x}:exists }
  multi method linked($x) { }
  method neighbors { ($.n, $.s, $.e, $.w).grep: *.defined }
}
class Grid {
  has $.rows;
  has $.cols;
  has @.cells;
  method prepare-grid {
    for ^$.rows -> $row {
      for ^$.cols -> $col {
        @!cells[$row][$col] = Cell.new( :$row, :$col );
      }
    }
  }
  method at($r, $c) {
    @!cells[$r][$c];
  }
  method configure-cells {
    self.each-cell: -> $cell {
      my ($row,$col) = $cell.row, $cell.col;
      $cell.n = self.at( $row - 1, $col );
      $cell.s = self.at( $row + 1, $col );
      $cell.e = self.at( $row, $col - 1);
      $cell.w = self.at( $row, $col + 1);
    }
  }
  method random-cell {
    self.at( (^$.rows).pick, (^$.cols).pick );
  }
  method size { $.rows * $.cols }
  method each-row(Block $b) {
    $b($_) for @!cells;
  }
  method each-cell(Block $b) {
    self.each-row: -> $r {
      $b($_) for @$r;
    }
  }
  method TWEAK {
    self.prepare-grid;
  }
  method gist {
    "$.rows x $.cols";
  }
  method Str {
    my $output = "┌" ~ ( ( "─" x 3) xx $.cols ).join("┬") ~ "┐" ~ "\n";
    self.each-row: -> $r {
      my $top = "│";
      my $bot = "├";
      for @$r -> $c {
        my $body = ' ' x 3;
        my $east = $c.linked($c.e) ?? " " !! "│";
        $top ~= $body ~ $east;
        my $south = $c.linked($c.s) ?? " " x 3 !! "─" x 3;
        $bot ~= $south ~ '┼'
      }
      $output ~= $top ~ "\n";
      $output ~= $bot ~ "\n";
    }
    $output
  }
}

my $g = Grid.new(:5rows, :5cols);

put $g;
