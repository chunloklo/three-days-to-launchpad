public abstract class Scene {
    public abstract void draw();
    public abstract void update();
    public abstract void keyPressed(char key);
    public abstract void start();
    // public LevelManager levelManager;

    public PApplet p;

    // public Scene(LevelManager levelManager) {
    //     this.levelManager = levelManager;
    // }
}

public class LevelScene extends Scene {
    public Player player;
    public ArrayList<Projectile> projectiles;
    public ArrayList<Enemy> enemies;
    public ArrayList<DamageEffect> damageEffects;
    public Counter counter;
    public LevelSpawner spawner;
    public PImage backgroundSprite;
    // public int score = 0;
    int timer = 0;
    int startMillis = 0;
    int duration = 30000;
    public PImage tipJar;
    PImage clock;

    public LevelScene() {
        player = new Player(this);
        projectiles = new ArrayList<Projectile>();
        enemies = new ArrayList<Enemy>();
        damageEffects = new ArrayList<DamageEffect>();
        counter = new Counter(0, height - 320, width, 320);
        backgroundSprite = loadImage("bgMed.png");
        tipJar = loadImage("tipJar.png");
        clock = loadImage("clock.png");


    }

    public void start() {
        this.reset();
        startMillis = millis();
        return;
    }

    public void update() {
        //readInput
        player.x = potVal;

        if (fire){
            // println("HOWER DISTNCE", scene.player.powerDistance);
            player.fire();
        }
        fire = false;

        player.powerDistance = slingVal;





        for (int i = projectiles.size() - 1; i >= 0; i--) {
            projectiles.get(i).update();

            if (projectiles.get(i).isFinished()) {
                projectiles.remove(i);
            }
        }

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).update();
            enemies.get(i).counterCheck(counter);
            if (enemies.get(i).isFinished()) {
                enemies.remove(i);
            }
        }

        for (int i = damageEffects.size() - 1; i >= 0; i--) {
            damageEffects.get(i).update();

            if (damageEffects.get(i).isFinished()) {
                damageEffects.remove(i);
            }
        }

        spawner.update();


        //end time
        if (millis() - startMillis > duration) {

            levelManager.nextScene();
            this.reset();
        }


        //health time
        if (counter.health < 0) {

            // levelManager.curScene = 0;
            levelManager.switchScene(levelManager.scenes.size() - 1);
            this.reset();
        }

    }

    public void reset() {
        spawner.reset();
        projectiles.clear();
        enemies.clear();
        damageEffects.clear();
        counter = new Counter(0, height - 320, width, 320);
        // spawner = new Level(this);
    }

    public void addEnemy(Enemy e){
        enemies.add(e);
    }

    public void draw(){
        imageMode(CORNER);
        image(backgroundSprite, 0, 0);
        counter.draw();



        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).draw();
        }

        for (int i = 0; i < damageEffects.size(); i++) {
            damageEffects.get(i).draw();
        }

        player.draw();

        for (int i = 0; i < projectiles.size(); i++) {
            projectiles.get(i).draw();
        }


        image(tipJar, width - 400 , height - 120);
        textSize(80);
        text(nf(levelManager.score, 1, 2), width - 340, height - 90);

        float time = map(millis() - startMillis, 0, 30000, 9, 17);

        int t = (int) ( time * 60 * 60);

        int hour = t/3600;
        t %= 3600;
        int min = t/60;
        t %= 60;
        int sec = t;

        // text("Hr: " + nf(hour, 2) + ":" + nf(min, 2), width - 800, 100);

        image(clock, width - 150, 100);

        float angle = map(millis() - startMillis, 0, 30000, -HALF_PI, PI + HALF_PI);
        noStroke();
        fill(255, 0, 0);
        arc(width - 150, 100, 100, 100, angle, PI + HALF_PI, PIE);


    }

    public void keyPressed(char key){
        if (key == 'a') {
            player.x -= player.speed;
        } else if (key == 'd') {
            player.x += player.speed;
        } else if (key == 'j'){
            player.fire();
        } else if (key == 'h') {
            player.powerDistance += 10;
        } else if (key == 'k') {
            player.powerDistance -= 10;
        }
        return;
    }
}


