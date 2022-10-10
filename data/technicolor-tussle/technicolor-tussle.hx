//a
import openfl.filters.ShaderFilter;

var curShootingBullets = false;
var canAttack = false;
var attackButton:FlxSprite;
var cardShit:FlxSprite;

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
    attackButton.alpha = 0.7;
    PlayState.add(attackButton);

    grainShit = new FlxSprite(0,0);
    grainShit.frames = Paths.getSparrowAtlas('cuphead/CUpheqdshid');
    grainShit.animation.addByPrefix('brrrrr', 'Cupheadshit_gif instance 1', 24, true);
    grainShit.animation.play('brrrrr');
    grainShit.antialiasing = EngineSettings.antialiasing;
    grainShit.cameras = [PlayState.camHUD];
    PlayState.add(grainShit);
    PlayState.isWidescreen = false;
}

var shader:CustomShader;
function createPost() {
    shader = new CustomShader(mod + ":chromaticAbliteration");
    shader.shaderData.offset.value = [-0.002]; // 0.001 (real indiecross shit)

    PlayState.camHUD.setFilters([new ShaderFilter(shader)]);
    PlayState.camHUD.filtersEnabled = true;
    
    PlayState.camGame.setFilters([new ShaderFilter(shader)]);
    PlayState.camGame.filtersEnabled = true;
}

function createInFront() {
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


function stepHit(curStep:Int) {
    // bullets
    if (curShootingBullets && PlayState.dad.animation.curAnim.name == 'shoot' && PlayState.dad.animation.curAnim.name != null) {
        var rngBulletAnim = FlxG.random.int(1, 3);
        var rngYvalBull = FlxG.random.int(200, 360);
        var rngBulletSFX = FlxG.random.int(0,5);

        bulletsYessir = new FlxSprite(223, rngYvalBull);
        bulletsYessir.frames = Paths.getSparrowAtlas('cuphead/Cupheadshoot');
        bulletsYessir.animation.addByPrefix('bulletShoot1', 'BulletFX_H-Tween_02 instance 1', 24, false);
        bulletsYessir.animation.addByPrefix('bulletShoot2', 'BulletFX_H-Tween_02 instance 2', 24, false);
        bulletsYessir.animation.addByPrefix('bulletShoot3', 'BulletFX_H-Tween_03 instance 1', 24, false);
        bulletsYessir.animation.play('bulletShoot' + rngBulletAnim);
        bulletsYessir.antialiasing = EngineSettings.antialiasing;
        bulletsYessir.scale.set(1.2, 1.2);
        bulletsYessir.updateHitbox();
        PlayState.add(bulletsYessir);
        bulletsYessir.animation.finishCallback = function(animName:String) { // you done? good now die
            bulletsYessir.destroy();
        }
        /*
        bulletsYessirVFX = new FlxSprite(280, 560);
        bulletsYessirVFX.frames = Paths.getSparrowAtlas('cuphead/Cupheadshoot');
        bulletsYessirVFX.animation.addByPrefix('bulletVFX', 'BulletFlashFX instance 1', 24, false);
        bulletsYessirVFX.animation.play('bulletVFX');
        bulletsYessirVFX.antialiasing = EngineSettings.antialiasing;
        bulletsYessirVFX.updateHitbox();
        PlayState.add(bulletsYessirVFX);
        bulletsYessirVFX.animation.finishCallback = function(animName:String) { // you done? good now die
            bulletsYessirVFX.destroy();
            PlayState.remove(bulletsYessirVFX);
        } */ // broken BRUH

        FlxG.sound.play(Paths.sound('cuphead/attacks/pea' + rngBulletSFX));
        PlayState.health -= .035;
    }

}
function beatHit(curBeat:Int) {
    if (curBeat == 81 || curBeat == 208 || curBeat == 304) {
        curShootingBullets = true;
    }
}

function update(elapsed:Float) {
    if (curShootingBullets && PlayState.dad.animation.curAnim.name == 'idle' && PlayState.dad.animation.curAnim.name != null) {
        PlayState.dad.playAnim('shoot');
    }

    if (canAttack && FlxG.keys.justPressed.SHIFT) {
        PlayState.dad.playAnim('hurt');
        PlayState.boyfriend.playAnim('attack');
        FlxG.sound.play(Paths.sound('cuphead/hurt'));
        canAttack = false;
		cardShit.animation.play('cardPopOut');
		FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
            cardShit.visible = false;
        }});
        cardShit.animation.finishCallback = function(animName:String) {
        }
        if (curShootingBullets) {
            curShootingBullets = false; }
    }

    if (curShootingBullets && FlxG.keys.justPressed.SHIFT && canAttack  || EngineSettings.botplay && curShootingBullets && canAttack ) {
        if (EngineSettings.botplay) {
            new FlxTimer().start(.7, function(tmr:FlxTimer) { 
                    if (curShootingBullets) {
                    curShootingBullets = false;
                    PlayState.dad.playAnim('hurt');
                    PlayState.boyfriend.playAnim('attack');
                    FlxG.sound.play(Paths.sound('cuphead/hurt'));
                    canAttack = false;
                    cardShit.animation.play('cardPopOut');
                    FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
                        cardShit.visible = false;
                    }});

                    // Clicked button
                    attackButton.animation.play('attackClicked');
                    attackButton.animation.finishCallback = function(animName:String) {
                        attackButton.animation.play('attackCooldown');
                            attackButton.animation.finishCallback = function(animName:String) {
                                attackButton.animation.play('attackNormal'); } } 
                }});
            }
        else {
            curShootingBullets = false;
            PlayState.dad.playAnim('hurt');
            PlayState.boyfriend.playAnim('attack');
            FlxG.sound.play(Paths.sound('cuphead/hurt'));
            canAttack = false;
            cardShit.animation.play('cardPopOut');
            FlxTween.tween(cardShit, {x: 1100, y: 900}, 1.5, {ease: FlxG.quadInOut, type: 1, onComplete: function () {
                cardShit.visible = false;
            }});
        // Clicked button
        attackButton.animation.play('attackClicked');
        attackButton.animation.finishCallback = function(animName:String) {
            attackButton.animation.play('attackCooldown');
                attackButton.animation.finishCallback = function(animName:String) {
                    attackButton.animation.play('attackNormal'); } } 
        }
    }
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

