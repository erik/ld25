package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;

class OilRig extends Facility
{
  var spritemap : TiledSpritemap;

  public function new(x, y : Float)
  {
    this.type = "oilrig";

    spritemap = new TiledSpritemap("gfx/facilities.png", 64, 64, 64, 64);
    spritemap.add("active", [0, 1], 2);

    spritemap.play("active");

    this.graphic = spritemap;

    super(x, y);
  }
}