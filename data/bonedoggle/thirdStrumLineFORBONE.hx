//a

var strums = [];
function onGenerateStaticArrows() {
    // move strums
    for(e in PlayState.playerStrums.members) {
        //e.x = FlxG.width - ((FlxG.width - e.x) * 0.9);
        //e.x += -112;
        trace("BF E: " + e);
    }
    for(e in PlayState.cpuStrums.members) {
        //e.x *= 0.9;
        //e.x += 112;
        trace("PAP E: " + e);
    }

    PlayState.generateStaticArrows();
    for(i in 0...PlayState_.SONG.keyNumber) {
        var strum = PlayState.cpuStrums.members[i + PlayState_.SONG.keyNumber];
        strum.x = (FlxG.width / 2) + ((i - 2.5) * (Note.swagWidth * 0.9));
        strum.x += -950;
        strum.alpha = 0;
        strums.push(strum);
    }
}

function updatePost(elapsed:Float) {
    EngineSettings.glowCPUStrums = true;
    PlayState.notes.forEach(function(n) {
        // trace(n.noteType);
        if (n.noteType == 1) {
            // gf note
            var strum = PlayState.cpuStrums.members[n.noteData % PlayState_.SONG.keyNumber];
            var nStrum = strums[n.noteData % PlayState_.SONG.keyNumber];
            n.x = n.x - strum.x + nStrum.x;
            n.y = n.y - strum.y + nStrum.y;
        }
        else if (n.noteType == 2) {
            // gf note alt
            var strum = PlayState.cpuStrums.members[n.noteData % PlayState_.SONG.keyNumber];
            var nStrum = strums[n.noteData % PlayState_.SONG.keyNumber];
            n.x = n.x - strum.x + nStrum.x;
            n.y = n.y - strum.y + nStrum.y;
        }
    });
}

function onDadHit(note:Note) {
    if (EngineSettings.glowCPUStrums = !(note.noteType == 1 || note.noteType == 2)) {
    } else {
        var nStrum = strums[note.noteData % PlayState_.SONG.keyNumber % PlayState_.SONG.keyNumber];
        nStrum.cpuRemainingGlowTime = Conductor.stepCrochet * 1.5 / 1000;
        nStrum.animation.play("confirm", true);
        nStrum.centerOffsets();
        nStrum.centerOrigin();
        nStrum.toggleColor(nStrum.colored);
    }
}

function beatHit(curBeat:Int) {
    switch (curBeat) {
        case 60:
            for (note in PlayState.notes) {
                    var opacity:{value:Float} = {value: strums[note.noteData % PlayState_.SONG.keyNumber].alpha};
                    FlxTween.tween(opacity, {value: 0}, 1, {ease: FlxEase.linear, onUpdate: twn -> {
                        strums[note.noteData % PlayState_.SONG.keyNumber].alpha = opacity.value; }}); }
        case 48:
            for (note in PlayState.notes) {
                if (!EngineSettings.middleScroll) { 
                    if (!EngineSettings.downscroll) {
                        // sans
                        FlxTween.tween(strums[0], { x: 17.5, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[1], { x: 118.3, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[2], { x: 219.1, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[3], { x: 319.9, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        // pap
                        FlxTween.tween(PlayState.cpuStrums.members[0], { x: 436.4, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[1], { x: 537.2, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[2], { x: 638, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[3], { x: 738.8, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        // bf
                        FlxTween.tween(PlayState.playerStrums.members[0], { x: 853.3, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[1], { x: 954.1, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[2], { x: 1054.9, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[3], { x: 1155.7, y: 50}, 1.5, {ease: FlxEase.quartInOut, type: 1}); }
                    else if (EngineSettings.downscroll) {
                        // sans
                        FlxTween.tween(strums[0], { x: 17.5, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[1], { x: 118.3, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[2], { x: 219.1, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(strums[3], { x: 319.9, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        // pap
                        FlxTween.tween(PlayState.cpuStrums.members[0], { x: 436.4, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[1], { x: 537.2, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[2], { x: 638, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.cpuStrums.members[3], { x: 738.8, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        // bf
                        FlxTween.tween(PlayState.playerStrums.members[0], { x: 853.3, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[1], { x: 954.1, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[2], { x: 1054.9, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1});
                        FlxTween.tween(PlayState.playerStrums.members[3], { x: 1155.7, y: 570}, 1.5, {ease: FlxEase.quartInOut, type: 1}); }
                }
            }
            for (note in PlayState.notes) {
                    var opacity:{value:Float} = {value: strums[note.noteData % PlayState_.SONG.keyNumber].alpha};
                    FlxTween.tween(opacity, {value: 1}, 1, {ease: FlxEase.linear, onUpdate: twn -> {
                        strums[note.noteData % PlayState_.SONG.keyNumber].alpha = opacity.value; }}); }
        case 75:
            for (note in PlayState.notes) {
                    var opacity:{value:Float} = {value: strums[note.noteData % PlayState_.SONG.keyNumber].alpha};
                    FlxTween.tween(opacity, {value: 1}, 1, {ease: FlxEase.linear, onUpdate: twn -> {
                        strums[note.noteData % PlayState_.SONG.keyNumber].alpha = opacity.value; }}); }
        case 311:
            for (i in 0...strums.length) {
                if (!EngineSettings.downscroll) {
                FlxTween.tween(PlayState.cpuStrums.members[i], { y: -150}, 0.5, {ease : FlxEase.quartInOut}); }
                else {
                    FlxTween.tween(PlayState.cpuStrums.members[i], { y: 900}, 0.5, {ease : FlxEase.quartInOut}); }
            }
            for (i in 0...PlayState.cpuStrums.length) {
                if (!EngineSettings.downscroll) {
                FlxTween.tween(PlayState.cpuStrums.members[i], { y: -150}, 0.5, {ease : FlxEase.quartInOut}); }
                else {
                    FlxTween.tween(PlayState.cpuStrums.members[i], { y: 900}, 0.5, {ease : FlxEase.quartInOut}); }
            }
            for (i in 0...PlayState.playerStrums.length) {
                if (!EngineSettings.downscroll) {
                FlxTween.tween(PlayState.playerStrums.members[i], { y: -150}, 0.5, {ease : FlxEase.quartInOut}); }
                else {
                    FlxTween.tween(PlayState.playerStrums.members[i], { y: 900}, 0.5, {ease : FlxEase.quartInOut}); }
            }
            
    }
}