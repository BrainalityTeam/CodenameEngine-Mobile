// Script by Aika and Chezzar

import funkin.backend.assets.Paths;
import funkin.game.Stage;
import funkin.game.StageCharPos;

function postCreate() for (event in PlayState.SONG.events) if (event.name == "ChangeStage") {
    var stagesToPreload = [event.params[0]];

    // Store original camera settings
    var originalZoom = PlayState.instance.defaultCamZoom;
    var originalCamFollowX = PlayState.instance.camFollow.x;
    var originalCamFollowY = PlayState.instance.camFollow.y;

    for (stageName in stagesToPreload) {
        var xmlContent = Paths.xml('data/stages/' + stageName);
        if (xmlContent != null) {
            var stageNew = new Stage(stageName);

            // Preload the stage
            for (sprite in stageNew.stageSprites) {
                sprite.visible = false;
            }

        }
    }

    // Restore original camera settings
    PlayState.instance.defaultCamZoom = originalZoom;
    PlayState.instance.camFollow.x = originalCamFollowX;
    PlayState.instance.camFollow.y = originalCamFollowY;

}

function onEvent(event:ScriptEvent) {
    if (event.event.name == "ChangeStage") {
        var stageName:String = event.event.params[0];

        // Remove existing stage sprites
        for (sprite in stage.stageSprites) {
            remove(sprite);
        }

        // Use the preloaded stage
        var newStage = new Stage(stageName);
        add(stage = newStage);

        // Reinsert characters at the correct depth
        for (strumLine in strumLines.members) {
            for (char in strumLine.characters) {
                remove(char, false);
                insert(members.indexOf(stage), char);
            }
        }


        var dadPos = new StageCharPos();
        dadPos.x = stage.characterPoses["dad"].x;
        dadPos.y = stage.characterPoses["dad"].y;
        dadPos.camxoffset = stage.characterPoses["dad"].camxoffset;
        dadPos.camyoffset = stage.characterPoses["dad"].camyoffset;
        dadPos.prepareCharacter(dad);

        var bfPos = new StageCharPos();
        bfPos.x = stage.characterPoses["boyfriend"].x;
        bfPos.y = stage.characterPoses["boyfriend"].y;
        bfPos.camxoffset = stage.characterPoses["boyfriend"].camxoffset;
        bfPos.camyoffset = stage.characterPoses["boyfriend"].camyoffset;
        bfPos.prepareCharacter(boyfriend);

        if (gf != null) {
            var gfPos = new StageCharPos();
            gfPos.x = stage.characterPoses["girlfriend"].x;
            gfPos.y = stage.characterPoses["girlfriend"].y;
            gfPos.camxoffset = stage.characterPoses["girlfriend"].camxoffset;
            gfPos.camyoffset = stage.characterPoses["girlfriend"].camyoffset;
            gfPos.prepareCharacter(gf);
        }
        

        
            
    }
}

