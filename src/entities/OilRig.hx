package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;

class OilRig extends Facility
{
  public static inline var BUILD_COST : Int = 500;

  var spritemap : TiledSpritemap;

  public function new(pay : Int, x, y : Float)
  {
    spritemap = new TiledSpritemap("gfx/facilities.png", 50,50,50,50);
    spritemap.add("active", [0, 1], 2);
    spritemap.add("inactive", [0]);

    spritemap.play("active");

    online = true;

    this.graphic = spritemap;

    super(pay, x, y);

    this.type = "oilrig";
  }

  public override function update()
  {
    if(!online) {
      spritemap.play("inactive");
    }
    super.update();
  }

}