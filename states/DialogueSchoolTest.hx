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

import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIDropDownHeader;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;

import flixel.FlxCamera;

var dialogueTemplate = {
    defaultStuff: { // things that will apply to ALL dialogues in the json, the dialogue 
        imagePath: ["speech_bubble_talking", "shared"], // [fileName, pathDirectory] | If there is no pathDir, it defaults to: modName/images
        textColor: 0xFF000000, // default text color
        textFont: "Pixel Arial 11 Bold", // default text font
        textXY: [50,100], // where the Default Text Offset should be, it adds to the current offset, it does not set it specifically
        textSize: 16,
        boxXY: null,
        boxScale: 0.75,
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
            overrideDefaults: false,
            textXY: null,
            textSize: 16,
            boxXY: null,
            boxScale: 0.75,
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

var addDialogue:FlxUIButton;
var changeTextScale:FlxUINumericStepper;
var changeBoxScale:FlxUINumericStepper;
var dialogueBoxScale:FlxUINumericStepper;

var dad:Character;
var boyfriend:Boyfriend;
var camGame:FlxCamera;

var currentDialogueDisplay:FlxText;
function create() {
    camGame = new FlxCamera();
    FlxG.cameras.reset(camGame);
    FlxCamera.defaultCameras = [camGame];

	if (!FileSystem.exists(saveFile + "/dialogueSchoolTest.json"))
		File.saveContent(saveFile + "/dialogueSchoolTest.json", Json.stringify(dialogueTemplate, null, "\t"));

	dialogue = Json.parse(File.getContent(saveFile + "/dialogueSchoolTest.json"));

    for (i in 0...dialogue.defaultStuff.scripts.length) dialogue.defaultStuff.scripts[i].path = mod + "/" + dialogue.defaultStuff.scripts[i].path;

    scripts = new ScriptPack(((dialogue.scripts == null)) ? [{paths: ''}] : dialogue.defaultStuff.scripts);
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

    dad = new Character(0,-100, mod + ":" + "sansIndie");
    dad.scale.set(0.5, 0.5);
    dad.updateHitbox();
    dad.screenCenter();
    dad.y += -125;
    dad.x += -125;

    boyfriend = new Boyfriend(0,-100, 'bf');
    boyfriend.scale.set(0.5, 0.5);
    boyfriend.updateHitbox();
    boyfriend.screenCenter();
    boyfriend.y += -65;
    boyfriend.x += -125;

    add(dad);
    add(boyfriend);
    boyfriend.alpha = 0.0001;
    dad.alpha = 0.0001;
    
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

    addDialogue = new FlxUIButton(0,0, "Add Dialogue", function() {
        dialogue.dialogueStart.push({
            daText: "Default Text: Dialogue " + (dialogue.dialogueStart.length + 1),
            textFont: "Pixel Arial 11 Bold",
            textColor: 0xFF000000,
            textSFX: "pixelText",
            textSize: 16,
            boxPlayAnim: "Normal loop",
            boxScale: 0.75,
            textSpeed: 0.04,
            boxFlipX: false,
            overrideDefaults: false,
        });
        nextDialogue(dialogue.dialogueStart.length + 1);
	});
    add(addDialogue);
    addDialogue.resize(100,50);
    addDialogue.updateHitbox();
    addDialogue.x = FlxG.width - addDialogue.width - 20;
    addDialogue.y = (FlxG.height / 2 - FlxG.height / 2) + addDialogue.height - 40;

    saveDialogue = new FlxUIButton(0,0, "Save Dialogue", function() {
        openDialoguePaths("SAVE");
	});
    add(saveDialogue);
    saveDialogue.resize(150,50);
    saveDialogue.updateHitbox();
    saveDialogue.x = FlxG.width - saveDialogue.width - 20;
    saveDialogue.y = FlxG.height - saveDialogue.height - 20;

    currentDialogueDisplay = new FlxText(0,0,0, "unknown", 25);
    currentDialogueDisplay.x = saveDialogue.x + (saveDialogue.width / 2 - saveDialogue.width / 2);
    currentDialogueDisplay.y = saveDialogue.y - saveDialogue.height;
    currentDialogueDisplay.text = "unknown";
    currentDialogueDisplay.font = "VCR OSD Mono";
    currentDialogueDisplay.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1.5);
    add(currentDialogueDisplay);

    dialogueEditorTab = new FlxUITabMenu(null, null, [
        {
            name: "currentDialogue",
            label: "Specific",
        },
        {
            name: "defaultStuff",
            label: "Default",
        },
    ], true);
    
    var specific = new FlxUI(null, dialogueEditorTab);
    specific.name = "currentDialogue";
    var defaultUh = new FlxUI(null, dialogueEditorTab);
    defaultUh.name = "defaultStuff";

    dialogueEditorTab.scrollFactor.set();
    dialogueEditorTab.setPosition(FlxG.width - dialogueEditorTab.width*2 + 85, 50);
    dialogueEditorTab.resize(300, 250);
    dialogueEditorTab.scrollFactor.set();
    add(dialogueEditorTab);
    dialogueEditorTab.addGroup(specific);
    dialogueEditorTab.addGroup(defaultUh);
    
    overrideDefault = new FlxUICheckBox(10, 10, null, null, "Override Default Values", 100, null, function() {
        dialogue.dialogueStart[curDialogue].overrideDefaults = overrideDefault.checked;
        nextDialogue(0);
    });
    specific.add(overrideDefault);

    changeTextScale = new FlxUINumericStepper(10,50, 1, 16, 1, 999, 2);
    changeTextScale.visible = false;
    textScaleLabel = new FlxUIText(changeTextScale.x, changeTextScale.y - changeTextScale.height, 280, "Text Scale");
    textScaleLabel.visible = false;
    specific.add(changeTextScale);
    specific.add(textScaleLabel);

    changeBoxScale = new FlxUINumericStepper(changeTextScale.width + 20,50, 0.25, 0.75, 0.25, 10, 2);
    changeBoxScale.visible = false;
    boxScaleLabel = new FlxUIText(changeBoxScale.x, changeBoxScale.y - changeBoxScale.height, 280, "Box Scale");
    boxScaleLabel.visible = false;
    specific.add(changeBoxScale);
    specific.add(boxScaleLabel);

    inputText = new FlxInputText(10,dialogueEditorTab.height - 50, dialogueEditorTab.width - 20, "test", 16, 0xFFFFFFFF, 0xFF000000, true);
    // inputText.scale.set(1.5,1.5);
    inputText.updateHitbox();
    inputText.callback = function() {
        inputText.updateHitbox();
        dialogue.dialogueStart[curDialogue].daText = inputText.text;
        nextDialogue(0);
    };
    specific.add(inputText);
    
    // Default Stuff

    defaultTextScale = new FlxUINumericStepper(10,25, 1, 16, 1, 999, 2);
    var label:FlxUIText = new FlxUIText(defaultTextScale.x, defaultTextScale.y - defaultTextScale.height, 280, "Text Scale");
    defaultUh.add(defaultTextScale);
    defaultUh.add(label);

    defaultBoxScale = new FlxUINumericStepper(defaultTextScale.width + 20,25, 0.25, 0.75, 0.25, 10, 2);
    var label:FlxUIText = new FlxUIText(defaultBoxScale.x, defaultBoxScale.y - defaultBoxScale.height, 280, "Box Scale");
    defaultUh.add(defaultBoxScale);
    defaultUh.add(label);
    
    changeBoxImage = new FlxUICheckBox(10, dialogueEditorTab.height - 50, null, null, "Change Box Image", 75, null, function () {
        if (!changeBoxImage.checked) return;
        CoolUtil.openDialogue("OPEN", "Select the PNG to change ALL of the Dialogue", function(path) {
            if (Path.extension(path).toLowerCase() != "png") {
                trace("You need an XML or PNG");
                return;
            }
            var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x88000000);
            add(bg);
            window = new FlxUITabMenu(null, null, [
                {
                    name: "boxImage",
                    label: "Change Box Image",
                }
            ], true);
    
            var tab = new FlxUI(null, window);
            tab.name = "boxImage";
            var label:FlxUIText = new FlxUIText(10, 10, 480, "Animation Names");
            tab.add(label);
            var anims:FlxUIInputText = new FlxUIInputText(10, label.y + label.height, 480, "'Animation 1', 'NewAnimationName 2'");
            var label:FlxUIText = new FlxUIText(10, anims.y + anims.height + 5, 480, "Looping Animations");
            tab.add(label);
            var loops:FlxUIInputText = new FlxUIInputText(10, label.y + label.height, 480, "true, false");
    
            var warning = new FlxUIText(10, loops.y + loops.height + 10, 480, "For the animations to work you need to look at the XML and make the animations from the XML top to bottom. ex: \n\nFirstAnimation0001\nFirstAnimation0002\nnewAnimation0001 \n\nand you put: 'newAnimation, FirstAnimation' \nthen when you `play('animationPlayNew');` it will play `FirstAnimation0001` because thats at the top of the XML");
    
            var addButton = new FlxUIButton(250, warning.y + warning.height + 10, "Change Box", function() {
                dialogue.defaultStuff.animations = [anims.text];
                dialogue.defaultStuff.loopAnims = [loops.text];
                dialogue.defaultStuff.imagePath = [path, "images"];
                trace(dialogue.defaultStuff.animations);
                trace(dialogue.defaultStuff.loopAnims);
                changeDialogueImage(
                    dialogue.defaultStuff.imagePath[0], 
                    dialogue.defaultStuff.imagePath[1], 
                    dialogue.defaultStuff.animation, 
                    dialogue.defaultStuff.loopAnims);
                window.destroy();
                bg.destroy();
                nextDialogue(0);
            });
            addButton.x -= addButton.width / 2;
    
            tab.add(anims);
            tab.add(warning);
            tab.add(addButton);
            tab.add(loops);
            window.addGroup(tab);
            window.resize(500, addButton.y + addButton.height + 10);
            window.screenCenter();
            add(window);
            var closeButton = new FlxUIButton(window.width - 20, -20, "X", function() {
                window.destroy();
                bg.destroy();
                nextDialogue(0);
            });
            closeButton.color = 0xFFFF4444;
            closeButton.label.color = 0xFFFFFFFF;
            closeButton.resize(20, 20);
            add(closeButton);
            tab.add(closeButton);
            });
    });
    defaultUh.add(changeBoxImage);

    nextDialogue(0);
}

