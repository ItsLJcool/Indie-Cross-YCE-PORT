//a
EngineSettings.middleScroll = false;

var strums = [];
var strumsLikeIC = false; // instead of OPPONENT, 3rd STRUM, PLAYER... ill be like Indie Cross Bonedoggle: 3rd STRUM, OPPONENT, PLAYER
function onGenerateStaticArrows() {
    // move strums
    for(e in PlayState.playerStrums.members) {
        e.x = FlxG.width - ((FlxG.width - e.x) * 0.9);
        if (!strumsLikeIC) {
        e.x += 50; }
        else {
        e.x += 55; }
    }
    for(e in PlayState.cpuStrums.members) {
        e.x *= 0.9;
        if (!strumsLikeIC) {
        e.x += -70; }
        else {
        e.x += 355; }
    }

    PlayState.generateStaticArrows();
    for(i in 0...PlayState.song.keyNumber) {
        var strum = PlayState.cpuStrums.members[i + PlayState.song.keyNumber];
        strum.x = (FlxG.width / 2) + ((i - 2.5) * (Note.swagWidth * 0.9));
        if (!strumsLikeIC) {
        strum.x += 5; }
        else {
        strum.x += -400; }
        strums.push(strum);
    }
}

function updatePost(elapsed:Float) {
    EngineSettings.glowCPUStrums = true;
    PlayState.notes.forEach(function(n) {
        // trace(n.noteType);
        if (n.noteType == 1) {
            // gf note
            var strum = PlayState.cpuStrums.members[n.noteData % PlayState.song.keyNumber];
            var nStrum = strums[n.noteData % PlayState.SONG.keyNumber];
            n.x = n.x - strum.x + nStrum.x;
            n.y = n.y - strum.y + nStrum.y;
        }
    });
}

function onDadHit(note:Note) {
    if (EngineSettings.glowCPUStrums = !(note.noteType == 1)) {
    } else {
        var nStrum = strums[note.noteData % PlayState.song.keyNumber % PlayState.song.keyNumber];
        nStrum.cpuRemainingGlowTime = Conductor.stepCrochet * 1.5 / 1000;
        nStrum.animation.play("confirm", true);
        nStrum.centerOffsets();
        nStrum.centerOrigin();
        nStrum.toggleColor(nStrum.colored);
    }
}