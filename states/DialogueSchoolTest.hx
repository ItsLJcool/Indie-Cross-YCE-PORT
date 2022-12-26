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

var dialogueTemplate = {
    defaultStuff: { // things that will apply to ALL dialogues in the json, the dialogue 
        imagePath: ["speech_bubble_talking", "shared"], // [fileName, pathDirectory] | If there is no pathDir, it defaults to: modName/images
        textColor: 0xFF000000, // default text color
        textFont: "Pixel Arial 11 Bold", // default text font
        textXY: [50,100], // where the Default Text Offset should be, it adds to the current offset, it does not set it specifically
        textSize: 16,
        boxXY: null,
        boxScaleXY: null,
        boxFlipX: false,
        textSFX: "pixelText", // default SFX when the letter is typed on screen.
        animations: ["AAH loop", "Normal open", "AAH open", "Normal loop"], // animations for the Dialogue Image if it contains an XML
        loopAnims: [true, false, false, true], // if those animations should be looped or not,
        textSpeed: 0.04,
        openAnim: "Normal open",
        loopAnim: "Normal loop",
        scripts: [ // idk if this works yet
            {
                path: "dialogueFolder/test"
            },
        ],
        // add more later
    },
    dialogueStart: [
        {
            daText: "Default Text: Dialogue 1",
            textXY: null,
            textSize: null,
            boxXY: null,
            boxScaleXY: null,
            boxFlipX: false,
            textFont: "Pixel Arial 11 Bold",
            textColor: 0xFF000000,
            textSFX: "pixelText",
            boxPlayAnim: "Normal loop",
            textSpeed: 0.04,
            bgImage: {
                defaultBG: true, // white opacity BG (Psych Engine :troll: )
                enabled: false,
                path: null,
                opacity: null,
            },
            boxImage: {
                changeImage: false,
                path: null,
                animations: null,
                loopAnims: null,
            },
        },
    ]
}

var rect:FlxSprite;

var dialogue:Dynamic;
var saveFile = "mods/" + mod + "/dialogueFolder";

var dialogueImage:FlxSprite;
var swagDialogue:FlxTypeText;
var inputText:FlxInputText;

var scripts:ScriptPack;
function create() {
	if (!FileSystem.exists(saveFile + "/dialogueSchoolTest.json"))
		File.saveContent(saveFile + "/dialogueSchoolTest.json", Json.stringify(dialogueTemplate, null, "\t"));

	dialogue = Json.parse(File.getContent(saveFile + "/dialogueSchoolTest.json"));

    scripts = new ScriptPack(((dialogue.scripts == null)) ? [{paths: ''}] : dialogue.scripts);
    scripts.setVariable("create", function() {
    });
    for (s in scripts.scripts) s.setScriptObject(this);

	rect = new FlxSprite(0, 0);
	rect.scrollFactor.set();
	rect.makeGraphic(FlxG.width, FlxG.height, 0x75FFFFFF);
	rect.scale.set(2,2);
	rect.screenCenter();
	rect.updateHitbox();
	add(rect);
    
    dialogueImage = new FlxSprite(0,0);
    changeDialogueImage(
        dialogue.defaultStuff.imagePath[0], 
        dialogue.defaultStuff.imagePath[1], 
        dialogue.defaultStuff.animations, 
        dialogue.defaultStuff.loopAnims
    );
    dialogueImage.animation.play(dialogue.defaultStuff.loopAnim);
    dialogueImage.scale.set(0.75, 0.75);
    dialogueImage.flipX = false;
    dialogueImage.updateHitbox();
    dialogueImage.screenCenter();
    dialogueImage.y += 200;
    add(dialogueImage);

    // thanks Yoshi :troll:
    swagDialogue = new FlxTypeText(dialogueImage.x + 50, dialogueImage.y + 125, dialogueImage.width, "test AAAAAAAAA", 32);
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
        dialogue.dialogueStart[curDialogue].daText = inputText.text;
        nextDialogue(0);
    };

    nextDialogue(0);
}

function update(elapsed:Float) {
    if ((FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) && !inputText.hasFocus)
        nextDialogue(1);
    if ((FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) && !inputText.hasFocus)
        nextDialogue(-1);

    if (FlxG.keys.justPressed.N && !inputText.hasFocus)
        openDialoguePaths("SAVE");
}