function getNewBoxImage(checkBox:Dynamic) {
}

function update(elapsed:Float) {
    if ((FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) && !inputText.hasFocus)
        nextDialogue(1);
    if ((FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) && !inputText.hasFocus)
        nextDialogue(-1);
    if ((FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.L) && !inputText.hasFocus)
        FlxG.switchState(new MainMenuState());

	updateButtons(elapsed);
}

function updateButtons() {
    if ((dialogue.defaultStuff.textSize != defaultTextScale.value) && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
        swagDialogue.size = defaultTextScale.value;
        dialogue.defaultStuff.textSize = defaultTextScale.value;
        nextDialogue(0);
    }
    else if ((dialogue.dialogueStart[curDialogue].textSize != changeTextScale.value) && dialogue.dialogueStart[curDialogue].overrideDefaults) {
        swagDialogue.size = changeTextScale.value;
        dialogue.dialogueStart[curDialogue].textSize = changeTextScale.value;
        nextDialogue(0);
    }

    if ((dialogue.defaultStuff.boxScale != defaultBoxScale.value) && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
        dialogueImage.scale.set(defaultBoxScale.value, defaultBoxScale.value);
        dialogue.defaultStuff.boxScale = defaultBoxScale.value;
        trace(dialogueImage.scale);
        nextDialogue(0);
    }
    else if ((dialogue.dialogueStart[curDialogue].boxScale != changeBoxScale.value) && dialogue.dialogueStart[curDialogue].overrideDefaults) {
        dialogueImage.scale.set(changeBoxScale.value, changeBoxScale.value);
        dialogue.dialogueStart[curDialogue].boxScale = changeBoxScale.value;
        trace(dialogueImage.scale);
        nextDialogue(0);
    }
}

