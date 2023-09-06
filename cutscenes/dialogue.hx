//a
import CoolUtil;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import haxe.io.Path;
import lime.ui.FileDialogType;
import lime.ui.FileDialog;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxInputText;
import Script;
import ScriptPack; // you fucking cant just do 'Script.ScriptPack' you gotta import them one by on
import flixel.text.FlxTextBorderStyle;
import flixel.FlxCamera;

var dialogueImage:FlxSprite;
var swagDialogue:FlxTypeText;
var dialogue:Dynamic;
var dialogueScripts:ScriptPack;
var pathToJson = "mods/" + mod + "/data/" + PlayState.song.song.toLowerCase() + "/dialogue.json";

var dialogueHUD:FlxCamera;
function create() {
    PlayState.camHUD.alpha = 0.0001;
    dialogueHUD = new FlxCamera();
    FlxG.cameras.add(dialogueHUD);
    dialogueHUD.bgColor = 0;
    if (save.data.hasSeenDialogue == null) {
        save.data.hasSeenDialogue = false;
        save.flush();
    }
    if (FileSystem.exists(pathToJson)) {
	    dialogue = Json.parse(File.getContent(pathToJson));
    } else {
        trace("doesn't exist, start song");
        startCountdown();
    }
    dialogueImage = new FlxSprite(0,0);
    changeDialogueImage(
        dialogue.defaultStuff.imagePath[0], 
        dialogue.defaultStuff.imagePath[1], 
        dialogue.defaultStuff.animations, 
        dialogue.defaultStuff.loopAnims);
    dialogueImage.animation.play(dialogue.defaultStuff.loopAnim);
    dialogueImage.scale.set(0.75, 0.75);
    dialogueImage.flipX = false;
    dialogueImage.updateHitbox();
    dialogueImage.screenCenter();
    dialogueImage.y += 200;
    PlayState.add(dialogueImage);
    dialogueImage.cameras = [dialogueHUD];

    // thanks Yoshi :troll:
    swagDialogue = new FlxTypeText(dialogueImage.x + 50, dialogueImage.y + 125, dialogueImage.width, "test AAAAAAAAA", 32);
    swagDialogue.font = 'Pixel Arial 11 Bold';
    swagDialogue.color = 0xFF3F2021;
    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
    swagDialogue.scrollFactor.set();
    swagDialogue.updateHitbox();
    swagDialogue.screenCenter();
    PlayState.add(swagDialogue);
    swagDialogue.cameras = [dialogueHUD];
    swagDialogue.completeCallback = function() {
        if (curDialogue <= dialogue.dialogueStart.length - 1)
            canContinue = true;
    }
    updateScripts();
    dialogueScripts.executeFunc("create");
    nextDialogue(0);
}

function updateScripts() {
    dialogueScripts = new ScriptPack((dialogue.defaultStuff.scripts == null) ? [{paths: ''}] : dialogue.defaultStuff.scripts);
    dialogueScripts.setVariable("state", this);
    dialogueScripts.setVariable("PlayState", PlayState);
    dialogueScripts.setVariable("dialogueImage", dialogueImage);
    dialogueScripts.setVariable("curDialogue", curDialogue);
    dialogueScripts.setVariable("swagDialogue", swagDialogue);
    dialogueScripts.setVariable("dad", PlayState.dad);
    dialogueScripts.setVariable("boyfriend", PlayState.boyfriend);
    dialogueScripts.setVariable("setDialogueTo", function(json) {
	    dialogue = Json.parse(File.getContent(json));
    });
    dialogueScripts.setVariable("dialogue", dialogue);
    
    for (s in dialogueScripts.scripts) s.setScriptObject(this);
    dialogueScripts.loadFiles();
}
var canContinue:Bool = true;
function update() {
    dialogueScripts.executeFunc("update");
    if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)) {
        swagDialogue.skip();
        if (canContinue) nextDialogue(1);
    }
    dialogueScripts.executeFunc("updatePost");
}

