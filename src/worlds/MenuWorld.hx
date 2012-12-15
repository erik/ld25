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

class MenuWorld extends World
{
  var background : Image;

  public function new()
  {
    super();
  }

  public override function begin()
  {
    background = new Image("gfx/menu.png");
    addGraphic(background);
  }

  public override function update()
  {
    if(Input.check(Key.SPACE)) {
      HXP.world = new GameWorld();
    }

    super.update();
  }

}