ArrayList<Vertex> v = new ArrayList<Vertex>();
int selected, curveCounter = 0, savedText, gridRadius = 600, grid_edge = 25, gridAltText, intText, roundToText = 0;
byte s;
boolean saving, save, dragging, drawing = true, check, integers = true;
char mode = 'v', pmode = 'v';
float scale, I, transX, transY, Xmouse, Ymouse, roundTo = 1;
color dim, bright, brighter, back;

void setup() {
  size(700, 600);
  
  transX = width/2f;
  transY = height/2f;
  scale = 1;
  I = 0;
  dim = color(190);
  bright = color(230);
  brighter = color(250);
  back = color(210);
  
  strokeWeight(2);
  textAlign(LEFT, TOP);
  textSize(20);
}

void draw() {
  background(0);
 
  Xmouse = (mouseX-transX)/scale;
  Ymouse = (mouseY-transY)/scale;
  
  grid();
  
  pushMatrix();
  translate(transX, transY);
  scale(scale);
  
  /*
  stroke(200);
  line(0, -gridRadius, 0, gridRadius);
  line(-gridRadius, 0, gridRadius, 0);
  stroke(100);strokeWeight(1);
  for(int i = 0; i < gridRadius; i += (grid-1)){
    line(i, -gridRadius, i, gridRadius);
    line(-gridRadius, i, gridRadius, i);
  }
  for(int i = 0; i > -gridRadius; i -= (grid-1)){
    line(i, -gridRadius, i, gridRadius);
    line(-gridRadius, i, gridRadius, i);
  }
  */
  strokeWeight(2);
  stroke(255);
  if( saving ) fill(255, 100); 
  else noFill();
  
  if ( v.size() > 2 ) {
    beginShape();
    for (int i = 0; i < v.size (); i++) {
      switch(v.get(i).type) {
      case 'v':
        vertex(v.get(i).x, v.get(i).y);
        break;
      case 'c':
        if( curveCounter < 4){
          stroke(255, 100);
          vertex(v.get(i).x, v.get(i).y);
          stroke(255);
        }
        else {
          curveVertex(v.get(i).x, v.get(i).y);
        }
        break;
      case 'q':
        quadraticVertex(v.get(i).cp1x, v.get(i).cp1y, v.get(i).x, v.get(i).y);

        break;
      case 'b':
        bezierVertex(v.get(i).cp1x, v.get(i).cp1y, v.get(i).cp2x, v.get(i).cp2y, v.get(i).x, v.get(i).y);
        break;
      }
      if(!saving){
        pushStyle();
        strokeWeight(3); stroke(#F2531D);
        if ( v.get(i).type == 'q') {
          ellipse(v.get(i).cp1x, v.get(i).cp1y, 5, 5);
          strokeWeight(1); stroke(255, 100);
          line(v.get(i).cp1x, v.get(i).cp1y, v.get(i-1).x, v.get(i-1).y);
          line(v.get(i).cp1x, v.get(i).cp1y, v.get(i).x, v.get(i).y);
        }
        else if (v.get(i).type == 'b') {
          ellipse(v.get(i).cp1x, v.get(i).cp1y, 5, 5);
          ellipse(v.get(i).cp2x, v.get(i).cp2y, 5, 5);
          strokeWeight(1); stroke(255, 100);
          line(v.get(i).cp1x, v.get(i).cp1y, v.get(i-1).x, v.get(i-1).y);
          line(v.get(i).cp2x, v.get(i).cp2y, v.get(i).x, v.get(i).y);
        }
        popStyle();
      }
    }
    if( saving ){
      endShape(CLOSE);
    }
    else{
      endShape(); 
    }
  }
  else if ( v.size() == 2 ) {
    line(v.get(0).x, v.get(0).y, v.get(1).x, v.get(1).y);
  } 
  else if ( v.size() == 1 ) {
    point(v.get(0).x, v.get(0).y);
  }

  if ( drawing && !saving) {
    if ( v.size() > 0 ) {
      stroke(255, 100);
      line(v.get(v.size()-1).x, v.get(v.size()-1).y, Xmouse, Ymouse);
      stroke(255);
    }
  }

  if ( dragging && !saving) {
    stroke(0, 0, 255);
    strokeWeight(1);
    switch (s) {
    case 0:
      ellipse(v.get(selected).x, v.get(selected).y, 10, 10);
      break;
    case 1:
      ellipse(v.get(selected).cp1x, v.get(selected).cp1y, 10, 10);
      break;
    case 2:
      ellipse(v.get(selected).cp2x, v.get(selected).cp2y, 10, 10);
      break;
    }
    stroke(255);
    strokeWeight(2);
    if ( mousePressed && check) {
      switch (s) {
      case 0:
        v.get(selected).x = Xmouse;
        v.get(selected).y = Ymouse;
        break;
      case 1:
        v.get(selected).cp1x= Xmouse;
        v.get(selected).cp1y= Ymouse;
        break;
      case 2:
        v.get(selected).cp2x= Xmouse;
        v.get(selected).cp2y= Ymouse;
        break;
      }
    }
  }
  popMatrix();

  String toptext = "";
  if( drawing ){
    switch(mode) {
    case 'v':
      toptext = "vertex(), "+v.size()+" vertices.";
      break;
    case 'c':
      toptext = "curveVertex(), "+v.size()+" vertices.";
      break;
    case 'q':
      toptext = "quadraticVertex(), "+v.size()+" vertices.";
      break;
    case 'b':
      toptext = "bezierVertex(), "+v.size()+" vertices.";
      break;
    }
  }
  else{
    toptext = "adjusting, "+v.size()+" vertices.";
  }
  
  fill(0); noStroke();
  textSize( 18 );
  rect(0, 0, 1.05 * textWidth( toptext ), 1.25 * (textAscent()+textDescent()) ); 
  fill(255);
  text(toptext, 5, 5);
  if( savedText > 0 ){
    text("saved.", 5, height-25);
    savedText--;
  }
  if( gridAltText > 0 ){
    text("grid: "+grid_edge+"px.", width-5-textWidth("grid: "+grid_edge+"px."), 5);
    gridAltText--;
  }
  if(intText > 0){
    if(integers){
      text("integers:True", 5, height-50);
    }
    else{
      text("integers:False", 5, height-50);
    }
    intText--;
  }
  if(roundToText > 0){
    text("round to "+roundTo+".", 5, height - 75);
    roundToText--;
  }
  
  if ( saving ) {
    //text("save as: "+saveTitle, 5, height-25);
    text("save?", 5, height-25);
    if( save ){
      String[] output = new String[v.size()+2];
      output[0] = "beginShape();";
      for (int i = 0; i < v.size(); i++) {
        if(integers){
          output[i+1] = v.get(i).intCode();
        }
        else{
          output[i+1] = v.get(i).Code();
        }
      }
      output[int(v.size()+1)] = "endShape(CLOSE);";
      //saveTitle += ".txt";
      saveStrings( year()+"-"+month()+"-"+day()+" "+hour()+"."+minute()+"."+second()+".txt", output);
      save = false;
      saving = false;
      savedText = 180;
    }
    fill(255, 100); 
  }
  else{
   noFill();
  }
}

void grid(){
  textSize(14);
  stroke(180);fill(180);
  int windowW = round( width / scale );
  int windowH = round( height / scale );
  int is = 0, js = 0, ie = 0, je = 0;
  boolean go = true, hardXs = false, hardYs = false, hardXe = false, hardYe = false;
  ///////////////////////////////////////////
  is = floor( -(transX/scale)/ grid_edge ) * grid_edge;
  ie = floor( -(transX/scale) + windowW );
  if( -(transX/scale) < -10000 ){
    if( transX < -10000 - windowW ) go = false;
    else{
      is = -10000;
      hardXs = true;
    }
  }
  if( -transX > 10000 - windowW ){
    if( -transX > 10000 ) go = false;
    else{
      ie = 10000;
      hardXe = true;
    }
  }
  ///////////////////////////////////////////
  js = floor( -(transY/scale)/ grid_edge ) * grid_edge;
  je = floor( -(transY/scale) + windowH );
  if( -(transY/scale) < -10000 ){
    if( -transY < -10000 - windowH ) go = false;
    else{
      js = -10000;
      hardYs = true;
    }
  }
  if( -transY > 10000 - windowH ){
    if( -transY > 10000 ) go = false;
    else{
      je = 10000;
      hardYe = true;
    }
  }
  ///////////////////////////////////////////
  if( go ){
    float xs = hardXs? is * scale + transX : 0;
    float ys = hardYs? js * scale + transY : 0;
    float xe = hardXe? ie * scale + transX : width;
    float ye = hardYe? je * scale + transY : height;
    for(int i = is; i <= ie; i+=grid_edge ){
      float x = i * scale + transX;
      if( i == 0 ) strokeWeight(3);
      else strokeWeight(1);
      line( x, ys, x, ye );
      if( i % 4 == 0 ) text( i, x, ys );
    }
    for(int j = js; j <= je; j+= grid_edge ){
      float y = j * scale + transY;
      if( j == 0 ) strokeWeight(3);
      else strokeWeight(1);
      line( xs, y, xe, y );
      if( j % 4 == 0 ) text( j, xs, y );
    }
  }
  strokeWeight(1);
}