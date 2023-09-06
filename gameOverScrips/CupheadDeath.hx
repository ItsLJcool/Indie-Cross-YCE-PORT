//a
import flixel.text.FlxText;
import flixel.input.gamepad.FlxGamepad;
import lime.app.Application;
import openfl.system.System;
import flixel.FlxCameraFollowStyle;

var bgImage:FlxSprite;
var bfRunning:FlxSprite;

var optionShit:Array<String> = ['retry', 'menu'];

var menuItems:FlxTypedGroup<FlxSprite>;
var menuArray:Array<FlxSprite> = [];

var curSelected:Int = 0;

var percentDone:Float = 0;

var goalPos:Array<Float> = [];

var runPos:Array<Dynamic> = [[0, 145], [370, 75]];
var quip:String = '';

var deadMusic:FlxSound;
var songPosSave:Dynamic = save.data.songPosition;
var songSpeed:Float = 1;

function update(elapsed:Float) {
    deadMusic.pitch = songSpeed;
}

function create() {
    character.visible = false;
    FlxG.camera.target = null;
    FlxG.camera.follow(2000, -100, FlxCameraFollowStyle.LOCKON, 0.01);
    trace('curtime is: ' + songPosSave + ' totaltime is: ' + FlxG.sound.music.length);

    FlxG.sound.music.stop();
    deadMusic = new FlxSound().loadEmbedded(Paths.modInst(PlayState.SONG.song, mod), true, true);
    deadMusic.fadeOut(2, 0.4);
    deadMusic.play(false, songPosSave);
    deadMusic.ID = 9000;
    FlxG.sound.list.add(deadMusic);

    // FlxTween.tween(this, {songSpeed: 0.5}, 2);
    FlxTween.num(songSpeed, songSpeed - 0.5, 2, {ease: FlxEase.linear}, function(v:Float) {
        songSpeed = v;
    });

    FlxG.mouse.visible = true;
    
    percentDone = (songPosSave / FlxG.sound.music.length) * 1.07;
    
	dialogue = ["You had your run, but now you're done!"]; // will add support for other cuphead weeks later
    rando = FlxG.random.int(0, dialogue.length - 1); // dialogue.length can return a 3 so thats why its null sometimes
    quip = dialogue[rando];
    trace(quip);

    // brightfyre made me use the pithagorean theorem to do an fnf mod let that sink in
    // sperez misspelled pythagorean theorem let that sink in
    // brightfyre misdpelled srperez wrong let that sink in
    // polybiusproxy misspelled misspelled let that sink in
    // brightfyre stealed my code without me and tweeted it bragging let that sink in
    // also brightfyre missed the word "wrong" let that sink in
    // brightfyre didnt replyed so i won the argument heeheh
    // let that sink in

    // hey guys, uh LJ here, dont mind me just borrowing your code :troll:

    var goalAngle:Float = 10 * (Math.PI / 180);
    var mathStuff:Array<Float> = [runPos[1][0] - runPos[0][0], runPos[1][1] - runPos[0][1]];
    var goalDis:Float = Math.sqrt(Math.pow(mathStuff[0], 2) + Math.pow(mathStuff[1], 2));

    goalPos = [
        runPos[0][0] + (Math.cos(goalAngle) * goalDis * percentDone),
        runPos[0][1] - (Math.sin(goalAngle) * goalDis * percentDone)
    ];
    for (i in 0...goalPos.length - 1) {
        trace(goalPos[i]);
      if (goalPos[i] <= 0) {
        goalPos[i] = 0;
        trace('bruh work dammit');
      }
      trace(goalPos[i]);
    }
    trace(goalPos);

    if (songPosSave <= 0) songPosSave = 0;
        // if the goalPos is negitive, then set it to 0, since uh bf goes nuts lol

    FlxG.sound.play(Paths.sound('cuphead/death'));

    PlayState.boyfriend.alpha = 0;
    var bfGhost:FlxSprite = new FlxSprite(PlayState.boyfriend.x, PlayState.boyfriend.y);
    bfGhost.frames = Paths.getSparrowAtlas('cuphead/BF_Ghost');
    bfGhost.animation.addByPrefix('ded lol', 'thrtr instance 1', 24, true);
    bfGhost.animation.play('ded lol', true);
    add(bfGhost);
    FlxTween.tween(bfGhost, {y: PlayState.boyfriend.y - 1500}, 4.25);

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    bg.setGraphicSize(Std.int(bg.width * 3));
    bg.updateHitbox();
    bg.screenCenter();
    bg.alpha = 0.6;
    bg.scrollFactor.set();
    add(bg);

    var death:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cuphead/death'));
    death.updateHitbox();
    death.screenCenter();
    death.scrollFactor.set();
    death.antialiasing = FlxG.save.data.highquality;
    // death.cameras = [PlayState.instance.camHUD];
    add(death);

    bgImage = new FlxSprite().loadGraphic(Paths.image('cuphead/cuphead_death'));
    bgImage.loadGraphic(Paths.image('cuphead/cuphead_death2'));
    // bgImage.loadGraphic(Paths.image('devil_death', 'cup')); // will do when i actually add devil stage lol
    bgImage.setGraphicSize(Std.int(bgImage.width * 1.2));
    bgImage.updateHitbox();
    bgImage.screenCenter();
    bgImage.antialiasing = FlxG.save.data.highquality;
    bgImage.scrollFactor.set();
    bgImage.angle = -55;
    bgImage.alpha = 0;
    // bgImage.cameras = [PlayState.instance.camHUD];
    add(bgImage);

    bfRunning = new FlxSprite();
    bfRunning.frames = Paths.getSparrowAtlas('cuphead/NewCupheadrunAnim');
    bfRunning.animation.addByPrefix('ohlawdherunnin', 'Run_cycle_gif', 24, true);
    bfRunning.animation.play('ohlawdherunnin', true);
    bfRunning.setGraphicSize(Std.int(bfRunning.width * 0.7));
    bfRunning.updateHitbox();
    bfRunning.x = runPos[0][0];
    bfRunning.y = runPos[0][1];
    bfRunning.antialiasing = FlxG.save.data.highquality;
    bfRunning.scrollFactor.set();
    bfRunning.angle = -10;
    bfRunning.alpha = 0;
    // bfRunning.cameras = [PlayState.instance.camHUD];
    add(bfRunning);

    var menuItems:Array<FlxSprite> = []; // LJ FIX THIS AT SCHOOL! // turns out this year they blocked External Drive Input
    // please kill me

    // calculated by holding 5 on the menu, I'm not a maniac
    // (LJ) yes you are
    var itmPos:Array<Dynamic> = [[618, 503], [560, 577]];

    for (i in 0...optionShit.length) {
        var menuItem:FlxSprite = new FlxSprite(0, 0);
        menuItem.frames = Paths.getSparrowAtlas('cuphead/buttons');
        menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
        menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
        menuItem.animation.play('idle', true);
        menuItem.scrollFactor.set();
        menuItem.antialiasing = FlxG.save.data.highquality;
        menuItem.screenCenter();
        menuItem.x = itmPos[i][0];
        menuItem.y = itmPos[i][1];
        menuItem.angle = -10;
        menuItem.alpha = 0;
        menuItem.ID = i;
        menuItems[i] = menuItem;
        add(menuItems[i]);
    }

    text = new FlxText(0, 0, 500, '"' + quip + '"'); // cuphead style
    text.setFormat(Paths.font("memphis"), 20, FlxColor.fromRGB(63, 68, 77), "center"); // brightfyre is dumb when using custom fonts lmao
    text.angle = -10;
    text.updateHitbox();
    text.screenCenter();
    text.y -= 25;
    text.scrollFactor.set();
    text.alpha = 0;
    // text.cameras = [PlayState.instance.camHUD];
    add(text);

    changeItem(3);

    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        FlxTween.tween(death, {alpha: 0}, 0.7);

        new FlxTimer().start(0.7, function(tmr:FlxTimer)
        {
            canAccept = true;
            FlxTween.tween(bgImage, {angle: -10}, 0.7, {ease: FlxEase.cubeOut});
            FlxTween.tween(bgImage, {alpha: 1}, 0.7);

            new FlxTimer().start(0.5, function(tmr:FlxTimer)
            {
                for (i in 0...menuArray.length) {
                    FlxTween.tween(menuArray[i], {alpha: 1}, 0.7, {ease: FlxEase.cubeOut});
                    trace('tween menu Items');
                }

                FlxTween.tween(text, {alpha: 1}, 0.7);

                FlxTween.tween(bfRunning, {alpha: 1}, 0.2);
                // FlxTween.tween(text, {alpha: 1}, 0.2);

                FlxTween.tween(bfRunning, {x: goalPos[0], y: goalPos[1]}, 2, {ease: FlxEase.cubeOut});
            });
        });
    });
}

function changeItem(huh:Int = 0) {
		if (huh != 3) {
			FlxG.sound.play(Paths.sound('cuphead/select'));
		}

		curSelected = huh;

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		for (i in 0...menuArray.length) {
			var spr = menuArray[i];
			spr.animation.play('idle', true);

			if (i == curSelected) {
				spr.animation.play('selected', true);
			}

			spr.updateHitbox();
		}
}
