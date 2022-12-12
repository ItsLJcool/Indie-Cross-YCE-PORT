//a
import CoolUtil;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import haxe.io.Path;
import lime.ui.FileDialogType;
import lime.ui.FileDialog;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxInputText;
import Script;
import ScriptPack; // you fucking cant just do 'Script.ScriptPack' you gotta import them one by on

var dialogueTemplate = {
    defaultStuff: { // things that will apply to ALL dialogues in the json, the dialogue 
        dialogueImagePath: ["speech_bubble_talking", "shared"] // [fileName, pathDirectory] | If there is no pathDir, it defaults to: modName/images
        textColor: 0xFF000000, // default text color
        textFont: "Pixel Arial 11 Bold" // default text fontt
        textXY: [50,100], // where the Default Text Offset should be, it adds to the current offset, it does not set it specifically
        textSFX: "pixelText", // default SFX when the letter is typed on screen.
        // characterImage: ["WorkInProgress", "filePath"], // PsychEngine moment :troll:
        dialogueAnimations: ["AAH loop", "Normal open", "AAH open", "Normal loop"], // animations for the Dialogue Image if it contains an XML
        dialogueLoopAnims: [true, false, false, true], // if those animations should be looped or not,
        // add more later
    }
    dialogueReal: [
        {
            daText: "Default Text: Dialogue 1"
        }
    ]
}

function create() {

}