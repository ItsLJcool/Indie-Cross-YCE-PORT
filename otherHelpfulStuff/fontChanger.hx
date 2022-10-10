//a
import('flixel.text.FlxTextBorderStyle');
function createPost() {    
    for(m in PlayState.members) {
    if (Std.isOfType(m, FlxSprite)) {
        m.antialiasing = true;
        if (Std.isOfType(m, FlxText)) {
            // lol it's actually a built in flixel font
            m.font = Paths.font("spongeBobFont"); // YOSHI DOSN'T NEED THE .tff EXTENSION YES
            m.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000);
            }
        }  
    }
}
// You know who else has dementia?