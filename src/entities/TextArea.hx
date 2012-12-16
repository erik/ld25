package entities;

import nme.geom.Point;

import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

import worlds.GameWorld;

class TextArea extends Entity
{
  public var image : Image;
  public var text : Text;
  public var relPos : Point;

  public function new(x,y:Float, str : String, img : Image)
  {
    super(x,y);
    this.type = "textarea";

    image = img;

    relPos = new Point(x,y);

    layer = 0;

    text = new Text(str, 0, 0, img.width, img.height);

    addGraphic(img);
    addGraphic(text);
  }

  public override function update()
  {
    super.update();

    x = relPos.x + Std.int(HXP.world.camera.x);
    y = relPos.y + Std.int(HXP.world.camera.y);

  }

  public function setText(str : String)
  {
    text.text = str;
  }

}