import com.haxepunk.Engine;
import com.haxepunk.HXP;

import worlds.MenuWorld;

class Main extends Engine
{

  public static inline var kScreenWidth:Int = 720;
  public static inline var kScreenHeight:Int = 480;
  public static inline var kFrameRate:Int = 30;
  public static inline var kClearColor:Int = 0x04819e;
  public static inline var kProjectName:String = "ld25";

  public function new()
  {
    super(kScreenWidth, kScreenHeight, kFrameRate, false);
  }

  override public function init()
  {
    HXP.console.enable();
    HXP.screen.color = kClearColor;
    HXP.world = new MenuWorld();
  }

  public static function main()
  {
    new Main();
  }

}