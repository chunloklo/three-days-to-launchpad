public class LevelManager {
    ArrayList<Scene> scenes;
    int curScene;
    int score = 0;

    public LevelManager(){
        scenes = new ArrayList<Scene>();
        curScene = 0;
    }

    public Scene scene(){
        return scenes.get(curScene);
    }

    public void switchScene(int sceneIndex) {
        assert(sceneIndex < scenes.size());
        curScene = sceneIndex;
        // scenes.get(curScene).reset();
        scenes.get(curScene).start();
    }

    public void nextScene() {
        curScene = (curScene + 1) % scenes.size();
        scenes.get(curScene).start();
    }
}

public class InputManager {

}