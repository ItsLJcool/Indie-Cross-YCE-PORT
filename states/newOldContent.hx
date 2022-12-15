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

// FlxText / Text
var textTitle:FlxText;
var textDesc:FlxText;
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

    doThePush();

    if (preloadImages) {
    for (i in 0...funny.length) {
        if (!funny[i].xml) {
            var newImageSprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image("old/images/" + funny[i].file));
            newImageSprite.scale.set(funny[i].scale, funny[i].scale);
            newImageSprite.updateHitbox();
            newImageSprite.screenCenter();
            newImageSprite.ID = i;
            newImageSprite.alpha = 0.0001;
            preloadedSprites.push(newImageSprite);
            add(newImageSprite);
        }
        else {
            var newXML:FlxSprite = new FlxSprite();
            changeXmlImage(newXML, "old/images/" + funny[i].file, funny[i].names, funny[i].loopAnim);
            newXML.scale.set(funny[i].scale, funny[i].scale);
            newXML.updateHitbox();
            newXML.screenCenter();
            newXML.ID = i;
            newXML.alpha = 0.0001;
            preloadedSprites.push(newXML);
            add(newXML);
        }
        }
    }

    changeGallery(0);
}
function update() {
    if ((FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.D)) {
        changeGallery(1);
    }
    if ((FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.A)) {
        changeGallery(-1);
    }

    if (FlxG.keys.justPressed.SPACE)
        changeSpecial();
}

var curSelected:Int = 0;
var trackSpecial:Int = 0;
function changeGallery(jesse:Int = 0) {
    trackSpecial = 0;
    switch(funny[curSelected].type) {
        case "cup","cuphead":
            FlxG.sound.play(Paths.sound('cuphead/select'));
        case "sans","undertale":
            FlxG.sound.play(Paths.sound('sans/select'));
        case "bendy","batim":
            FlxG.sound.play(Paths.sound('bendy/click'));
    }
    curSelected += jesse;
    if (curSelected >= funny.length)
        curSelected = 0;
    if (curSelected < 0)
        curSelected = funny.length - 1;

    if (funny[curSelected].xml) {
        if (preloadImages) {
            for (spr in preloadedSprites) {
                for (spr in preloadedSprites) {
                if (spr.ID == curSelected) {
                    spr.alpha = 1;
                    checkAnimFrames(spr);
                } else {
                    spr.alpha = 0.0001;
                    preloadedSprites[curSelected].animation.play((funny[curSelected].names == null) ? 0 : funny[curSelected].names[0]);
                }
            }
        }
        } else {
        changeXmlImage(xmlImage, funny[curSelected].file, funny[curSelected].names, funny[curSelected].loopAnim);
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
    textDesc.text = funny[curSelected].title;
    textTitle.text = funny[curSelected].desc;
    
    textTitle.updateHitbox();
    textTitle.screenCenter();
    textTitle.y = FlxG.height - textTitle.height - 20;

    textDesc.updateHitbox();
    textDesc.screenCenter();
    textDesc.y = FlxG.height - textTitle.height - textDesc.height - 20;
}


function changeSpecial() {
    if (!funny[curSelected].xml) return;

    if (funny[curSelected].pausable != null && funny[curSelected].pausable) {
        if (preloadImages) {
            for (spr in preloadedSprites)
                (spr.animation.paused) ? spr.animation.resume() : spr.animation.pause();
        } else
            (xmlImage.animation.paused) ? xmlImage.animation.resume() : xmlImage.animation.pause();
    }

    trackSpecial++;
    if  (trackSpecial > availableAnims.length - 1)
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

function changeXmlImage(sprite:FlxSprite, path:String, names:Array<String>, looping:Array<Bool>) { // changes the Dialgoue Box image, causes a sec of lag tho
    sprite.frames = Paths.getSparrowAtlas(path);
    checkAnimFrames(sprite);
    for (i in 0...availableAnims.length) {
        sprite.animation.addByPrefix((names == null) ? i : names[i], availableAnims[i], 24, (looping == null) ? false : looping[i]);
    }
    sprite.updateHitbox();
}
function checkAnimFrames(sprite:FlxSprite) {
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
}

function doThePush() {
    funny.push({file: "attackdodge", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5, 
    title: "Cuphead Help", 
    desc: "This Was the old Cuphead Dodge & Attack Help Info"});

    funny.push({file: "MobileGame", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5,
    title: "Old Attack / Dodge Sprites", 
    desc: "We all know what this looks like already (if not then there you go)"});

    funny.push({file: "NewCuphead", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5,
    title: "Unused Cuphead Anims?", 
    desc: "Its still the normal anims but with unused ones"});

    funny.push({file: "angrycuphead", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5,
    title: "Unused / Old Cuphead Anims for Knockout", 
    desc: "Knockout had its own weird animations like the old Knockout BF"});

    funny.push({file: "characters/rainboyfriend", xml: true, type: "cup", names: null, loopAnim: null, scale: 0.5,
    title: "Old Boyfriend Anims", 
    desc: "This was what BF would look like in Knockout"});

    funny.push({file: "characters/BF_LC_shader", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Old BF Sansational Anims", 
    desc: "How old? The Beta Old (probably)"});

    funny.push({file: "characters/BOYFRIEND_White", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Old BF Sansational Anims | White Version", 
    desc: "How old? The Beta Old (probably)"});

    funny.push({file: "characters/BF_ded_Sans", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Beta Death Anim", 
    desc: "This is used in the beta (i think) for sans GameOver"});

    funny.push({file: "characters/SANS_FNF", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Beta Sans", 
    desc: "Oh Dear God"});

    funny.push({file: "characters/SANS_FNF_white", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Beta Sans | White Version", 
    desc: "What happened to sans"});

    funny.push({file: "characters/DeathSans", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Death Sans | Nightmare Sans", 
    desc: "First Character to have a Nightmare form"});
    
    funny.push({file: "UTextBox", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Old Sans Dialogue Box", 
    desc: "It was all seperated so it looks wierd here"});
    
    funny.push({file: "gaster2", xml: true, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "First idea of Gaster Blasters", 
    desc: "Fwoosh"});
    
    funny.push({file: "chara easter egg", xml: false, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Scrapped Achievements", 
    desc: "They could be in IC 2.0 though"});
    
    funny.push({file: "man behind the slaughter", xml: false, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Scrapped Achievements", 
    desc: "They could be in IC 2.0 though"});
    
    funny.push({file: "eye", xml: false, type: "sans", names: null, loopAnim: null, scale: 0.5,
    title: "Scrapped Achievements", 
    desc: "They could be in IC 2.0 though"});
    
    // funny.push({file: "LEGSS", xml: true, type: "bendy", names: null, loopAnim: null, scale: 0.5,
    // title: "Old idea of running BF", 
    // desc: "instead of running through XML frames", pausable: true}); // shut
}