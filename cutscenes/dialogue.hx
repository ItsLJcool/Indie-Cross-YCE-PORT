//a
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import Conductor;

var textShit:Dynamic;

var swagDialogue:FlxTypeText;

var dialogueImage:FlxSprite;
var availableAnims:Array<String> = [];
var saveFile =  "mods/" + mod + "/dialogueFolder";
function create() {
    camZooming = false;
    autoCamZooming = false;
	if (!FileSystem.exists(saveFile + "/dialogue.json"))
        trace("No dialogue!")
    else
        textShit = Json.parse(File.getContent(saveFile + "/dialogue.json"));

    if (save.data.hasSeenDialogue == null) {
        save.data.hasSeenDialogue = false;
        save.flush();
    }
    //else if (save.data.hasSeenDialogue || !textShit[0].canViewMultipleTimes && textShit[0].canViewMultipleTimes != null) {
    //    startCountdown();
    //    return;
    //}

    dialogueImage = new FlxSprite(0,0);
    changeDialogueImage(textShit[0].dialoguePNG, textShit[0].pathDir, textShit[0].dialogueNames, textShit[0].dialogueLoopAnims);
    dialogueImage.animation.play(textShit[0].dialogueLoop);
    dialogueImage.scale.set(0.75, 0.75);
    dialogueImage.flipX = false;
    dialogueImage.antialiasing = EngineSettings.antialiasing;
    dialogueImage.updateHitbox();
    dialogueImage.screenCenter();
    dialogueImage.y += 200;
    dialogueImage.cameras = [PlayState.camHUD];
    trace("dialogueImage: " + dialogueImage);
    PlayState.add(dialogueImage);

    // thanks Yoshi :troll:
    swagDialogue = new FlxTypeText(dialogueImage.x + 50, dialogueImage.y + 125, FlxG.width, "test AAAAAAAAA", 32);
    swagDialogue.font = 'Pixel Arial 11 Bold';
    swagDialogue.color = 0xFF3F2021;
    swagDialogue.scrollFactor.set();
    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
    swagDialogue.cameras = [PlayState.camHUD];
    PlayState.add(swagDialogue);
    
    FlxG.sound.music.time = 0;
    FlxG.sound.music.play();
    FlxG.sound.music.time = 0;
    Conductor.songPosition = 0;
    startDialogue(0);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.K) {
        PlayState.remove(dialogueImage);
        PlayState.remove(swagDialogue);
        save.data.hasSeenDialogue = true;
        save.flush();
        camZooming = true;
        autoCamZooming = true;
        startCountdown();
    }
    if (FlxG.keys.justPressed.SPACE)
        startDialogue(1);
    
    PlayState.camFollow.setPosition(PlayState.boyfriend.getMidpoint().x - 100 + PlayState.boyfriend.camOffset.x, PlayState.boyfriend.getMidpoint().y - 100 + PlayState.boyfriend.camOffset.y);

    Conductor.songPosition = FlxG.sound.music.time;
}

function beatHit(curBeat:Int) {
    playDadsAnim("idle");
    playBFsAnim("idle");
}

