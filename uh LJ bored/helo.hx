//a
var yes:Array<String> = [
    "Botplay??",
    "SANSSSSSSSSSSSS",
    "He Had No BODY To Go With!",
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    "Helo Zander :)",
    "DEBIL GAMBIT",
    "INDIE CROCS!",
    "Xav helo",
    "Among US",
    "Insert Indie Crocs Image",
    "L BOZO",
    "+ RATIO"
];
var randonImages:Array<String> = [
    "HOW IS IT UPSIDE DOWN",
    "HUH",
    "Indie Cross Ports be like",
    "Loading_screen",
    "menuBG",
    "menuBGBlue",
    "menuBGMagenta",
    "menuBGYoshiCrafter",
    "menuDesat",
    "VM be like",
    "WHYY",
    "cuphead/cuphead_death",
    "cuphead/cuphead_death2",
    "cuphead/devil_death",
    "cuphead/cardfull",
    "cuphead/death",
    "healthbars/bendyhealthbar",
    "healthbars/cuphealthbar",
    "healthbars/sanshealthbar",
    "sans/battle",
    "sans/heart",
    "sans/Waterfall",
    "bendy/BACKBACKgROUND",
    "bendy/BackgroundwhereDEEZNUTSfitINYOmOUTH",
    "bendy/ChainUTS",
    "bendy/Damage01",
    "bendy/Damage02",
    "bendy/Damage03",
    "bendy/Damage04",
    "bendy/ForegroundEEZNUTS",
    "bendy/go",
    "bendy/inky depths",
    "bendy/introductionbonus",
    "bendy/introductionbonus2",
    "bendy/introductiondespair",
    "bendy/introductionsong1",
    "bendy/introductionsong2",
    "bendy/introductionsong3",
    "bendy/introductionsong4",
    "bendy/MidGrounUTS",
    "bendy/nightmareBendy_foreground",
    "bendy/NUTS",
    "bendy/postdemise",
    "bendy/ready",
    "bendy/SammyS",
    "bendy/set",
    "bendy/tits",
    "bendy/first/BG01",
    "bendy/first/Boi",
    "bendy/first/introductionsong1",
    "bendy/first/Pillar",
    "bendy/gay/C_00",
    "bendy/gay/C_01",
    "bendy/gay/C_02",
    "bendy/gay/C_03",
    "bendy/gay/C_04",
    "bendy/gay/C_05",
    "bendy/gay/C_06_BLEND_MODE_ADD",
    "bendy/gay/C_07",
    "bendy/gay/Particlestuff0",
    "bendy/gay/Particlestuff1",
    "bendy/gay/Particlestuff2",
    "bendy/stairs/chainleft",
    "bendy/stairs/chainright",
    "bendy/stairs/gradient",
    "bendy/stairs/scrollingBG",
    "bendy/stairs/stairs",
    "bendy/third/Butchergang_Bg",
    "bendy/third/Ink_shit"
];
var indieCrocs:FlxSprite;
function onGenerateStaticArrows() {

    EngineSettings.botplay = true;
    indieCrocs = new FlxSprite(0,0).loadGraphic(Paths.image('title/INDIE CROCKS'));
    indieCrocs.antialiasing = EngineSettings.antialiasing;
    indieCrocs.screenCenter();
    indieCrocs.updateHitbox();
    indieCrocs.cameras = [PlayState.camHUD];
    // indieCrocs.alpha = 0.0001;
    add(indieCrocs);
}
var imLazy:Int = 0;
function onPlayerHit(note:Note) {
        // var rng = FlxG.random.int(0, yes.length);
        // imLazy = rng;
        // msScoreLabel.text = yes[rng];
        // switch(rng) {
        //     case 9:
        //         remove(indieCrocs);
        //         add(indieCrocs);
        //         indieCrocs.alpha = 1;
        //         indieCrocs.loadGraphic(Paths.image('title/INDIE CROCKS'));
        //     case 11:
        //         remove(indieCrocs);
        //         add(indieCrocs);
        //         indieCrocs.alpha = 1;
        //         indieCrocs.loadGraphic(Paths.image('title/INDIE CROCKS'));

        //     default:
        //         indieCrocs.alpha = 0.0001;
        // }
        if (!note.isSustainNote) {
            var rng = FlxG.random.int(0, randonImages.length - 1);
            indieCrocs.loadGraphic(Paths.image(randonImages[rng]));
            indieCrocs.screenCenter();
            indieCrocs.updateHitbox();
        }       
        camGame.angle = FlxG.random.float(0, 360);
        camHUD.angle = FlxG.random.float(0, 360);
}

function update(elapsed:Float) {
    // if (imLazy == 9)
    indieCrocs.alpha = msScoreLabel.alpha;
    // indieCrocs.angle = indieCrocs.angle + 1;
    // camGame.angle = camGame.angle + 1;
    // camHUD.angle = camHUD.angle + 1;
}