var screenVignette:FlxSprite;
var curAlpha:Float = 0;
var alphaTween:FlxTween = null;
var blackoutShader:CustomShader;


function create() {
    if (!Options.gameplayShaders) {
        disableScript();
        return;
    }

    screenVignette = new FlxSprite();
    screenVignette.loadGraphic(Paths.image("vignette"));
    screenVignette.setGraphicSize(FlxG.width, FlxG.height, true);
    screenVignette.scrollFactor.set(0, 0);
    screenVignette.alpha = curAlpha;
    screenVignette.color = FlxColor.BLACK;
    screenVignette.screenCenter();

    add(screenVignette);
    screenVignette.cameras = [camHUD];

    blackoutShader = new CustomShader("blackOut");
    camGame.addShader(blackoutShader);

}

function update() {
    if (curStep == 144 && blackoutShader != null) {
        camGame.removeShader(blackoutShader);
    }
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Screen Vignette") {
        var instant:Bool = !params[0];
        var newAlpha:Float = params[1];
        var duration:Float = ((Conductor.crochet / 4) / 1000) * params[2];

        if (instant) {
            screenVignette.alpha = curAlpha = newAlpha;
        } else {
            if (alphaTween != null) alphaTween.cancel();
            alphaTween = FlxTween.num(curAlpha, newAlpha, duration,
                {ease: FlxEase.quadOut},
                function(val:Float) {
                    screenVignette.alpha = curAlpha = val;
                });
        }
    }
}

function destroy() {
    screenVignette.destroy();
}
