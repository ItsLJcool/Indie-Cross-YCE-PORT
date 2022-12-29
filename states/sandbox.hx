import("MainMenuState");

import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIDropDownHeader;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;

import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;

import flixel.FlxCamera;


var camButtons:FlxCamera;
var camStage:FlxCamera;

var BUTTON_TAB:FlxUITabMenu;


//initialization department
function create() {
	camStage = new FlxCamera();
	camButtons = new FlxCamera();
	FlxG.cameras.reset(camStage);
	FlxG.cameras.add(camButtons);
	FlxCamera.defaultCameras = [camStage];
	camButtons.bgColor = 0;
	persistentUpdate = true;
	persistentDraw = true;
	createStage();
	createButtons();
	createSmooth();
}
function update(elapsed) {
	updateSmooth(elapsed);
	updateShake(elapsed);
	updateButtons(elapsed);
	updateStage(elapsed);
}






//stage department
var boyfriend:Boyfriend;
var gf:Character;
var dad:Character;
function createStage() {
	FlxG.camera.zoom = 0.8;
    var bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('default_stage/stageback'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.9, 0.9);
    bg.active = false;
    add(bg);

    var stageFront = new FlxSprite(-690, 600).loadGraphic(Paths.image('default_stage/stagefront'));
    stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
    stageFront.updateHitbox();
    stageFront.antialiasing = true;
    stageFront.scrollFactor.set(1, 1);
    stageFront.active = false;
    add(stageFront);

    var stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('default_stage/stagecurtains'));
    stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
    stageCurtains.updateHitbox();
    stageCurtains.antialiasing = true;
    stageCurtains.scrollFactor.set(1.4, 0.9);
    stageCurtains.active = false;
    add(stageCurtains);

	boyfriend = new Boyfriend(770, 100, "bf");
	gf = new Character(400, 130, "gf");
	dad = new Character(100, 100, "dad");
    gf.scrollFactor.set(1.125, 1.05);
    boyfriend.scrollFactor.set(1.15, 1.1);
    dad.scrollFactor.set(1.15, 1.1);
	add(gf);
	add(boyfriend);
	add(dad);
	var dancer:Bool = false;
	boyfriend.animation.finishCallback = function() {boyfriend.playAnim("idle");};
	gf.animation.finishCallback = function() {if (dancer) gf.playAnim("danceLeft"); else gf.playAnim("danceRight");dancer = !dancer;};
	dad.animation.finishCallback = function() {dad.playAnim("idle");};

}
function updateStage(elapsed) {
	if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)boyfriend.playAnim("singUP");
	if (FlxG.keys.pressed.A || FlxG.keys.pressed.DOWN)boyfriend.playAnim("singDOWN");
	if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)boyfriend.playAnim("singLEFT");
	if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)boyfriend.playAnim("singRIGHT");
}






//smooth camera department
var accelSprite:FlxSprite = new FlxSprite(400, 130);
var disableCamMovement:Bool = true;
var speedIthink = 0.8;
var driftAmount = 50;
function createSmooth() {
	add(accelSprite);
	FlxG.camera.follow(accelSprite);
}
var mousePos;
function updateSmooth(elapsed) {
	FlxG.camera.followLerp = 0.05;
	var realSpeed = FlxG.camera.followLerp;
	if (disableCamMovement) mousePos = FlxG.mouse.getScreenPosition();
	var offset:FlxPoint = new FlxPoint();
	if (boyfriend.animation.curAnim.name == "singUP")
		offset.y -= driftAmount;
	if (boyfriend.animation.curAnim.name == "singDOWN")
		offset.y += driftAmount;
	if (boyfriend.animation.curAnim.name == "singLEFT")
		offset.x -= driftAmount;
	if (boyfriend.animation.curAnim.name == "singRIGHT")
		offset.x += driftAmount;
	accelSprite.acceleration.set((((mousePos.x + offset.x) - accelSprite.x) - (accelSprite.velocity.x * speedIthink)) / realSpeed, (((mousePos.y + offset.y) - accelSprite.y) - (accelSprite.velocity.y * speedIthink)) / realSpeed);
	if (FlxG.keys.justPressed.ESCAPE) {
		FlxG.switchState(new MainMenuState());
	}
	if (FlxG.keys.justPressed.SPACE) disableCamMovement = !disableCamMovement;
}





//shake department
var fadeStart:Float = 0;
var fadeTimer:Float = 0;
var time:Float = 0;
var coords:String;
var shakeMagnitude:Float = 0;
var amplitude:Float = 0;
var frequency:Float = 0;
var startFading:Bool = false;
var randomX:Float = 0;
var randomY:Float = 0;
function shake(magnitude:Float = 1.5, amp:Float = 1, freq:Float = 0.3, fade:Float = 1, timer:Float = 0.1, coord:String = 'xy', startFadeDelay:Float = 0.0001) {
	amplitude = amp;
	frequency = freq;
	shakeMagnitude = magnitude;
	fadeStart = fade;
	fadeTimer = timer;
	coords = coord;
	startFading = false;
	randomX = new FlxRandom().float(15, 30);
	randomY = new FlxRandom().float(12, 38);
	new FlxTimer().start(startFadeDelay, function(tmr:FlxTimer) {startFading = true;});
}
function updateShake(elapsed) {
	time += elapsed;
	if (coords == 'x' || coords == 'xy') {
		var sine = Math.sin((amplitude * randomX) * time) * shakeMagnitude;
		var shake = new FlxRandom().float(0, 20) * frequency;
		camStage.scroll.x += (shake * sine) * fadeStart;
	}
	if (coords == 'y' || coords == 'xy') {
		var sine = Math.sin((amplitude * randomY) * time) * shakeMagnitude;
		var shake = new FlxRandom().float(0, 15) * frequency;
		camStage.scroll.y += (shake * sine) * fadeStart;
	}
	if (startFading) fadeStart = FlxMath.lerp(fadeStart, 0, fadeTimer);
}






