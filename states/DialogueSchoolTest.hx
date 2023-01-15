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
import dev_toolbox.file_explorer.FileExplorer;
import dev_toolbox.file_explorer.FileExplorerType;
import flixel.addons.ui.StrNameLabel;
import flixel.FlxBasic;

import flixel.FlxCamera;

import dev_toolbox.ColorPicker;

var dialogueTemplate = {
    defaultStuff: { // things that will apply to ALL dialogues in the json, the dialogue 
        imagePath: ["speech_bubble_talking", "shared"], // [fileName, pathDirectory] | If there is no pathDir, it defaults to: modName/images
        textColor: 0xFF000000, // default text color
        textFont: "Pixel Arial 11 Bold", // default text font // not done
        textXY: null, // where the Default Text Offset should be, it adds to the current offset, it does not set it specifically
        textSize: 16,
        boxXY: null, // not done
        boxScale: 0.75,
        boxFlipX: false, // not done
        textSFX: "pixelText", // default SFX when the letter is typed on screen. // not done
        animations: ["AAH loop", "Normal open", "AAH open", "Normal loop"], // animations for the Dialogue Image if it contains an XML
        loopAnims: [true, false, false, true], // if those animations should be looped or not,
        textSpeed: 0.04, // not done
        openAnim: "Normal open",
        loopAnim: "Normal loop",
        endAnim: null,
        scripts: null,
        musicStuff: {
            musicEnabled: true,
            audioPath: "breakfast",
            volume: 0.8,
        }
        // add more later
    },
    dialogueStart: [
        {
            daText: "Default Text: Dialogue 1",
            overrideDefaults: false,
            playSFX: null,
            textXY: null,
            textSize: 16,
            boxXY: null, // not done
            boxScale: 0.75,
            boxFlipX: false, // not done
            textFont: "Pixel Arial 11 Bold", // not done
            textColor: 0xFF000000,
            textSFX: "pixelText", // not done
            boxPlayAnim: null,
            textSpeed: 0.04, // not done
            endAnim: null,
            bgImage: { // not done
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
            musicStuff: {
                musicEnabled: false,
                audioPath: null,
                volume: 0.8,
                pauseMusic: false,
                resumeMusic: false,
            }
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

var currentDialoguePath:String = saveFile + "/dialogueTemplate.json";
var dialogueScripts:ScriptPack;
function create() {
	if (!FileSystem.exists(saveFile + "/dialogueTemplate.json"))
		File.saveContent(saveFile + "/dialogueTemplate.json", Json.stringify(dialogueTemplate, null, "\t"));
	dialogue = Json.parse(File.getContent(saveFile + "/dialogueTemplate.json"));
    updateScripts();

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
    
    dialogueScripts.executeFunc("create");

    addDialogue = new FlxUIButton(0,0, "Add Dialogue", function() {
        dialogue.dialogueStart.push({
            daText: "Default Text: Dialogue " + (dialogue.dialogueStart.length + 1),
            textFont: "Pixel Arial 11 Bold",
            textColor: 0xFF000000,
            textSFX: "pixelText",
            textSize: 16,
            boxPlayAnim: null,
            boxScale: 0.75,
            textSpeed: 0.04,
            boxFlipX: false,
            overrideDefaults: false,
            boxImage: {
                changeImage: false,
                path: null,
                animations: null,
                loopAnims: null,
            },
            musicStuff: {
                musicEnabled: false,
                audioPath: null,
                volume: 0.8,
                pauseMusic: false,
                resumeMusic: false,
            },
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
    saveDialogue.resize(100,50);
    saveDialogue.updateHitbox();
    saveDialogue.x = FlxG.width - saveDialogue.width - 20;
    saveDialogue.y = FlxG.height - saveDialogue.height - 20;
    
    openDialogueLol = new FlxUIButton(0,0, "Open Dialogue", function() {
        openDialoguePaths("OPEN");
	});
    add(openDialogueLol);
    openDialogueLol.resize(100,50);
    openDialogueLol.updateHitbox();
    openDialogueLol.x = FlxG.width - openDialogueLol.width - saveDialogue.width - 40;
    openDialogueLol.y = FlxG.height - openDialogueLol.height - 20;
    
    removeCurrentDialogue = new FlxUIButton(0,0, "Remove Current Dialogue", function() {
        if (dialogue.dialogueStart.length == 1) return;
        dialogue.dialogueStart[curDialogue] = dialogue.dialogueStart.splice(0, dialogue.dialogueStart[curDialogue]);
        trace(dialogue.dialogueStart[curDialogue]);
        for (i in curDialogue...dialogue.dialogueStart.length) dialogue.dialogueStart[i] = dialogue.dialogueStart[i+1];
        dialogue.dialogueStart.resize(dialogue.dialogueStart.length-1);
        nextDialogue(0);
	});
    add(removeCurrentDialogue);
    removeCurrentDialogue.resize(100,50);
    removeCurrentDialogue.updateHitbox();
    removeCurrentDialogue.x = (FlxG.width / 2 - FlxG.width / 2) + removeCurrentDialogue.width - 20;
    removeCurrentDialogue.y = FlxG.height - removeCurrentDialogue.height - 20;

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
    ], null, true);
    
    var specific = new FlxUI(null, dialogueEditorTab);
    specific.name = "currentDialogue";
    var defaultUh = new FlxUI(null, dialogueEditorTab);
    defaultUh.name = "defaultStuff";

    dialogueEditorTab.scrollFactor.set();
    dialogueEditorTab.setPosition(FlxG.width - dialogueEditorTab.width*2 + 85, 50);
    dialogueEditorTab.resize(300, 300);
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
    
    changeTextColor = new FlxUIButton(210, dialogueEditorTab.height - 80, "Change Text Color", function() {
        var e = new ColorPicker(swagDialogue.color, function(newColor) {
            trace(newColor);
            swagDialogue.color = newColor;
            dialogue.dialogueStart[curDialogue].textColor = newColor;
            nextDialogue(0);
        });
        openSubState(e);
    });
    changeTextColor.visible = false;
    specific.add(changeTextColor);

    changeBoxImage = new FlxUICheckBox(10, dialogueEditorTab.height - 80, null, null, "Change Box Image", 75, null, function () {
        dialogue.dialogueStart[curDialogue].boxImage.changeImage = changeBoxImage.checked;
        if (!changeBoxImage.checked) return;
        changeBoxImage.checked = false;
        var fe = new FileExplorer(mod, FileExplorerType.Bitmap, "/images", function(path) {
            changeBoxImage.checked = true;
            dialogueEditorTab.active = false;
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                trace(e);
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'images') {
                trace("You need to have the file in Images Folder");
                return;
            }
            for (i in 0...splitThing.length) {
                trace(splitThing[i]);
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            trace(splitThing);
            trace(killMeNow);
            addNewWindow("boxImage", "Change Box Image", 200, "Change Box", function() {
                var data_animations = [for (e in anims.text.split(", ")) e];
                var data_loopAnims = [];
                for (e in loops.text.split(", ")) {
                    Std.string(e);
                    trace(e);
                    if (e == "true") e = true
                    else e = false;
                    data_loopAnims.push(e);
                }
                trace("data_animations: " + data_animations + " | length: " + data_animations.length);
                trace("data_loopAnims: " + data_loopAnims + " | length: " + data_loopAnims.length);
                if (data_loopAnims.length == 1) {
                    data_loopAnims = [];
                    for (e in loops.text.split(",")) {
                        Std.string(e);
                        trace(e);
                        if (e == "true") e = true
                        else e = false;
                        data_loopAnims.push(e);
                    }
                }
                if (data_animations.length == 1) data_animations = [for (e in anims.text.split(",")) e];
                trace("data_animations: " + data_animations + " | length: " + data_animations.length);
                trace("data_loopAnims: " + data_loopAnims + " | length: " + data_loopAnims.length);
                trace(killMeNow.split(".")[0]);
                var data_path = [killMeNow.split(".")[0], null];
                trace(data_path);
                addNewWindow("openAnim", "Open and Closing Animation", 200, "Change Box", function() {
                    trace(dialogue.dialogueStart[curDialogue].boxImage.changeImage);
                    dialogue.dialogueStart[curDialogue].boxPlayAnim = loops.text;
                    dialogue.dialogueStart[curDialogue].boxImage.animations = data_animations;
                    dialogue.dialogueStart[curDialogue].boxImage.loopAnims = data_loopAnims;
                    dialogue.dialogueStart[curDialogue].boxImage.path = data_path;
                    nextDialogue(0);
                    dialogueEditorTab.active = true;
                });
                label = new FlxUIText(10, 10, 480, "Box Loop Animation Name");
                uhTab.add(label);
                loops = new FlxUIInputText(10, label.height + 15, 480, dialogue.dialogueStart[curDialogue].boxPlayAnim);
        
                warning = new FlxUIText(10, loops.y + loops.height + 10, 480, "Uh so you need to play an animation");
                uhTab.add(loops);
                uhTab.add(warning);
            });
            label = new FlxUIText(10, 10, 480, "Animation Names");
            uhTab.add(label);
            var ugh = '';
            if (dialogue.dialogueStart[curDialogue].boxImage.animations != null) {
            for (i in 0...dialogue.dialogueStart[curDialogue].boxImage.animations.length) {
                ugh += dialogue.dialogueStart[curDialogue].boxImage.animations[i];
                if (i != dialogue.dialogueStart[curDialogue].boxImage.animations.length-1) ugh += ",";
            } }
            anims = new FlxUIInputText(10, label.height + 15, 480, ugh);
            label = new FlxUIText(10, 45, 480, "Looping Animations");
            uhTab.add(label);
            ugh = '';
            if (dialogue.dialogueStart[curDialogue].boxImage.animations != null) {
            for (i in 0...dialogue.dialogueStart[curDialogue].boxImage.loopAnims.length) {
                ugh += dialogue.dialogueStart[curDialogue].boxImage.loopAnims[i];
                if (i != dialogue.dialogueStart[curDialogue].boxImage.loopAnims.length-1) ugh += ",";
            } }
            loops = new FlxUIInputText(10, 60, 480, ugh);
    
            warning = new FlxUIText(10, loops.y + loops.height + 10, 480, "For the animations to work you need to look at the XML and make the animations from the XML top to bottom. ex: \n\nFirstAnimation0001\nFirstAnimation0002\nnewAnimation0001 \n\nand you put: 'newAnimation, FirstAnimation' \nthen when you `play('animationPlayNew');` it will play `FirstAnimation0001` because thats at the top of the XML");
            uhTab.add(anims);
            uhTab.add(warning);
            uhTab.add(loops);
        });
        openSubState(fe);
    });
    specific.add(changeBoxImage);
    changeBoxImage.visible = false;
    changeTextXY = new FlxUIButton(10 + changeBoxImage.width, dialogueEditorTab.height - 80, "Change Text XY", function() {
        canMoveText = true;
        FlxTween.tween(dialogueEditorTab, {alpha: 0.35}, 0.25, {ease: FlxEase.quadOut});
        dialogueEditorTab.active = false;
    });
    specific.add(changeTextXY);
    changeTextXY.visible = false;
    overrideChangeTextXY = new FlxUIButton(10 + changeBoxImage.width, dialogueEditorTab.height - 110, "Set Text XY to Default", function() {
        dialogue.dialogueStart[curDialogue].textXY = dialogue.defaultStuff.textXY;
    });
    specific.add(overrideChangeTextXY);
    overrideChangeTextXY.visible = false;

    boxAnimLabel = new FlxUIText(changeTextScale.width + 85, 33, 480, "Play Box Anim");
    specific.add(boxAnimLabel);
    boxAnimLabel.visible = false;

    boxAnim = new FlxInputText(changeTextScale.width + 85, 50, 100, dialogue.dialogueStart[curDialogue].boxPlayAnim, 10, 0xFFFFFFFF, 0xFF000000, true);
    // boxAnim.scale.set(1.5,1.5);
    boxAnim.updateHitbox();
    boxAnim.callback = function() {
        boxAnim.updateHitbox();
        dialogue.dialogueStart[curDialogue].boxPlayAnim = (boxAnim.text == "") ? null : boxAnim.text;
        nextDialogue(0);
    };
    boxAnim.visible = false;
    specific.add(boxAnim);

    var label:FlxUIText = new FlxUIText(10, 67, 50, "Play SFX");
    specific.add(label);
    playDialogueSFX = new FlxUIInputText(10, 87, 100, dialogue.dialogueStart[curDialogue].playSFX);
    specific.add(playDialogueSFX);
    specific.add(playButton = new FlxUIButton(10 + playDialogueSFX.width + 5, 85, "", function() {
        FlxG.sound.play(Paths.sound(dialogue.dialogueStart[curDialogue].playSFX));
    }));
    playButton.color = 0xFF44FF44;
    playButton.resize(20, 20);
    var playIcon:FlxSprite;
    specific.add(playIcon = CoolUtil.createUISprite("play"));
    playIcon.setPosition(playButton.x + 2, playButton.y + 2);
    specific.add(browseButton = new FlxUIButton(10 + playDialogueSFX.width + 30, 85, "", function() {
        persistentUpdate = false;
        openSubState(new FileExplorer(mod, FileExplorerType.OGG, "sounds", function(path) {
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'sounds') {
                trace("You need to have the file in sounds folder");
                return;
            }
            for (i in 0...splitThing.length) {
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            playDialogueSFX.text = dialogue.dialogueStart[curDialogue].playSFX = killMeNow.split(".")[0];
            nextDialogue(0);
        }));
    }));
    browseButton.resize(20, 20);
    browseButton.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);
    
    labelTextSFX = new FlxUIText(10, 105, 50, "Text SFX");
    specific.add(labelTextSFX);
    changeTextSFX = new FlxUIInputText(10, 120, 100, dialogue.dialogueStart[curDialogue].textSFX);
    specific.add(changeTextSFX);
    specific.add(playButtonTextSFX = new FlxUIButton(10 + changeTextSFX.width + 5, 117, "", function() {
        FlxG.sound.play(Paths.sound(dialogue.dialogueStart[curDialogue].textSFX));
    }));
    playButtonTextSFX.color = 0xFF44FF44;
    playButtonTextSFX.resize(20, 20);
    specific.add(playIconTextSFX = CoolUtil.createUISprite("play"));
    playIconTextSFX.setPosition(playButtonTextSFX.x + 2, playButtonTextSFX.y + 2);
    specific.add(browseButtonTextSFX = new FlxUIButton(10 + changeTextSFX.width + 30, 117, "", function() {
        persistentUpdate = false;
        openSubState(new FileExplorer(mod, FileExplorerType.OGG, "sounds", function(path) {
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'sounds') {
                trace("You need to have the file in sounds folder");
                return;
            }
            for (i in 0...splitThing.length) {
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            changeTextSFX.text = dialogue.dialogueStart[curDialogue].textSFX = killMeNow.split(".")[0];
            nextDialogue(0);
        }));
    }));
    browseButtonTextSFX.resize(20, 20);
    browseButtonTextSFX.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);
    
    labelTextFont = new FlxUIText(10, 135, 75, "Change Text Font");
    specific.add(labelTextFont);
    changeTextFont = new FlxUIInputText(10, 150, 100, dialogue.dialogueStart[curDialogue].textFont);
    specific.add(changeTextFont);
    specific.add(browseButtonTextFont = new FlxUIButton(10 + changeTextFont.width + 5, 143, "", function() {
        CoolUtil.openDialogue(FileDialogType.OPEN, "Select A Font", function(path) {
            if (Path.extension(path).toLowerCase() != "ttf") {
                trace("You Need To Grab A ttf File");
                return;
            }
            var thing = path.split('fonts\\')[1];
            var newThing:String = '';
            for (i in 0...thing.split("\\").length) {
                newThing += thing.split("\\")[i];
                if (i != thing.split("\\").length-1) newThing += "/"; 
            }
            changeTextFont.text = dialogue.dialogueStart[curDialogue].textFont = newThing.split(".")[0];
            nextDialogue(0);
        });
    }));
    browseButtonTextFont.resize(20, 20);
    browseButtonTextFont.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);
    
    // Default Stuff

    defaultTextScale = new FlxUINumericStepper(10,25, 1, 16, 1, 999, 2);
    var label:FlxUIText = new FlxUIText(defaultTextScale.x, defaultTextScale.y - defaultTextScale.height, 280, "Text Scale");
    defaultUh.add(defaultTextScale);
    defaultUh.add(label);

    defaultBoxScale = new FlxUINumericStepper(defaultTextScale.width + 20,25, 0.25, 0.75, 0.25, 10, 2);
    var label:FlxUIText = new FlxUIText(defaultBoxScale.x, defaultBoxScale.y - defaultBoxScale.height, 280, "Box Scale");
    defaultUh.add(defaultBoxScale);
    defaultUh.add(label);

    var label:FlxUIText = new FlxUIText(10, 45, 50, "Text SFX");
    defaultUh.add(label);
    defaultTextSFX = new FlxUIInputText(10, 60, 100, dialogue.defaultStuff.textSFX);
    defaultUh.add(defaultTextSFX);
    defaultUh.add(playButton = new FlxUIButton(10 + defaultTextSFX.width + 5, 57, "", function() {
        FlxG.sound.play(Paths.sound(dialogue.defaultStuff.textSFX));
    }));
    playButton.color = 0xFF44FF44;
    playButton.resize(20, 20);
    var playIcon:FlxSprite;
    defaultUh.add(playIcon = CoolUtil.createUISprite("play"));
    playIcon.setPosition(playButton.x + 2, playButton.y + 2);
    defaultUh.add(browseButton = new FlxUIButton(10 + defaultTextSFX.width + 30, 57, "", function() {
        persistentUpdate = false;
        openSubState(new FileExplorer(mod, FileExplorerType.OGG, "sounds", function(path) {
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'sounds') {
                trace("You need to have the file in sounds folder");
                return;
            }
            for (i in 0...splitThing.length) {
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            defaultTextSFX.text = dialogue.defaultStuff.textSFX = killMeNow.split(".")[0];
            nextDialogue(0);
        }));
    }));
    browseButton.resize(20, 20);
    browseButton.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);

    var label:FlxUIText = new FlxUIText(10, 75, 50, "Music");
    defaultUh.add(label);
    defaultMusic = new FlxUIInputText(10, 90, 100, dialogue.defaultStuff.musicStuff.audioPath);
    defaultUh.add(defaultMusic);
    defaultUh.add(browseButton = new FlxUIButton(10 + defaultMusic.width + 5, 87, "", function() {
        persistentUpdate = false;
        openSubState(new FileExplorer(mod, FileExplorerType.OGG, "music", function(path) {
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'music') {
                trace("You need to have the file in music folder");
                return;
            }
            for (i in 0...splitThing.length) {
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            dialogue.defaultStuff.musicStuff.musicEnabled = true;
            defaultMusic.text = dialogue.defaultStuff.musicStuff.audioPath = killMeNow.split(".")[0];
            nextDialogue(0);
        }));
    }));
    browseButton.resize(20, 20);
    browseButton.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);
    
    var label:FlxUIText = new FlxUIText(10, 105, 75, "Text Font");
    defaultUh.add(label);
    defaultTextFont = new FlxUIInputText(10, 120, 100, dialogue.defaultStuff.textFont);
    defaultUh.add(defaultTextFont);
    defaultUh.add(browseButton = new FlxUIButton(10 + defaultTextFont.width + 5, 117, "", function() {
        CoolUtil.openDialogue(FileDialogType.OPEN, "Select A Font", function(path) {
            if (Path.extension(path).toLowerCase() != "ttf") {
                trace("You Need To Grab A ttf File");
                return;
            }
            var thing = path.split('fonts\\')[1];
            var newThing:String = '';
            for (i in 0...thing.split("\\").length) {
                newThing += thing.split("\\")[i];
                if (i != thing.split("\\").length-1) newThing += "/"; 
            }
            defaultTextFont.text = dialogue.defaultStuff.textFont = newThing.split(".")[0];
            nextDialogue(0);
        });
    }));
    browseButton.resize(20, 20);
    browseButton.addIcon(CoolUtil.createUISprite("folder"), 2, 2, true);
    
    defaultBoxImage = new FlxUIButton(10, dialogueEditorTab.height - 95, "Default Box Image", function () {
        var fe = new FileExplorer(mod, FileExplorerType.Bitmap, "/images", function(path) {
            dialogueEditorTab.active = false;
            var splitThing = [];
            var killMeNow:String = '';
            for (e in path.split("/")) {
                trace(e);
                if (e != "") splitThing.push(e);
            }
            if (splitThing[0] != 'images') {
                trace("You need to have the file in Images Folder");
                return;
            }
            for (i in 0...splitThing.length) {
                if (i != 0 && i != splitThing.length-1) killMeNow += splitThing[i] + "/";
                if (i == splitThing.length-1) killMeNow += splitThing[i];
            }
            addNewWindow("boxImage", "Change Box Image", 200, "Change Box", function() {
                var data_animations = [for (e in anims.text.split(", ")) e];
                var data_loopAnims = [];
                for (e in loops.text.split(", ")) {
                    Std.string(e);
                    trace(e);
                    if (e == "true") e = true
                    else e = false;
                    data_loopAnims.push(e);
                }
                trace("data_animations: " + data_animations + " | length: " + data_animations.length);
                trace("data_loopAnims: " + data_loopAnims + " | length: " + data_loopAnims.length);
                if (data_loopAnims.length == 1) {
                    for (e in loops.text.split(",")) {
                        Std.string(e);
                        trace(e);
                        if (e == "true") e = true
                        else e = false;
                        data_loopAnims.push(e);
                    }
                }
                if (data_animations.length == 1) data_animations = [for (e in anims.text.split(",")) e];
                trace("data_animations: " + data_animations + " | length: " + data_animations.length);
                trace("data_loopAnims: " + data_loopAnims + " | length: " + data_loopAnims.length);
                var data_imagePath = [killMeNow.split(".")[0], null];
                addNewWindow("openAnim", "Open and Closing Animation", 200, "Change Box", function() {
                    dialogue.defaultStuff.openAnim = (anims.text == "null" || anims.text == "") ? null : anims.text;
                    dialogue.defaultStuff.loopAnim = (loops.text == "null" || loops.text == "") ? null : loops.text;
                    dialogue.defaultStuff.endAnim = (ending.text == null || ending.text == "") ? null : ending.text;
                    dialogue.defaultStuff.animations = data_animations;
                    dialogue.defaultStuff.loopAnims = data_loopAnims;
                    dialogue.defaultStuff.imagePath = data_imagePath;
                    nextDialogue(0);
                    dialogueEditorTab.active = true;
                });
                label = new FlxUIText(10, 10, 480, "Box Opening Animation Name");
                uhTab.add(label);
                anims = new FlxUIInputText(10, label.height + 15, 480, dialogue.defaultStuff.openAnim);

                label = new FlxUIText(10, 45, 480, "Box Loop Animation Name");
                uhTab.add(label);
                loops = new FlxUIInputText(10, 60, 480, dialogue.defaultStuff.loopAnim);

                label = new FlxUIText(10, 75, 480, "Box Ending Animation Name");
                uhTab.add(label);
                ending = new FlxUIInputText(10, 90, 480, dialogue.defaultStuff.endAnim);
        
                warning = new FlxUIText(10, ending.y + ending.height + 10, 480, "Uh so you need to add Opening Animation, Looping Animation and Ending Anim (if avaliable, leave blank or say null)");
                uhTab.add(anims);
                uhTab.add(warning);
                uhTab.add(loops);
                uhTab.add(ending);
            });
            label = new FlxUIText(10, 10, 480, "Animation Names");
            uhTab.add(label);
            var ugh = '';
            for (i in 0...dialogue.defaultStuff.animations.length) {
                ugh += dialogue.defaultStuff.animations[i];
                if (i != dialogue.defaultStuff.animations.length-1) ugh += ",";
            }
            anims = new FlxUIInputText(10, label.height + 15, 480, ugh);
            label = new FlxUIText(10, 45, 480, "Looping Animations");
            uhTab.add(label);
            ugh = '';
            for (i in 0...dialogue.defaultStuff.loopAnims.length) {
                ugh += dialogue.defaultStuff.loopAnims[i];
                if (i != dialogue.defaultStuff.loopAnims.length-1) ugh += ",";
            }
            loops = new FlxUIInputText(10, 60, 480, ugh);
    
            warning = new FlxUIText(10, loops.y + loops.height + 10, 480, "For the animations to work you need to look at the XML and make the animations from the XML top to bottom. ex: \n\nFirstAnimation0001\nFirstAnimation0002\nnewAnimation0001 \n\nand you put: 'newAnimation, FirstAnimation' \nthen when you `play('animationPlayNew');` it will play `FirstAnimation0001` because thats at the top of the XML");
            uhTab.add(anims);
            uhTab.add(warning);
            uhTab.add(loops);
        });
        openSubState(fe);
    });
    defaultUh.add(defaultBoxImage);
    resetBoxXY = new FlxUIButton(10, dialogueEditorTab.height - 70, "Reset Box XY", function() {
        dialogue.defaultStuff.boxXY = null;
        nextDialogue(0);
    });
    defaultUh.add(resetBoxXY);
    defaultBoxXY = new FlxUIButton(10, dialogueEditorTab.height - 45, "Change Box XY", function() {
        canMoveBoxDefault = true;
        FlxTween.tween(dialogueEditorTab, {alpha: 0.35}, 0.25, {ease: FlxEase.quadOut});
        dialogueEditorTab.active = false;
    });
    defaultUh.add(defaultBoxXY);
    
    defaultTextColor = new FlxUIButton(210,dialogueEditorTab.height - 45, "Default Text Color", function() {
        var e = new ColorPicker(swagDialogue.color, function(newColor) {
            trace(newColor);
            swagDialogue.color = newColor;
            dialogue.defaultStuff.textColor = newColor;
            nextDialogue(0);
        });
        openSubState(e);
    });
    defaultUh.add(defaultTextColor);
    resetTextXY = new FlxUIButton(30 + defaultTextColor.width, dialogueEditorTab.height - 70, "Reset Text XY", function() {
        dialogue.defaultStuff.textXY = null;
        nextDialogue(0);
    });
    defaultUh.add(resetTextXY);
    defaultTextXY = new FlxUIButton(30 + defaultTextColor.width, dialogueEditorTab.height - 45, "Default Text XY", function() {
        canMoveTextDefault = true;
        FlxTween.tween(dialogueEditorTab, {alpha: 0.35}, 0.25, {ease: FlxEase.quadOut});
        dialogueEditorTab.active = false;
    });
    defaultUh.add(defaultTextXY);
    
    scriptsAddDialogue = new FlxUIButton(50 + defaultTextColor.width + defaultTextXY.width, 10, "Add A Script", function() {
        var fe = new FileExplorer(mod, FileExplorerType.HScript, null, function(path) {
            if (dialogue.defaultStuff.scripts == null) dialogue.defaultStuff.scripts = [];
            var killMeAGAIN = {
                path: mod + path.split(".")[0],
            }
            if (!dialogue.defaultStuff.scripts.contains(killMeAGAIN)) {
                dialogue.defaultStuff.scripts.push(killMeAGAIN);
            }
            trace(dialogue.defaultStuff.scripts);
            updateScripts();
        });
        openSubState(fe);
    });
    defaultUh.add(scriptsAddDialogue);
    scriptsRemoveDialogue = new FlxUIButton(50 + defaultTextColor.width + defaultTextXY.width, scriptsAddDialogue.height + 15, "Remove A Script", function() {
        addNewWindow("removeScript", "Remove Script(s)", 300, null, function() {
        });
        updateScriptsRemoved();
    });
    defaultUh.add(scriptsRemoveDialogue);

    dialogueScripts.executeFunc("createPost");
    if (dialogue.defaultStuff.musicStuff.musicEnabled) {
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music(dialogue.defaultStuff.musicStuff.audioPath, (dialogue.defaultStuff.musicStuff.audioPath == "breakfast") ? "shared" : null), dialogue.defaultStuff.musicStuff.volume);
        FlxG.sound.music.time = 0;
        Conductor.songPosition = 0;
    }
    nextDialogue(0); 
}
var bgMusic:FlxSound;

