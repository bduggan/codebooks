use Cell;
use Draw;

class Grid does Positional {
  has $.rows;
  has $.cols;
  has @.cells handles <AT-POS>;
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
  method configure-cells {
    self.each-cell: -> $cell {
      my ($row,$col) = $cell.row, $cell.col;
      $cell.n = self[ $row - 1 ][ $col ];
      $cell.s = self[ $row + 1 ][ $col ];
      $cell.e = self[ $row     ][ $col + 1 ];
      $cell.w = self[ $row     ][ $col - 1 ];
    }
  }
  method random-cell {
    self[ (^$.rows).pick ][ (^$.cols).pick ];
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
  method row($n) {
    self[$n]<>;
  }
  method Str {
    my $top-row = "┌";
    for self.row(0).rotor(2 => -1) -> ($this,$next) {
      $top-row ~= Draw.line;
      if ($this.linked($next)) {
        $top-row ~= Draw.dash;
      } else {
        $top-row ~= "┬";
      }
    }
    $top-row ~= Draw.line ~ "┐";
    my $output = $top-row ~ "\n";
    for self.cells -> $r {
      my $top = Draw.vert;
      my $bot = Draw.bottom-left($r[0].s, $r[0].linked($r[0].s));

      for @$r -> $c {
        my $body = ' ' ~ ($c.content // '  ');
        my $east = $c.linked($c.e) ?? " " !! "│";
        $top ~= $body ~ $east;
        my $south = $c.linked($c.s) ?? " " x 3 !! "─" x 3;
        my $corner = Draw.lower-right(
            (not $c.linked($c.e)),
            (not $c.linked($c.s)),
            ((not $c.e) ?? False !! not $c.e.?linked($c.?e.?s)),
            ((not $c.s) ?? False !! not $c.s.?linked($c.?s.?e))
        );

        $bot ~= $south ~ $corner;
      }
      $output ~= $top ~ "\n";
      $output ~= $bot ~ "\n";
    }
    $output
  }
}

