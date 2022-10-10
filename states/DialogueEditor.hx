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
import PlayState;

var rect:FlxSprite;
var dialogueTemplate = [
    {   // Default and applies to all the shit so you don't have to set it for each one
        // so basically makes your life easier :D
        dialoguePNG: "speech_bubble_talking",
        pathDir: "shared",
        dialogueNames: ["AAH loop", "Normal open", "AAH open", "Normal loop"],
        dialogueLoopAnims: [true, false, false, true],
        hasMusic: true, // not done
        music: "freakyMenu", // not done
        musicLoop: true, // not done
        dialogueIntro: "Normal open",
        dialogueLoop: "Normal loop",
        textXY: [50,100],
        textFont: "Pixel Arial 11 Bold",
        textSize: 32,
        textColor: "Black",
        textSFX: "pixelText"
    },
	{
        text: "Default Text",
        noText: null,
        changeTextXY: [null,null],
        changeTextFont: null,
        changeTextSize: null,
        changeTextColor: null, // you can call colors by Yellow, Red, etc, "Default Colors"
        changeTextSFX: null,
        char: "filePath", // not done
        continueNext: null,
        continueDelay: null,
        // VVV These might use .hx folders :troll:
        customFunction: "", // not done
        onStart: "", // not done
        onComplete: "", // not done
        onUpdate: "", // not done
        onBeat: "", // not done
        onStep: "", // not done
        // ^^^ These might use .hx folders :troll:
        changeDialoguePNG: null,
        changeDialoguePathDir: null,
        changeDialogueNames: [null],
        changeDialogueLoopAnims: [null],
        changeDialogueIntro: null,
        changeDialogueLoop: null,
        changeDialogueOffsetXY: [null,null],
        changeDialogueScale: [null, null],
        dialoguePlayAnim: null,
        playAnim: "singUP", // not done | like dad.playAnim("singUP");
        playCutscene: false, // not done | Plays a cutscene in-game
        cutsceneCallCustomFunction: false, // not done | you can call the customFunction
        playSFX: "soundPath", // the enter button ig
        stopMusic: false,
        resumeMusic: false,
        changeMusic: "musicPath"
    },
    {
        text: "Guh?????",
        char: "filePath"
    }
];

var textShit:Dynamic;
var saveFile = "mods/" + mod + "/dialogueFolder";

var swagDialogue:FlxTypeText;

var inputText:FlxInputText;
var dialogueImage:FlxSprite;
var availableAnims:Array<String> = [];
function create() {
    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

	if (!FileSystem.exists(saveFile + "/dialogue.json"))
		File.saveContent(saveFile + "/dialogue.json", Json.stringify(dialogueTemplate, null, "\t"));

	textShit = Json.parse(File.getContent(saveFile + "/dialogue.json"));
    // trace("textShit: " + textShit);

	rect = new FlxSprite(0, 0);
	rect.scrollFactor.set();
	rect.makeGraphic(FlxG.width, FlxG.height, 0x75FFFFFF);
	rect.scale.set(2,2);
	rect.screenCenter();
	rect.updateHitbox();
	add(rect);

    dialogueImage = new FlxSprite(0,0);
    changeDialogueImage(textShit[0].dialoguePNG, textShit[0].pathDir, textShit[0].dialogueNames, textShit[0].dialogueLoopAnims);
    dialogueImage.animation.play(textShit[0].dialogueLoop);
    dialogueImage.scale.set(0.75, 0.75);
    dialogueImage.flipX = false;
    dialogueImage.antialiasing = EngineSettings.antialiasing;
    dialogueImage.updateHitbox();
    dialogueImage.screenCenter();
    dialogueImage.y += 200;
    add(dialogueImage);

    // thanks Yoshi :troll:
    swagDialogue = new FlxTypeText(dialogueImage.x + 50, dialogueImage.y + 125, FlxG.width, "test AAAAAAAAA", 32);
    swagDialogue.font = 'Pixel Arial 11 Bold';
    swagDialogue.color = 0xFF3F2021;
    swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
    swagDialogue.scrollFactor.set();
    swagDialogue.updateHitbox();
    swagDialogue.screenCenter();
    add(swagDialogue);

    inputText = new FlxInputText(180, 10, 0, "test", 16, 0xFFFFFFFF, 0xFF000000, true);
    // inputText.scale.set(1.5,1.5);
    inputText.updateHitbox();
    add(inputText);
    inputText.callback = function() {
        inputText.updateHitbox();
        trace(inputText.text);
        textShit[curDialogue].text = inputText.text;
        nextDialogue(0);
    };

    nextDialogue(0);
}

function openDialoguePaths(type:String = 'open') {
    switch(type) {
        case "open", "OPEN":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Open Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                textShit = Json.parse(File.getContent(t));
                nextDialogue(0);
            });
        case "save", "SAVE":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Save Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                File.saveContent(t, Json.stringify(textShit, null, "\t"));
            });
    }
}

function update(elapsed:Float) {

    if (inputText.hasFocus)
        inputText.updateHitbox();

    if (FlxG.keys.justPressed.L && !inputText.hasFocus)
        FlxG.switchState(new MainMenuState());

    if (FlxG.keys.justPressed.D && !inputText.hasFocus)
        nextDialogue(1);

    if (FlxG.keys.justPressed.A && !inputText.hasFocus)
        nextDialogue(-1);

    if (FlxG.keys.justPressed.B && !inputText.hasFocus)
        openDialoguePaths("SAVE");

    if (FlxG.keys.justPressed.V && !inputText.hasFocus)
        openDialoguePaths("OPEN");
}

var curDialogue:Int = 1;
function nextDialogue(hur:Int = 0) {
    curDialogue += hur;
    if (curDialogue > textShit.length - 1)
        curDialogue = textShit.length - 1;
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

    if (textShit[curDialogue].text != null)
        inputText.text = textShit[curDialogue].text;

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
    switch(textShit[curDialogue].changeTextColor) {
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
                nextDialogue(1);
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
    dialogueImage.updateHitbox();
}