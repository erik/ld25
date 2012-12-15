package worlds;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.World;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Backdrop;

import entities.OilRig;
import entities.Facility;

class GameWorld extends World
{

  var background : Image;
  var facilities : Array<Facility>;

  public function new()
  {
    super();
  }

  public override function begin()
  {
    background = new Image("gfx/world_map.png");
    addGraphic(background);
  }

  public override function update()
  {
    if(Input.check(Key.LEFT)) {
      camera.x -= HXP.elapsed * 350;
      HXP.clamp(camera.x, 0, background.width);
    }
    if(Input.check(Key.RIGHT)) {
      camera.x += HXP.elapsed * 350;
      HXP.clamp(camera.x, 0, background.width);
    }

    if(Input.check(Key.UP)) {
      camera.y -= HXP.elapsed * 350;
      HXP.clamp(camera.y, 0, background.height);
    }
    if(Input.check(Key.DOWN)) {
      camera.y += HXP.elapsed * 350;
      HXP.clamp(camera.y, 0, background.height);
    }

    if(Input.mousePressed) {
      add(new OilRig(mouseX-32, mouseY-32));
    }

    super.update();
  }
}