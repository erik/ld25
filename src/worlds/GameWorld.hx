 package worlds;

import nme.Assets;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.World;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Backdrop;

import com.haxepunk.masks.Grid;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;


import entities.Facility;
import entities.ProcessingFacility;
import entities.OilRig;
import entities.Probe;

import entities.Cursor;

import clash.data.Clash;
import clash.data.ClashParser;
import clash.Button;
import clash.Checkbox;
import clash.RadioButton;
import clash.Handle;

enum MouseState {
  FREE;
  PLACE_OILRIG;
}


class GameWorld extends World
{

  private var _currentClash : Clash;
  var background : Image;
  var facilities : Array<Facility>;
  var coffers : Int;
  var buttons : Array<Button>;
  var mouseState : MouseState;
  var cursor : Cursor;

  public function new()
  {
    super();
    _currentClash = ClashParser.parse("clash/default.clash");
  }

  public override function begin()
  {
    background = new Image("gfx/world_map.png");
    facilities = new Array<Facility>();

    addGraphic(background);

    buttons = new Array<Button>();

    var b = new Button(0, 0, _currentClash,
                       "Default", "Send Probe");
    buttons.push(b);
    add(b);

    b = new Button(0, 100, _currentClash,
                   "Default", "Build Rig", ConstructRigCallback);
    buttons.push(b);
    add(b);

    mouseState = FREE;

    var map : TmxMap = new TmxMap(Assets.getText("levels/collisionmap.tmx"));
    var tmx : TmxEntity = new TmxEntity(map);
    tmx.type = "collide";
    tmx.loadMask("collide", "collide", null);
    tmx.type = "collide";

    add(tmx);

    flash.ui.Mouse.hide();

    cursor = new Cursor(mouseX, mouseY);

    add(cursor);

    Input.define("left",  [Key.LEFT, Key.A]);
    Input.define("right", [Key.RIGHT, Key.D]);
    Input.define("up",    [Key.UP, Key.W]);
    Input.define("down",  [Key.DOWN, Key.S]);
  }

  public override function update()
  {
    if(Input.check("left")) {
      camera.x -= HXP.elapsed * 350;
      HXP.clamp(camera.x, 0, background.width);
    }
    if(Input.check("right")) {
      camera.x += HXP.elapsed * 350;
      HXP.clamp(camera.x, 0, background.width);
    }

    if(Input.check("up")) {
      camera.y -= HXP.elapsed * 350;
      HXP.clamp(camera.y, 0, background.height);
    }
    if(Input.check("down")) {
      camera.y += HXP.elapsed * 350;
      HXP.clamp(camera.y, 0, background.height);
    }

    if(Input.mousePressed) {
      switch(mouseState) {
      case PLACE_OILRIG:
        // bad area to place rig
        if(collidePoint("collide", mouseX, mouseY) != null) {
          var fac = new OilRig(Std.random(30), mouseX-32, mouseY-32);
          add(fac);
          facilities.push(fac);
          cursor.image.play("free");
          mouseState = FREE;
        }
      case FREE:
      }
    }

    for(fac in facilities.iterator()) {
      coffers += fac.getPayout();
    }

    for(but in buttons.iterator()) {
      but.x = HXP.camera.x + HXP.width-225;
      switch(but._label.text) {
      case "Send Probe": but.y = HXP.camera.y;
      case "Build Rig": but.y = HXP.camera.y + 100;
      }
    }

    cursor.x = mouseX;
    cursor.y = mouseY;

    super.update();
  }

  public function ConstructRigCallback()
  {
    mouseState = PLACE_OILRIG;
    cursor.image.play("rig");
  }

}