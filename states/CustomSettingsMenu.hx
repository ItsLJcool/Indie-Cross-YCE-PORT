//a
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxTypedGroup;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import openfl.filters.ShaderFilter;

var title:FlxText;
var subtitle:FlxText;
var txt:AlphabetOptimized;
var curSelected:Int = 0;
var grp:FlxTypedGroup<AlphabetOptimized>;
var file = "mods/" + mod + "/mod_settings.json";
var cfg:Dynamic;

var settings = [
	[
		"Unworthy",
		"hitBlueNotes",
		"Hit 50 Blue Bone Notes (Bone Notes Hit: " + hitBlueNotes + ")"
	]
];

var template = {
	hitBlueNotes: false

};

var rect:FlxSprite;

function create() {
	if (FileSystem.exists(file) == false)
		File.saveContent(file, Json.stringify(template));

	cfg = Json.parse(File.getContent("mods/" + mod + "/mod_settings.json"));

	rect = new FlxSprite(0, 0);
	rect.scrollFactor.set();
	rect.makeGraphic(FlxG.width, FlxG.height, 0x75FFFFFF);
	rect.scale.x = 2;
	rect.scale.y = 2;
	rect.screenCenter();
	rect.alpha = 1;
	state.add(rect);

	title = new FlxText(0, 0, 0, "Mod-Specific Settings", 32);
	title.font = "VCR OSD Mono";
	title.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
	title.updateHitbox();
	title.screenCenter();
	title.y = 15;
	add(title);

	var _e = new FlxText(0, 0, 0, "Press ESC or BACKSPACE to save your settings and go back", 16);
	_e.font = "VCR OSD Mono";
	_e.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
	_e.updateHitbox();
	_e.x = 11;
	_e.y = FlxG.height - _e.height - 11;
	add(_e);

	subtitle = new FlxText(0, 0, 0, "DESCRIPTION", 26);
	subtitle.font = "VCR OSD Mono";
	subtitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
	subtitle.updateHitbox();
	subtitle.screenCenter();
	subtitle.y = title.y + title.height + 5;
	add(subtitle);

	grp = new FlxTypedGroup();
	add(grp);

	for (i in 0...settings.length) {
		txt = new AlphabetOptimized(0, 0, 0, "", 16);
		txt.targetY = i;
		txt.y = 75 + (i * (txt.height + 10));
		txt.x = 100;
		txt.textSize = Math.min(1, (FlxG.width - 256) / (51 * txt.text.length));
		txt.text = settings[i][0];
		grp.add(txt);
	}

	selection(0);
}

function update(elapsed) {
	var controls = FlxControls.justPressed;

	if (controls.ESCAPE || controls.BACKSPACE) {
		saveSettings();
		FlxG.switchState(new MainMenuState());
	}
	if (controls.UP)
		selection(-1);
	if (controls.DOWN)
		selection(1);
	if (controls.ENTER || controls.SPACE) {
		var _a = settings[curSelected][1];
		switch (_a) {
			case "hitBlueNotes":
				cfg.disableMechanics = !cfg.disableMechanics;
				if (cfg.disableMechanics == true) {
					grp.members[0].textColor = 0xFF00FF00;
				} else {
					grp.members[0].textColor = 0xFFFF0000;
				}
				trace(cfg.disableMechanics);
		}
	}
}

function saveSettings() {
	File.saveContent(file, Json.stringify(cfg));
}

function selection(?change:Int = 0) {
	// FlxG.sound.play(Paths.sound("menuScroll"), 0.4);

	curSelected += change;

	if (curSelected < 0)
		curSelected = settings.length - 1;
	if (curSelected >= settings.length)
		curSelected = 0;

	var br:Int = 0;

	subtitle.text = settings[curSelected][2];
	subtitle.screenCenter();
	subtitle.y = title.y + title.height + 5;

	for (i in grp.members) {
		i.targetY = br - curSelected;
		br++;

		i.alpha = 0.5;
		if (i.targetY == 0)
			i.alpha = 1;
	}

	if (change == 0)
		if (cfg.disableMechanics == true) {
			grp.members[0].textColor = 0xFF00FF00;
		} else {
			grp.members[0].textColor = 0xFFFF0000;
		}
}
