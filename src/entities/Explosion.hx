package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.TiledSpritemap;
import com.haxepunk.graphics.Emitter;

class Explosion
{
  public static function at(x, y : Float)
  {
    var emitter : Emitter;

    emitter = new Emitter("gfx/smoke.png", 10, 10);
    emitter.newType('smoke', [0]);
    emitter.setMotion('smoke', 45, 45, 1, 360, 20, 3);
    emitter.setAlpha('smoke', 1, 0);
    emitter.setColor('smoke', 0xff0000, 0xffffff);


    HXP.world.addGraphic(emitter).layer = 0;

    for(i in 0...50)
      emitter.emit('smoke', x, y);
  }
  public static function waterAt(x, y : Float)
  {
    var emitter : Emitter;

    emitter = new Emitter("gfx/smoke.png", 10, 10);
    emitter.newType('smoke', [0]);
    emitter.setMotion('smoke', 45, 45, 1, 360, 20, 3);
    emitter.setAlpha('smoke', 1, 0);
    emitter.setColor('smoke', 0x0000ff, 0xffffff);

    HXP.world.addGraphic(emitter).layer = 0;

    for(i in 0...50)
      emitter.emit('smoke', x, y);

  }
}