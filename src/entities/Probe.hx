package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Probe extends Entity
{
  var timeLeft : Float;
  var resources : Int;

  public function new(time : Float, res : Int, x, y : Float)
  {
    super(x, y);

    timeLeft = time;
    resources = res;
  }

  public override function update()
  {
    timeLeft -= HXP.elapsed;
    HXP.clamp(timeLeft, 0, timeLeft);

    super.update();
  }

  public function isDone() : Bool
  {
    return timeLeft <= 0;
  }

  public function getResourceCount() : Int
  {
    return resources;
  }
}