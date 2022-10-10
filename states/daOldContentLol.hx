//a
import flixel.text.FlxTextBorderStyle;
import flixel.animation.FlxAnimation;

// FlxSprites
var bg:FlxSprite;
var attackDodge:FlxSprite;
var legsLol:FlxSprite;

// Arrays
var oldContentSpr:Array<FlxSprite> = []; // just used for length lol // now its not
var oldContentMultipleSpr:Array<FlxSprite> = []; // just used for length lol // now its not
var daAnimations:Array<String> = [];

var daDescTitle:Array<String> = [];
var daDescText:Array<String> = [];

var textTitle:FlxText;
var textDesc:FlxText;
var addingSTFU:Int = 0;
function create() {
    FlxG.sound.music.stop();
    FlxG.sound.playMusic(Paths.music("settin"));

    bg = new FlxSprite(0,0).loadGraphic(Paths.image('menuDesat'));
    bg.antialiasing = EngineSettings.antialiasing;
    bg.scrollFactor.set();
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    textTitle = new FlxText(0, 0, 0, "haha if you see this then oops", 32);
    textTitle.font = "VCR OSD Mono";
    textTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
    textTitle.updateHitbox();
    textTitle.screenCenter();
    textTitle.y = FlxG.height - textTitle.height - 20;
    add(textTitle);

    textDesc = new FlxText(0, 0, 0, "haha if you see this then oops", 45);
    textDesc.font = "VCR OSD Mono";
    textDesc.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
    textDesc.updateHitbox();
    textDesc.screenCenter();
    textDesc.y = FlxG.height - textTitle.height - textDesc.height - 20;
    add(textDesc);

    makeNewShit(['old/images/attackdodge'], "xml", [["dodge", "attack"]], [["Dodge instance 1", "Parry notes instance 1"]], 24, true, 0.45, true, false); // attackDodge
    daDescTitle.push("Cuphead Help");
    daDescText.push("This Was the old Cuphead Dodge & Attack Help Info");

    makeNewShit(['old/images/MobileGame'], "xml", 
    [["attack", "attackClick", "dodge", "dodgeClick"]], 
    [["Attack Avaiable instance 1", "Attack Click instance 1",
    "Dodge Available instance 1", "Dodge not Avaiblefze instance 1"]], 24, true, 0.5, true, false); // "Mobile Game"
    daDescTitle.push("Old Attack / Dodge Sprites");
    daDescText.push("We all know what this looks like already (if not then there you go)");

    makeNewShit(['old/images/NewCuphead'], "xml", // cuphead unused anims
    [["intro", "idle", "left", "down", "up", "right", "shoot", "dodge" "hit"]],
    [["Cuphead_Warmup_container instance 1",
    "Cuphead_standing instance 1", "Cupleft instance 1", "CupON THE GROUND NOW instance 1", "CupUp instance 1", "CupyRight instance 1",
    "Cupshoot instance 1", "Dodge instance 1", "Oich instance 1", "L-Miss instance 1"
    ]], 24, true, 0.5, true, false);
    daDescTitle.push("Unused Cuphead Anims?");
    daDescText.push("Its still the normal anims but with unused ones");
    
    makeNewShit(['old/images/angrycuphead'], "xml", // cuphead Knockout
    [["idle", "left", "down", "up", "right", "hit"]],
    [["Cup with ef instance 1", 
    "gzrg instance 1", "Um instance 1", "Down instance 1", "YOU instance 1",
    "oUCHY instance 1"]], 24, true, 0.5, true, false);
    daDescTitle.push("Unused / Old Cuphead Anims for Knockout");
    daDescText.push("Knockout had its own weird animations like the old Knockout BF");

    makeNewShit(['old/images/characters/rainboyfriend'], "xml", // bf Knockout rain
    [["idle", "left", "down", "up", "right", "leftMiss" "downMiss", "upMiss", "rightMiss", "attack"]],
    [["greqerg instance 1", 
    "gerfreyer instance 1", "yetyregerg instance 1", "erstregdrg instance 1", "gwgsgd instance 1",
    "R-Miss instance 1", "D-Miss instance 1", "U-Miss instance 1", "L-Miss instance 1",
    "Boom instance 1"
    ]], 24, true, 0.5, true, false);
    daDescTitle.push("Old Boyfriend Anims");
    daDescText.push("This was what BF would look like in Knockout");

    makeNewShit(['old/images/characters/BF_LC_shader'], "xml", 
    [["idle", "left", "down", "up", "right", "leftMiss" "downMiss", "upMiss", "rightMiss", "attack"]], 
    [["0Idle instance 1", 
    "0EEEE instance 1", "0Ouu instance 1", "0UPPP instance 1", "0EERR instance 1",
    "R-Miss instance 1", "D-Miss instance 1", "U-Miss instance 1", "L-Miss instance 1", 
    "0BF attack copy instance 1"]], 24, true, 0.5, true, false); // old BF sansational
    daDescTitle.push("Old BF Sansational Anims");
    daDescText.push("How old? The Beta Old (probably)");

    makeNewShit(['old/images/characters/BOYFRIEND_White'], "xml", 
    [["idle", "left", "down", "up", "right", "leftMiss" "downMiss", "upMiss", "rightMiss", "attack", "dodge", "dodge2?", "firstDeath", "deathLoop", "deathConfirm"]], 
    [["0Idle0", 
    "0EEEE0", "0Ouu0", "0UPPP0", "0EERR0",
    "BF NOTE LEFT MISS0", "BF NOTE DOWN MISS0", "BF NOTE UP MISS0", "BF NOTE RIGHT MISS0", 
    "0BF attack", "0Dodge00", "0Dodge02", "BF dies0", "BF Dead Loop0", "BF Dead confirm0"]], 24, true, 0.5, true, false); // old BF sansational white
    daDescTitle.push("Old BF Sansational Anims | White Version");
    daDescText.push("How old? The Beta Old (probably)");
    
    makeNewShit(['old/images/characters/BF_ded_Sans'], "xml", 
    [["deathFirst", "loop"]], 
    [["Dedf instance 1", "loop instance 1"]], 24, false, 0.5, true, false); // bf dead anims
    daDescTitle.push("Beta Death Anims");
    daDescText.push("This is used in the beta (i think) for sans GameOver");
    
    makeNewShit(['old/images/characters/SANS_FNF'], "xml", 
    [["idle", "left", "down", "up", "right", "sleep", "snap", "gotem", "uh"]], 
    [["S-Idle0",
    "S-Left0", "S-Up0", "S-down0", "S-Right0",
    "S-leeping0", "Snap AN0", "S-Gottem0", "aaa0"]], 24, true, 0.5, true, false); // fnf sans
    daDescTitle.push("Beta Sans");
    daDescText.push("Oh Dear God");
    
    makeNewShit(['old/images/characters/SANS_FNF_white'], "xml", 
    [["idle", "left", "down", "up", "right"]], 
    [["S-Idle0",
    "S-Left0", "S-Up0", "S-down0", "S-Right0"]], 24, true, 0.5, true, false); // fnf sans white
    daDescTitle.push("Beta Sans | White Version");
    daDescText.push("Bruh what happen to sans");
    
    makeNewShit(['old/images/characters/DeathSans'], "xml", 
    [["idle", "left", "down", "up", "right"]],
    [["Nightmare Sans instance 1",
    "Left instance 1", "Up instance 1", "Down instance 1", "Right instance 1"]], 24, true, 0.5, true, false); // deathSand (Nm sans)
    daDescTitle.push("Death Sans | Nightmare Sans");
    daDescText.push("First Character to have a Nightmare form");
    
    makeNewShit(['old/images/UTextBox', 'old/images/UTextBox'], "xml", 
    [
    ["daShit"], ["pap1", "pap2", "pap3", "pap4", "pap5", "pap6", "pap7"]
    ], [
    ["DiaBox instance 1"], ["Paps-1 instance 1", "Paps-2 instance 1", "Paps-3 instance 1", 
    "Papy-4 instance 1", "Paps-5 instance 1", "Paps-6 instance 1", "Paps-7 instance 1"]
    ], 24, false, 0.5, true, true); // unused dialog shit
    
    // makeNewShit('old/images/UTextBox', "xml", 
    // ["pap1", "pap2", "pap3", "pap4", "pap5", "pap6", "pap7"], 
    // ["Paps-1 instance 1", "Paps-2 instance 1", "Paps-3 instance 1", 
    // "Papy-4 instance 1", "Paps-5 instance 1", "Paps-6 instance 1", "Paps-7 instance 1"], 24, true, 0.5, true, false); // unused dialog shit

    daDescTitle.push("Text Boxes | Sans & Pap");
    daDescText.push("Its the same Dialogue box but with sans");

    // makeNewShit('old/images/LEGSS', "xml", ["run"], ["AAAAright instance 1"], 24, true,  0.5, true); // bf Legs
    // daDescTitle.push("The Old Nightmare Run Legs");
    // daDescText.push("Instead of it being looped from frames, it would be seperate legs");

    // makeNewShit('old/images/MUH_LEGS', "xml", // bf old anims NM run
    // ["idle", "left", "up", "down", "right", "miss"],
    // ["AAAABF instance 1", "AAAAleft instance 1", "AAAAdown instance 1", "AAAAup instance 1", "AAAAright instance 1", "Misses instance 1"], 24, true,  0.5, true); 
    // daDescTitle.push("Nightmare Run Boyfriend Anims");
    // daDescText.push("An Old version of BF animations, it uses the legs from before");

    switchImages(0);
}
function makeNewShit(path:Array<String> = ["old/images/attackdodge"], type:String = "xml", 
    ?prefixNames:Array<Array<String>>,  ?xmlNames:Array<Array<String>>, ?xmlFrames:Int = 24, ?looping:Bool = true,
    scale:Float = 1.0, center:Bool = true, 
    ?addMoreShit:Bool = false, ?xOffset:Int = 0, ?yOffset:Int = 0, ?xVal:Int = 0, ?yVal:Int = 0) {
    var tempArray:Array<FlxSprite> = [];
    switch(type) {
        case "xml":
            daAnimations.push(prefixNames);
            if (addMoreShit) {
                trace("path: " + path);
                trace("path.length: " + path.length);
                for (spr in 0...path.length) {
                    trace("prefixNames[spr].length: " + prefixNames[spr].length);
                    for (pre in 0...prefixNames[spr].length) {
                        newSpr = new FlxSprite(0,0);
                        newSpr.frames = Paths.getSparrowAtlas(path[spr]);
                        newSpr.animation.addByPrefix(prefixNames[spr][pre], xmlNames[spr][pre], xmlFrames, looping);
                        trace("prefixNames: " + prefixNames[spr][pre] + " | xmlNames: " + xmlNames[spr][pre]);
                    }
                    newSpr.animation.play(prefixNames[spr][0], looping);
                    tempArray.push(newSpr);
                    trace(spr);
                }
            } else {
                newSpr = new FlxSprite(0,0);
                newSpr.frames = Paths.getSparrowAtlas(path[0]);
                for (pre in 0...prefixNames[0].length) {
                    newSpr.animation.addByPrefix(prefixNames[0][pre], xmlNames[0][pre], xmlFrames, looping);
                }
                newSpr.animation.play(prefixNames[0][0], looping);
            }
        case "png","image":
            daAnimations.push(null);
            newSpr = new FlxSprite(0,0).loadGraphic(Paths.image(path[0]));
        default:
            daAnimations.push(null);
            trace('oops, wrong type bro');
    }
    if (!addMoreShit) {
        newSpr.scrollFactor.set();
        newSpr.scale.set(scale,scale);
        newSpr.updateHitbox();
        if (center)
            newSpr.screenCenter();
        newSpr.x += xOffset;
        newSpr.y += yOffset;
        newSpr.antialiasing = EngineSettings.antialiasing;
        newSpr.ID = addingSTFU;
        add(newSpr);
        oldContentSpr.push(newSpr);
        addingSTFU++;
    } else {
        trace("tempArray: " + tempArray);
        for (spr in tempArray) {
            spr.scrollFactor.set();
            spr.scale.set(scale,scale);
            spr.updateHitbox();
            if (center)
                spr.screenCenter();
            spr.x += xOffset;
            spr.y += yOffset;
            tempArray[1].x += 200;
            spr.antialiasing = EngineSettings.antialiasing;
            spr.ID = addingSTFU;
            add(spr);
            oldContentMultipleSpr.push(spr);
        }
        oldContentSpr.push(tempArray[0]);
        addingSTFU++;
    }
    tempArray = [];
}   

