OPC opc;
PImage dot;

private static final int MAX_BPM = 300;
private static final int MIN_BPM = 30;
private static final int APPROX_DRAW_INTERVAL_MSEC = 17;
private static long startTimeMillis;
private static boolean on = false;
private static final int DRAW_GRID_W = 512;
private static final int DRAW_GRID_H = 512;
private static final int DRAW_RECT_W = 128;
private static final int DRAW_RECT_H = 128;

private static class Position {
  public final int x;
  public final int y;
  public final boolean directionRight;

  public Position(int x, int y, boolean directionRight) {
    this.x = x;
    this.y = y;
    this.directionRight = directionRight;
  }
}

private static Position position = new Position(0, 0, true);


void setup()
{
  startTimeMillis = System.currentTimeMillis();
  size(DRAW_GRID_H, DRAW_GRID_W);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map an 8x8 grid of LEDs to the center of the window
  opc.ledGrid8x8(0, width/2, height/2, height / 8.0, 0, false);
  frameRate(60);
}

Position updatePosition(Position oldPosition) {
  return oldPosition;
}

void draw()
{
  long delta =  System.currentTimeMillis() - startTimeMillis;
  float beatPerSec = ((MAX_BPM - MIN_BPM) * (mouseY / (height * 1.0)) + MIN_BPM) / 60.0;
  long millisPerBeat = Math.round(1000 /  beatPerSec);
  position = updatePosition(position);
  
  if ((delta % millisPerBeat) < (millisPerBeat /4)) {
    // on
    background(0);
    stroke(100);
    fill(255,255,255);
    
    rect(position.x, position.y, DRAW_RECT_W, DRAW_RECT_H);    
  } else {
    // off
    float intensityPerCent = ((delta % millisPerBeat) / (1.0 * millisPerBeat));
    int intensity = Math.round(255 * intensityPerCent);  
    background(0);
    stroke(100);
    fill(intensity, intensity , intensity);
    rect(position.x, position.y, 128, 128);
  }
  
}

void keyPressed() {
  System.out.println("TIME: " + System.currentTimeMillis());
}  
