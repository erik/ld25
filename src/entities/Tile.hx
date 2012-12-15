package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.TiledSpritemap;

import worlds.GameWorld;

class Tile extends Entity
{
  public static inline var TILE_SIZE : Int = 50;

  public var outline : TiledSpritemap;
  public var selected : Bool = false;
  public var facility : Facility = null;
  public var resourceValue : Int = 30;
  public var conservationValue : Int = 30;
  public var resKnown : Bool = false;

  public function new(x, y : Int)
  {
    super(x * TILE_SIZE, y * TILE_SIZE);

    type = "tile";
    setHitbox(50, 50, 0, 0);

    outline = new TiledSpritemap("gfx/tile.png", 50,50,50,50);
    outline.add("reg", [0]);
    outline.add("sel", [1]);
    outline.add("known", [2]);

    outline.play("reg");

    layer = 10;

    conservationValue = Std.random(100);
    resourceValue = Std.random(2*conservationValue + 100);

    if(Std.random(10) == 0) {
      resourceValue = 0;
    }

    graphic = outline;
  }

  public override function update()
  {
    if(facility != null) {
      resKnown = true;
      if(facility.payoutTimer <= 0) {
        facility.payoutTimer = Facility.PAYOUT_TIMER;
        cast(HXP.world, GameWorld).coffers += resourceValue - Facility.UPKEEP;
      }
    }

    if(selected) {
      outline.play("sel");
      selected = false;
    } else {
      if(resKnown) outline.play("known");
      else outline.play("reg");
    }
    super.update();
  }

}