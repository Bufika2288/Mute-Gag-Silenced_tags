#pragma semicolon 1

#define DEBUG

#define AUTHOR "Levi2288"
#define VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sourcecomms>
//#include <sdkhooks>

ConVar Cvar_muted;
ConVar Cvar_gagged;
ConVar Cvar_silenced;

public Plugin myinfo = 
{
	name = "Sourcecomms_tags",
	author = AUTHOR,
	description = "Add Muted/Gagged tag to players (Sourcecomms edition)",
	version = VERSION,
	url = ""
};

public OnPluginStart()
{

	RegConsoleCmd("sm_refreshtags", Refresh_Tags, "Refresh the tags");
	Cvar_muted = CreateConVar("bt_muted", "[Muted]", "Tag to display if client muted");
	Cvar_gagged = CreateConVar("bt_gagged", "[Gagged]", "Tag to display if client gagged");
	Cvar_silenced = CreateConVar("bt_silenced", "[Silenced]", "Tag to display if client sileneced");
	AutoExecConfig(true, "Sourcecomm_tags");
	// HookEvent("round_start", Event_round_start);
	//LoadTranslations("common.phrases");

	CreateTimer(3.0, Timer_RefreshTags, _, TIMER_REPEAT);
}

public Action Timer_RefreshTags(Handle timer) 
{
	bool blnReturn;
	blnReturn = Refresh_Tags_By_Timer();
}


public bool Refresh_Tags_By_Timer ()
{
	
	for (int intCurrentPlayer = 1; intCurrentPlayer  <= MaxClients; intCurrentPlayer++) {	
		
		if (IsClientInGame(intCurrentPlayer) && !IsFakeClient(intCurrentPlayer)) {
			
		Refresh_Tags(intCurrentPlayer, 0);	
		
		}
	}
		
	return true;
} 


Action Refresh_Tags (int client, int args)
{
	bool blnMuted, blnGagged;
	char strTag[MAX_NAME_LENGTH];
	char Tag_muted[32];
	char Tag_gagged[32];
	char Tag_silenced[32];
	
	//Cvar_muted[index].GetString(Tag_muted, sizeof(Tag_muted));
	GetConVarString(Cvar_muted, Tag_muted, sizeof(Tag_muted));
	GetConVarString(Cvar_gagged, Tag_gagged, sizeof(Tag_gagged));
	GetConVarString(Cvar_silenced, Tag_silenced, sizeof(Tag_silenced));
	
	
	blnGagged = SourceComms_GetClientGagType(intClient);
	blnMuted = SourceComms_GetClientMuteType(intClient);
	CS_GetClientClanTag(client, strTag, sizeof(strTag));
	
	
		
	if (blnMuted && ! blnGagged)
	{
		if (StrContains(strTag, Tag_muted, true) == -1) {
			CS_SetClientClanTag(client, Tag_muted);
		}
	}
			
	else if (! blnMuted && blnGagged)
	{		
		
		if (StrContains(strTag, Tag_gagged, true) == -1) {
			CS_SetClientClanTag(client, Tag_gagged);
		}
	}
	
	else if (blnMuted && blnGagged)
	{		
		
		if (StrContains(strTag, Tag_silenced, true) == -1) {
			CS_SetClientClanTag(client, Tag_silenced);
		}	
	}
	
	else
	{
		if (!StrEqual(strTag, "")) {
			CS_SetClientClanTag(client, "");
		}
	}
}
