//a
function onCountdown(val:Int) {
    return false;
    trace(val);
    if (!inCutscene && !dontAgain && !save.data.hasSeenDialogue) {
        // canPause = false;
        inCutscene = true;
        dontAgain = true;
        openSubState(new ModSubState("DialogueReader", mod));
        trace("openSubState");
        PlayState.camHUD.alpha = 0.0001;
        new FlxTimer().start(2, function(tmr:FlxTimer) {
            inCutscene = false;
            save.data.hasSeenDialogue = false;
            save.flush();
            onCountdown(3);
            FlxTween.tween(PlayState.camHUD, {alpha: 1}, 2, { ease: FlxEase.linear });
        });
    }
}