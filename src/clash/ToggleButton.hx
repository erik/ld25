package clash;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

import nme.geom.Rectangle;

import clash.ClashWidget;
import clash.data.Clash;
import clash.data.ClashParser;
import clash.data.ClashImage;
import clash.data.ClashSlice;
import clash.data.ClashStyle;


/**
 * A clickable button widget
 */
class ToggleButton extends Button
{
  /**
   * Function to be called on button presses
   * @todo 			Provide more generic callback support
   */

  /**
   * Constructor. Must provide a position and a Clash data object
   * @param x 		X coordinate of the widget
   * @param y 		Y coordinate of the widget
   * @param clash 	Clash data object
   * @param style 	Specifies the style, found in the Clash data object, to use. If none provided, use the "Default" style
   * @param text 		Label of the button (Optional)
   * @param calling 	Callback function for the widget, which is activated when the widget is pressed
   */
  public function new(x : Float, y : Float, clash : Clash = null, style : String = "Default", text : String = "", calling : Void -> Void = null)
  {
    super(x, y, clash, style);

    var currentStyle : ClashStyle = clash.getElement("Button").getStyle(style);
    _normalRect = makeSliceRectangle(currentStyle.getSlice("Normal"));
    _downRect   = makeSliceRectangle(currentStyle.getSlice("Down"));

    reskin(clash.getCurrentImage());

    graphic = _normal;
    setHitboxTo(graphic);

    layer = 0;

    _label = new Text(text);
    _label.x = (width - _label.width) / 2;
    _label.y = (height - _label.height) / 2;

    this.calling = calling;

    _clicked = false;
  }

  public override function render() : Void
  {
    super.render();

    renderGraphic(_label);
  }

  /**
   * Applies a new skin to the widget; called automatically when clash.setCurrentImage() is called
   * @param 			image The new ClashImage to reskin the widget to
   */
  public override function reskin(image : ClashImage) : Void
  {
    _normal = new Image(image.path, _normalRect);
    _down = new Image(image.path, _downRect);
  }

  /**
   * Updates the widget; if overridden, the super must be called; otherwise, the widget will not work
   */
  public override function update() : Void
  {
    super.update();

    if (collidePoint(x, y, world.mouseX, world.mouseY)) {
      if (Input.mousePressed) {
        _clicked = true;
      }

      if (_clicked) {
        changeState(DOWN);
      } else {
      }

      if (_clicked && Input.mouseReleased) {
        click();
      }
    } else {
      if (_clicked) {
      } else {
        //changeState(NORMAL);
      }
    }

    if (Input.mouseReleased) {
      _clicked = false;
    }
  }

  private override function changeState(state : Int = 0)
  {
    switch (state) {
    case NORMAL:
      graphic = _normal;
    case DOWN:
      graphic = _down;
    }

  }

  private override function click() : Void
  {
    if (calling != null) {
      calling();
    }
  }

  public static inline var NORMAL : Int = 0;
  public static inline var DOWN : Int = 2;

}