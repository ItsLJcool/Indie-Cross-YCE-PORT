enableRating = false;

function create() {
    note.frames = Paths.getSparrowAtlas("notes/NOTE_assets_devil");

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "Left alone");
            note.animation.addByPrefix('holdend', "pruple end hold");
            note.animation.addByPrefix('holdpiece', "purple hold piece");
        case 1:
            note.animation.addByPrefix('scroll', "Down alone");
            note.animation.addByPrefix('holdend', "blue hold end");
            note.animation.addByPrefix('holdpiece', "blue hold piece");
        case 2:
            note.animation.addByPrefix('scroll', "Up alone");
            note.animation.addByPrefix('holdend', "green hold end");
            note.animation.addByPrefix('holdpiece', "green hold piece");
        case 3:
            note.animation.addByPrefix('scroll', "Right alone");
            note.animation.addByPrefix('holdend', "red hold end");
            note.animation.addByPrefix('holdpiece', "red hold piece");
    }
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    note.colored = false;
    note.hitOnBotplay = false;
    note.cpuIgnore = true;
    note.splash = Paths.splashes("notes/NOTE_assets_devil");

    note.animation.play('scroll');
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onPlayerHit() {
    FlxG.sound.play(Paths.sound('cuphead/burnSound'));
    if (EngineSettings.botplay == false) { // apparently !botplay doesn't work anymore?? Fuck You Yoshi
        PlayState.health -= .025;
    }
}

function onDadHit(shrex:Int) { // still don't know what shrex variable is
    super.onDadHit(shrex);
}

function onMiss() {
    return false;
}