var curDialogue:Int = 0;
function nextDialogue(hur:Int = 0)  {

    curDialogue += hur;
    if (curDialogue > dialogue.dialogueStart.length - 1)
        curDialogue = dialogue.dialogueStart.length - 1;
    if (curDialogue < 0)
        curDialogue = 0;
    
    currentDialogueDisplay.text = (curDialogue + 1) + " / " + dialogue.dialogueStart.length;
    
    inputText.text = dialogue.dialogueStart[curDialogue].daText;
    if (dialogue.dialogueStart[curDialogue].overrideDefaults == null) dialogue.dialogueStart[curDialogue].overrideDefaults = false;
    overrideDefault.checked = dialogue.dialogueStart[curDialogue].overrideDefaults;

    changeTextScale.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeBoxScale.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    textScaleLabel.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    boxScaleLabel.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;

    if (dialogue.defaultStuff.openAnim != null && curDialogue == 0) {
        dialogueImage.animation.play(dialogue.defaultStuff.openAnim, true);
        dialogueImage.animation.finishCallback = function() {
            dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true); }
    }

    if (dialogue.dialogueStart[curDialogue].boxImage != null) {
    if (dialogue.dialogueStart[curDialogue].boxImage.changeImage != null && dialogue.dialogueStart[curDialogue].boxImage.changeImage) {
        changeDialogueImage(
            dialogue.dialogueStart[curDialogue].boxImage.path[0], 
            dialogue.dialogueStart[curDialogue].boxImage.path[1], 
            dialogue.dialogueStart[curDialogue].boxImage.animation, 
            dialogue.dialogueStart[curDialogue].boxImage.loopAnims);
        }
    }
    if (dialogue.dialogueStart[curDialogue].boxPlayAnim != null)
        dialogueImage.animation.play(dialogue.dialogueStart[curDialogue].boxPlayAnim);

    if (dialogue.defaultStuff.boxScale != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        dialogueImage.scale.set(dialogue.defaultStuff.boxScale, dialogue.defaultStuff.boxScale);
    else if (dialogue.dialogueStart[curDialogue].boxScale != null)
        dialogueImage.scale.set(dialogue.dialogueStart[curDialogue].boxScale, dialogue.dialogueStart[curDialogue].boxScale);
    else
        dialogueImage.scale.set(0.75,0.75);
    dialogueImage.updateHitbox();
    changeBoxScale.value = dialogue.dialogueStart[curDialogue].boxScale;
    defaultBoxScale.value = dialogue.defaultStuff.boxScale;
    
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

    if (dialogue.defaultStuff.textSize != null && !dialogue.dialogueStart[curDialogue].overrideDefaults)
        swagDialogue.size = dialogue.defaultStuff.textSize;
    else if (dialogue.dialogueStart[curDialogue].textSize != null)
        swagDialogue.size = dialogue.dialogueStart[curDialogue].textSize;
    else
        swagDialogue.size = 16;
    defaultTextScale.value = dialogue.defaultStuff.textSize;
    changeTextScale.value = dialogue.dialogueStart[curDialogue].textSize;

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