function updateScripts() {
    dialogueScripts = new ScriptPack((dialogue.defaultStuff.scripts == null) ? [{paths: ''}] : dialogue.defaultStuff.scripts);
    dialogueScripts.setVariable("update", function(?elapsed:Float){});
	dialogueScripts.setVariable("create", function(){});

    dialogueScripts.setVariable("add", function(obj:FlxBasic) {add(obj);});
    dialogueScripts.setVariable("state", this);
    dialogueScripts.setVariable("PlayState", this);
    dialogueScripts.setVariable("dialogueImage", dialogueImage);
    dialogueScripts.setVariable("curDialogue", curDialogue);
    dialogueScripts.setVariable("swagDialogue", swagDialogue);
    dialogueScripts.setVariable("dad", dad);
    dialogueScripts.setVariable("boyfriend", boyfriend);
    
    for (s in dialogueScripts.scripts) s.setScriptObject(this);
    dialogueScripts.loadFiles();
}
function updateScriptsRemoved() {
    if (dialogue.defaultStuff.scripts == null) {
        noneHere = new FlxText(0,50,newWindow.width,"You Have No Scripts", 25);
        noneHere.alignment = "center";
        uhTab.add(noneHere);
        noneHere.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1.5);
        return;
    }
    var index:Int = 0; // because
    for (i in 0...dialogue.defaultStuff.scripts.length) {
        var e = dialogue.defaultStuff.scripts[i];
        var scriptText:FlxText = new FlxText(0,10,0, e.path.split("/")[e.path.split("/").length-1] + ".hx", 16);
        scriptText.x = (10*i)*10 + 10;
        uhTab.add(scriptText);
        var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image("fileIcons"), true, 16, 16);
        icon.animation.add("icon", [3], 0, false);
        icon.animation.play("icon");
        icon.scale.set(3,3);
        icon.updateHitbox();
        uhTab.add(icon);
        icon.x = scriptText.x + scriptText.width/2 - icon.width/2;
        icon.y = scriptText.y + icon.height - 20;
        var removeButton = new FlxUIButton(0,0, "Remove Script", function() {
            trace(i);
            trace(dialogue.defaultStuff.scripts[i]);
            if (dialogue.defaultStuff.scripts.length == 1)  {
                dialogue.defaultStuff.scripts = null;
                trace(dialogue.defaultStuff.scripts);
                removeWindow();
                updateScripts();
                return;
            }
            dialogue.defaultStuff.scripts[i] = dialogue.defaultStuff.scripts.splice(0, dialogue.defaultStuff.scripts[i]);
            trace("splice: " + dialogue.defaultStuff.scripts);
            for (f in i...dialogue.defaultStuff.scripts.length) dialogue.defaultStuff.scripts[f] = dialogue.defaultStuff.scripts[f+1];
            dialogue.defaultStuff.scripts.resize(dialogue.defaultStuff.scripts.length-1);
            trace(dialogue.defaultStuff.scripts);
            updateScripts();
            removeWindow();
            addNewWindow("removeScript", "Remove Script(s)", 300, null, function() {
            });
            updateScriptsRemoved();
        });
        uhTab.add(removeButton);
        removeButton.x = scriptText.x + scriptText.width/2 - removeButton.width/2;
        removeButton.y = scriptText.y + icon.height + removeButton.height + 10;
        index++;
    }
    index = 0;
}

