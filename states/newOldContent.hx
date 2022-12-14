//a
import flixel.text.FlxTextBorderStyle;
import flixel.animation.FlxAnimation;

// Sprites / XML's
var anImage:FlxSprite;
var xmlImage:FlxSprite;

// Arrays
var availableAnims:Array<Dynamic> = [];
var preloadedSprites:Array<FlxSprites> = [];
var funny:Array<Dynamic> = [];

// Booleans / Bool
var preloadImages:Bool = true;
function create() {
    FlxG.sound.music.stop();
    FlxG.sound.playMusic(Paths.music("settin"));

    bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
    bg.scrollFactor.set();
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    anImage = new FlxSprite().loadGraphic(Paths.image('old/images/attackdodge'));
    anImage.screenCenter();
    anImage.updateHitbox();
    anImage.alpha = 0.0001;
    
    xmlImage = new FlxSprite();
    changeXmlImage(xmlImage, "old/images/attackdodge", null, null);
    xmlImage.screenCenter();
    xmlImage.alpha = 0.0001;
    if (!preloadImages) {
        add(anImage);
        add(xmlImage);
    }

    funny.push({file: "attackdodge", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5});
    funny.push({file: "NewCuphead", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5});

    if (preloadImages) {
    for (i in 0...funny.length) {
        var newSprite:FlxSprite = new FlxSprite();
        if (!funny[i].xml) 
            newSprite.loadGraphic(Paths.image("old/images/" + funny[i].file));
        else 
            changeXmlImage(newSprite, "old/images/" + funny[i].file, funny[i].names, funny[i].loopAnim);

        newSprite.updateHitbox();
        newSprite.screenCenter();
        newSprite.alpha = 0.0001;
        newSprite.ID = i;
        preloadedSprites.push(newSprite);
        add(newSprite);
        }
    }

    changeGallery(0);
}
function update() {
    if ((FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.D)) {
        changeGallery(-1);
    }
    if ((FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.A)) {
        changeGallery(1);
    }

    if (FlxG.keys.justPressed.SPACE)
        changeSpecial();
}

var curSelected:Int = 0;
var trackSpecial:Int = 0;
function changeGallery(jesse:Int = 0) {
    trackSpecial = 1;
    switch(funny[curSelected].type) {
        case "cup","cuphead":
            FlxG.sound.play(Paths.sound('cuphead/select'));
        case "sans","undertale":
            FlxG.sound.play(Paths.sound('sans/select'));
        case "bendy","batim":
            FlxG.sound.play(Paths.sound('bendy/click'));
    }
    curSelected += jesse;
    if  (curSelected >= funny.length - 1)
        curSelected = 0;
    if (curSelected < 0)
        curSelected = funny.length - 1;

    if (funny[curSelected].xml) {
        changeXmlImage((preloadImages) ? preloadedSprites[curSelected] : xmlImage, funny[curSelected].file, funny[curSelected].names, funny[curSelected].loopAnim);
        if (preloadImages) {
            for (spr in preloadedSprites) {
                if (spr.ID == curSelected) {
                    spr.scale.set(funny[curSelected].scale, funny[curSelected].scale);
                    spr.updateHitbox();
                    spr.screenCenter();
                    spr.alpha = 1;
                } else {
                    spr.alpha = 0.0001;
                }

            }
        } else {
        xmlImage.scale.set(funny[curSelected].scale, funny[curSelected].scale);
        xmlImage.updateHitbox();
        xmlImage.screenCenter();
        xmlImage.alpha = 1;
        anImage.alpha = 0.0001;
        }
    } else {
        if (preloadedSprites) {
            for (spr in preloadedSprites) {
                if (spr.ID == curSelected) {
                    preloadedSprites[curSelected].loadGraphic(Paths.image(funny[curSelected].file));
                    preloadedSprites[curSelected].scale.set(funny[curSelected].scale, funny[curSelected].scale);
                    preloadedSprites[curSelected].updateHitbox();
                    preloadedSprites[curSelected].screenCenter();
                    preloadedSprites[curSelected].alpha = 1;
                } else {
                    preloadedSprites[curSelected].alpha = 0.0001;
                }
            }
        } else {
        anImage.loadGraphic(Paths.image(funny[curSelected].file));
        anImage.scale.set(funny[curSelected].scale, funny[curSelected].scale);
        anImage.updateHitbox();
        anImage.screenCenter();
        anImage.alpha = 1;
        xmlImage.alpha = 0.0001;
        }
    }

}

/**
function changeSpecial() {
    if (!funny[curSelected].xml) return;

    trackSpecial++;
    if  (trackSpecial > availableAnims.length)
        trackSpecial = 0;
    
    if (!preloadImages) {
        xmlImage.animation.play((funny[curSelected].names == null) ? trackSpecial : funny[curSelected].names[trackSpecial]);
    } else {
        for (spr in preloadedSprites) {
            if (spr.ID == curSelected) {
                preloadedSprites[curSelected].animation.play((funny[curSelected].names == null) ? trackSpecial : funny[curSelected].names[trackSpecial]);
            }
        }
    }
}
**/
function changeXmlImage(sprite:FlxSprite, path:String, names:Array<String>, looping:Array<Bool>) { // changes the Dialgoue Box image, causes a sec of lag tho
    sprite.frames = Paths.getSparrowAtlas(path);
    availableAnims = [];
    var numbers = ["0","1","2","3","4","5","6","7","8","9"];
    if (sprite.frames != null) {
        for(e in sprite.frames.frames) {
            var animName = e.name;
            while (numbers.contains(animName.substr(-1))) {
                animName = animName.substr(0, animName.length - 1);
            }
            if (!availableAnims.contains(animName))
                availableAnims.push(animName);
        }
    }
    for (i in 0...availableAnims.length) {
        sprite.animation.addByPrefix((names == null) ? i + 1 : names[i], availableAnims[i], 24, (looping == null) ? false : looping[i]);
    }
    sprite.updateHitbox();
}