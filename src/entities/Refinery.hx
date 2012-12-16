package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

class Refinery extends Facility
{
  public static inline var BUILD_COST : Int = 2500;

  var spritemap : TiledSpritemap;

  public function new(x, y : Float)
  {
    spritemap = new TiledSpritemap("gfx/facilities.png", 50,50,50,50);
    spritemap.add("active", [5], 10);

    spritemap.play("active");

    this.graphic = spritemap;

    super(0, x, y);

    emitter.setMotion('smoke', 45, 45, 1, 45, 20, 3);
    emitter.setAlpha('smoke', 1, 0);
    emitter.setColor('smoke', 0x00000);
    emitter.setGravity('smoke', -2);

    this.type = "refinery";
  }


  public override function particleEffect()
  {
    emitter.emit('smoke', width/2, 10);
  }

  public override function update()
  {
    super.update();
  }


  public override function getUpkeep()
  {
    return 250;
  }
}