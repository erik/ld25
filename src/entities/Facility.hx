package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;

class Facility extends Entity
{
  public static var smogLevel : Int;

  var emitter : Emitter;

  public function new(x, y : Float)
  {
    super(x, y);

    this.type = "facility";

    setHitbox(64, 64, 0, 0);

    emitter = new Emitter("gfx/smoke.png", 10, 10);
    emitter.newType('smoke', [0]);
    emitter.setMotion('smoke', 45, 45, .2, 70, 20, 3);
    emitter.setAlpha('smoke', 1, 0);

    addGraphic(emitter);
  }

  public override function update()
  {
    super.update();
    emitter.emit('smoke',32, 32);
  }

}