package entities;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.World;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Backdrop;


class Cursor extends Entity
{
  public var image : TiledSpritemap;

  public function new(x, y : Float)
  {
    super(x,y);

    type = "cursor";

    image = new TiledSpritemap("gfx/cursors.png", 32, 32, 32, 32);
    image.add("free", [0]);
    image.add("probe", [1]);
    image.add("rig", [2]);
    image.add("windmill", [3]);
    image.add("rec", [4]);
    image.add("ref", [5]);
    image.play("free");

    layer = 0;

    graphic = image;
  }
}