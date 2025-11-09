import funkin.backend.system.framerate.Framerate;

function preStateSwitch() {
    Framerate.codenameBuildField.text = 'INTERSTELLAR ADVENTURE';
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;
	data.button1Label = data.button1Url = '';
}