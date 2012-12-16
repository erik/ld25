package worlds;

import com.haxepunk.Engine;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.World;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Backdrop;

import entities.Cursor;

class TutorialWorld extends World
{
  var bg : Entity;
  var cursor : Cursor;
  var i : Int = 0;

  public function new()
  {
    super();
  }

  public override function begin()
  {
    flash.ui.Mouse.show();
    addGraphic(new Image("gfx/tutorial.png"));
    bg = addGraphic(new Image("gfx/tutorial0.png"));
  }

  public override function update()
  {
    super.update();

    if(Input.mousePressed || Input.check(Key.ENTER)
       || Input.check(Key.SPACE))
      next();

    if(Input.check(Key.ESCAPE)) HXP.world = new MenuWorld();

  }

  public function next()
  {
    if(++i > 11) HXP.world = new GameWorld();
    else {
      var im = new Image("gfx/tutorial" + Std.string(i) + ".png");
      bg.graphic = im;
    }
  }

}