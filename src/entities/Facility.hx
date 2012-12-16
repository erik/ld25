package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;

class Facility extends Entity
{
  public static inline var PAYOUT_TIMER : Float = 1;
  public static inline var UPKEEP : Int = 50;

  public static var smogLevel : Int;

  var emitter : Emitter;
  var payout : Int;
  public var payoutTimer: Float;
  public var online : Bool = true;
  public var positive : Bool = false;

  public function new(pay : Int, x, y : Float)
  {
    super(x, y);

    this.type = "facility";

    setHitbox(50, 50, 0, 0);

    emitter = new Emitter("gfx/smoke.png", 10, 10);
    emitter.newType('smoke', [0]);
    emitter.setMotion('smoke', 45, 45, .2, 70, 20, 3);
    emitter.setAlpha('smoke', 1, 0);
    emitter.setColor('smoke', 0x00000);
    emitter.setGravity('smoke', 2);

    addGraphic(emitter);

    payout = pay;
    payoutTimer = PAYOUT_TIMER;
  }

  public function particleEffect() : Void
  {
    emitter.emit('smoke',width/2, 10);
  }

  public function die()
  {
    HXP.world.remove(this);
  }

  public override function update()
  {
    super.update();
    if(online)particleEffect();

    if(online) {
      payoutTimer -= HXP.elapsed;
    }
  }

  public function getUpkeep() : Int
  {
    return UPKEEP;
  }
}