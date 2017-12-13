void mousePressed() {
  if(mouseButton == LEFT){
    if ( drawing ) {
      switch(mode) {
      case 'v':
        v.add( new Vertex( mode, Xmouse, Ymouse));
        break;
      case 'c':
        v.add( new Vertex( mode, Xmouse, Ymouse));
        curveCounter++;
        break;
      case 'q':
        if( v.size() >= 1 ){
          if( v.get( v.size()-1 ).type == 'v' || v.get( v.size()-1 ).type == 'b' || v.get( v.size()-1 ).type == 'q' ){
            v.add( new Vertex( mode, Xmouse, Ymouse, lerp( Xmouse, v.get( v.size()-1 ).x, 0.5 ) , lerp( Ymouse, v.get( v.size()-1 ).y, 0.5 )));
          }
        }
        break;
      case 'b':
        if( v.size() >= 1 ){
          if( v.get( v.size()-1 ).type == 'v' || v.get( v.size()-1 ).type == 'b' || v.get( v.size()-1 ).type == 'q' ){
            v.add( new Vertex( mode, Xmouse, Ymouse, lerp( Xmouse, v.get( v.size()-1 ).x, 0.75 ) , lerp( Ymouse, v.get( v.size()-1 ).y, 0.75 ) , lerp( Xmouse, v.get( v.size()-1 ).x, 0.25 ), lerp( Ymouse, v.get( v.size()-1 ).y, 0.25 ) ));
          }
        }
        break;
      }
    } 
    else {
      boolean r = true;
      float reach = 4*scale;
      for (int i = 0; i < v.size (); i++) {
        switch(v.get(i).type) {
        case 'v':
          if ( abs(Xmouse - v.get(i).x) <= reach && abs(Ymouse - v.get(i).y) <= reach ) {
            selected = i; 
            s = 0; 
            dragging = true; r = false;
          }
          break;
        case 'c':
          if ( abs(Xmouse - v.get(i).x ) <= reach && abs(Ymouse - v.get(i).y ) <= reach ) {
            selected = i; 
            s = 0; 
            dragging = true; r = false;
          }
          break;
        case 'q':
          if ( abs(Xmouse - v.get(i).x ) <= reach && abs(Ymouse - v.get(i).y ) <= reach ) {
            selected = i; 
            s = 0; 
            dragging = true; r = false;
          }
          if ( abs(Xmouse - v.get(i).cp1x ) <= reach && abs(Ymouse - v.get(i).cp1y ) <= reach ) {
            selected = i; 
            s = 1; 
            dragging = true; r = false;
          }
          break;
        case 'b':
          if ( abs(Xmouse - v.get(i).x ) <= reach && abs(Ymouse - v.get(i).y ) <= reach ) {
            selected = i; 
            s = 0; 
            dragging = true; r = false;
          }
          if ( abs(Xmouse - v.get(i).cp1x ) <= reach && abs(Ymouse - v.get(i).cp1y ) <= reach ) {
            selected = i; 
            s = 1; 
            dragging = true; r = false;
          }
          if ( abs(Xmouse - v.get(i).cp2x ) <= reach && abs(Ymouse - v.get(i).cp2y ) <= reach ) {
            selected = i; 
            s = 2; 
            dragging = true; r = false;
          }
          break;
        }
      }
      check = true;
      if(r){
        drawing = true; 
        dragging  = false;
      }
    }
  }
}
void mouseReleased(){
  check = false;
}
void keyPressed() {
  /*
  if ( saving ) {
    if( key != CODED ){
      saveTitle += key;
    }
    else if( key == BACKSPACE ){
      saveTitle = saveTitle.substring(0, saveTitle.length()-2);
    }
  }
  */
  if ( key == ENTER ) {
    if ( saving ) {
      save = true;
    }
    else{
      saving = true;
    }
  }
  else if ( key == 0x03 ) {  // Ctrl+C
    String[] out = output();
    String concat = "";
    for( int i = 0; i < out.length; ++i ) concat += out[i] + "\n";
    writeTextToClipboard( concat );
  }
  else if ( key == ESC ) {
    if ( saving ) {
      saving = false;
    }
    if ( drawing ) {
      drawing = false;
    }
    if ( dragging ) {
      dragging = false;
    }
    key = '0';
  } 
  else if (key == '+'){
    grid_edge++; 
    gridAltText = 180;
  }
  else if(key == '-'){
    if(grid_edge > 1){
      grid_edge--; 
      gridAltText = 180;
    }
  }
  else if(key == 'i'){
    integers = !integers;
    intText = 180;
  }
  else if(key == 'r'){
    if(roundTo == 1){
        roundTo = 2.5;
    }
    else if(roundTo == 2.5){
        roundTo = 5;
    }
    else if(roundTo == 5){
        roundTo = 10;
    }
    else if(roundTo == 10){
        roundTo = 1;
    }
    integers = true;
    roundToText = 180;
  }
  else if( key == 's' ){
    for( int i = v.size()-1; i > 0; --i ){
      if( v.get(i).type == 'v' ) v.add( new Vertex( 'v', -v.get(i-1).x, v.get(i-1).y ) );
      else if( v.get(i).type == 'b' ) v.add( new Vertex('b', -v.get(i-1).x, v.get(i-1).y, -v.get(i).cp2x, v.get(i).cp2y, -v.get(i).cp1x, v.get(i).cp1y ) );
    }
  }
  else if ( key == BACKSPACE ){
    if( v.size() > 0 ){
      v.remove(v.size()-1);
    }
  }
  else if( key == DELETE ){
    if( dragging ){
      v.remove(selected);
    }
  }
  else if ( key == 'v' || key == 'c' || key == 'q' || key == 'b' ) {
    mode = key;
    if ( key == 'c' && pmode != 'c') {
      curveCounter = 0;
    }
    if ( key != 'c' && pmode == 'c' && curveCounter < 4) {
      mode = 'c';
    }
    if( v.size() < 2 && key == 'b'){
      key = 'v';
    }
    pmode = mode;
  }
}
void mouseWheel(MouseEvent event) {
  float wheel = event.getAmount();
  float xrd = Xmouse;
  float yrd = Ymouse;
  if (wheel==1) I-=1;
  else if (wheel==-1)I+=1;
  //I = constrain(I, minI, maxI);
  scale=pow(1.1,I);
  transX = mouseX -xrd*scale;
  transY = mouseY -yrd*scale;
}
void mouseDragged(){
  if(mouseButton == RIGHT){
    transX += (mouseX - pmouseX);
    transY += (mouseY - pmouseY);
  }
}