package entities;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

class GUI extends Entity
{

  var money : Text;

  public function new()
  {
    super(0, 0);

    layer = -1;

    money = new Text("asd");
    money.x = HXP.camera.x;
    money.y = HXP.camera.y;

    this.graphic = money;
  }

  public override function update()
  {
  }
}