var curDialogue:Int = 0;
var audioBefore = [];
function nextDialogue(hur:Int = 0)  {
    dialogueScripts.executeFunc("nextDialogue");
    if (curDialogue != 0) canContinue = false;
    curDialogue += hur;
    if (curDialogue > dialogue.dialogueStart.length - 1) {
        if (dialogue.defaultStuff.endAnim == null) {
        FlxTween.tween(dialogueHUD, {alpha: 0}, 1, {ease: FlxEase.quadIn, onComplete: function() {
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.quadIn});
                startCountdown();
            }});
        } else {
            swagDialogue.visible = false;
            dialogueImage.animation.play(dialogue.defaultStuff.endAnim);
            dialogueImage.animation.finishCallback = function () {
                PlayState.remove(swagDialogue);
                PlayState.remove(dialogueImage);
            }
            startCountdown();
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 1, {ease: FlxEase.quadIn});
        }
        return;
    }
    if (curDialogue < 0)
        curDialogue = 0;
    
    if (dialogue.dialogueStart[curDialogue].playSFX != null && dialogue.dialogueStart[curDialogue].playSFX != "")
        FlxG.sound.play(Paths.sound(dialogue.dialogueStart[curDialogue].playSFX));

    if (dialogue.defaultStuff.musicStuff.audioPath == "") dialogue.defaultStuff.musicStuff.audioPath = null;
    if (dialogue.dialogueStart[curDialogue].musicStuff.audioPath == "") dialogue.dialogueStart[curDialogue].musicStuff.audioPath = null;
    if ((dialogue.defaultStuff.musicStuff.audioPath != null 
    && audioBefore[0] != dialogue.defaultStuff.musicStuff.audioPath) 
    && dialogue.defaultStuff.musicStuff.musicEnabled) {
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music(dialogue.defaultStuff.musicStuff.audioPath, (dialogue.defaultStuff.musicStuff.audioPath == "breakfast") ? "shared" : null), dialogue.defaultStuff.musicStuff.volume);
        FlxG.sound.music.time = 0;
        Conductor.songPosition = 0;
    } else if (dialogue.dialogueStart[curDialogue].overrideDefaults 
    && (dialogue.dialogueStart[curDialogue].musicStuff.audioPath != null 
    && audioBefore[1] != dialogue.dialogueStart[curDialogue].musicStuff.audioPath)) {
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music(dialogue.dialogueStart[curDialogue].musicStuff.audioPath, (dialogue.dialogueStart[curDialogue].musicStuff.audioPath == "breakfast") ? "shared" : null), dialogue.dialogueStart[curDialogue].musicStuff.volume);
        FlxG.sound.music.time = 0;
        Conductor.songPosition = 0;
    }
    audioBefore[0] = dialogue.defaultStuff.musicStuff.audioPath;
    audioBefore[1] = dialogue.dialogueStart[curDialogue].musicStuff.audioPath;

    if (dialogue.dialogueStart[curDialogue].overrideDefaults == null) dialogue.dialogueStart[curDialogue].overrideDefaults = false;
    
    if (dialogue.dialogueStart[curDialogue].boxImage != null && dialogue.dialogueStart[curDialogue].boxImage.changeImage) {
        changeDialogueImage(
            dialogue.dialogueStart[curDialogue].boxImage.path[0], 
            dialogue.dialogueStart[curDialogue].boxImage.path[1], 
            dialogue.dialogueStart[curDialogue].boxImage.animations, 
            dialogue.dialogueStart[curDialogue].boxImage.loopAnims);
    } else if (!dialogue.dialogueStart[curDialogue].overrideDefaults || !dialogue.dialogueStart[curDialogue].boxImage.changeImage) {
        changeDialogueImage(
            dialogue.defaultStuff.imagePath[0],
            dialogue.defaultStuff.imagePath[1],
            dialogue.defaultStuff.animations, 
            dialogue.defaultStuff.loopAnims);
    }

    if (dialogue.dialogueStart[curDialogue].boxPlayAnim != null && dialogue.dialogueStart[curDialogue].overrideDefaults)
        dialogueImage.animation.play(dialogue.dialogueStart[curDialogue].boxPlayAnim);
    else if (dialogue.dialogueStart[curDialogue].boxPlayAnim == null || !dialogue.dialogueStart[curDialogue].overrideDefaults) {
        if (dialogue.defaultStuff.openAnim != null && curDialogue == 1) {
            dialogueImage.animation.play(dialogue.defaultStuff.openAnim, true);
            dialogueImage.animation.finishCallback = function() {
                if (dialogue.defaultStuff.loopAnim != null) 
                    dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true); } }
        if (dialogue.defaultStuff.openAnim == null)
            dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true);
    }
    if (curDialogue != 1 && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
        dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true);
        dialogueImage.animation.finishCallback = function() { }
    }

    if (dialogue.defaultStuff.boxScale != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        dialogueImage.scale.set(dialogue.defaultStuff.boxScale, dialogue.defaultStuff.boxScale);
    else if (dialogue.dialogueStart[curDialogue].boxScale != null)
        dialogueImage.scale.set(dialogue.dialogueStart[curDialogue].boxScale, dialogue.dialogueStart[curDialogue].boxScale);
    else
        dialogueImage.scale.set(0.75,0.75);
    dialogueImage.updateHitbox();
    
    if (dialogue.defaultStuff.boxXY != null && dialogue.dialogueStart[curDialogue].boxXY == null) {
        dialogueImage.x = dialogue.defaultStuff.boxXY[0];
        dialogueImage.y = dialogue.defaultStuff.boxXY[1];
    }
    else if (dialogue.dialogueStart[curDialogue].boxXY != null) {
        dialogueImage.x = dialogue.dialogueStart[curDialogue].boxXY[0]; 
        dialogueImage.y = dialogue.dialogueStart[curDialogue].boxXY[1];
    }
    else {
        dialogueImage.screenCenter();
        dialogueImage.y += 200; 
        /** //or we could do:
        dialogueImage.y = (FlxG.height - dialogueImage.height) - 20;
        **/
    }
    dialogueImage.updateHitbox(); // make sure everything is good

    if (dialogue.defaultStuff.boxFlipX != null && dialogue.dialogueStart[curDialogue].boxFlip == null)
        dialogueImage.flipX = dialogue.defaultStuff.boxFlip;
    else if (dialogue.dialogueStart[curDialogue].boxFlip != null)
        dialogueImage.flipX = dialogue.dialogueStart[curDialogue].boxFlip;
    else
        dialogueImage.flipX = false;

    swagDialogue.resetText(dialogue.dialogueStart[curDialogue].daText);
    swagDialogue.updateHitbox();
    swagDialogue.width = dialogueImage.width;

    if (dialogue.defaultStuff.textXY != null && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
        swagDialogue.x = dialogue.defaultStuff.textXY[0];
        swagDialogue.y = dialogue.defaultStuff.textXY[1];
    }
    else if (dialogue.dialogueStart[curDialogue].textXY != null) {
        swagDialogue.x = dialogue.dialogueStart[curDialogue].textXY[0];
        swagDialogue.y = dialogue.dialogueStart[curDialogue].textXY[1];
    }
    else {
        swagDialogue.x = dialogueImage.x + 50;
        swagDialogue.y = dialogueImage.y + 100;
    }
    var textChangeColor:String = '';
    if (dialogue.defaultStuff.textColor != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        textChangeColor = dialogue.defaultStuff.textColor;
    else if (dialogue.dialogueStart[curDialogue].textColor != null)
        textChangeColor = dialogue.dialogueStart[curDialogue].textColor;
    else
        textChangeColor = 'Black';

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
        case "Senpi", "Week 6", "FNF Pixel Text", "Pixel Theme":
            swagDialogue.color = 0xFF3F2021;
        default:
            var colorText = Std.parseInt(textChangeColor);
            swagDialogue.color = colorText;
    }

    if (dialogue.defaultStuff.textFont != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        swagDialogue.font = (dialogue.defaultStuff.textFont != "Pixel Arial 11 Bold") ? Paths.font(dialogue.defaultStuff.textFont) : "Pixel Arial 11 Bold";
    else if (dialogue.dialogueStart[curDialogue].textFont != null)
        swagDialogue.font = (dialogue.dialogueStart[curDialogue].textFont != "Pixel Arial 11 Bold") ? Paths.font(dialogue.dialogueStart[curDialogue].textFont) : "Pixel Arial 11 Bold";
    else
        swagDialogue.font = "Pixel Arial 11 Bold";
    
    if (dialogue.defaultStuff.textSFX != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(dialogue.defaultStuff.textSFX), 0.6)];
    else if (dialogue.dialogueStart[curDialogue].textSFX != null && dialogue.dialogueStart[curDialogue].overrideDefaults)
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(dialogue.dialogueStart[curDialogue].textSFX), 0.6)];
    else
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

    if (dialogue.defaultStuff.textSFX == "" || (dialogue.dialogueStart[curDialogue].textSFX == "" && dialogue.dialogueStart[curDialogue].overrideDefaults))
        swagDialogue.sounds = null;

    if (dialogue.defaultStuff.textSize != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        swagDialogue.size = dialogue.defaultStuff.textSize;
    else if (dialogue.dialogueStart[curDialogue].textSize != null)
        swagDialogue.size = dialogue.dialogueStart[curDialogue].textSize;
    else
        swagDialogue.size = 16;
    
    swagDialogue.width = dialogueImage.width - 25;
    
    if (dialogue.defaultStuff.textSpeed != null && dialogue.dialogueStart[curDialogue].textSpeed == null)
        swagDialogue.start(dialogue.defaultStuff.textSpeed, true);
    else if (dialogue.dialogueStart[curDialogue].textSpeed != null)
        swagDialogue.start(dialogue.dialogueStart[curDialogue].textSpeed, true);
    else 
        swagDialogue.start(0.04, true);
    dialogueScripts.executeFunc("nextDialoguePost");
}

function changeDialogueImage(path:String, ?pathDIR:String, names:Array<String>, looping:Array<Bool>) { // changes the Dialgoue Box image, causes a sec of lag tho
    if (dialogueScripts != null) dialogueScripts.executeFunc("dialogueChangedImages");
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
    dialogueImage.updateHitbox();
    if (dialogueScripts != null)dialogueScripts.executeFunc("dialogueChangedImagesPost");
}