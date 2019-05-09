class Cell {
  has ($.row, $.col);
  has ($.n, $.s, $.e, $.w ) is rw;
  has Hash $!linked-to;
  method link(Cell $other, Bool :$bidi = True) {
    $!linked-to{ $other } = True;
    $other.link(self,:!bidi) if $bidi;
  }
  method unlink(Cell $other, Bool :$bidi = True) {
    $!linked-to{ $other } = False;
    $other.unlink(self,:!bidi) if $bidi;
  }
  method links { $!linked-to.keys }
  multi method linked(Cell:D $x) { $!linked-to{$x}:exists }
  multi method linked(Any $x) { False }
  method neighbors { ($.n, $.s, $.e, $.w).grep: *.defined }
}
