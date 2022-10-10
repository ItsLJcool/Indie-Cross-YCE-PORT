//a
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import HealthIcon;

var healthBarNEW:FlxBar;

function onGuiPopup() {
    healthBarBG.loadGraphic(Paths.image('healthbars/sanshealthbar'));
    healthBarBG.y = FlxG.height * 0.77;
    healthBarBG.y += 94;
    healthBar.y = healthBarBG.y + 20;
    healthBar.visible = false; // forgor it existed
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
    
	healthBarNEW = new FlxBar(PlayState.healthBarBG.x, PlayState.healthBarBG.y + 10, FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(PlayState.healthBarBG.width),
    Std.int(PlayState.healthBarBG.height), this, 'health', 0, PlayState.maxHealth);
    healthBarNEW.scrollFactor.set();
    healthBarNEW.cameras = [PlayState.camHUD];
    healthBarNEW.createFilledBar(0xFFFF0000,0xFFFFFF00);
    healthBarNEW.visible = true;
    healthBarNEW.angle = -180;
    PlayState.insert(14, healthBarNEW);

    healthBarNEW.setRange(-1, 1);
    healthBarNEW.setRange(0, maxHealth);
    healthBarNEW.dirty = true;
    
    healthBarBG.y += 10;
    healthBarBG.x -= 100;
    PlayState.iconP1.visible = false;
    PlayState.iconP2.visible = false;
}

function update(elapsed:Float) {
    // healthBarNEW.percent = PlayState.healthBar.percent;
	healthBarNEW.value = PlayState.healthBar.value;
}