var uhTab:FlxUI;
var canMoveText:Bool = false;
var canMoveTextDefault:Bool = false;
var canMoveBox:Bool = false;
var canMoveBoxDefault:Bool = false;
function addNewWindow(name:String, title:String, height:Int, enterText:String, ?callback:Void->Void) {
    dialogueEditorTab.active = false;
    windowBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x88000000);
    add(windowBG);
    newWindow = new FlxUITabMenu(null, null, [
        {
            name: name,
            label: title,
        }
    ], null, true);
    uhTab = new FlxUI(null, newWindow);
    uhTab.name = name;

    var bottomButton = new FlxUIButton(250, height, enterText, function() {
        removeWindow();
        if (callback != null) callback();
    });
    bottomButton.x -= bottomButton.width / 2;

    newWindow.resize(500, bottomButton.y + bottomButton.height + 25);
    newWindow.screenCenter();
    newWindow.addGroup(uhTab);
    trace(enterText != null);
    if (enterText != null) uhTab.add(bottomButton);
    add(newWindow);
    
    var closeButton = new FlxUIButton(newWindow.width - 24, -15, "X", function() {
        removeWindow();
    });
    closeButton.color = 0xFFFF4444;
    closeButton.label.color = 0xFFFFFFFF;
    closeButton.resize(20, 20);
    
    uhTab.add(closeButton);
}
function removeWindow() {
    newWindow.destroy();
    windowBG.destroy();
    uhTab.destroy();
    dialogueEditorTab.active = true;
}

