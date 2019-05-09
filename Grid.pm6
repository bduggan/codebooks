use Cell;

class Grid {
  has $.rows;
  has $.cols;
  has @.cells;
  method TWEAK {
    self.prepare-grid;
    self.configure-cells;
  }
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
      $cell.e = self.at( $row, $col + 1);
      $cell.w = self.at( $row, $col - 1);
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
  method gist {
    "$.rows x $.cols";
  }
  method Str {
    my $output = "┌" ~ ( ( "─" x 3) xx $.cols ).join("┬") ~ "┐" ~ "\n";
    self.each-row: -> $r {
      my $top = "│";
      my $bot = $r[0].s ?? "├" !! '└';
      for @$r -> $c {
        my $body = ' ' x 3;
        my $east = $c.linked($c.e) ?? " " !! "│";
        $top ~= $body ~ $east;
        my $south = $c.linked($c.s) ?? " " x 3 !! "─" x 3;
        $bot ~= $south ~ ( $c.e && $c.s ?? '┼'
                        !! $c.e         ?? '┴'
                        !! $c.s         ?? '┤'
                        !! '┘' );
      }
      $output ~= $top ~ "\n";
      $output ~= $bot ~ "\n";
    }
    $output
  }
}