public class StartScene extends LevelScene {

    int enemyX;
    int enemyY = 170;
    public StartScene() {
        backgroundSprite = loadImage("screens/startScreen.png");

        player = new Player(this);
        // projectiles = new ArrayList<Projectile>();
        // enemies = new ArrayList<Enemy>();
        // damageEffects = new ArrayList<DamageEffect>();
        // counter = new Counter(0, height - 320, width, 320);

        enemyX = width / 2 - 50;
        enemyY = 170;
    }

    public void update() {
        //readInput
        player.x = potVal;

        if (fire){
            // println("HOWER DISTNCE", scene.player.powerDistance);
            player.fire();
        }
        fire = false;

        player.powerDistance = slingVal;



        for (int i = projectiles.size() - 1; i >= 0; i--) {
            projectiles.get(i).update();

            if (projectiles.get(i).isFinished()) {
                projectiles.remove(i);
            }
        }

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).update();
            enemies.get(i).counterCheck(counter);
            if (enemies.get(i).isFinished()) {
                enemies.remove(i);
            }
        }

        for (int i = damageEffects.size() - 1; i >= 0; i--) {
            damageEffects.get(i).update();

            if (damageEffects.get(i).isFinished()) {
                damageEffects.remove(i);
            }
        }


        //if enemies hit
        if (enemies.size() <= 0) {
            levelManager.score = 0;
            levelManager.nextScene();
        }

    }

    public void draw(){
        imageMode(CORNER);
        image(backgroundSprite, 0, 0);


        // counter.draw();

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).draw();
        }

        for (int i = 0; i < damageEffects.size(); i++) {
            damageEffects.get(i).draw();
        }

        player.draw();

        for (int i = 0; i < projectiles.size(); i++) {
            projectiles.get(i).draw();
        }




    }

    public void start() {
        enemies.add(new Enemy(enemyX, enemyY, this));
        enemies.get(0).speed = 0;
        levelManager.score = 0;
        return;
    }
}

public class TransitionScene extends Scene {
    public PImage backgroundSprite;

    public int fullTime = 150;
    public int time = fullTime;

    public TransitionScene(String image) {
        backgroundSprite = loadImage(image);
    }

    public void update() {
        time -= 1;
        if (time < 0) {
            // levelManager.curScene += 1;
            levelManager.switchScene(levelManager.curScene + 1);
            time = 0;
        }
    }

    public void draw(){
        imageMode(CORNER);
        image(backgroundSprite, 0, 0);
        fill(0, 102, 153);
    }

    public void keyPressed(char key){

    }
    public void start() {
        time = fullTime;
        return;
    }
}

public class EndScene extends LevelScene {

    int enemyX;
    int enemyY;
    int startMillis = 0;
    int duration = 60000;
    public PImage tipJar;

    public EndScene() {
        backgroundSprite = loadImage("screens/endScreen.png");

        player = new Player(this);
        // projectiles = new ArrayList<Projectile>();
        // enemies = new ArrayList<Enemy>();
        // damageEffects = new ArrayList<DamageEffect>();
        // counter = new Counter(0, height - 320, width, 320);
        enemyX = 50;
        enemyY = 170;

        // enemies.add(new Enemy(enemyX, enemyY, this));
        // enemies.get(0).speed = 0;
        player.x = 100;
        tipJar = loadImage("tipJar.png");
    }

