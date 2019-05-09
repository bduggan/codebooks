use Cell;

my $SEGMENT = "─";
my $LINE = $SEGMENT x 3;
my $DH = "┬"; # "\c[BOX DRAWINGS LIGHT DOWN AND HORIZONTAL]";

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
      $top-row ~= $LINE;
      if ($this.linked($next)) {
        $top-row ~= $SEGMENT;
      } else {
        $top-row ~= "┬";
      }
    }
    $top-row ~= $LINE ~ "┐";
    my $output = $top-row ~ "\n";
    for self.cells -> $r {
      my $top = "│";
      my $bot = !$r[0].s ?? '└'
                !! $r[0].linked($r[0].s) ?? "│"
                !! "├";
      my $bot-new = $bot;
      for @$r -> $c {
        my $body = ' ' x 3;
        my $east = $c.linked($c.e) ?? " " !! "│";
        $top ~= $body ~ $east;
        my $south = $c.linked($c.s) ?? " " x 3 !! "─" x 3;
        $bot ~= $south ~ ( $c.e && $c.s ?? '┼'
                        !! $c.e         ?? '┴'
                        !! $c.s         ?? '┤'
                        !! '┘' );
        $bot-new ~= $south ~ (
               $c.linked($c.e & $c.s ) && !$c.e.linked($c.e.s) ?? '┌' # ┼'
            !! $c.linked($c.e) && !$c.linked($c.s) ?? '+'
            !! $c.e         ?? '+'
            !! $c.s         ?? '+'
            !! '┘' );
      }
      $output ~= $top ~ "\n";
      $output ~= $bot ~ " new: $bot-new\n";
    }
    $output
  }
}

