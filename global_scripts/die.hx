//a
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

function create() {
    var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
    diamond.persist = true;
    diamond.destroyOnNoUse = false;
    FlxTransitionableState.defaultTransIn = new TransitionData("tiles", 0xFF000000, 1, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
        new FlxRect(0, 0, FlxG.width, FlxG.height));
    FlxTransitionableState.defaultTransOut = new TransitionData("tiles", 0xFF000000, 1, new FlxPoint(0, 1),
        {asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));
}