// keys cool
var controls = FlxG.keys.pressed;
var controlsJust = FlxG.keys.justPressed;
var controlsJustNUM = FlxControls.anyJustPressed;
var controlsNUM = FlxControls.anyPressed;
function update(elapsed:Float) {
    if (controlsJust.L)
        FlxG.switchState(new MainMenuState());

    if (controlsJustNUM([65,37])) {
        CoolUtil.playMenuSFX(0);
        switchImages(-1);
    }

    if (controlsJustNUM([68,39])) {
        CoolUtil.playMenuSFX(0);
        switchImages(1);
    }

    if (controlsJustNUM([13])) {
        otherCoolThing();
    }
}
var curSelected:Int = 0;

var cycleAnims:Int = 0;
function switchImages(huh:Int = 0) {
    cycleAnims = 0;
    curSelected += huh;
    if (curSelected >= oldContentSpr.length)
        curSelected = 0;
    if (curSelected < 0)
        curSelected = oldContentSpr.length - 1;

    textTitle.text = daDescText[curSelected];
    textTitle.updateHitbox();
    textTitle.screenCenter();
    textTitle.y = FlxG.height - textTitle.height - 20;

    textDesc.text = daDescTitle[curSelected];
    textDesc.updateHitbox();
    textDesc.screenCenter();
    textDesc.y = FlxG.height - textDesc.height - textTitle.height - 20;

    for (spr in oldContentSpr) {
        if (spr.ID == curSelected) {
            spr.alpha = 1;
            switch(spr.ID) {
                case 7:
                    spr.animation.play(daAnimations[spr.ID][0][0]);
                    spr.animation.finishCallback = function(animName:String)
                        spr.animation.play(daAnimations[spr.ID][0][1], true);
            }
        } else {
            spr.alpha = 0.0001;
            switch(spr.ID) {
                // case 4:
                //     spr.animation.resume();
                case 0,1,2,3,4,5,6,7,8,9,10:
                    spr.animation.play(daAnimations[spr.ID][0][cycleAnims]);
            }
        }
    }
    trace("oldContentMultipleSpr: " + oldContentMultipleSpr);
    for (spr in oldContentMultipleSpr) {
        if (spr.ID == curSelected) {
            spr.alpha = 1;
            trace(oldContentMultipleSpr[0]);
            switch(spr.ID) {
                case 11:
                    trace(daAnimations[spr.ID][0][0]);
                    trace(daAnimations[spr.ID][1][0]);
                    spr.animation.play(daAnimations[spr.ID][0][0]);
                    spr.animation.play(daAnimations[spr.ID][1][0]);
            }
        } else {
            spr.alpha = 0.0001;
        }
    }
}
function otherCoolThing() {
    switch(curSelected) {
        case 0,1,2,3,4:
            FlxG.sound.play(Paths.sound('cuphead/select'));
        case 5,6,7,8,9,10,11:
            FlxG.sound.play(Paths.sound('sans/select'));
    }

    for (spr in oldContentSpr) {
        if (spr.ID == curSelected) {
        switch(spr.ID) {
            // case 4: // legs
            //     (spr.animation.paused) ? spr.animation.resume() : spr.animation.pause();
            case 0,1,2,3,4,5,6,8,9,10:
                cycleAnims++;
                if (cycleAnims > daAnimations[spr.ID][0].length-1)
                    cycleAnims = 0;
                spr.animation.play(daAnimations[spr.ID][0][cycleAnims]);
                trace(daAnimations[spr.ID][0][cycleAnims]);
            case 7:
                spr.animation.play(daAnimations[spr.ID][0][0]);
                spr.animation.finishCallback = function(animName:String)
                    spr.animation.play(daAnimations[spr.ID][0][1], true);
            }
                
        }
    }
    for (spr in oldContentMultipleSpr) {
        if (spr.ID == curSelected) {
            switch(spr.ID) {
                case 11:
                    trace(spr);
                    spr.animation.play(daAnimations[spr.ID][0][0]);
            }
        }
    }
}