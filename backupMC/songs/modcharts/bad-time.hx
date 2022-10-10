//a
var sansStageLol:FlxSprite;
var sansFlash:FlxSprite;
function create() {
    PlayState.remove(PlayState.dad);
    PlayState.remove(PlayState.boyfriend);
    PlayState.remove(PlayState.gf);
    // PlayState.gf.y = 9999;
    PlayState.gf.visible = false;

    EngineSettings.botplay = true;
    
    sansStageLol = new FlxSprite(-1155, -915);
    sansStageLol.frames = Paths.getSparrowAtlas('sans/Nightmare Sans Stage');
    sansStageLol.animation.addByPrefix('normal', 'Normal instance 1', 24, true);
    // sansStageLol.animation.addByPrefix('FLASH', 'dd instance 1', 24, false);
    sansStageLol.animation.addByPrefix('fullBright', 'sdfs instance 1', 24, false);
    sansStageLol.animation.addByIndices('blankNormal', 'Normal instance 1', [0], "", 24, true);
    sansStageLol.animation.play('blankNormal');
    sansStageLol.antialiasing = EngineSettings.antialiasing;
    sansStageLol.scale.set(1.9,1.9);
    sansStageLol.updateHitbox();
    PlayState.add(sansStageLol);

    PlayState.add(PlayState.dad);
    PlayState.add(PlayState.boyfriend);
    
    sansFlash = new FlxSprite(-1155, -915);
    sansFlash.frames = Paths.getSparrowAtlas('sans/Nightmare Sans Stage');
    // sansFlash.animation.addByPrefix('normal', 'Normal instance 1', 24, true);
    sansFlash.animation.addByPrefix('FLASH', 'dd instance 1', 24, false);
    // sansFlash.animation.addByPrefix('fullBright', 'sdfs instance 1', 24, false);
    // sansFlash.animation.addByIndices('blankNormal', 'Normal instance 1', [0], "", 24, true);
    sansFlash.visible = false;
    sansFlash.animation.play('FLASH');
    sansFlash.antialiasing = EngineSettings.antialiasing;
    sansFlash.scale.set(1.9,1.9);
    sansFlash.updateHitbox();
    PlayState.add(sansFlash);
}

function onGuiPopup() {
    PlayState.iconP1.y -= 500;
}