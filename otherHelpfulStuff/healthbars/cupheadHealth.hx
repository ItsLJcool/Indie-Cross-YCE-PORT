//a
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import HealthIcon;

var healthBarNEW:FlxBar;

function onGuiPopup() {
    healthBarBG.loadGraphic(Paths.image('healthbars/cuphealthbar'));
    healthBarBG.y = FlxG.height * 0.8565;
    healthBar.y -= 15;
    scoreTxt.y += 15;
    healthBarBG.updateHitbox();
    healthBarBG.screenCenter(FlxAxes.X);
    healthBarBG.cameras = [PlayState.camHUD];
    if (EngineSettings.downscroll) {
        healthBarBG.y = 30;
    }
    // PlayState.healthBar.kill();
    PlayState.remove(PlayState.healthBar);
    PlayState.insert(0, PlayState.healthBar);
    
	healthBarNEW = new FlxBar(PlayState.healthBarBG.x + 17, PlayState.healthBarBG.y + 4, FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(PlayState.healthBarBG.width - 32),
    Std.int(PlayState.healthBarBG.height - 10), this, 'healthNEW', 0, PlayState.maxHealth);
    healthBarNEW.scrollFactor.set();
    healthBarNEW.cameras = [PlayState.camHUD];
    healthBarNEW.createFilledBar(dad.getColors()[0], boyfriend.getColors()[0]);
    healthBarNEW.visible = true;
    PlayState.insert(14, healthBarNEW);

    healthBarNEW.setRange(-1, 1);
    healthBarNEW.setRange(0, maxHealth);
    healthBarNEW.dirty = true;
}

function update(elapsed:Float) {
    // healthBarNEW.percent = PlayState.healthBar.percent;
	healthBarNEW.value = PlayState.healthBar.value;
}