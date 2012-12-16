package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;

class RecyclingCenter extends Facility
{
  public static inline var BUILD_COST : Int = 350;

  var spritemap : TiledSpritemap;

  public function new(x, y : Float)
  {
    super(0, x, y);

    positive = true;

    this.type = "recycle";

    spritemap = new TiledSpritemap("gfx/facilities.png", 50,50,50,50);
    spritemap.add("active", [4], 10);

    spritemap.play("active");

    this.graphic = spritemap;
  }

  public override function particleEffect()
  {
    return;
  }

  public override function getUpkeep()
  {
    return 150;
  }
}