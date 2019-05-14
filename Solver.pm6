use Log::Async;

unit role Solver;
use Cell;

method solve {
  my @frontier = ($.start);
  my $distance = 0;
  while @frontier.elems {
    debug "distance = $distance";
    my SetHash $next;
    for @frontier -> $f {
      next if $f.distance;
      $f.distance = $distance;
      for $f.links -> Cell $c {
        $next{ $c } = True 
      }
    }
    @frontier = $next.keys.grep: { !defined(.distance) }
    $distance += 1;
  }
}