// buttons department
var varz = [
	"magnitude" => 1.5,
	"freq" => 0.4,
	"amp" => 1,
	"fade" => 1,
	"timer" => 0.1,
	"fade delay" => 0.0001,
	"coord" => 'xy'
];
var followLerp;
var zoom;
var smoothSpeed;
var smoothAcceleration;
var driftAmountthing;
function createButtons() {
	var coordinates:String = "xy";

	//shake params
	var text = new FlxText(0, 70, 0, "Shake Parametters:", 20);
	text.cameras = [camButtons];
	add(text);
	var shakeParamArray = ["magnitude","freq","amp","fade","timer","fade delay","coord"];
	for (i in 0...shakeParamArray.length)
	{
		if (varz[shakeParamArray[i]] == 'xy') {
			var coords:Array<StrNameLabel> = [new StrNameLabel("xy","xy"),new StrNameLabel("y","y"),new StrNameLabel("x","x")];
			thingy = new FlxUIDropDownMenu(5, 100 + (25 * i), coords, function(name:String) {coordinates = name;trace(coordinates);}, new FlxUIDropDownHeader(58));
			thingy.cameras = [camButtons];
		}
		else {
			thingy = new FlxUINumericStepper(5, 100 + (25 * i), 0.1, varz[shakeParamArray[i]], -999, 999, 5);
			thingy.name = shakeParamArray[i];
			thingy.text_field.cameras = [camButtons];
			thingy.cameras = [camButtons];
		}
		varz[shakeParamArray[i]] = thingy;
		add(thingy);
		var label = new FlxText(65, 95 + (25 * i), 0, shakeParamArray[i], 16);
		label.cameras = [camButtons];
		add(label);
	}
	var button = new FlxUIButton(5,320, "start fading shake", function() {
		shake(varz["magnitude"].value, varz["amp"].value, varz["freq"].value, varz["fade"].value, varz["timer"].value, coordinates, varz["fade delay"].value);
	});
	button.cameras = [camButtons];
	add(button);
	var button2 = new FlxUIButton(5,345, "start infinite shake", function() {
		shake(varz["magnitude"].value, varz["amp"].value, varz["freq"].value, varz["fade"].value, varz["timer"].value, coordinates, 9999999999999);
	});
	button2.cameras = [camButtons];
	add(button2);
	var button3 = new FlxUIButton(5,370, "stop infinite shake", function() {
		shake(varz["magnitude"].value, varz["amp"].value, varz["freq"].value, varz["fade"].value, 1, coordinates, 0);
	});
	button3.cameras = [camButtons];
	add(button3);


	//camera properties
	var text = new FlxText(0, 420, 0, "Camera Properties:", 20);
	text.cameras = [camButtons];
	add(text);

	followLerp = new FlxUINumericStepper(5, 450, 0.01, 0.05, -999, 999, 5);
	followLerp.cameras = [camButtons];
	var followLerpText = new FlxText(65, 445, 0, "follow speed (follow lerp)", 16);
	followLerpText.cameras = [camButtons];
	add(followLerpText);
	zoom = new FlxUINumericStepper(5, 475, 0.1, 0.8, -999, 999, 5);
	zoom.cameras = [camButtons];
	var zoomText = new FlxText(65, 470, 0, "zoom", 16);
	zoomText.cameras = [camButtons];
	add(zoomText);
	smoothAcceleration = new FlxUINumericStepper(5, 500, 0.1, 0.8, -999, 999, 5);
	smoothAcceleration.cameras = [camButtons];
	var smoothAccelerationText = new FlxText(65, 495, 0, "camera acceleration (the lower the faster)", 16);
	smoothAccelerationText.cameras = [camButtons];
	driftAmountthing = new FlxUINumericStepper(5, 525, 1, 50, -999, 999, 5);
	driftAmountthing.cameras = [camButtons];
	var driftAmountText = new FlxText(65, 520, 0, "drift amount (cam note press)", 16);
	driftAmountText.cameras = [camButtons];
	add(driftAmountthing);
	add(driftAmountText);
	add(smoothAccelerationText);
	add(followLerp);
	add(zoom);
	add(smoothAcceleration);


	var space = new FlxText(5, 665, 0, "MOVE THE MOUSE to move camera. \n\nPress SPACE to freeze camera.\nPress ARROW KEYS or WASD to move cameras on note press\nPress ESCAPE to return to main menu");
	space.cameras = [camButtons];
	add(space);

}
function updateButtons(elapsed) {
	FlxG.camera.followLerp = followLerp.value;
	FlxG.camera.zoom = zoom.value;
	speedIthink = smoothAcceleration.value;
	driftAmount = driftAmountthing.value;
}

