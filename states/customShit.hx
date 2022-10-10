// yes

import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedGroup;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import openfl.filters.ShaderFilter;
import ModSupport;

var template = [
    {
        moreImages: false,
        path: "test",
        title: "Shit",
        desc: "explain",
        type: "xml",
        prefixes: ["yourShit", "another Shit"],
        xmlNames: ["xml1", "xml2"],
        fps: 24,
        loop: true,
        centerSpr: true,
        x: 0,
        y: 0,
        moreShit: true
    },
    {
        moreImages: false,
        path: "test",
        title: "Shit",
        desc: "explain",
        type: "xml",
        prefixes: ["yourShit", "another Shit"],
        xmlNames: ["xml1", "xml2"],
        fps: 24,
        loop: true,
        centerSpr: true,
        x: 0,
        y: 0,
        moreShit: true
    }
];
var file = "mods/" + mod + "/customThingy.json";
var settingsList:Dynamic;
var imagesArray:Array<FlxSprite> = [];
var availableAnims:Array<String> = [];
function create() {
	if (!FileSystem.exists(file))
		File.saveContent(file, Json.stringify(template, null, "\t"));

	settingsList = Json.parse(File.getContent(file));
    trace(settingsList.length);

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

    for (i in 0...settingsList.length) {
        makeShit(settingsList[i].moreShit, settingsList[i].path, settingsList[i].type, settingsList[i].prefixes, settingsList[i].xmlNames, settingsList[i].fps, settingsList[i].loop, settingsList[i].centerSpr, settingsList[i].x, settingsList[i].y);
    }
    changeSection(0);
}
var curSelected:Int = 0;
var addID:Int = 0;
var imagesArray:Array<FlxSprite> = [];
function makeShit(moreImages:Bool = false, path:String = "", type:String = "xml", ?prefixNames:Array<String> = "", ?xmlNames:Array<String> = "", ?fps:Int = 24, ?looping:Bool = false,
    center:Bool = true, xPos:Int = 0, yPos:Int = 0) {
    var spr:FlxSprite;
    switch(type) {
        case "xml":
            spr = new FlxSprite(xPos,yPos);
            spr.frames = Paths.getSparrowAtlas(path);
            for (i in 0...prefixNames.length)
                spr.animation.addByPrefix(prefixNames[i], xmlNames[i], fps, looping);
            spr.animation.play(prefixNames[0], looping);
            if (center)
                spr.screenCenter();
            spr.updateHitbox();
            spr.ID = addID;
            add(spr);
        default:
            trace("uh oh, currently " + type + " isn't supported, if its null, you fucked up");
    }
    addID++;
    imagesArray.push(spr);
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
        changeSection(-1);
    }

    if (controlsJustNUM([68,39])) {
        CoolUtil.playMenuSFX(0);
        changeSection(1);
    }

    if (controlsJustNUM([13])) {
        changeFunny();
    }
}

function changeSection(hur:Int = 0) {
    curSelected += hur;
    if (curSelected >= imagesArray.length)
        curSelected = 0;
    if (curSelected < 0)
        curSelected = imagesArray.length - 1;

    for (spr in imagesArray) {
        if (spr.ID == curSelected) {
            textTitle.text = settingsList[spr.ID].title;
            textTitle.screenCenter();
            textTitle.y = FlxG.height - textTitle.height - 20;

            textDesc.text = settingsList[spr.ID].desc;
            textDesc.screenCenter();
            textDesc.y = FlxG.height - textTitle.height - textDesc.height - 20;

            spr.alpha = 1;
            switch(spr.ID) {

            }
        }
        else {
            spr.alpha = 0.0001;
        }
    }
}

function changeFunny() {
    
}