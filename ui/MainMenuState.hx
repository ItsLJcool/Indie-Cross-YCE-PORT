//a
import ("lime.app.Application"); // testing cool shit
import ("dev_toolbox.ToolboxMain");
import ("dev_toolbox.ToolboxMessage");
import ("Main");
import Sys;
import Settings; // stupid developer mode
// import ("OPTIONS.OPTIONMAIN");
var yoLOGO:FlxSprite;
var sketch:FlxSprite;

// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;

var titleScreenSelect:Int = 0;
var selectedSomethin:Bool = false;
var optionShit:Array<String> = ['storymode', 'freeplay', 'options', 'credits', "achievements"];
var optionShitOffsetY:Array<Int> = [270, 370, 470.5, 571.5, 630];
var optionShitscaleLOL:Array<Int> = [0.680625, 0.66875, 0.674375, 0.665, 0.674375];

var menuItems:Array<FlxSprite> = [];
var toolboxSpr:FlxSprite;
// var menuItems:FlxTypedGroup<FlxSprite>;

var yceVer = Main.engineVer;
function create() {

}
function createPost() {
    trace("ENGINE SETTINGS DEVELOP: " + Settings.engineSettings.data.developerMode);
    if (Std.int(yceVer.split('.').join('')) >= 200) {
        state.defaultBehaviour = false; }
    else {
        //
    }

    for (i in state.menuItems) {
        state.menuItems.remove(i);
    }

    state.bg.scale.set(1,1);
    state.bg.scrollFactor.set();

    yoLOGO = new FlxSprite(0,0).loadGraphic(Paths.image('menu/LOGO'));
    yoLOGO.antialiasing = EngineSettings.antialiasing;
    yoLOGO.scale.set(0.675625,0.675625);
    yoLOGO.scrollFactor.set();
    yoLOGO.updateHitbox();
    state.add(yoLOGO);
    
    sketch = new FlxSprite(507.5,86.5);
    sketch.frames = Paths.getSparrowAtlas('menu/sketch');
    sketch.animation.addByPrefix('draw', 'sketch', 10);
    sketch.animation.play('draw');
    sketch.antialiasing = EngineSettings.antialiasing;
    sketch.scale.set(0.67375,0.67375);
    sketch.scrollFactor.set();
    sketch.updateHitbox();
    state.add(sketch);

    for (i in 0...optionShit.length) {   
        var menuItem:FlxSprite;
        if (i != 4) {
        menuItem = new FlxSprite(-48.5, optionShitOffsetY[i]);
        menuItem.loadGraphic(Paths.image('menu/buttons/' + optionShit[i])); }
        else {
        menuItem = new FlxSprite(802.5, optionShitOffsetY[i]);
        menuItem.loadGraphic(Paths.image('menu/buttons/achievements')); }

        menuItem.scale.x = optionShitscaleLOL[i];
        menuItem.scale.y = optionShitscaleLOL[i];
        menuItem.ID = i;
        menuItems[i] = menuItem;
        menuItem.antialiasing = EngineSettings.antialiasing;
        menuItem.scrollFactor.set();
        menuItem.updateHitbox();
        state.add(menuItems[i]);
    }

    toolboxSpr = new FlxSprite(1150,25);
    toolboxSpr.loadGraphic(Paths.image("menu/buttons/toolbox"));
    toolboxSpr.scale.set(0.20875,0.20875);
    toolboxSpr.antialiasing = EngineSettings.antialiasing;
    toolboxSpr.scrollFactor.set();
    toolboxSpr.updateHitbox();
    if (Settings.engineSettings.data.developerMode) {
        state.add(toolboxSpr); }

    changeItem(0);
    // cutsceneYo(true, false);
    // cutsceneYo(true, false);
    trace(Std.int(yceVer.split('.').join('')));


}
var char:Int = 0;
function update(elapsed) {

    if (!selectedSomethin) {
        if (controlsJustNUM([87,38])) {
            CoolUtil.playMenuSFX(0);
            changeItem(-1); }
        if (controlsJustNUM([83,40])) {
            CoolUtil.playMenuSFX(0);
            changeItem(1); }
    
    if (controlsJust.O)
        FlxG.switchState(new ModState('newOldContent', mod));
    if (controlsJust.G)
        FlxG.switchState(new ModState('DialogueSchoolTest', mod));
    if (controlsJust.C)
        FlxG.switchState(new ModState('sandbox', mod));

    var pressed = false;
    if (char == 0) pressed = controlsJust.G;
    if (char == 1) pressed = controlsJust.O;
    if (char == 2) pressed = controlsJust.S;
    if (char == 3) pressed = controlsJust.E;
    if (pressed) {
        char++;
        FlxG.sound.play(Paths.sound('type'));
    } else {
        if (controlsJust.ANY) {
            if (char >= 1)
            FlxG.sound.play(Paths.sound('delete'));
            char = 0;
            }
        }
        if (char >= 4) {
            char = 0;
            cutsceneYo(false, true);
        }
        
    if (controlsJustNUM([13])) {
        onSelect(); }

    if (controlsJustNUM([8])) {
        FlxG.switchState(new TitleState()); }
    }
}

