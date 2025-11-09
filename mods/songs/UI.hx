import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import flixel.addons.display.FlxPieDial;
import flixel.addons.display.FlxPieDialShape;

using StringTools;

var blackScreen:FlxSprite;
var introSprites:Array<String>;
var introSound:Array<String>;
var introIndex:Int = 0;
var card:FlxSprite;
var nameTxt:FunkinText;
var creditText:FunkinText;
var timePie:FlxPieDial;
var timeTxt:FlxText;
var timePieBG:FlxSprite;
var metaData = PlayState.SONG.meta;

function postCreate() {
	for (poop in [iconP1, iconP2, healthBar, healthBarBG, scoreTxt, accuracyTxt, missesTxt, comboGroup]) poop.kill();
	strumLines.members[0].visible = false;

	timePieBG = new FlxSprite(10, 10, Paths.image('timeBG'));
	timePieBG.scale.set(0.5, 0.5);
	timePieBG.updateHitbox();

	timePie = new FlxPieDial(0, 0, 25, FlxColor.WHITE, Math.floor((inst.length / 1000) - (inst.time / 1000)), FlxPieDialShape.CIRCLE, true);
	timePie.color = 0xffb359;
	timePie.scale.set(0.95, 0.95);
	timePie.updateHitbox();
	timePie.x = timePieBG.x + (timePieBG.width / 0.94) - (timePie.width / 0.58);
	timePie.y = timePieBG.y + (timePieBG.height / 1.9) - (timePie.height / 2.1);

	timeTxt = new FlxText(0, 0, 100, 'X:XX', 24);
	timeTxt.setFormat(Paths.font('Jost-Bold.ttf'), 40, 0xFFfcecca, 'center',FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timeTxt.x = timePieBG.x + (timePieBG.width / 3) - (timeTxt.width / 3);
	timeTxt.y = timePieBG.y + (timePieBG.height / 2) - (timeTxt.height / 2);

	underlay = new FlxSprite(timeTxt.x + 100, timeTxt.y).makeSolid(60, 60, 0xFF000000);

	for (e in [underlay, timePie, timePieBG, timeTxt]) {
		e.camera = camHUD;
		e.alpha = 0;
		add(e);
	}

	if (PlayState.SONG.meta.name.toLowerCase() == "socberg") {
		var offsetthing = 150; 

		timePieBG.x = FlxG.width - (timePieBG.width * timePieBG.scale.x) - offsetthing;
		timePie.x = timePieBG.x + (timePieBG.width / 0.94) - (timePie.width / 0.58);
		timePie.y = timePieBG.y + (timePieBG.height / 1.9) - (timePie.height / 2.1);
		timeTxt.x = timePieBG.x + (timePieBG.width / 3) - (timeTxt.width / 3);
		timeTxt.y = timePieBG.y + (timePieBG.height / 2) - (timeTxt.height / 2);
		underlay.x = timeTxt.x + 100;
		underlay.y = timeTxt.y;
	}
}

function create() {
	playCutscenes = true;

	add(blackScreen = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK));
	blackScreen.scrollFactor.set();
	blackScreen.zoomFactor = 0;

	introSprites = ['game/onyourmarks', 'game/ready', 'game/set', 'game/go'];
	introSounds = ['intro3', 'intro2', 'intro1', 'introGo'];

	if (metaData.name.toLowerCase() != "lime64") {
		add(card = new FlxSprite(0, FlxG.height - 200, Paths.image("card")));
		card.camera = camHUD;
		card.scale.set(0.75, 0.75);
		card.updateHitbox();
		card.x = -card.width;

		add(nameTxt = new FunkinText(0, 0, 182, metaData.displayName.replace("-", " ")));
		nameTxt.setFormat(Paths.font("Jumpman.ttf"), 36, 0xFF000000, "center");
		nameTxt.camera = camHUD;
		nameTxt.y = !camHUD.downscroll ? (card.y + 35) + ((100 - nameTxt.height) / 2) : (card.y + 4) + ((100 - nameTxt.height) / 2);

		var credit:String = (metaData.customValues?.titleCardCredits != null) ? metaData.customValues.titleCardCredits : "Man i dont fucking know lmao";

		add(creditText = new FunkinText(0, 0, 182, credit));
		creditText.setFormat(Paths.font("Jumpman.ttf"), 36, 0xFF000000, "center");
		creditText.camera = camHUD;
		creditText.y = !camHUD.downscroll ? (card.y + 4) + ((100 - creditText.height) / 2) : (card.y + 35) + ((100 - creditText.height) / 2);
	}
}

function onCountdown(event) {
	event.cancel();

	if (introIndex < introSprites.length) {
		var spr = new FlxSprite().loadGraphic(Paths.image(introSprites[introIndex]));
		spr.screenCenter();
		spr.camera = camHUD;
		spr.scale.set(1.5, 1.5);
		add(spr);

		FlxG.sound.play(Paths.sound(introSounds[introIndex]));

		FlxTween.tween(spr, {y: spr.y - 500, "scale.x": 1.0, "scale.y": 1.0}, 0.75, {
			ease: FlxEase.quadInOut,
			onComplete: function(_) {
				spr.kill();

				if (introIndex == introSprites.length - 1) {
					FlxTween.tween(blackScreen, {alpha: 0}, 1, {ease: FlxEase.quadOut, onComplete: function(_){
						blackScreen.kill();
					}});
					if (metaData.name.toLowerCase() != "booty-shaker") {
						for (e in [timePie, timeTxt, timePieBG, underlay])
							FlxTween.tween(e, {alpha: 1}, 0.5, {ease: FlxEase.quadIn});
					}
				}
			}
		});

		introIndex++;
	}
}

function update(elapsed:Float) {
	timeTxt.text = FlxStringUtil.formatTime((inst.length / 1000) - (inst.time / 1000));
	
	if (timePie != null)
		timePie.amount = Math.max(0, (inst.length - inst.time) / inst.length);

	if (card != null && card.active) {
		nameTxt.x = card.x + 190;
		creditText.x = card.x + 4;
	}
}

public var move:Bool = true;
function postUpdate(e:Float) {
    if (move && curCameraTarget >= 0) {
        final char = strumLines.members[curCameraTarget]?.characters[0]?.getAnimName();
        if (char != null) switch(char.split('-')[0]) {
            case 'singLEFT': camFollow.x -= 30;
            case 'singDOWN': camFollow.y += 30;
            case 'singUP': camFollow.y -= 30;
            case 'singRIGHT': camFollow.x += 30;
        }
    }
} // THANK YOU VECHETT based on yuour script okay. -hypsk8r

function onSongStart() {
	if (PlayState.SONG.meta.name.toLowerCase() != "lime64" && card != null) {
		FlxTween.tween(card, {x: 0}, 0.8, {ease: FlxEase.expoOut, onComplete: function(_) {
			FlxTween.tween(card, {x: -card.width}, 0.6, {ease: FlxEase.quadIn, startDelay: 3.0, onComplete: function(_) {
				card.kill();
				nameTxt.kill();
			}});
		}});
	}
}

function onSubstateOpen(e) if (paused) camHUD.visible = false;
function onSubstateClose(e) camHUD.visible = true;