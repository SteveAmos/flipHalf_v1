import hype.*;
import hype.extended.behavior.*;
import hype.extended.colorist.*;
import hype.extended.layout.*;
import hype.interfaces.*;

HColorPool    colors;
HCanvas       maincanvas;
HDrawablePool pool;
HTimer        timer;

void setup() {
  size(600, 600, P3D);
  H.init(this).background(#cfcfcf).use3D(true);
  smooth();

  colors = new HColorPool(#AAAAAA, #BBBBBB, #CCCCCC, #DDDDDD, #FFFFFF, #222222, #333333, #555555, #888888);

  maincanvas = new HCanvas(width/2, height, P3D).autoClear(false).fade(1);
  H.add(maincanvas);
  //textureMode(NORMAL);


  pool = new HDrawablePool(300);
  pool.autoParent(maincanvas)
    .add(new HRect().rounding(5)) //for adding rounded rectangles
    //.add(new HPath())
    .onRequest(
    new HCallback() {
    public void run(Object obj) {
     HDrawable d = (HDrawable) obj;
     d
     .strokeWeight(1)
     .stroke(#000000, 150)
     .fill( colors.getColor(), 200 )
     .loc( (int)random(width), (int)random(height), -(int)random(2000) )
     .anchorAt(H.CENTER)
     .size( 15+((int)random(10)*5) )
     ;
     }
  }
  )
  ;

  timer = new HTimer()
    .interval(10)
    .callback(
    new HCallback() { 
    public void run(Object obj) {
      pool.request();
    }
  }
  )
  ;
}


void draw() {
  for (HDrawable d : pool) {
    d.rotation( d.z()/1.5 ).loc(d.x(), d.y(), d.z()+4 );
    if (d.z() > 1000) pool.release(d);
  }

  H.drawStage();
  flipHalf();
  //saveFrame("../frames/#########.png"); if (frameCount == 1200) exit();
}

void flipHalf() {
  beginShape();
  texture(maincanvas.graphics());
  vertex(width/2, 0, width/2, 0);
  vertex(width, 0, 0, 0);
  vertex(width, height, 0, height);
  vertex(width/2, height, width/2, height);
  endShape();
}
