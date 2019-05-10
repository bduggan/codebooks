class Draw {

  method lower-right($e,$s,$es,$se) is export {
    my $dir = ('UP' x $e) ~ ('DOWN' x $se);
    s/UPDOWN/VERTICAL/ with $dir;
    my $lr = ('LEFT' x $s) ~ ('RIGHT' x $es);
    s/LEFTRIGHT/HORIZONTAL/ with $lr;
    my $str = "BOX DRAWINGS LIGHT ";
    $str ~= ($dir,$lr).grep({.defined && .chars}).join(" AND ");
    #return $str;
    uniparse($str);
  }

  method bottom-left($can-go-south,$linked-to-south) {
    return '└' unless $can-go-south;
    return "│" if $linked-to-south;
    "├";
  }

  method dash {
    return uniparse("BOX DRAWINGS LIGHT HORIZONTAL");
  }
  method vert {
    return uniparse("BOX DRAWINGS LIGHT VERTICAL");
  }
  method line {
    Draw.dash x 3;
  }
  method top-corner-piece {
    "┐";
  }
  method top-piece {
    "┬";
  }

}