var curDialogue:Int = 0;
function nextDialogue(hur:Int = 0)  {
    curDialogue += hur;
    if (curDialogue > dialogue.dialogueStart.length - 1)
        curDialogue = dialogue.dialogueStart.length - 1;
    if (curDialogue < 0)
        curDialogue = 0;

    inputText.text = dialogue.dialogueStart[curSelected].daText;

    if (dialogue.defaultStuff.openAnim != null && curDialogue == 0) {
        dialogueImage.animation.play(dialogue.defaultStuff.openAnim, true);
        dialogueImage.animation.finishCallback = function() {
            dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true); }
    }

    if (dialogue.dialogueStart[curDialogue].boxImage.changeImage != null && dialogue.dialogueStart[curDialogue].boxImage.changeImage) {
        changeDialogueImage(
            dialogue.dialogueStart[curDialogue].boxImage.path[0], 
            dialogue.dialogueStart[curDialogue].boxImage.path[1], 
            dialogue.dialogueStart[curDialogue].boxImage.animation, 
            dialogue.dialogueStart[curDialogue].boxImage.loopAnims);
    }
    if (dialogue.dialogueStart[curDialogue].boxPlayAnim != null)
        dialogueImage.animation.play(dialogue.dialogueStart[curDialogue].boxPlayAnim);

    if (dialogue.defaultStuff.boxScaleXY != null && dialogue.dialogueStart[curDialogue].boxScaleXY == null)
        dialogueImage.scale.set(dialogue.defaultStuff.boxScaleXY[0], dialogue.defaultStuff.boxScaleXY[1]);
    else if (dialogue.dialogueStart[curDialogue].boxScaleXY != null)
        dialogueImage.scale.set(dialogue.dialogueStart[curDialogue].boxScaleXY[0], dialogue.dialogueStart[curDialogue].boxScaleXY[1]);
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

    if (dialogue.defaultStuff.textXY != null && dialogue.dialogueStart[curDialogue].textXY == null) {
        swagDialogue.x = dialogueImage.x + dialogue.defaultStuff.textXY[0];
        swagDialogue.y = dialogueImage.y + dialogue.defaultStuff.textXY[1];
    }
    else if (dialogue.dialogueStart[curDialogue].textXY != null) {
        swagDialogue.x = dialogueImage.x + dialogue.dialogueStart[curDialogue].textXY[0];
        swagDialogue.y = dialogueImage.y + dialogue.dialogueStart[curDialogue].textXY[1];
    }
    else {
        swagDialogue.x = dialogueImage.x;
        swagDialogue.y = dialogueImage.y;
    }
    var textChangeColor:String = '';
    if (dialogue.defaultStuff.textColor != null && dialogue.dialogueStart[curDialogue].textColor == null)
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

    if (dialogue.defaultStuff.textSFX != null && dialogue.dialogueStart[curDialogue].textSFX == null)
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(dialogue.defaultStuff.textSFX), 0.6)];
    else if (dialogue.dialogueStart[curDialogue].textSFX != null)
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound(dialogue.dialogueStart[curDialogue].textSFX), 0.6)];
    else
        swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

    if (dialogue.defaultStuff.textSize != null && dialogue.dialogueStart[curDialogue].textSize == null)
        swagDialogue.size = dialogue.defaultStuff.textSize;
    else if (dialogue.dialogueStart[curDialogue].textSize != null)
        swagDialogue.size = dialogue.dialogueStart.textSize;
    else
        swagDialogue.size = 16;

    if (dialogue.defaultStuff.textSpeed != null && dialogue.dialogueStart[curDialogue].textSpeed == null)
        swagDialogue.start(dialogue.defaultStuff.textSpeed, true);
    else if (dialogue.dialogueStart[curDialogue].textSpeed != null)
        swagDialogue.start(dialogue.dialogueStart[curDialogue].textSpeed, true);
    else 
        swagDialogue.start(0.04, true);
}

function changeDialogueImage(path:String, ?pathDIR:String, names:Array<String>, looping:Array<Bool>) { // changes the Dialgoue Box image, causes a sec of lag tho
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

/**
    Alr so ideas ima put here:
    
        -- JSON usages --
    [1] Able to change dialogue box (I call it Dialogue Image bc makes sense)
    [2] Able to change default properties of the Text (ex: color, font, size, position, etc)
    [3] Able to change animation names of the animated Dialogue Box
    [4] Have Character Icons to show who is talking, prob gonna need an editor
    [5] Customize how fast the text shows on screen
    [6] Automatic next dialogue after X time (this feature will disable player to move between dialogue(s))
    [7] Custom background image or the basic Alpha white that fades in then out when the dialogue starts.
    [8] Play SFX when advancing dialogue (this can also be used to have voicelines during dialogue)
    [9] Custom cutscenes while dialogue (this will use an HX file like a custom script)
    [10] Speaking of scripts, you can use scripts for dialogues to have more customizability in your Dialogue, 
        you can also use that exact same hx file to use cutscenes.
        
        -- Scripting Abilities --
    [1] Set current dialogue to any, so you could advance 3 pages into the dialogue, then get sent to #6, then 7, then 1, etc.
    [2] Access to all functions and inputs.
    [3] Make / add your own changes to the dialogue, but if you want to suggest or add more features, DM ItsLJcool on Discord 
        or in the Codename / YoshiCrafterEngine Discord server, you can find a fourm on the LJ Dialogue Editor there.
    [4] honestly idk bc there is too much to list honestly
**/
function openDialoguePaths(type:String = 'open') {
    switch(type) {
        case "open", "OPEN":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Open Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                dialogue = Json.parse(File.getContent(t));
                nextDialogue(0);
            });
        case "save", "SAVE":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Save Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                File.saveContent(t, Json.stringify(dialogue, null, "\t"));
            });
    }
}