    public void update() {

        if (fire){
            // println("HOWER DISTNCE", scene.player.powerDistance);
            player.fire();
        }
        fire = false;

        player.powerDistance = slingVal;

        for (int i = projectiles.size() - 1; i >= 0; i--) {
            projectiles.get(i).update();

            if (projectiles.get(i).isFinished()) {
                projectiles.remove(i);
            }
        }

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).update();
            enemies.get(i).counterCheck(counter);
            if (enemies.get(i).isFinished()) {
                enemies.remove(i);
            }
        }

        for (int i = damageEffects.size() - 1; i >= 0; i--) {
            damageEffects.get(i).update();

            if (damageEffects.get(i).isFinished()) {
                damageEffects.remove(i);
            }
        }


        //if enemies hit
        if (enemies.size() <= 0) {
            levelManager.switchScene(0);
        }

        if (millis() - startMillis > duration) {
            levelManager.switchScene(0);
            enemies.clear();
        }

    }

    public void draw(){
        imageMode(CORNER);
        image(backgroundSprite, 0, 0);


        // counter.draw();

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).draw();
        }

        for (int i = 0; i < damageEffects.size(); i++) {
            damageEffects.get(i).draw();
        }

        player.draw();

        for (int i = 0; i < projectiles.size(); i++) {
            projectiles.get(i).draw();
        }

        image(tipJar, width / 2 - 150 , 350);
        textSize(80);
        text(nf(levelManager.score, 1, 2), width / 2 - 50, 375);




    }

    public void keyPressed(char key){
        // if (key == 'a') {
        //     player.x -= player.speed;
        // } else if (key == 'd') {
        //     player.x += player.speed;
         if (key == 'j'){
            player.fire();
        } else if (key == 'h') {
            player.powerDistance += 10;
        } else if (key == 'k') {
            player.powerDistance -= 10;
        }
        return;
    }

    public void start() {
        enemies.add(new Enemy(enemyX, enemyY, this));
        enemies.get(0).speed = 0;
        startMillis = millis();
        return;
    }
}

public class WinScene extends LevelScene {

    int enemyX ;
    int enemyY;
    public PImage tipJar;

    public WinScene() {
        backgroundSprite = loadImage("screens/successScreen.png");

        player = new Player(this);
        // projectiles = new ArrayList<Projectile>();
        // enemies = new ArrayList<Enemy>();
        // damageEffects = new ArrayList<DamageEffect>();
        // counter = new Counter(0, height - 320, width, 320);
        enemyX = 50;
        enemyY = 300;

        // enemies.add(new Enemy(enemyX, enemyY, this));
        // enemies.get(0).speed = 0;
        player.x = 100;
        player.y += 100;
        tipJar = loadImage("tipJar.png");

    }

    public void update() {
        if (fire){
            // println("HOWER DISTNCE", scene.player.powerDistance);
            player.fire();
        }
        fire = false;

        player.powerDistance = slingVal;

        for (int i = projectiles.size() - 1; i >= 0; i--) {
            projectiles.get(i).update();

            if (projectiles.get(i).isFinished()) {
                projectiles.remove(i);
            }
        }

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).update();
            enemies.get(i).counterCheck(counter);
            if (enemies.get(i).isFinished()) {
                enemies.remove(i);
            }
        }

        for (int i = damageEffects.size() - 1; i >= 0; i--) {
            damageEffects.get(i).update();

            if (damageEffects.get(i).isFinished()) {
                damageEffects.remove(i);
            }
        }


        //if enemies hit
        if (enemies.size() <= 0) {
            levelManager.switchScene(0);
        }

    }

    public void draw(){
        imageMode(CORNER);
        image(backgroundSprite, 0, 0);


        // counter.draw();

        for (int i = enemies.size() - 1; i >= 0; i--) {
            enemies.get(i).draw();
        }

        for (int i = 0; i < damageEffects.size(); i++) {
            damageEffects.get(i).draw();
        }

        player.draw();

        for (int i = 0; i < projectiles.size(); i++) {
            projectiles.get(i).draw();
        }

        // textSize(100);
        // text("YOU WIN:", width - 400, height - 100);
        image(tipJar, width / 2 - 150 , 425);
        textSize(80);
        text(nf(levelManager.score, 1, 2), width / 2 - 50, 450);


    }

    public void keyPressed(char key){
        // if (key == 'a') {
        //     player.x -= player.speed;
        // } else if (key == 'd') {
        //     player.x += player.speed;
         if (key == 'j'){
            player.fire();
        } else if (key == 'h') {
            player.powerDistance += 10;
        } else if (key == 'k') {
            player.powerDistance -= 10;
        }
        return;
    }

    public void start() {
        enemies.add(new Enemy(enemyX, enemyY, this));
        enemies.get(0).speed = 0;
        return;
    }
}