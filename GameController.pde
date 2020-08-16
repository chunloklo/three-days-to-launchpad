//Import Serial library
import processing.serial.*;
Serial myPort;

int y = 100;

LevelManager levelManager;
ArrayList<Scene> scenes;
int curScene = 0;

float potVal = 1023;
int prevSlingReading = -1;
int slingVal = -1;
int slingReading = -1;
boolean fire = false;

int numReadings = 2;

int readingsAvg[] = new int[2];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
float average = 0;                // the average

float leftLimit = 0;
float rightLimit = 1023;
float curPotReading = 0.0;

PApplet pApplet;

AudioPlayer mplayer;
Minim minim;


// The statements in the setup() function
// execute once when the program begins
void setup() {
  pApplet = this;
  // size(1920, 1080);  // Size must be the first statement
  fullScreen();
  stroke(255);     // Set line drawing color to white
  frameRate(60);

  levelManager = new LevelManager();

  scenes = new ArrayList<Scene>();

  StartScene level0 = new StartScene();
  scenes.add(level0);

  TransitionScene l1Trans = new TransitionScene("screens/day3.png");

  scenes.add(l1Trans);

  LevelScene level1 = new LevelScene();
  scenes.add(level1);
  LevelSpawner spawner = new Level1Spawner(level1);
  level1.spawner = spawner;



  //level 2 transition and level
  TransitionScene l2Trans = new TransitionScene("screens/day2.png");

  scenes.add(l2Trans);

  LevelScene level2 = new LevelScene();
  scenes.add(level2);
  spawner = new Level2Spawner(level2);
  level2.spawner = spawner;


  ///level 3 transition and level
  TransitionScene l3Trans = new TransitionScene("screens/day1.png");

  scenes.add(l3Trans);

  LevelScene level3 = new LevelScene();
  scenes.add(level3);
  spawner = new Level3Spawner(level3);
  level3.spawner = spawner;


  //winScene
  WinScene winScene = new WinScene();
  scenes.add(winScene);

  //End Screen
  EndScene endScene = new EndScene();
  scenes.add(endScene);


  levelManager.scenes = scenes;
  levelManager.curScene = curScene;
  levelManager.switchScene(curScene);

  minim = new Minim(pApplet);
  mplayer = minim.loadFile("audio/bgmLoop.mp3");
  mplayer.loop();

  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 115200);

}
// The statements in draw() are executed until the
// program is stopped. Each statement is executed in
// sequence and after the last line is read, the first
// line is executed again.

void draw() {
  background(0);   // Clear the screen with a black background

  // mDetector.draw();
  readVal();
  // setVal();

  levelManager.scene().draw();
  levelManager.scene().update();

  // scenes.get(levelManager.curScene).draw();
  // scenes.get(levelManager.curScene).update();

  // LevelScene scene = (LevelScene) scenes.get(curScene);
  // println(scene.player.x);
  // scene.player.x = 1820 - (int) map((float)mDetector.x, 50.0, 550.0, 100.0, 1820.0);
}

void keyPressed() {
  levelManager.scene().keyPressed(key);
  if (key == 'o') {
    leftLimit = curPotReading;
  } else if (key == 'p') {
    rightLimit = curPotReading;
  }
}

void readVal() {
  //READ DATA SENT OVER SERIAL
  String val = "";

  if ( myPort.available() > 0 ) {
    val = myPort.readStringUntil('\n');
  }

  if (val != null) {
    //REMOVE WHITE SPACE/NOISE
    val = trim(val);

    //READINGS CONTAINS AN ARRAY OF "STRINGS" SENT OVER FROM ARDUINO SEPARATED BY A COMMA
    String[] readings = split(val, ',');

    //ENSURE THAT ONLY THREE VALUES HAVE BEEN RECEIVED
    if (readings.length == 3) {

      //ENSURE IT IS NOT AN EMPTY STRING
      if (readings[1].length() > 0) {

        //PARSE VALUES IN READINGS ARRAY FROM STRING TO INTEGER
        int reading = int(readings[0]);
        //buttonVal = int(readings[1]);
        //capVal = int(readings[2]);


        // if (potVal > 1001){
        // }

        if (reading < 2000) {

          total = total - readingsAvg[readIndex];
          // read from the sensor:
          readingsAvg[readIndex] = reading;
          // add the reading to the total:
          total = total + readingsAvg[readIndex];
          // advance to the next position in the array:
          readIndex = readIndex + 1;

          // if we're at the end of the array...
          if (readIndex >= numReadings) {
            // ...wrap around to the beginning:
            readIndex = 0;
          }



          average = (float)total / (float)numReadings;
          curPotReading = average;
          // println(average);


          potVal = map(average, leftLimit, rightLimit, 0.0, 1920.0);
          // println(potVal);
          // potVal = 1920 - potVal;
        }


        slingReading = int(readings[1]);
        slingVal = (int) Math.pow(1.008, (float)slingReading * 0.9);
        // slingVal = (int) Math.pow(1.01, (float)slingReading * 0.8);

        if (slingReading - prevSlingReading < -2000) {
          fire = true;
        } else {
          fire = false;
        }
        // println(slingReading - prevSlingReading );
        prevSlingReading = slingReading;
        // slingVal = (int)map(float(slingVal), 0.0, 1000, 0.0, 650);


        // potVal = (double) readings[0];

        // potVal = 1023 - potVal;
        // println(potVal);
        //print(",");
        //print(buttonVal);
        //print(",");
        //println(capVal);
      }
    }
  }
}

void setVal() {
  if(levelManager.curScene == 1) {
    if (levelManager.scene() instanceof LevelScene) {
      LevelScene scene = (LevelScene) levelManager.scene();
      scene.player.x = potVal;

      if (fire){
        println("HOWER DISTNCE", scene.player.powerDistance);
        scene.player.fire();
      }
      fire = false;

      scene.player.powerDistance = slingVal;

    }
  }

}