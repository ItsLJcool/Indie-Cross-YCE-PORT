// FUCK MAKING THIS FOR A 4th TIME, MY ENTIRE DRIVE GOT CORRUPTED AAAAAAaa
import("openfl.filters.ShaderFilter");
var curShooting = false;
var curAttacking = false;

// Mechanic Buttons
var attackButton:FlxSprite;
var dodgeButton:FlxSprite;
var cardShit:FlxSprite;

// Mechanics themselfs
var nmBullets:FlxSprite;
var nmAttack:FlxSprite;
var canAttack = false;

var shader = null;
var time = 0;
var res = [1280, 720];

function create() {
	attackButton = new FlxSprite(-30, 200);
	attackButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
	attackButton.animation.addByPrefix('attackNormal', 'Attack instance 1', 24, false);
	attackButton.animation.addByPrefix('attackClicked', 'Attack Click instance 1', 24, false);
	attackButton.animation.addByPrefix('attackCooldown', 'AttackNA instance 1', 24, false);
	attackButton.animation.play('attackNormal');
	attackButton.antialiasing = EngineSettings.antialiasing;
	attackButton.scale.set(.5, .5);
	attackButton.cameras = [PlayState.camHUD];
	PlayState.add(attackButton);

	dodgeButton = new FlxSprite(-30, 300);
	dodgeButton.frames = Paths.getSparrowAtlas('cuphead/Notmobilegameanymore');
	dodgeButton.animation.addByPrefix('dodgeNormal', 'Dodge instance 1', 24, false);
	dodgeButton.animation.addByPrefix('dodgeClicked', 'Dodge click instance 1', 24, false);
	dodgeButton.animation.play('dodgeNormal');
	dodgeButton.antialiasing = EngineSettings.antialiasing;
	dodgeButton.scale.set(.5, .5);
	dodgeButton.cameras = [PlayState.camHUD];
	PlayState.add(dodgeButton);

	cardShit = new FlxSprite(1100, 550);
	cardShit.frames = Paths.getSparrowAtlas('cuphead/cardShit/Cardcrap');
	cardShit.animation.addByPrefix('cardFilled', 'Card Filled instance 1', 24, false);
	cardShit.animation.addByPrefix('cardPopOut', 'Card Normal Pop out instance 1', 24, false);
	cardShit.animation.addByPrefix('cardUsed', 'Card Used instance 1', 24, false);
	cardShit.animation.addByPrefix('cardFlipping', 'Card but flipped instance 1', 24, false);
	cardShit.animation.addByPrefix('cardPopOutPARRY', 'PARRY Card Pop out  instance 1', 24, false);
	cardShit.animation.play('cardFilled');
	cardShit.antialiasing = EngineSettings.antialiasing;
	// cardShit.scale.set(.5, .5);
	// cardShit.screenCenter();
	cardShit.cameras = [PlayState.camHUD];
	cardShit.visible = false;
	PlayState.add(cardShit);

}


function beatHit(curBeat:Int) {
	// Blasting
	if (curBeat == 10 || curBeat == 52 || curBeat == 112 || curBeat == 200 || curBeat == 308) {
		curShooting = true;
		FlxG.log.add("Cuphead: Shooting");
	}
	if (curBeat == 48 || curBeat == 96 || curBeat == 144 || curBeat == 192 || curBeat == 240 || curBeat == 288 || curBeat == 336) {
		curAttacking = true;
		FlxG.log.add("Cuphead: Attacking");
		PlayState.dad.playAnim('attack');
		nmAttack = new FlxSprite(-350, 450);
		nmAttack.frames = Paths.getSparrowAtlas('cuphead/NMcupheadAttacks');
		nmAttack.animation.addByPrefix('deathBlast', 'DeathBlast instance 1', 24, true);
		// nmAttack.animation.addByPrefix('sawLmao', 'DeathRoundabout instance 1', 24, true); //unused in Indie Cross, so here it is if ya want it
		nmAttack.animation.play('deathBlast');
		nmAttack.antialiasing = true;
		nmAttack.scale.set(.9, .9);
		PlayState.add(nmAttack);
		FlxG.sound.play(Paths.sound('cuphead/pre_shoot'));
		FlxTween.tween(nmAttack, {x: 3000, y: 400}, 3, {ease: FlxG.linear, type: 8});
	}
}

