package worlds;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.World;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Backdrop;

import clash.data.Clash;
import clash.data.ClashParser;
import clash.Button;
import clash.Checkbox;
import clash.RadioButton;
import clash.Handle;

import entities.Cursor;

class MenuWorld extends World
{
  var background : Image;
  var cursor : Cursor;
  private var _currentClash : Clash;

  public function new()
  {
    super();
    _currentClash = ClashParser.parse("clash/default.clash");
  }

  public override function begin()
  {

    flash.ui.Mouse.show();
    background = new Image("gfx/menu.png");
    background.originX = background.width/2;
    background.originY = background.height/2;
    background.x = background.width/2;
    background.y = background.height/2;
        addGraphic(background);

    add(new Button(HXP.width-225, HXP.halfHeight, _currentClash, "Default",
                   "  Begin  ", StartButtonCallback));

    add(new Button(HXP.width-225, HXP.halfHeight + 100, _currentClash,
                   "Default", "  Tutorial  ", TutorialButtonCallback));
  }

  public override function update()
  {
    super.update();
  }

  public function StartButtonCallback()
  {
    HXP.world = new GameWorld();
  }

  public function TutorialButtonCallback()
  {
    HXP.world = new TutorialWorld();
  }
}