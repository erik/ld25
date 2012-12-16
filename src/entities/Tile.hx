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
  public var resKnown : Bool;

  public function new(x, y : Int)
  {
    super(x * TILE_SIZE, y * TILE_SIZE);

    type = "tile";
    setHitbox(50, 50, 0, 0);

    outline = new TiledSpritemap("gfx/tile.png", 50,50,50,50);
    outline.add("reg", [0]);
    outline.add("sel", [1]);
    outline.add("known", [2]);
    outline.add("spent", [3]);

    outline.play("reg");

    layer = 10;

    conservationValue = Std.random(100);
    resourceValue = Std.random(2*conservationValue);

    if(Std.random(10) == 0) {
      resourceValue = 0;
    }

    graphic = outline;
    resKnown = false;
  }

  public function setFac(fac : Facility)
  {
    HXP.world.add(fac);
    facility = fac;
  }

  public override function update()
  {
    // disturbing my environment!
    if(resKnown && facility == null) {
      cast(HXP.world, GameWorld).activism += 2;
    }

    if(facility != null) {
      resKnown = true;
      if(!facility.positive) {
        if(facility.type=="refinery")
          cast(HXP.world, GameWorld).activism += 2*conservationValue;
        else cast(HXP.world, GameWorld).activism += conservationValue;
      }
      if(facility.online) {
        if(facility.payoutTimer <= 0) {
          facility.payoutTimer = Facility.PAYOUT_TIMER;
          if(!facility.positive) {
            if(facility.type == "refinery")
              cast(HXP.world, GameWorld).coffers += resourceValue + 275;
            else
              cast(HXP.world, GameWorld).coffers += resourceValue + 75;

            var newR : Int = Std.int(resourceValue * .90);
            cast(HXP.world, GameWorld).extRes += resourceValue - newR;
            resourceValue = newR;
          }
          cast(HXP.world, GameWorld).coffers -= facility.getUpkeep();
        }
        if(facility.positive) {
          switch(facility.type) {
          case "windmill":
            cast(HXP.world, GameWorld).activism -= conservationValue +
              resourceValue;
          case "recycle":
            cast(HXP.world, GameWorld).activism -= conservationValue +
              2 * resourceValue;
          }
        }
      }
    }

    if(resourceValue <= 0) {
      resourceValue = 0;
      if(facility != null && (facility.online && !facility.positive) && facility.type != "windmill") {
        Explosion.at(facility.x+25, facility.y+25);
        facility.online = facility.positive || false;
      }
    }

    if(selected) {
      outline.play("sel");
      selected = false;
    } else {
      if(resKnown) {
        if(resourceValue == 0) outline.play("spent");
        else outline.play("known");
      }
      else outline.play("reg");
    }
    super.update();
  }

}