function stepHit(curStep:Int) {
	if (curShooting && PlayState.dad.animation.curAnim.name == 'shoot' && PlayState.dad.animation.curAnim.name != null) {
		var rngNMbullets = FlxG.random.int(1, 5);
		var nmBulletsSFX = FlxG.random.int(0, 5);
		nmBullets = new FlxSprite(420, 520);
		nmBullets.frames = Paths.getSparrowAtlas('cuphead/NMcupheadBull');
		nmBullets.animation.addByPrefix('nmBulletRNG1', 'Shot01 instance 1', 24, false);
		nmBullets.animation.addByPrefix('nmBulletRNG2', 'Shot02 instance 1', 24, false);
		nmBullets.animation.addByPrefix('nmBulletRNG3', 'Shot03 instance 1', 24, false);
		nmBullets.animation.addByPrefix('nmBulletRNG4', 'Shot04 instance 1', 24, false);
		nmBullets.animation.addByPrefix('nmBulletRNG5', 'Shot05 instance 1', 24, false);
		nmBullets.animation.play('nmBulletRNG' + rngNMbullets);
		nmBullets.antialiasing = true;
		nmBullets.scale.set(1.5, 1.5);
		PlayState.add(nmBullets);
		PlayState.health -= .05;
		// if animations are finished, just remove them lmao
		nmBullets.animation.finishCallback = function(animName:String) {
			PlayState.remove(nmBullets);
		}
		// FlxG.log.add('Cuphead: Shooting BF');
		FlxG.sound.play(Paths.sound('cuphead/attacks/pea' + nmBulletsSFX));
	}
}

function update(elapsed:Float) {
    //shader
    res = [FlxG.width * 4, FlxG.height * 4];
    //no more shader
	if (curShooting && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
		PlayState.dad.playAnim('shoot');
	}
    // EyeDaleHim suggested
    FlxG.camera.active = !PlayState.paused;

	// add fucking mechanics here
	if (FlxG.keys.justPressed.SHIFT && canAttack && curShooting || canAttack && curShooting && EngineSettings.botplay) {
		curShooting = false;
        canAttack = false;
		cardShit.animation.play('cardPopOut');
		FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
            cardShit.visible = false;
        }});
        cardShit.animation.finishCallback = function(animName:String) {
        }
		PlayState.dad.playAnim('dodge');
		PlayState.boyfriend.playAnim('attack');
		FlxG.sound.play(Paths.sound('cuphead/hurt'));
		FlxG.log.add('Cuphead: Dodge');
		FlxG.log.add('BF: Attack');
		// yo button shit
		attackButton.animation.play('attackClicked');
		attackButton.animation.finishCallback = function(animName:String) {
			attackButton.animation.play('attackCooldown');
			attackButton.animation.finishCallback = function(animName:String) {
				attackButton.animation.play('attackNormal');
			}
		}
	}
} // end of Attacking

if (canAttack && FlxG.keys.justPressed.SHIFT) {
	canAttack = false;
	PlayState.dad.playAnim('hurt');
	PlayState.boyfriend.playAnim('attack');
	FlxG.sound.play(Paths.sound('cuphead/hurt'));
}

if (FlxG.keys.justPressed.SPACE && curAttacking || curAttacking && EngineSettings.botplay) {
	if (EngineSettings.botplay) {
		new FlxTimer().start(.5, function(tmr:FlxTimer) {
			if (curAttacking) {
				curAttacking = false;
				PlayState.boyfriend.playAnim('dodge');
				FlxG.log.add('BF: Dodge');
			}
		});

	} else {
		curAttacking = false;
		PlayState.boyfriend.playAnim('dodge');
		FlxG.log.add('BF: Dodge');
	}
	// yo button shit
	dodgeButton.animation.play('dodgeClicked');
	dodgeButton.animation.finishCallback = function(animName:String) {
		dodgeButton.animation.play('dodgeNormal');
	}
} // end of dodge Mechanic
if (curAttacking) {
	new FlxTimer().start(.85, function(tmr:FlxTimer) {
		if (curAttacking) {
			curAttacking = false;
			PlayState.health = -1;
			FlxG.log.add('Haha you died lmao');
		}
	});

    if (!canAttack && curShooting) {
		cardShit.animation.play('cardPopOut');
		FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
            cardShit.visible = false;
        }});
    }

} 

function onDadHit() {
	FlxG.camera.shake(.015, .2);
}

function onPlayerHit(note:Note) {
	if (note.noteType == 1) {
        cardShit.y = 550;
		cardShit.visible = true;
        if (!canAttack) {
		    cardShit.animation.play('cardPopOutPARRY');
            canAttack = true; }
	}
}

function setCamShader(shader, camera) {
    shader = new CustomShader(mod + ":" + shader);
    camera.setFilters([new ShaderFilter(shader)]);
    camera.filtersEnabled = true;
}