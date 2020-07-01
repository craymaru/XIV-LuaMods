local cray_tweaks = {}
cray_tweaks.GUI = {
	open = true,
	visible = true,
}
cray_tweaks.neverSkip = {
	cutscene = true,
	talk = true,
}
cray_tweaks.legacySupport = {
	isEnable = true,
	botRan = true
}

function cray_tweaks.Init()
	ml_gui.ui_mgr:AddMember({ id = "FFXIVMINION##MENU_CrayTweaks", name = "CrayTweaks", onClick = function() cray_tweaks.GUI.open = not cray_tweaks.GUI.open end, tooltip = "Open the CrayTweaks settings."},"FFXIVMINION##MENU_HEADER")
end

function cray_tweaks.OnUpdate( event, tickcount )

	if cray_tweaks.neverSkip.cutscene and gSkipCutscene == true then
		gSkipCutscene = false
	end

	if cray_tweaks.neverSkip.talk and gSkipTalk == true then
		gSkipTalk = false
	end

	if not cray_tweaks.legacySupport.botRan and
	FFXIV_Common_BotRunning and
	gBotMode ~= GetString("assistMode")
	then
		cray_tweaks.legacySupport.botRan = true
	end

	if cray_tweaks.legacySupport.isEnable and cray_tweaks.legacySupport.botRan then
		if ( not FFXIV_Common_BotRunning ) or
		( FFXIV_Common_BotRunning and gBotMode == GetString("assistMode") )
		then
			gAssistUseLegacy = true
			ml_global_information.GetMovementInfo(false)
			cray_tweaks.legacySupport.botRan = false
		end
	end

end
 
function cray_tweaks.Draw( event, ticks ) 	
 
	if ( cray_tweaks.GUI.open ) then	
        GUI:SetNextWindowSize(200,200,GUI.SetCond_FirstUseEver)
 
		cray_tweaks.GUI.visible, cray_tweaks.GUI.open = GUI:Begin("CrayTweaks", cray_tweaks.GUI.open)
 
		if ( cray_tweaks.GUI.visible ) then
			cray_tweaks.legacySupport.isEnable = GUI:Checkbox(GetString("Legacy Support"),cray_tweaks.legacySupport.isEnable)
			cray_tweaks.legacySupport.botRan = GUI:Checkbox(GetString("botRan"),cray_tweaks.legacySupport.botRan)

			if (GUI:IsItemHovered()) then
				GUI:SetTooltip("This option sets automatically turn on Legacy movement mode when the bot is off. (Even in assault mode.)")
			end

			GUI_Capture(GUI:Checkbox(GetString("Set Legacy Movement"),gAssistUseLegacy),"gAssistUseLegacy", function () ml_global_information.GetMovementInfo(false) end)
			if (GUI:IsItemHovered()) then
				GUI:SetTooltip("This option sets Legacy movement mode.")
			end

			cray_tweaks.neverSkip.cutscene = GUI:Checkbox(GetString("Never Skip Cutscene"),cray_tweaks.neverSkip.cutscene)
			cray_tweaks.neverSkip.talk = GUI:Checkbox(GetString("Never Skip Dialogue"),cray_tweaks.neverSkip.talk)

			GUI_Capture(GUI:Checkbox(GetString("Skip Cutscene"),gSkipCutscene),"gSkipCutscene", function () Hacks:SkipCutscene(gSkipCutscene) end)
			GUI_Capture(GUI:Checkbox(GetString("Skip Dialogue"),gSkipTalk),"gSkipTalk")

	   end
	   GUI:End()
	end	
end



function cray_tweaks.ToggleMenu()
	cray_tweaks.GUI.open = not cray_tweaks.GUI.open
end

RegisterEventHandler("Module.Initalize",cray_tweaks.Init,"cray_tweaks.Init")
RegisterEventHandler("CrayTweaks.toggle", cray_tweaks.ToggleMenu, "cray_tweaks.ToggleMenu")
RegisterEventHandler("Gameloop.Update",cray_tweaks.OnUpdate, "cray_tweaks.OnUpdate")
RegisterEventHandler("Gameloop.Draw", cray_tweaks.Draw, "cray_tweaks-AnyNameHereToIdentYourCodeInCaseOfError")
