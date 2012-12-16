package entities;

import nme.geom.Point;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

class ImageButton extends Entity
{

  public var buttonMap : TiledSpritemap;

  // TBD
  // public static var tooltipMap = new
  //   TiledSpritemap("gfx/tooltip.png", 32, 32, 32, 32);


  public var relPos : Point;

  public function new(x, y : Float, imgInd : Int)
  {
    super(x, y);

    this.type = "button";

    setHitbox(64, 64, 0, 0);

    buttonMap = new TiledSpritemap("gfx/icons.png", 64,64,64,64);
    buttonMap.add("up", [imgInd]);
    buttonMap.add("down", [imgInd+5]);
    buttonMap.play("up");

    relPos = new Point(x,y);

    layer = 1;

    this.graphic = buttonMap;
  }

  public override function update()
  {
    x = relPos.x + Std.int(HXP.world.camera.x);
    y = relPos.y + Std.int(HXP.world.camera.y);

    if(HXP.world.collidePoint("button", HXP.world.mouseX, HXP.world.mouseY)
       == this)
    {
      buttonMap.play("down");
    } else {
      buttonMap.play("up");
    }

    super.update();
  }

}