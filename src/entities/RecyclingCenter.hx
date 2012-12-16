package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

class RecyclingCenter extends Facility
{
  public static inline var BUILD_COST : Int = 350;

  var spritemap : TiledSpritemap;
  var _emitter : Emitter;

  public function new(x, y : Float)
  {
    super(0, x, y);

    positive = true;

    this.type = "recycle";

    spritemap = new TiledSpritemap("gfx/facilities.png", 50,50,50,50);
    spritemap.add("active", [4], 10);

    spritemap.play("active");

    _emitter = new Emitter("gfx/rec.png", 20, 20);
    _emitter.newType('smoke', [0,1]);
    _emitter.setMotion('smoke', 45, 45, .2, 70, 20, 3);
    _emitter.setAlpha('smoke', 1, 0);
    _emitter.setGravity('smoke', -2);

    this.graphic = spritemap;
    addGraphic(_emitter);
  }

  public override function particleEffect()
  {
    if(Std.random(25) == 0) _emitter.emit('smoke',width/2, 10);
  }

  public override function getUpkeep()
  {
    return 150;
  }
}