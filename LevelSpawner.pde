public abstract class LevelSpawner{
    int time;
    ArrayList<EnemySpawn> enemySpawns;
    LevelScene levelScene;

    public LevelSpawner(LevelScene levelScene) {
        this.time = 0;
        this.enemySpawns = new ArrayList<EnemySpawn>();
        this.levelScene = levelScene;
    }

    public void update(){
        time += 1;
    };

    public void reset() {
        time = 0;
        this.enemySpawns.clear();
    }
}

public class EnemySpawn {
    Enemy enemy;
    int time;

    public EnemySpawn(Enemy enemy, int time) {
        this.enemy = enemy;
        this.time = time;
    }
}
public class Level1Spawner extends LevelSpawner{

    public Level1Spawner(LevelScene levelScene){
        super(levelScene);

    }

    public void update() {

        for (int i = enemySpawns.size() - 1; i >= 0; i--) {
            if (enemySpawns.get(i).time == time) {
                levelScene.addEnemy(enemySpawns.get(i).enemy);
                // enemySpawns.remove(i);
            }
        }

        if (time % 240 == 0) {
            EnemySpawn es = new EnemySpawn(new Enemy(int(random(width - 100)), 0, levelScene), time + 10);
            enemySpawns.add(es);
        }
        super.update();
    }

}

public class Level2Spawner extends LevelSpawner{

    public Level2Spawner(LevelScene levelScene){
        super(levelScene);

    }

    public void update() {

        for (int i = enemySpawns.size() - 1; i >= 0; i--) {
            if (enemySpawns.get(i).time == time) {
                levelScene.addEnemy(enemySpawns.get(i).enemy);
                // enemySpawns.remove(i);
            }
        }

        if (time % 150 == 0) {
            EnemySpawn es = new EnemySpawn(new Enemy(int(random(width - 100)), 0, levelScene), time + 10);
            enemySpawns.add(es);
        }
        super.update();
    }

}

public class Level3Spawner extends LevelSpawner{

    public Level3Spawner(LevelScene levelScene){
        super(levelScene);

    }

    public void update() {

        for (int i = enemySpawns.size() - 1; i >= 0; i--) {
            if (enemySpawns.get(i).time == time) {
                levelScene.addEnemy(enemySpawns.get(i).enemy);
                // enemySpawns.remove(i);
            }
        }

        if (time % 80 == 0) {
            EnemySpawn es = new EnemySpawn(new Enemy(int(random(width - 100)), 0, levelScene), time + 10);
            enemySpawns.add(es);
        }
        super.update();
    }

}