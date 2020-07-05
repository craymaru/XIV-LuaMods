local cray_tweaks = {}
cray_tweaks.GUI = {
	open = false,
	visible = true,
}
cray_tweaks.smartLegacyMovement = {
	botRan = true,
	assistRan = true,
}


function cray_tweaks.Init()
	ml_gui.ui_mgr:AddMember({ id = "FFXIVMINION##MENU_CrayTweaks", name = "CrayTweaks", onClick = function() cray_tweaks.GUI.open = not cray_tweaks.GUI.open end, tooltip = "Open the CrayTweaks settings."},"FFXIVMINION##MENU_HEADER")
	
	ctTestValue = ffxivminion.GetSetting("ctTestValue", true)
	ctNeverSkipCutscene = ffxivminion.GetSetting("ctNeverSkipCutscene", true)
	ctNeverSkipTalk = ffxivminion.GetSetting("ctNeverSkipTalk", true)
	ctSmartLegacyMovement = ffxivminion.GetSetting("ctSmartLegacyMovement", true)
end



function cray_tweaks.OnUpdate( event, tickcount )

	if ctNeverSkipCutscene and gSkipCutscene == true then
		gSkipCutscene = false
	end

	if ctNeverSkipTalk and gSkipTalk == true then
		gSkipTalk = false
	end

	function setLegacyMovement()
		gAssistUseLegacy = true
		ml_global_information.GetMovementInfo(false)
	end

	if ctSmartLegacyMovement then

		if ( not cray_tweaks.smartLegacyMovement.assistRan ) and ( FFXIV_Common_BotRunning ) and ( gBotMode == GetString("assistMode") ) then
			setLegacyMovement()
			cray_tweaks.smartLegacyMovement.assistRan = true
		end

		if ( cray_tweaks.smartLegacyMovement.assistRan ) and ( not FFXIV_Common_BotRunning ) and ( gBotMode == GetString("assistMode") ) then
			setLegacyMovement()
			cray_tweaks.smartLegacyMovement.assistRan = false
		end

		if not cray_tweaks.smartLegacyMovement.botRan then
			if FFXIV_Common_BotRunning and gBotMode ~= GetString("assistMode") then
				cray_tweaks.smartLegacyMovement.botRan = true
			end
		end

		if cray_tweaks.smartLegacyMovement.botRan and not FFXIV_Common_BotRunning then
			setLegacyMovement()
			cray_tweaks.smartLegacyMovement.botRan = false
		end
	end

end
 
function cray_tweaks.Draw( event, ticks ) 	
 
	if ( cray_tweaks.GUI.open ) then	
        GUI:SetNextWindowSize(200,200,GUI.SetCond_FirstUseEver)
 
		cray_tweaks.GUI.visible, cray_tweaks.GUI.open = GUI:Begin("CrayTweaks", cray_tweaks.GUI.open)
 
		if ( cray_tweaks.GUI.visible ) then
			
			GUI_Capture(GUI:Checkbox(GetString("Smart Legacy Movement"),ctSmartLegacyMovement),"ctSmartLegacyMovement")
			if (GUI:IsItemHovered()) then
				GUI:SetTooltip("This option sets automatically turn on Legacy movement mode when the bot is off. (Even in assault mode.)")
			end

			GUI:Spacing();
			GUI:Separator();
			GUI:Spacing();

			GUI_Capture(GUI:Checkbox(GetString("Never Skip Cutscene"),ctNeverSkipCutscene),"ctNeverSkipCutscene")
			if (GUI:IsItemHovered()) then
				GUI:SetTooltip("This option sets automatically turn off Skip Cutscene when it turn on. (Please turn on Allow Cutscene Watching in Letty's Addon)")
			end
			GUI_Capture(GUI:Checkbox(GetString("Never Skip Dialog"),ctNeverSkipTalk),"ctNeverSkipTalk")
			if (GUI:IsItemHovered()) then
				GUI:SetTooltip("This option sets automatically turn off Skip Dialog when it turn on. (Please turn on Allow Dialog Watching in Letty's Addon)")
			end
			GUI_Capture(GUI:Checkbox(GetString("Skip Cutscene"),gSkipCutscene),"gSkipCutscene", function () Hacks:SkipCutscene(gSkipCutscene) end)
			GUI_Capture(GUI:Checkbox(GetString("Skip Dialog"),gSkipTalk),"gSkipTalk")

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
