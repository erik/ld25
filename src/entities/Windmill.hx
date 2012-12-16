package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;

class Windmill extends Facility
{
  public static inline var BUILD_COST : Int = 150;

  var spritemap : TiledSpritemap;

  public function new(x, y : Float)
  {
    super(0, x, y);

    this.type = "windmill";

    spritemap = new TiledSpritemap("gfx/facilities.png", 50,50,50,50);
    spritemap.add("active", [2, 3], 10);

    spritemap.play("active");

    this.graphic = spritemap;

    positive = true;
  }

  public override function particleEffect()
  {
    return;
  }

  public override function getUpkeep()
  {
    return 5;
  }
}