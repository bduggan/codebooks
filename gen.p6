#!/usr/bin/env perl6

sub show(@points, Bool :$green = False, Bool :$blue = False, Bool :$red = False) {
  state $r = 0.3;
  state $g = 0.3;
  state $b = 0.3;
  for @points -> ($x,$y) {
   say "$x $y";
  }
  if $green {
    $g += 0.05;
    $g = 1 if $g > 1;
    say "0.3 $g 0.04";
  }
  if $blue {
    $b += 0.05;
    $b = 1 if $b > 1;
    say "$b 0.1 0.04";
  }
  if $red {
    $r += 0.05;
    $r = 1 if $r > 1;
    say "0.4 0.1 $r";
  }
  say "pathie";
  say "";
}

sub compute($p1,$p3,$p2) {
  # say "computing { @$p1  } + { @$p3 } - { @$p2 }";
  return @$p1 >>->> @$p3 >>+>> @$p2
}

sub listie {
  gather {
   my ($i,$j,$k,$l) = 10,20,30,40;
   for ^10 {
     # take ( (0..600).pick(2).List, (0..600).pick(2).List );
     $i += (10..100).pick;
     $j += (200..400).pick;
     $k += (10..100).pick;
     $l += (10..100).pick;
     $i mod= 500;
     $j mod= 500;
     $k mod= 500;
     $l mod= 500;
     take ( [$i,$j], [$k,$l] );
   }
   #take <200 180>, <90 190>;
   # take <100 180>, <120 130>;
   # take <50 180>, <220 120>;
  }
}

my @red-points = <10 10>, <10 10>, < 20 20 >, < 30 30 >;
my @blue-points = <10 10>, <10 10>, < 20 20 >, < 30 30 >;
my @green-points = <10 10>, <10 10>, < 20 20 >, < 30 30 >;

my $reds := listie;
my $blues := listie;
my $greens := listie;
my $pre = 'pre.ps'.IO.slurp;

put $pre;

show(@red-points, :red);
show(@green-points, :green);
show(@blue-points, :blue);
for $greens Z, $blues Z, $reds -> ( @green, @blue, @red ) {
  @green-points = |@green, compute(@green-points[0], @green-points[1],@green-points[0]), @green-points[0];
  show(@green-points, :green);
  @blue-points = |@blue, compute(@blue-points[0], @blue-points[1],@blue-points[0]), @blue-points[0];
  show(@blue-points, :blue);
  @red-points = |@red, compute(@red-points[0], @red-points[1],@red-points[0]), @red-points[0];
  show(@red-points, :red);
}

put 'showpage';