var curDialogue:Int = 1;
function startDialogue(hur:Int = 0) {
    curDialogue += hur;
    if (curDialogue > textShit.length - 1) {
        PlayState.remove(dialogueImage);
        PlayState.remove(swagDialogue);
        startCountdown();
        save.data.hasSeenDialogue = true;
        save.flush();
        return;
    }
    if (curDialogue <= 1)
        curDialogue = 1;

    swagDialogue.resetText(textShit[curDialogue].text);
    swagDialogue.updateHitbox();

    if (textShit[0].hasMusic) {
        if (!FlxG.sound.music.playing || textShit[curDialogue].resumeMusic) {
            if (textShit[0].music == "breakfast") // suck my dick, im HARD coding
            FlxG.sound.playMusic(Paths.music(textShit[0].music, "shared"));
            else
                FlxG.sound.playMusic(Paths.music(textShit[0].music));
        }

        if ((textShit[curDialogue].stopMusic))
            FlxG.sound.music.stop();
        else {
        if (textShit[curDialogue].changeMusic != null)
            FlxG.sound.playMusic(Paths.music(textShit[curDialogue].changeMusic));
        }
    }

    if (textShit[curDialogue].changeDialoguePNG != null)
        changeDialogueImage(textShit[curDialogue].changeDialoguePNG, textShit[curDialogue].changeDialoguePathDir, textShit[curDialogue].changeDialogueNames, textShit[curDialogue].changeDialogueLoopAnims)
    else
        changeDialogueImage(textShit[0].dialoguePNG, textShit[0].pathDir, textShit[0].dialogueNames, textShit[0].dialogueLoopAnims);

    if (textShit[curDialogue].changeDialogueOffsetXY != null) {
        if (textShit[curDialogue].changeDialogueScale != null)
            dialogueImage.scale.set(textShit[curDialogue].changeDialogueScale[0], textShit[curDialogue].changeDialogueScale[1]);
        
        dialogueImage.updateHitbox();
        dialogueImage.screenCenter();
        dialogueImage.x = textShit[curDialogue].changeDialogueOffsetXY[0];
        dialogueImage.y = textShit[curDialogue].changeDialogueOffsetXY[1];
    } else {
        dialogueImage.scale.set(0.75, 0.75);
        dialogueImage.updateHitbox();
        dialogueImage.screenCenter();
        dialogueImage.y += 250;
    }
    var textChangeColor:String = '';
    if (textShit[curDialogue].changeTextColor != null)
        textChangeColor = textShit[curDialogue].changeTextColor;
    else
        textChangeColor = textShit[0].textColor;

    var colorText = Std.parseInt(textChangeColor);
    switch(textChangeColor) {
        case "Black", "BLACK", "black", "FlxColor.Black":
            swagDialogue.color = 0xFF000000;
        case "White", "WHITE", "white", "FlxColor.White":
            swagDialogue.color = 0xFFFFFFFF;
        case "Red", "RED", "red", "FlxColor.Red":
            swagDialogue.color = 0xFFFF0000;
        case "Orange", "ORANGE", "orange", "FlxColor.Orange":
            swagDialogue.color = 0xFFFFA500;
        case "Yellow", "YELLOW", "yellow", "FlxColor.Yellow":
            swagDialogue.color = 0xFFFFFF00;
        case "Green", "GREEN", "green", "FlxColor.Green":
            swagDialogue.color = 0xFF00FF00;
        case "Blue", "BLUE", "blue", "FlxColor.Blue":
            swagDialogue.color = 0xFF0000FF;
        case "Cyan", "CYAN", "cyan", "FlxColor.Cyan":
            swagDialogue.color = 0xFF00FFFF;
        case "Pink", "PINK", "pink", "FlxColor.Pink":
            swagDialogue.color = 0xFFFFC0CB;
        case "Purple", "PURPLE", "purple", "FlxColor.Purple":
            swagDialogue.color = 0xFFA020F0;
        default:
            if (textChangeColor != null)
            swagDialogue.color = colorText;
    }

    if (textShit[curDialogue].dialoguePlayAnim != null) {
        dialogueImage.animation.play(textShit[curDialogue].dialoguePlayAnim);
        dialogueImage.animation.finishCallback = function(animName:String) {
            dialogueImage.animation.play(textShit[curDialogue].changeDialogueLoop, true);
                startText();
            }
    } else {
        if (textShit[curDialogue].changeDialogueIntro != null) {
            dialogueImage.animation.play(textShit[curDialogue].changeDialogueIntro);
            dialogueImage.animation.finishCallback = function(animName:String) {
                dialogueImage.animation.play(textShit[curDialogue].changeDialogueLoop, true);
                startText();
            }
        } else {
            dialogueImage.animation.play(textShit[0].dialogueIntro);
            dialogueImage.animation.finishCallback = function(animName:String) {
                dialogueImage.animation.play(textShit[0].dialogueLoop, true);
                startText();
            }
        }
    }
    
}

function startText() {
    if (!textShit[curDialogue].noText) {
    if (textShit[curDialogue].changeTextFont != null)
        swagDialogue.font = Paths.font(textShit[curDialogue].changeTextFont);
    else
        swagDialogue.font = Paths.font(textShit[0].textFont);

    if (textShit[curDialogue].changeTextXY != null) {
        swagDialogue.x = dialogueImage.x + textShit[curDialogue].changeTextXY[0];
        swagDialogue.y = dialogueImage.y + textShit[curDialogue].changeTextXY[1];
    }
    else {
        swagDialogue.x = dialogueImage.x + textShit[0].textXY[0];
        swagDialogue.y = dialogueImage.y + textShit[0].textXY[1];
    }

    if (textShit[curDialogue].changeTextSize != null)
        swagDialogue.size = textShit[curDialogue].changeTextSize;
    else
        swagDialogue.size = textShit[0].textSize;

    if (textShit[curDialogue].changeTextSFX != null)
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(textShit[curDialogue].changeTextSFX), 0.6)];
    else
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(textShit[0].textSFX), 0.6)];

    if (textShit[curDialogue].playSFX != null) 
        FlxG.sound.play(Paths.sound(textShit[curDialogue].playSFX), 1);

    swagDialogue.start(0.04, true);
    swagDialogue.completeCallback = function() {
        if (textShit[curDialogue].continueNext && textShit[curDialogue].continueNext != null) {
            new FlxTimer().start((textShit[curDialogue].continueDelay != null) ? textShit[curDialogue].continueDelay : 0, function(tmr:FlxTimer) {
                startDialogue(1);
                });
            }
        };
    }
}


function changeDialogueImage(path:String, ?pathDIR:String, names:Array<String>, looping:Array<Bool>) {
    dialogueImage.frames = Paths.getSparrowAtlas(path, (pathDIR != null) ? pathDIR : "images");
    availableAnims = [];
    var numbers = ["0","1","2","3","4","5","6","7","8","9"];
    if (dialogueImage.frames != null) {
        for(e in dialogueImage.frames.frames) {
            var animName = e.name;
            while (numbers.contains(animName.substr(-1))) {
                animName = animName.substr(0, animName.length - 1);
            }
            if (!availableAnims.contains(animName))
                availableAnims.push(animName);
        }
    }
    for (i in 0...availableAnims.length) {
        dialogueImage.animation.addByPrefix(names[i], availableAnims[i], 24, looping[i]);
    }
}