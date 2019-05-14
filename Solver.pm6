unit role Solver;
use Log::Async;

method solve {
  my $at = $.end;
  debug "Starting at $at";
  while ($at !=== $.start) {
    my $next = $at.links.grep({ .distance == $at.distance-1 }).pick;
    debug "moving to $next";
    $at = $next;
    $at.content = '•';
  }
}

