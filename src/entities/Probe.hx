package entities;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;

import nme.geom.Point;
import nme.display.BitmapData;

class Probe extends Entity
{
  public var endPos : Point;
  public function new(x, y : Float)
  {
    super(x, y);

    endPos = new Point(0,0);

    graphic = new Image(
      new BitmapData(10,10, false, 0xffffff));

    layer = 0;
  }

  public override function update()
  {

    super.update();
  }

  public function setEnd(x, y : Float)
  {
    endPos.x = x;
    endPos.y = y;

    graphic = new Image(new BitmapData(
                          Std.int(Math.abs(endPos.x-this.x)+1),
                          Std.int(Math.abs(endPos.y-this.y)+1),
                          true, 0x55222222));
  }
}