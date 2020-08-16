import ddf.minim.*;
public abstract class GameObject {
    public abstract void draw();
}


public class Player extends GameObject{
    float x;
    int y;
    int speed = 20;
    LevelScene level;
    PImage sprite;

    int powerDistance = 100;

    public Player(LevelScene level){
        x = width / 2;
        y = height - 300;
        this.level = level;
        sprite = loadImage("slingshot_med.png");
    }

    public void fire(){
        Projectile p = new Projectile(powerDistance, 15, level);
        p.x = x;
        p.y = y;
        level.projectiles.add(p);
    }

    public void draw() {
        fill(255);
        stroke(255);
        // ellipse(x, y, 10, 10);
        imageMode(CENTER);
        image(sprite, x, y);

        stroke(255, 0, 0);

        strokeWeight(10);
        line(x, y, x, y - powerDistance);
    }

}

public class Enemy extends GameObject{
    int x;
    int y;
    int health = 1;
    PImage sprite;
    PImage[] walkSprites;
    PImage servedSprite;
    int walkFrame = 0;
    int prevWalkTime = 0;
    int rate = 100;

    PImage[] bangSprites;
    int bangFrame = 0;
    int prevBangTime = 0;
    int bangRate = 500;
    //offset for differnet waist heights
    int offset = 0;

    LevelScene levelScene;

    int timeBetweenAttack = 1000;
    int prevTime = -1;
    int attacking = -1;
    boolean move = true;
    int speed = 1;

    boolean active = true;
    int despawnTime = 0;

    AudioPlayer mplayer;
    Minim minim;

    public Enemy(int x, int y, LevelScene levelScene) {
        this.levelScene = levelScene;
        this.x = x;
        this.y = y;

        walkSprites = new PImage[6];

        int character = (int) random(4);

        String prefix = "A/walkA_";
        if (character == 0) {
            prefix = "A/walkA_";
        } else if (character == 1) {
            prefix = "B/walkB_";
        }else if (character == 2) {
            prefix = "C/walkC_";
        }else if (character == 3) {
            prefix = "D/walkD_";
        }


        for (int i = 0; i < walkSprites.length; i++)  {
            String s = prefix + str(i + 1) + ".png";
            walkSprites[i] = loadImage(s);
        }

        //served image
        prefix = "A/servedA.png";
        if (character == 0) {
            prefix = "A/servedA.png";
        } else if (character == 1) {
            prefix = "B/servedB.png";
        }else if (character == 2) {
            prefix = "C/servedC.png";
        }else if (character == 3) {
            prefix = "D/servedD.png";
        }

        servedSprite = loadImage(prefix);


        //banging sprites
        prefix = "A/bangCropA";
        if (character == 0) {
            prefix = "A/bangCropA";
            offset -= 10;
        } else if (character == 1) {
            prefix = "B/bangCropB";
        }else if (character == 2) {
            prefix = "C/bangCropC";
            offset -= 10;
        }else if (character == 3) {
            prefix = "D/bangCropD";
            // offset -= 10;
        }

         bangSprites = new PImage[2];
         for (int i = 0; i < bangSprites.length; i++) {
            bangSprites[i] = loadImage(prefix + str(i + 1) + ".png");
         }
         // bangSprites[0] = loadImage("B/bangCropA1.png");
         // bangSprites[1] = loadImage("B/bangCropA2.png");

        sprite = loadImage("B/walkB_1.png");


        //audio
        minim = new Minim(pApplet);
        mplayer = minim.loadFile("audio/bang.mp3");
    }

    public void update(){
        if (move && active) {
            y += speed;
            int currentTime = millis();
            if (prevWalkTime + rate < currentTime) {
                walkFrame = (walkFrame + 1) % walkSprites.length;
                prevWalkTime = millis();

            }

        } else if (!move) {
            int currentTime = millis();
            if (prevBangTime + bangRate < currentTime) {
                bangFrame = (bangFrame + 1) % bangSprites.length;
                prevBangTime = millis();

                if (bangFrame == 1) {
                    mplayer.rewind();
                    mplayer.play();
                    levelScene.counter.health -= 1;

                    tint(255, 0, 0);
                    draw();
                    noTint();
                }
            }
        }
        // println(y);
        if (active && health <= 0) {
                active = false;
                // levelScene.score += 1;
                //594 max y
                float score = map(y, 0, 594, 5, 1);
                levelManager.score += int(score);
                despawnTime = millis() + 1000;

        }
        if (!active) {
            y -= 1;
        }
        // if (attacking >= 0) {
        //     levelScene.counter.health -= 1;

        //     tint(255, 0, 0);
        //     draw();
        //     noTint();
        //     //reset
        //     prevTime = millis();
        //     attacking = -1;
        // }

    }

    public boolean isFinished() {
        return (!active && millis() >= despawnTime);
        // return health <= 0;
    }

