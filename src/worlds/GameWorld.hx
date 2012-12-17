package worlds;

import nme.Assets;
import nme.geom.Point;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
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
import clash.ToggleButton;
import clash.Label;
import clash.Checkbox;
import clash.RadioButton;
import clash.Handle;

import entities.Facility;
import entities.ProcessingFacility;
import entities.OilRig;
import entities.Windmill;
import entities.RecyclingCenter;
import entities.Refinery;
import entities.Probe;
import entities.ResourceGrid;
import entities.Tile;

import entities.Cursor;
import entities.ImageButton;
import entities.TextArea;

enum MouseState {
  FREE;
  PLACE_OILRIG;
  PLACE_REFINERY;
  PLACE_RECYCLING;
  PLACE_WINDMILL;
  PLACE_PROBE_PRE;
  PLACE_PROBE;
}

enum LoseCondition {
  WIN;
  BANKRUPT;
  OVERTHROW;
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
  var lose : Bool = false;
  var bankruptImg : Image;
  var winImg : Image;
  var overImg : Image;
  public var activism : Int = 0;
  public var cond : LoseCondition;
  public var but : ImageButton;
  public var totRes : Int;
  public var extRes : Int = 0;
  public var dontAdd : Bool = false;
  public var text : TextArea;
  public var place : Sfx;

  public function new()
  {
    super();
    _currentClash = ClashParser.parse("clash/default2.clash");
  }

  public override function begin()
  {
    flash.ui.Mouse.hide();

    place = new Sfx("sfx/place.wav");

    background = new Image("gfx/world_map.png");

    addGraphic(background).layer = 100;

    buttons = new Array<Button>();

    text = new TextArea(1, HXP.height - 64,
                        "textarea", new Image("gfx/textarea.png"));
    add(text);

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

    coffers = 1500;

    grid = new ResourceGrid(background.width, background.height);

    bankruptImg = new Image("gfx/gameover_bank.png");
    bankruptImg.visible = false;
    bankruptImg.x = HXP.halfWidth;
    bankruptImg.y = HXP.halfHeight;
    addGraphic(bankruptImg).layer = 0;


    winImg = new Image("gfx/gameover_win.png");
    winImg.visible = false;
    winImg.x = HXP.halfWidth;
    winImg.y = HXP.halfHeight;
    addGraphic(winImg).layer = 0;


    overImg = new Image("gfx/gameover_overthrow.png");
    overImg.visible = false;
    overImg.x = HXP.halfWidth;
    overImg.y = HXP.halfHeight;
    addGraphic(overImg).layer = 0;


    var xpos : Int = Std.int((HXP.width-65*5)/2);


    add(new ImageButton(xpos += 1, HXP.height -64, 0, ProbeCallback,
                        " Probe a region for delicious oil\n\n" +
                        " Reveals the resources available\n" +
                        " on each selected tile.\n\n" +
                        " Probing costs $50 per tile\n"+
                        " and slightly increases activism"));

    add(new ImageButton(xpos += 64+1, HXP.height -64, 1, ConstructRigCallback,
                        " Construct basic oil rig facility.\n\n" +
                        " Quick and easy resource draining!\n\n" +
                        " Costs $500 to build"));
    add(new ImageButton(xpos += 64+1, HXP.height -64, 4, ConstructRefineryCallback,
                        " The latest and greatest in\n" +
                        " resource draining technology!\n\n" +
                        " Refineries are much more\n" +
                        " efficient than oil rigs, but more\n" +
                        " expensive\n\n" +
                        " Costs $2500 to build."
          ));

    add(new ImageButton(xpos += 64+1, HXP.height -64, 2, ConstructWindmillCallback,
                        " They sure love their windmills for\n" +
                        " some reason\n\n" +
                        " Decreases activism at rate of\n" +
                        " RES + ECO for a given tile\n\n" +
                        " Costs $150 to build, $5 to run"));

    add(new ImageButton(xpos += 64+1, HXP.height - 64, 3, ConstructRecycleCallback,
                        " The perfect activism reducer\n" +
                        " Recycling facilities make the\n" +
                        " activists jump for joy. \n\n" +
                        " Significantly reduces activism\n\n" +
                        " Costs $350 to build, $50 to run"
                        ));

    camera.x = HXP.halfWidth;
    camera.y = HXP.halfHeight;

  }

