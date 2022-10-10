/**
	Author: ItsLJcool
	What it do: offset/size editor thingie

	= CONTROLS =
	HKUJ    move
	QE      size
    M       toggle alpha (0.5 or 1)
	T       prints results to logs
**/

var ogOffsetX:Int;
var ogOffsetY:Int;
var ogOffsetXscale:Int;
var ogOffsetYscale:Int;
var controlsJust = FlxG.keys.justPressed;
var controls = FlxG.keys.pressed;
var controlsNUM = FlxControls.anyPressed;

function createPost()
{
	// images go here

	// uh code
	ogOffsetX = sprite.x;
	ogOffsetY = sprite.y;
	ogOffsetXscale = sprite.scale.x;
	ogOffsetYscale = sprite.scale.y;
}

function update(elapsed)
{
	editImagesLOL(sprite);
}

var moveSpeed = 1;
var moveScale = 0.00125;

function editImagesLOL(sprite:FlxSprite)
{
	if (controls.U)
	{
		sprite.y -= moveSpeed;
		if (controls.SHIFT)
		{
			sprite.y -= moveSpeed;
		}
		else if (controlsNUM([17]))
		{
			sprite.y += moveSpeed / 2;
		}
	}
	if (controls.J)
	{
		sprite.y += moveSpeed;
		if (controls.SHIFT)
		{
			sprite.y += moveSpeed;
		}
		else if (controlsNUM([17]))
		{
			sprite.y -= moveSpeed / 2;
		}
	}
	if (controls.H)
	{
		sprite.x -= moveSpeed;
		if (controls.SHIFT)
		{
			sprite.x -= moveSpeed;
		}
		else if (controlsNUM([17]))
		{
			sprite.x += moveSpeed / 2;
		}
	}
	if (controls.K)
	{
		sprite.x += moveSpeed;
		if (controls.SHIFT)
		{
			sprite.x += moveSpeed;
		}
		else if (controlsNUM([17]))
		{
			sprite.x -= moveSpeed / 2;
		}
	}

	if (controls.Q)
	{
		sprite.scale.x += moveScale;
		sprite.scale.y += moveScale;
		sprite.updateHitbox();
		if (controls.SHIFT)
		{
			sprite.scale.x += moveScale;
			sprite.scale.y += moveScale;
			sprite.updateHitbox();
		}
		else if (controlsNUM([17]))
		{
			sprite.scale.x -= moveScale / 2;
			sprite.scale.y -= moveScale / 2;
			sprite.updateHitbox();
		}
	}

	if (controls.E)
	{
		sprite.scale.x -= moveScale;
		sprite.scale.y -= moveScale;
		sprite.updateHitbox();
		if (controls.SHIFT)
		{
			sprite.scale.x -= moveScale;
			sprite.scale.y -= moveScale;
			sprite.updateHitbox();
		}
		else if (controlsNUM([17]))
		{
			sprite.scale.x += moveScale / 2;
			sprite.scale.y += moveScale / 2;
			sprite.updateHitbox();
		}
	}

	if (controlsJust.R)
	{
		trace("Resetting to OG Offset");
		sprite.x = ogOffsetX;
		sprite.y = ogOffsetY;
		sprite.scale.x = ogOffsetXscale;
		sprite.scale.y = ogOffsetYscale;
		sprite.updateHitbox();
	}

	var yes:Bool = false;
	if (controlsJust.M)
	{
		if (!yes)
			sprite.alpha = 1;
		else
			sprite.alpha = 0.5;

		yes = !yes;
	}

	if (controlsJust.T)
	{
		trace("------------------------------------");
		trace("sprite.x: " + sprite.x);
		trace("sprite.y: " + sprite.y);
		trace("sprite.scale.x: " + sprite.scale.x);
		trace("sprite.scale.y: " + sprite.scale.y);
		trace("------------------------------------");
	}
}