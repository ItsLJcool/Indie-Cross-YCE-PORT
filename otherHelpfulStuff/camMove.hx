// a
import Section;

var moveCam = 10;

function postUpdate(elapsed:Float) {
    var animName = "";
    var animNameGF = "";
    if (PlayState.section.mustHitSection) {
        animName = PlayState.boyfriend.animation.curAnim.name;
        animNameGF = PlayState.gf.animation.curAnim.name; }
    else {
        animName = PlayState.dad.animation.curAnim.name; 
        animNameGF = PlayState.gf.animation.curAnim.name; }

    if (animName == 'singLEFT' || animName == 'singLEFT-alt' || animNameGF == 'singLEFT' || animNameGF == 'singLEFT-alt') {
      PlayState.camFollow.x -= moveCam;
    }
    if (animName == 'singRIGHT' || animName == 'singRIGHT-alt' || animNameGF == 'singRIGHT' || animNameGF == 'singRIGHT-alt') {
      PlayState.camFollow.x += moveCam;
    }
    if (animName == 'singUP' || animName == 'singUP-alt' || animNameGF == 'singUP' || animNameGF == 'singUP-alt') {
      PlayState.camFollow.y -= moveCam;
    }
    if (animName == 'singDOWN' || animName =='singDOWN-alt' || animNameGF == 'singDOWN' || animNameGF == 'singDOWN-alt') {
      PlayState.camFollow.y += moveCam;
    }
}