import funkin.options.TreeMenu;
import funkin.options.OptionsMenu;
import funkin.editors.charter.Charter;
import funkin.menus.StoryMenuState;
import flixel.util.FlxStringUtil;

var pauseCam = new FlxCamera();
var options:Array<String> = [
    'CONTINUE', 'RESTART', 'OPTIONS', 'EXIT'
];
var optionGroup:FlxTypedGroup<FunkinText>;
var bg:FunkinSprite;
var canDoShit:Bool = true;
public var imageArray:Array<String> = ['maxPause', 'broPause'];

function create(e){
    e.cancel();

    FlxG.cameras.add(pauseCam, false).bgColor = 0;
    cameras = [pauseCam];
    pauseCam.alpha = 1;
    pauseCam.zoom = 1;

    var black = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.alpha = 0;
    black.zoomFactor = 0;
    add(black);
    FlxTween.tween(black, {alpha: 0.5}, 0.5, {ease: FlxEase.quartOut});

    add(optionGroup = new FlxTypedGroup(4));
    for (a => b in options){
        var newText = new FunkinText(25, ((a * 90)) + 150, 0, b, 70, true);
        newText.font = Paths.font('vcr.ttf');
        newText.alpha = 0.4;
        newText.borderSize = 4;
        optionGroup.add(newText);
    }

    var composer = switch(PlayState.instance.curSong){
        case 'dwiddlefinger': 'Matasaki & Clappers46 (ft. LoserXSinging)';
    }
    var songTxt = new FunkinText(25, 650, 0, FlxStringUtil.toTitleCase(PlayState.instance.curSong), 28);
    var composerTxt = new FunkinText(25, songTxt.y + 7.5, 0, '\nBy: ' + composer, 20);

    pauseRender = new FlxSprite(songTxt.x + 600, 0).loadGraphic(Paths.image("maxPause"));
    pauseRender.alpha = 0;
    add(pauseRender);

    FlxTween.tween(pauseRender, {alpha: 1, x: 300}, 1, {ease: FlxEase.quartOut});

    for (a in [songTxt, composerTxt]) {
        a.font = Paths.font('vcr.ttf');
        a.borderSize = 2;
        add(a);
    }

    changeSelection(0);
}

function update(elapsed:Float) {
    if (pauseMusic.volume < 0.4 && canDoShit)
        pauseMusic.volume += 0.15 * elapsed;
    if (canDoShit){
        if (controls.DOWN_P || controls.UP_P){
            changeSelection(controls.DOWN_P ? 1 : -1);
        }
        if (controls.ACCEPT){
            selectButton();
        }
    }
}

var elapsedTime:Float = 0.0;
function postUpdate(elapsed:Float) {
    elapsedTime += elapsed;
    if (elapsedTime >= 1) {
        elapsedTime = 0.0;
        pauseRender.skew.set(FlxG.random.float(-0.2, 0.2),FlxG.random.float(-0.2, 0.2));
    }
}

var selectedMember;
function changeSelection(select:Float){
    if (select != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);

    optionGroup.members[curSelected].color = FlxColor.WHITE;
    optionGroup.members[curSelected].alpha = 0.5;
    optionGroup.members[curSelected].scale.set(1, 1);

    curSelected = FlxMath.wrap(curSelected + select, 0, 3);

    selectedMember = optionGroup.members[curSelected];
    optionGroup.members[curSelected].color = 0xFFCE388D;
    optionGroup.members[curSelected].alpha = 1;
}

function closeMenu(){
    pauseMusic.fadeOut(0.3);
    close();
}

function selectButton(){
    canDoShit = false;
    switch(options[curSelected]){
        case 'CONTINUE':
            closeMenu();
        case 'RESTART':
            parentDisabler.reset();
            game.registerSmoothTransition();
            FlxG.resetState();
        case 'OPTIONS':
            TreeMenu.lastState = PlayState;
            FlxG.switchState(new OptionsMenu());
        case 'EXIT':
            if (PlayState.chartingMode && Charter.undos.unsaved)
                game.saveWarn(false);
            else {
                PlayState.resetSongInfos();
                if (Charter.instance != null) Charter.instance.__clearStatics();

                game.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

                CoolUtil.playMenuSong();
                FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
            }
    }
}