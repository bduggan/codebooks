class Cell {
  has ($.row, $.col);
  has ($.n, $.s, $.e, $.w ) is rw;
  has %!linked-to{Cell} of Bool;
  has $.content is rw;
  has Bool $.is-start is rw;
  has Bool $.is-end is rw;

  has Int $.distance is rw;

  method render {
     return ' 🐁' if $.is-start;
     return ' 🧀' if $.is-end;
     return ' ' ~ $.distance.fmt('%2d') if $.distance;
     return ' ' x 3 unless $.content;
     return $.content;
  }

  method link(Cell $other, Bool :$bidi = True) {
    %!linked-to{ $other } = True;
    $other.link(self,:!bidi) if $bidi;
  }
  method unlink(Cell $other, Bool :$bidi = True) {
    %!linked-to{ $other } = False;
    $other.unlink(self,:!bidi) if $bidi;
  }
  method links { %!linked-to.keys }
  multi method linked(Cell:D $x) { %!linked-to{$x}:exists }
  multi method linked(Any $x) { False }
  method neighbors { ($.n, $.s, $.e, $.w).grep: *.defined }
}