function onCountdown(val:Int) {
    var cupheadIntro:FlxSprite = new FlxSprite(0,0);
    cupheadIntro.frames = Paths.getSparrowAtlas('cuphead/the_thing2.0');
    cupheadIntro.animation.addByPrefix('intro', 'BOO instance 1', 24, false);
    cupheadIntro.animation.play('intro');
    cupheadIntro.antialiasing = EngineSettings.antialiasing;
    cupheadIntro.cameras = [PlayState.camHUD];
    cupheadIntro.animation.finishCallback = function(animName:String) {
        cupheadIntro.destroy();
    }

    var wallopIntro:FlxSprite = new FlxSprite(-300,50);
    wallopIntro.frames = Paths.getSparrowAtlas('cuphead/ready_wallop');
    wallopIntro.animation.addByPrefix('WALLOP', 'Ready? WALLOP!', 24, false);
    wallopIntro.animation.play('WALLOP');
    wallopIntro.antialiasing = EngineSettings.antialiasing;
    wallopIntro.scale.set(.7, .7);
    wallopIntro.updateHitbox();
    wallopIntro.cameras = [PlayState.camHUD];
    wallopIntro.animation.finishCallback = function(animName:String) {
        wallopIntro.destroy();
    }
    var introSFX = FlxG.random.int(0,4);

    switch(val) {
        case 3:
            PlayState.add(cupheadIntro);
            PlayState.add(wallopIntro);
            FlxG.sound.play(Paths.sound('cuphead/intros/normal/' + introSFX));
    }
    return false;
}