function beatHit(curBeat) {
    boyfriend.playAnim("idle");
}

function update(elapsed:Float) {
    dialogueScripts.executeFunc("update");
    if (FlxG.sound.music.playing && FlxG.sound.music.playing != null) {
        Conductor.songPosition = FlxG.sound.music.time;
    }
    if ((FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT) && (!inputText.hasFocus && !canMoveText && !canMoveTextDefault && !boxAnim.hasFocus))
        nextDialogue(1);
    if ((FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT) && (!inputText.hasFocus && !canMoveText && !canMoveTextDefault && !boxAnim.hasFocus))
        nextDialogue(-1);
    if ((FlxG.keys.justPressed.ESCAPE) && !inputText.hasFocus)
        FlxG.switchState(new MainMenuState());

    if (canMoveText || canMoveTextDefault) {
        swagDialogue.x = FlxG.mouse.x;
        swagDialogue.y = FlxG.mouse.y;
        if (canMoveText) dialogue.dialogueStart[curDialogue].textXY = [swagDialogue.x, swagDialogue.y];
        if (canMoveTextDefault) dialogue.defaultStuff.textXY = [swagDialogue.x, swagDialogue.y];
        if (FlxG.mouse.pressed) {
            FlxTween.tween(dialogueEditorTab, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            canMoveText = false;
            canMoveTextDefault = false;
            dialogueEditorTab.active = true;
            nextDialogue(0);
        }
    }
    if (canMoveBox || canMoveBoxDefault) {
        dialogueImage.x = FlxG.mouse.x - dialogueImage.width / 2;
        dialogueImage.y = FlxG.mouse.y - dialogueImage.height / 2;
        if (canMoveBox) dialogue.dialogueStart[curDialogue].boxXY = [dialogueImage.x, dialogueImage.y];
        if (canMoveBoxDefault) dialogue.defaultStuff.boxXY = [dialogueImage.x, dialogueImage.y];
        if (FlxG.mouse.pressed) {
            FlxTween.tween(dialogueEditorTab, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            canMoveBox = false;
            canMoveBoxDefault = false;
            dialogueEditorTab.active = true;
            nextDialogue(0);
        }
    }

	updateButtons(elapsed);
    dialogueScripts.executeFunc("updatePost");
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
var audioBefore = [];
function nextDialogue(hur:Int = 0)  {
    curDialogue += hur;
    if (curDialogue > dialogue.dialogueStart.length-1)
        curDialogue = dialogue.dialogueStart.length-1;
    if (curDialogue < 0)
        curDialogue = 0;
    
    currentDialogueDisplay.text = (curDialogue + 1) + " / " + dialogue.dialogueStart.length;
    
    inputText.text = dialogue.dialogueStart[curDialogue].daText;
    if (dialogue.dialogueStart[curDialogue].overrideDefaults == null) dialogue.dialogueStart[curDialogue].overrideDefaults = false;
    overrideDefault.checked = dialogue.dialogueStart[curDialogue].overrideDefaults;

    changeTextScale.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeBoxScale.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeTextColor.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeTextXY.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    overrideChangeTextXY.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeBoxImage.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    labelTextFont.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    browseButtonTextFont.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeTextFont.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;

    changeTextSFX.text = dialogue.dialogueStart[curDialogue].textSFX;
    defaultTextSFX.text = dialogue.defaultStuff.textSFX;
    playDialogueSFX.text = dialogue.dialogueStart[curDialogue].playSFX;
    defaultTextFont.text = dialogue.defaultStuff.textFont;
    changeTextFont.text = dialogue.dialogueStart[curDialogue].textFont;

    changeTextSFX.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    labelTextSFX.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    playButtonTextSFX.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    playIconTextSFX.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    browseButtonTextSFX.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;

    textScaleLabel.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    boxScaleLabel.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;

    boxAnim.text = dialogue.dialogueStart[curDialogue].boxPlayAnim;
    boxAnim.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    boxAnimLabel.visible = dialogue.dialogueStart[curDialogue].overrideDefaults;
    changeBoxImage.checked = dialogue.dialogueStart[curDialogue].boxImage.changeImage;
    
    if (dialogue.dialogueStart[curDialogue].playSFX != null && dialogue.dialogueStart[curDialogue].playSFX != "")
        FlxG.sound.play(Paths.sound(dialogue.dialogueStart[curDialogue].playSFX));

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
    if (dialogue.defaultStuff.musicStuff.audioPath == "" || dialogue.dialogueStart[curDialogue].musicStuff.audioPath == "") 
        FlxG.sound.music.stop();
    audioBefore[0] = dialogue.defaultStuff.musicStuff.audioPath;
    audioBefore[1] = dialogue.dialogueStart[curDialogue].musicStuff.audioPath;
    
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
        if (dialogue.defaultStuff.openAnim != null && curDialogue == 0) {
            dialogueImage.animation.play(dialogue.defaultStuff.openAnim, true);
            dialogueImage.animation.finishCallback = function() {
                dialogueImage.animation.finishCallback = function() { }
                if (dialogue.defaultStuff.loopAnim != null) 
                    dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true); } }
        if (dialogue.defaultStuff.openAnim == null)
            dialogueImage.animation.play(dialogue.defaultStuff.loopAnim, true);
    }
    if (curDialogue != 0 && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
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
    changeBoxScale.value = dialogue.dialogueStart[curDialogue].boxScale;
    defaultBoxScale.value = dialogue.defaultStuff.boxScale;
    
    if (dialogue.defaultStuff.boxXY != null && !dialogue.dialogueStart[curDialogue].overrideDefaults) {
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
    defaultTextScale.value = dialogue.defaultStuff.textSize;
    changeTextScale.value = dialogue.dialogueStart[curDialogue].textSize;

    trace(swagDialogue.width);
    swagDialogue.width = dialogueImage.width - 25;
    trace(swagDialogue.width);

    if (dialogue.defaultStuff.textSpeed != null && dialogue.dialogueStart[curDialogue].textSpeed == null)
        swagDialogue.start(dialogue.defaultStuff.textSpeed, true);
    else if (dialogue.dialogueStart[curDialogue].textSpeed != null)
        swagDialogue.start(dialogue.dialogueStart[curDialogue].textSpeed, true);
    else 
        swagDialogue.start(0.04, true);
    
    dialogueScripts.executeFunc("nextDialogue");
}

function changeDialogueImage(path:String, ?pathDIR:String, names:Array<String>, looping:Array<Bool>) { // changes the Dialgoue Box image, causes a sec of lag tho
    dialogueScripts.executeFunc("dialogueChangedImages");
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
    dialogueScripts.executeFunc("dialogueChangedImagesPost");
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
    switch(type.toLowerCase()) {
        case "open":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Open Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                var FUCK = t;
                addNewWindow("test", "Unfinished work", 200, "Nah Im Good, DO NOT SAVE", function() {
                    dialogue = Json.parse(File.getContent(FUCK));
                    nextDialogue(0);
                });
                killMePlease = new FlxText(0,50,newWindow.width,"Before you open this Dialogue, would you like to save your current one or discard it?", 25);
                killMePlease.alignment = "center";
                uhTab.add(killMePlease);
                killMePlease.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1.5);
            });
        case "save":
            CoolUtil.openDialogue(FileDialogType.OPEN, "Save Your Dialogue.json", function(t) {
                if (Path.extension(t).toLowerCase() != "json") {
                    trace("You Need To Grab A json File");
                    return;
                }
                File.saveContent(t, Json.stringify(dialogue, null, "\t"));
            });
    }
}