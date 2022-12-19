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
        textFont: "Pixel Arial 11 Bold", // default text fontt
        textXY: [50,100], // where the Default Text Offset should be, it adds to the current offset, it does not set it specifically
        textSFX: "pixelText", // default SFX when the letter is typed on screen.
        animations: ["AAH loop", "Normal open", "AAH open", "Normal loop"], // animations for the Dialogue Image if it contains an XML
        loopAnims: [true, false, false, true], // if those animations should be looped or not,
        textSpeed: 0.04,
        openAnim: "Normal open",
        loopAnim: "Normal loop",
        scripts: [
            {
                path: "dialogueFolder/test"
            },
        ],
        // add more later
    },
    dialogueStart: [
        {
            daText: "Default Text: Dialogue 1",
        },
    ]
}

var blankBG:FlxSprite;

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

    scripts = new ScriptPack(dialogue.scripts);
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
    };

    nextDialogue(0);
}

var curDialogue:Int = 0;
function nextDialogue(hur:Int = 0)  {
    curDialogue += hur;
    if (curDialogue > dialogue.dialogueStart.length - 1)
        curDialogue = dialogue.dialogueStart.length - 1;
    if (curDialogue < 0)
        curDialogue = 0;

    swagDialogue.resetText(dialogue.dialogueStart[curDialogue].daText);
    swagDialogue.updateHitbox();
    swagDialogue.x = (checkNull(dialogue.defaultStuff.textXY[0]) ? dialogueImage.x : dialogueImage.x + dialogue.defaultStuff.textXY[0]);
    swagDialogue.y = (checkNull(dialogue.defaultStuff.textXY[1]) ? dialogueImage.y : dialogueImage.y + dialogue.defaultStuff.textXY[1]);
    swagDialogue.start((checkNull(dialogue.defaultStuff.textSpeed) ? 0.04 : dialogue.defaultStuff.textSpeed), true);
}

function checkNull(check:Dynamic) { // can use this so ppl in scripts can check if something is null and then they can set the value- idk nvm shut the fuck up this makes it easier on me
    if (check == null) return true;
    else return false;
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