    public void draw() {

        if (!active){
            imageMode(CORNER);
        // image(sprite, x, y);
            PImage img = servedSprite;
            tint(255, map(despawnTime - millis(), 0, 1000, 0, 255));
            image(img, x, y);
            noTint();
            return;

        }

        fill(255);
        stroke(255);
        // rect(x, y, 10, 10);
        imageMode(CORNER);

        //banging
        if (!move) {
            PImage img = bangSprites[bangFrame];
            if (bangFrame == 0){
                image(img, x - 25, y);
            } else {
                image(img, x, y);
            }


            return;
        }



        // image(sprite, x, y);
        PImage img = walkSprites[walkFrame];
        int h = img.height;
        if (y + img.height > levelScene.counter.y) {
            h -= y + img.height - levelScene.counter.y;
        }
        if (h <= 0) {
            h = 1;
        }
        PImage cropped = img.get(0, 0, img.width, h);
        image(cropped, x, y);
        // fill(0, 255, 0);
        // ellipse(x, y, 10, 10);
    }

    public void counterCheck(Counter c) {
        int curTime = millis();
        // boolean timerDone = (prevTime < 0 || prevTime + timeBetweenAttack < curTime) ? true : false;
        // if (attacking < 0 && timerDone && pointInRect(c.x, c.y, c.w, c.h, x, y + 200)) {
        //     attacking = 0;
        //     // attack = true;
        //     // c.health -= 1;
        //     // prevTime = curTime;
        // }

        if (pointInRect(c.x, c.y, c.w, c.h, x, y + 167 + offset)) {
            if (move == true){
                prevBangTime = millis();
            }
            move = false;

        } else {
            move = true;
        }
    }

}

public class Projectile extends GameObject {
    float x;
    int y;
    int distanceRemain;
    int speed;
    PImage sprite;

    LevelScene level;

    public Projectile(int distanceRemain, int speed, LevelScene level) {
        this.distanceRemain = distanceRemain;
        this.speed = speed;
        this.level = level;

        sprite = loadImage("cup_med.png");

    }

    public boolean isFinished() {
        return distanceRemain <= 0;
    }

    public void update() {
        y -= speed;
        distanceRemain -= speed;

        if (distanceRemain <= 0) {
            level.damageEffects.add(new DamageEffect((int)x, y, 150, level));
        }
    }

    public void draw() {
        // fill(0, 100, 0);
        // stroke(255);
        // triangle(x, y, x + 20, y, x, y + 20);
        imageMode(CENTER);
        image(sprite, x, y);
    }
}

public class DamageEffect extends GameObject {
    int time = 0;
    LevelScene level;
    int x;
    int y;
    int radiusSquared;
    boolean finished = false;
    int finishedTime = 0;
    AudioPlayer mplayer;
    Minim minim;

    public DamageEffect(int x, int y, int radius, LevelScene level) {
        this.x = x;
        this.y = y;
        this.radiusSquared = radius * radius;
        this.level = level;
        minim = new Minim(pApplet);
        mplayer = minim.loadFile("audio/coffeeSplash.mp3");
    }

    public void update(){
        time += 1;

        if (finished) {
            return;
        }

        for (int i = level.enemies.size() - 1; i >= 0; i--) {
            Enemy e = level.enemies.get(i);
            int distanceSquared = (e.x + 50 - x) * (e.x + 50 - x) + (e.y + 160 - y) * (e.y+ 160 - y);
            if (e.active && radiusSquared >= distanceSquared) {
                level.enemies.get(i).health -= 1;
                finished = true;
                finishedTime = time;
                mplayer.play();
                break;
            }

        }
    }

    public void draw() {
        if (finished) {
            fill(111, 78, 55, (30 - (time - finishedTime)) * 255.0 / 30.0);
        } else {
            fill(111, 78, 55);
        }
        noStroke();

        // stroke(111, 78, 55);
        // println((30 - (time - finishedTime)) * 255.0 / 30.0);
        ellipse(x, y, sqrt(radiusSquared), sqrt(radiusSquared));
        noTint();
    }

    public boolean isFinished() {
        // if (finished){
        //     return finished;
        // }
        return time >= 60;
    }

}

public class Counter extends GameObject {
    int health = 10;

    int h;
    int w;

    int x;
    int y;

    PImage tired;
    PImage mad;

    public Counter(int x, int y, int w, int  h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        tired = loadImage("tired.png");
        mad = loadImage("mad.png");

    }

    public void draw() {
        // noFill();

        image(tired, 150 - 100, height - 175);
        image(mad, 300 + 150 + 20, height - 175);

        noStroke();
        fill(255, 0, 0);
        rect(150, height - 150, 300 - health * 30, 50);

        noFill();
        stroke(0, 0, 0);
        strokeWeight(5);
        rect(150, height - 150, 300, 50);



        // textSize(100);
        // text("Health:" + str(health), 0, height - 100);

    }

}

public boolean pointInRect(int x, int y, int w, int h, int x1, int y1) {
    if (x1 > x && x1 < x + w && y1 > y && y1 < y + h) {
        return true;
    }
    return false;
}
