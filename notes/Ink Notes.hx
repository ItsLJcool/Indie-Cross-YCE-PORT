enableRating = true;

function create() {
    note.frames = Paths.getSparrowAtlas("notes/NOTE_assets_inks");

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "inkLeft");
        case 1:
            note.animation.addByPrefix('scroll', "inkDown");
        case 2:
            note.animation.addByPrefix('scroll', "inkUp0");
        case 3:
            note.animation.addByPrefix('scroll', "inkRight");
    }
    note.animation.addByPrefix('holdend', "hold end");
    note.animation.addByPrefix('holdpiece', "hold piece");
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    note.colored = false;
    note.hitOnBotplay = false;
    note.cpuIgnore = true;
    note.splashColor = 0xFF000000;

    note.animation.play('scroll');
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onPlayerHit() {
    if (EngineSettings.botplay == false) { // apparently !botplay doesn't work anymore?? Fuck You Yoshi
        PlayState.health -= .05;
    }
}

function onDadHit(shrex:Int) { // still don't know what shrex variable is
    super.onDadHit(shrex);
}

function onMiss() {
    return false;
}
