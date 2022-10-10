enableRating = true;

function create() {
    note.frames = Paths.getSparrowAtlas("notes/NOTE_assets_sansOrange");

    switch(note.noteData % PlayState.song.keyNumber) {
        case 0:
            note.animation.addByPrefix('scroll', "purple0");
            note.animation.addByPrefix('holdend', "pruple end hold");
            note.animation.addByPrefix('holdpiece', "purple hold piece");
        case 1:
            note.animation.addByPrefix('scroll', "blue0");
            note.animation.addByPrefix('holdend', "blue hold end");
            note.animation.addByPrefix('holdpiece', "blue hold piece");
        case 2:
            note.animation.addByPrefix('scroll', "green0");
            note.animation.addByPrefix('holdend', "green hold end");
            note.animation.addByPrefix('holdpiece', "green hold piece");
        case 3:
            note.animation.addByPrefix('scroll', "red0");
            note.animation.addByPrefix('holdend', "red hold end");
            note.animation.addByPrefix('holdpiece', "red hold piece");
    }
    note.setGraphicSize(Std.int(note.width * 0.7));
    note.updateHitbox();
    note.antialiasing = true;
    note.splashColor = 0xFFFFCC00;

    note.animation.play('scroll');
    if (note.isSustainNote) {
        if (note.prevNote != null)
            if (note.prevNote.animation.curAnim.name == "holdend")
                note.prevNote.animation.play("holdpiece");
        note.animation.play("holdend");
    }
}

function onMiss() {
    if (!EngineSettings.botplay) { // apparently !botplay doesn't work anymore?? Fuck You Yoshi
	  PlayState.health = -1;
	}
}