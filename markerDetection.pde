/**
 * NyARToolkit for proce55ing/3.0.5
 * (c)2008-2017 nyatla
 * airmail(at)ebony.plala.or.jp
 *
 * 最も短いARToolKitのコードです。
 * Hiroマーカの上に立方体を表示します。
 * 全ての設定ファイルとマーカファイルはスケッチディレクトリのlibraries/nyar4psg/dataにあります。
 *
 * This sketch is shortest sample.
 * The sketch shows cube on the marker of "patt.hiro".
 * Any pattern and configuration files are found in libraries/nyar4psg/data inside your sketchbook folder.
*/
import processing.video.*;
import jp.nyatla.nyar4psg.*;

class MarkerDetector {

  Capture cam;
  MultiMarker nya;

  double x = 0;


  void setup(PApplet pa) {
    println(MultiMarker.VERSION);
    cam=new Capture(pa,640,480);
    nya=new MultiMarker(pa,640,480,"data/camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
    nya.addARMarker("data/patt.hiro",80);
    cam.start();
    // nya.setConfidenceThreshold(0.1);
    nya.setLostDelay(20);
  }

  void draw()
  {
    if (cam.available() !=true) {
        return;
    }
    cam.read();
    nya.detect(cam);
    // background(0);
    // nya.drawBackground(cam);//frustumを考慮した背景描画
    if((!nya.isExist(0))){
      return;
    }

    PVector[] pos = nya.getMarkerVertex2D(0);
    // println(pos[0].x);
    x = pos[0].x;
    println("marker detected!");
    println(x);
    // println(pos);
    // nya.beginTransform(0);
    // fill(0,0,255);
    // translate(0,0,20);
    // box(40);
    // nya.endTransform();
  }
}

