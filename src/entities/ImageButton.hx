package entities;

import nme.geom.Point;

import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

import entities.TextArea;

import worlds.GameWorld;

class ImageButton extends Entity
{

  public var buttonMap : TiledSpritemap;
  public var tooltip : TextArea;

  public var relPos : Point;
  public var calling : Void -> Void;

  public var click : Sfx;

  public function new(x, y : Float, imgInd : Int,
                      call : Void -> Void = null, str : String = "")
  {
    super(x, y);

    this.type = "button";

    click = new Sfx("sfx/select.wav");

    setHitbox(64, 64, 0, 0);

    buttonMap = new TiledSpritemap("gfx/icons.png", 64,64,64,64);
    buttonMap.add("up", [imgInd]);
    buttonMap.add("down", [imgInd+5]);
    buttonMap.add("press", [imgInd+10]);
    buttonMap.play("up");

    relPos = new Point(x,y);

    this.calling = call;

    if(str != "") {
      tooltip = new TextArea(-256+x+20, y-156, str,
                             new Image("gfx/tooltip.png"));
    }
    if(tooltip != null) {
      tooltip.visible = false;
      HXP.world.add(tooltip);
    }

    layer = 1;

    this.graphic = buttonMap;
  }

  public override function update()
  {
    if(tooltip != null) tooltip.visible = false;
    x = relPos.x + Std.int(HXP.world.camera.x);
    y = relPos.y + Std.int(HXP.world.camera.y);

    if(HXP.world.collidePoint("button", HXP.world.mouseX, HXP.world.mouseY)
       == this)
    {
      cast(HXP.world, GameWorld).dontAdd = true;

      if(tooltip != null)tooltip.visible = true;

      if(Input.mousePressed) click.play(.5);

      if(Input.mouseDown)
        buttonMap.play("press");
      else buttonMap.play("down");

      if(Input.mouseReleased && calling != null) {
        calling();
      }

    } else {
      buttonMap.play("up");
    }

    super.update();
  }

}