String path;
PImage source;
PImage destination;
PGraphics lines;
PImage imgLines;

float w = 150; //larger value = less colour
float b = 100; //larger value = more colour
float s;
float inter = 8;

void setup() {
  size(640, 640);

  selectInput("Select an image to process:", "fileSelected");
  noLoop();
  interrupt();
  source = loadImage(path);
  destination = createImage(source.width, source.height, RGB);

  lines = createGraphics(source.width, source.height);
  lines.beginDraw();
  lines.background(255);
  lines.stroke(1);
  lines.fill(0);
  for (int i = 0; i < source.width; i+= inter) {
    lines.line((i), 0, source.width, source.height -(i));
    lines.line(0, (i+inter), source.width-(i+inter), source.height);
  }
  lines.endDraw();
  imgLines = lines.get();
}



void fileSelected(File selection) {
  if (selection == null) {
    println("nothing selected");
  } else {
    path = selection.getAbsolutePath();
    println("selected" + selection.getAbsolutePath());
  }
}

void interrupt() {
  while (path == null) {
    delay(200);
  }
  loop();
}



void draw() {
  background(255);
  keyPressed();

  if (source.width >= 600) {
    s = 600.00/source.width;
  } else {
    s = 600.00/source.height;
  };

  if (source != null) {
    source.loadPixels();
  }
  imgLines.loadPixels();
  destination.loadPixels();
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++) {
      int loc = x + y*source.width;
      
      if (brightness(source.pixels[loc]) > w) {
        destination.pixels[loc] = color(255);
      } else if (brightness(source.pixels[loc]) < b) {
        destination.pixels[loc] = color(0);
      } else {
        destination.pixels[loc] = imgLines.pixels[loc];
      }
    }
  }

  destination.updatePixels();

  pushMatrix();
  imageMode(CENTER);
  translate(width/2, height/2);
  scale(s);
  image(destination, 0, 0);
  fill(255);
  
  popMatrix();
}


void save() {
  String fileName = frameCount+".png";
  println("saved " + fileName + "!");
  destination.save(fileName);
  noLoop();
}


void lineGen(float inter) {
  lines = createGraphics(source.width, source.height);
  float dist = source.width*1.5;
  lines.beginDraw();
  lines.background(255);
  lines.stroke(1);
  lines.fill(0);
  for (int i = 0; i < dist; i+= inter) {
    lines.line((i), 0, dist, dist-i);
    lines.line(0, i+inter, dist-i, dist+inter);
  }
  lines.endDraw();
}



void keyPressed() {
  if (key == 'w' || key == 'W') {
    loop();
    w = map(mouseX, 10, width-10, 0, 255);
    b = map(mouseY, 10, height-10, 0, 255);
  } else if ( key == 'd' || key == 'D') {
    loop();
    inter = map(mouseX, 10, width-10, 30, 2);
    lineGen(inter);
    imgLines = lines.get();
  } else if ( key == 's' || key == 'S') {
    save();
  } else if ( key == 'q' || key == 'Q') {
    exit();
  }
}