function onSelect() {
    CoolUtil.playMenuSFX(1);
    selectedSomethin = true;
    for (spr in menuItems) {
        if (titleScreenSelect != spr.ID) {
            FlxTween.tween(spr, {alpha: 0}, 0.5, { ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
                spr.kill();
                onSelectEnd();
            }}); }
        else if (titleScreenSelect == spr.ID) {
            // FlxTween.color(spr, 1, 0xFF000000, 0xFFFCFCFC, {ease:FlxEase.linear});
        }
    }
    if (titleScreenSelect != 5) {
        FlxTween.tween(toolboxSpr, {alpha: 0}, 0.5, { ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
            toolboxSpr.kill();
        }});
    }
}
function onSelectEnd() {
    
    switch (titleScreenSelect) {
        case 0:
			FlxG.switchState(new StoryMenuState());
        case 1:
			FlxG.switchState(new FreeplayState());
        case 2:
            FlxG.switchState(new options.screens.OptionMain()); // FIXED THANKS Sybmir.hx#2998 !!!!
        case 3:
			FlxG.switchState(new CreditsState());
        case 4:
            if (Std.int(yceVer.split('.').join('')) >= 200) {
                trace("Medals are avaliable!");
                FlxG.switchState(new MedalsState()); }
            else {
                trace("no more medals");
                FlxG.switchState(new ModState('noMedalsState', mod)); }
        case 5:
            FlxG.switchState(new dev_toolbox.ToolboxMain());
    }
}
function changeItem(huh:Int = 0) {
    
    // im too lazy
    titleScreenSelect += huh;
    if (Settings.engineSettings.data.developerMode) {
        if (titleScreenSelect >= menuItems.length + 1)
            titleScreenSelect = 0;
        if (titleScreenSelect < 0)
            titleScreenSelect = menuItems.length;
    } else {
		if (titleScreenSelect >= menuItems.length)
			titleScreenSelect = 0;
		if (titleScreenSelect < 0)
			titleScreenSelect = menuItems.length - 1;
    }
    // trace(titleScreenSelect);
    
    
    for (spr in menuItems) {
        if (spr.ID != 4) {
        FlxTween.tween(spr,{x: (spr.ID == titleScreenSelect)? 0 : -45}, 0.1, {ease: FlxEase.circOut, type: 1}); }
        else {
        FlxTween.tween(spr,{x: (spr.ID == titleScreenSelect)? FlxG.width - spr.width : FlxG.width - spr.width+45}, 0.1, {ease: FlxEase.circOut, type: 1}); }
        FlxTween.tween(spr,{alpha:(spr.ID == titleScreenSelect)? 1 : 0.5}, 0.1, {ease: FlxEase.circOut, type: 1});

    }
    FlxTween.tween(toolboxSpr.scale,{x: 0.20875, y: 0.20875}, 0.1, {ease: FlxEase.circOut, type: 1, onComplete: function() {
        if (titleScreenSelect != 5)
            toolboxSpr.loadGraphic(Paths.image("menu/buttons/toolbox"));
    }});
    switch(titleScreenSelect) {
        case 5:
            toolboxSpr.loadGraphic(Paths.image("menu/buttons/toolboxSel"));
            FlxTween.tween(toolboxSpr.scale,{x: toolboxSpr.scale.x += 0.1, y: toolboxSpr.scale.y += 0.1}, 0.1, {ease: FlxEase.circOut, type: 1});
    }

}

function cutsceneYo(preload:Bool, crashLol:Bool) {
    if (FlxG.sound.music != null) {
        FlxG.sound.music.stop(); }
    var mFolder = Paths_.modsPath;
    
    // To get video path in your custom cutscene, type Paths.video("(video file name)");
    var path = mFolder + "\\" + mod + "\\videos\\" + "gose.mp4";
    trace(path);
    
    var videoSprite:FlxSprite = null;
    videoSprite = MP4Video.playMP4(path, function() {
            state.remove(videoSprite);

            if (!preload && crashLol) {
                Sys.exit(0); }
            } ,false);

    videoSprite.scrollFactor.set();
    state.add(videoSprite);
    if (preload) {
        state.remove(videoSprite); }
    
}