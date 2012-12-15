package worlds;

import nme.Assets;
import nme.geom.Point;

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

import clash.data.Clash;
import clash.data.ClashParser;
import clash.Button;
import clash.Label;
import clash.Checkbox;
import clash.RadioButton;
import clash.Handle;

import entities.Facility;
import entities.ProcessingFacility;
import entities.OilRig;
import entities.Probe;
import entities.ResourceGrid;
import entities.Tile;

import entities.Cursor;

enum MouseState {
  FREE;
  PLACE_OILRIG;
  PLACE_PROBE_PRE;
  PLACE_PROBE;
}


class GameWorld extends World
{

  private var _currentClash : Clash;
  var background : Image;
  public var coffers : Int;
  public var buttons : Array<Button>;
  var mouseState : MouseState;
  var cursor : Cursor;
  var grid : ResourceGrid;
  var probe : Probe;
  var bankrupt : Bool = false;
  var bankruptImg : Image;

  public function new()
  {
    super();
    _currentClash = ClashParser.parse("clash/default.clash");
  }

  public override function begin()
  {
    flash.ui.Mouse.hide();

    background = new Image("gfx/world_map.png");

    addGraphic(background).layer = 100;

    buttons = new Array<Button>();

    var l = new Label(0, 0, _currentClash, "Default",
                      "000000000000\n000000000000\n000000000000");
    l.type = "stats";
    buttons.push(l);
    add(l);

    var b = new Button(160, 0, _currentClash,
                       "Default", "Probe Region\n$50/tile", ProbeCallback);
    buttons.push(b);
    add(b);

    b = new Button(310, 0, _currentClash,
                   "Default", "Build Rig\n$500", ConstructRigCallback);
    buttons.push(b);
    add(b);

    mouseState = FREE;

    var map : TmxMap = new TmxMap(Assets.getText("levels/collisionmap.tmx"));
    var tmx : TmxEntity = new TmxEntity(map);
    tmx.type = "collide";
    tmx.loadMask("collide", "collide", null);
    tmx.type = "collide";

    add(tmx);

    cursor = new Cursor(mouseX, mouseY);

    add(cursor);

    Input.define("left",  [Key.LEFT, Key.A]);
    Input.define("right", [Key.RIGHT, Key.D]);
    Input.define("up",    [Key.UP, Key.W]);
    Input.define("down",  [Key.DOWN, Key.S]);

    coffers = 5000;

    grid = new ResourceGrid(background.width, background.height);

    bankruptImg = new Image("gfx/gameover.png");
    bankruptImg.visible = false;
    bankruptImg.x = HXP.halfWidth;
    bankruptImg.y = HXP.halfHeight;

    addGraphic(bankruptImg).layer = 0;

    camera.x = HXP.halfWidth;
    camera.y = HXP.halfHeight;

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

    if(coffers < 0) {
      bankrupt = true;
      bankruptImg.visible = true;
      bankruptImg.x = Std.int(HXP.halfWidth - bankruptImg.width/2 +
                              HXP.camera.x);
      bankruptImg.y = Std.int(HXP.halfHeight- bankruptImg.height/2 +
                              HXP.camera.y);
    }

    var curTile : Tile = cast(collidePoint("tile", mouseX, mouseY),Tile);
    if(curTile != null) {
      curTile.selected = true;
    }
    if(!bankrupt) {
      if(Input.mousePressed) {
        switch(mouseState) {
        case PLACE_OILRIG:
          if(collidePoint("collide", mouseX, mouseY) != null) {
            if(coffers - OilRig.BUILD_COST > 0) {
              if(curTile != null && curTile.facility == null) {
                var fac = new OilRig(Std.random(100), curTile.x, curTile.y);
                curTile.facility = fac;
                add(fac);
                coffers -= OilRig.BUILD_COST;
              }
            } else {
              // No money
            }
            mouseState = FREE;
          }
        case PLACE_PROBE_PRE:
          mouseState = PLACE_PROBE;
          probe = new Probe(Std.int(mouseX / Tile.TILE_SIZE) * Tile.TILE_SIZE,
                            Std.int(mouseY / Tile.TILE_SIZE) * Tile.TILE_SIZE);
          add(probe);
        case FREE:
          //
        case PLACE_PROBE:
          //
        }
      }

      if(Input.mouseDown && mouseState == PLACE_PROBE) {
        probe.setEnd(mouseX, mouseY);
      }

      if(Input.mouseReleased && mouseState == PLACE_PROBE) {
        var start = new Point(probe.x / Tile.TILE_SIZE,
                              probe.y / Tile.TILE_SIZE);
        var end = new Point(Std.int(probe.endPos.x / Tile.TILE_SIZE),
                            Std.int(probe.endPos.y / Tile.TILE_SIZE));

        var cost = (Std.int(end.x+1)-Std.int(start.x)) *
          (Std.int(end.y+1)-Std.int(start.y)) * 50;

        if(coffers - cost >= 0) {
          var tiles = grid.tiles;

          for(i in Std.int(start.x)...Std.int(end.x+1)) {
            for(j in Std.int(start.y)...Std.int(end.y+1)) {
              tiles[i][j].selected = true;
              tiles[i][j].resKnown = true;
            }
          }
          coffers -= cost;
        }

        remove(probe);
        probe == null;
        mouseState = FREE;
      }
    }
    switch(mouseState) {
    case PLACE_OILRIG:
      cursor.image.play("rig");
    case FREE:
      cursor.image.play("free");
    case PLACE_PROBE, PLACE_PROBE_PRE:
      cursor.image.play("probe");
    }

    var xpos = Std.int(HXP.camera.x);
    for(but in buttons.iterator()) {
      but.y = Std.int(HXP.height + HXP.camera.y - 60);
      but.x = xpos;
      xpos += 160;
      if(but.type == "stats") {
        // wow.
        but._label.text = "$" + Std.string(coffers) + " \nECO: "
          + Std.string(curTile != null ? curTile.conservationValue : 0)
          + "\nRES: " +
          (curTile != null ? (curTile.resKnown ?
                              Std.string(curTile.resourceValue) : "???")
           : "???");
      }
    }


    if(Input.check(Key.ESCAPE)) {
      HXP.world = new MenuWorld();
    }

    cursor.x = mouseX;
    cursor.y = mouseY;

    super.update();
  }

  public function ConstructRigCallback()
  {
    mouseState = PLACE_OILRIG;
  }

  public function ProbeCallback()
  {
    mouseState = PLACE_PROBE_PRE;
  }

}