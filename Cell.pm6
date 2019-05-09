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