  public override function update()
  {
    dontAdd = false;

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


    super.update();

    if(coffers < 0) {
      lose = true;
      cond = BANKRUPT;
    }

    if(extRes >= totRes) {
      lose = true;
      cond = WIN;
    }

    var curTile : Tile = cast(collidePoint("tile", mouseX, mouseY),Tile);

    if(!dontAdd) {
      if(curTile != null) {
        curTile.selected = true;
      }
      if(!lose) {
        if(Input.mousePressed) {
          switch(mouseState) {
          case PLACE_REFINERY:
            if(collidePoint("collide", mouseX, mouseY) != null) {
              if(coffers - Refinery.BUILD_COST >= 0) {
                if(curTile != null && curTile.facility == null) {
                  var fac = new Refinery(curTile.x, curTile.y);
                  curTile.setFac(fac);
                  coffers -= Refinery.BUILD_COST;
                  place.play(0.5);
                }
              } else {
                // No money
              }
            } else {
              Explosion.waterAt(mouseX, mouseY);
            }
            mouseState = FREE;
          case PLACE_RECYCLING:
            if(collidePoint("collide", mouseX, mouseY) != null) {
              if(coffers - RecyclingCenter.BUILD_COST >= 0) {
                if(curTile != null && curTile.facility == null) {
                  var fac = new RecyclingCenter(curTile.x, curTile.y);
                  curTile.setFac(fac);
                  coffers -= RecyclingCenter.BUILD_COST;
                  place.play(0.5);
                }
              } else {
                // No money
              }
            } else {
              Explosion.waterAt(mouseX, mouseY);
            }
            mouseState = FREE;
          case PLACE_OILRIG:
            if(collidePoint("collide", mouseX, mouseY) != null) {
              if(coffers - OilRig.BUILD_COST >= 0) {
                if(curTile != null && curTile.facility == null) {
                  var fac = new OilRig(Std.random(100), curTile.x, curTile.y);
                  curTile.setFac(fac);
                  coffers -= OilRig.BUILD_COST;
                  place.play(0.5);
                }
              } else {
                // No money
              }
            } else {
              Explosion.waterAt(mouseX, mouseY);
            }
            mouseState = FREE;
          case PLACE_WINDMILL:
            if(collidePoint("collide", mouseX, mouseY) != null) {
              if(coffers - Windmill.BUILD_COST >= 0) {
                if(curTile != null && curTile.facility == null) {
                  var fac = new Windmill(curTile.x, curTile.y);
                  curTile.setFac(fac);
                  add(fac);
                  coffers -= Windmill.BUILD_COST;
                  place.play(0.5);
                }
              } else {
                // No money
              }
            } else {
              Explosion.waterAt(mouseX, mouseY);
            }
            mouseState = FREE;
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
              if(i >= tiles.length || i < 0) { break; }
              for(j in Std.int(start.y)...Std.int(end.y+1)) {
                if(j >= tiles[i].length || j < 0 ) { break; }
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
    }

    switch(mouseState) {
    case PLACE_OILRIG:
      cursor.image.play("rig");
    case PLACE_REFINERY:
      cursor.image.play("ref");
    case PLACE_RECYCLING:
      cursor.image.play("rec");
    case PLACE_WINDMILL:
      cursor.image.play("windmill");
    case FREE:
      cursor.image.play("free");
    case PLACE_PROBE, PLACE_PROBE_PRE:
      cursor.image.play("probe");
    }

    HXP.clamp(this.activism, 0, 10000);

    var xpos = Std.int(HXP.camera.x);
    for(but in buttons.iterator()) {
      but.y = Std.int(HXP.height + HXP.camera.y - 60);
      but.x = xpos;
      xpos += 160;
     }

    var per = Std.int(activism / 2500 * 100);
    // wow.
    text.setText(
      "$" + Std.string(coffers) + ", ACT: " +
      Std.string(per < 0? 0 : per) + "%, EXT: " +
      Std.string(Std.int(extRes/totRes * 100)) + "%"
      +"\n\n" +(curTile != null ? curTile.facility != null
       ? curTile.facility.type : "Empty" : "Empty")
      + ", ECO: "
      + Std.string(curTile != null ? curTile.conservationValue : 0)
      + ", RES: " +
      (curTile != null ? (curTile.resKnown ?
                          Std.string(curTile.resourceValue) : "???")
       : "???"));



    if(activism > 2500) {
      lose = true;
      cond = OVERTHROW;
    }

    if(Input.check(Key.ESCAPE)) {
      HXP.world = new MenuWorld();
    }

    if(lose) {
      switch(cond) {
      case OVERTHROW:
      overImg.visible = true;
      overImg.x = Std.int(HXP.halfWidth - overImg.width/2 +
                              HXP.camera.x);
      overImg.y = Std.int(HXP.halfHeight- overImg.height/2 +
                              HXP.camera.y);
      case BANKRUPT:
        bankruptImg.visible = true;
        bankruptImg.x = Std.int(HXP.halfWidth - bankruptImg.width/2 +
                                HXP.camera.x);
        bankruptImg.y = Std.int(HXP.halfHeight- bankruptImg.height/2 +
                                HXP.camera.y);
      case WIN:
        winImg.visible = true;
        winImg.x = Std.int(HXP.halfWidth - winImg.width/2 +
                                HXP.camera.x);
        winImg.y = Std.int(HXP.halfHeight- winImg.height/2 +
                                HXP.camera.y);

      }
    }

    cursor.x = mouseX;
    cursor.y = mouseY;

    activism = 0;

  }

  public function ConstructRigCallback()
  {
    if(mouseState == PLACE_OILRIG) mouseState = FREE;
    else mouseState = PLACE_OILRIG;
  }

  public function ConstructRecycleCallback()
  {
    if(mouseState == PLACE_RECYCLING) mouseState = FREE;
    else mouseState = PLACE_RECYCLING;
  }

  public function ConstructRefineryCallback()
  {
    if(mouseState == PLACE_REFINERY) mouseState = FREE;
    else mouseState = PLACE_REFINERY;
  }

  public function ConstructWindmillCallback()
  {
    if(mouseState == PLACE_WINDMILL) mouseState = FREE;
    else mouseState = PLACE_WINDMILL;
  }

  public function ProbeCallback()
  {
    if(mouseState == PLACE_PROBE_PRE) mouseState = FREE;
    else mouseState = PLACE_PROBE_PRE;
  }

}