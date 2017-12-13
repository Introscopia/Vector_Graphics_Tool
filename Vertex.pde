class Vertex {
  public char type;
  public float x, y;
  public float cp1x, cp1y, cp2x, cp2y;
  Vertex ( char t, float a, float b ) {
    type = t;
    x = a;
    y = b;
  }
  Vertex(  char t, float a, float b, float c, float d ) {
    type = t;
    x = a;
    y = b;
    cp1x = c;
    cp1y = d;
  }
  Vertex(  char t, float a, float b, float c, float d, float e, float f ) {
    type = t;
    x = a;
    y = b;
    cp1x = c;
    cp1y = d;
    cp2x = e;
    cp2y = f;
  }
  String Code() {
    switch(type) {
    case 'v':
      return "vertex("+x+", "+y+");";
    case 'c':
      return "curveVertex("+x+", "+y+");";
    case 'q':
      return "quadraticVertex("+cp1x+", "+cp1y+", "+x+", "+y+");";
    case 'b':
      return "bezierVertex("+cp1x+", "+cp1y+", "+cp2x+", "+cp2y+", "+x+", "+y+");";
    default:
      return "";
    }
  }
  String intCode() {
    if( roundTo == 2.5 ){
      switch(type) {
        case 'v':
          return "vertex("+roundTo*round(x/roundTo)+", "+roundTo*round(y/roundTo)+");";
        case 'c':
          return "curveVertex("+roundTo*round(x/roundTo)+", "+roundTo*round(y/roundTo)+");";
        case 'q':
          return "quadraticVertex("+roundTo*round(cp1x/roundTo)+", "+roundTo*round(cp1y/roundTo)+", "+roundTo*round(x/roundTo)+", "+roundTo*round(y/roundTo)+");";
        case 'b':
          return "bezierVertex("+roundTo*round(cp1x/roundTo)+", "+roundTo*round(cp1y/roundTo)+", "+roundTo*round(cp2x/roundTo)+", "+roundTo*round(cp2y/roundTo)+", "+roundTo*round(x/roundTo)+", "+roundTo*round(y/roundTo)+");";
        default:
          return "";
      }
    }
    else{
      switch(type) {
      case 'v':
        return "vertex("+int(roundTo*round(x/roundTo))+", "+int(roundTo*round(y/roundTo))+");";
      case 'c':
        return "curveVertex("+int(roundTo*round(x/roundTo))+", "+int(roundTo*round(y/roundTo))+");";
      case 'q':
        return "quadraticVertex("+int(roundTo*round(cp1x/roundTo))+", "+int(roundTo*round(cp1y/roundTo))+", "+int(roundTo*round(x/roundTo))+", "+int(roundTo*round(y/roundTo))+");";
      case 'b':
        return "bezierVertex("+int(roundTo*round(cp1x/roundTo))+", "+int(roundTo*round(cp1y/roundTo))+", "+int(roundTo*round(cp2x/roundTo))+", "+int(roundTo*round(cp2y/roundTo))+", "+int(roundTo*round(x/roundTo))+", "+int(roundTo*round(y/roundTo))+");";
      default:
        return "";
      }
    }
  }
}