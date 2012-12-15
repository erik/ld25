package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.World;

class ResourceGrid extends Entity
{
  public var tiles : Array<Array<Tile>>;

  public function new(w, h : Int)
  {
    super(0, 0);

    // i'm a dummy, these are doing to be backwards, i know it
    var cols : Int = Std.int(w / Tile.TILE_SIZE);
    var rows : Int = Std.int(h / Tile.TILE_SIZE);

    tiles = new Array<Array<Tile>>();

    for(i in 0...rows) {
      tiles[i] = new Array<Tile>();
      for(j in 0...cols) {
        tiles[i][j] = new Tile(i, j);
        HXP.world.add(tiles[i][j]);
      }
    }
  }
}