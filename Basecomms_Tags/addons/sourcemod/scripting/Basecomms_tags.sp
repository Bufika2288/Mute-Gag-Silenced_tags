#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Levi2288"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <basecomm>
//#include <sdkhooks>

ConVar Cvar_muted;
ConVar Cvar_gagged;
ConVar Cvar_silenced;

public Plugin myinfo = 
{
	name = "Basecomms_tags",
	author = PLUGIN_AUTHOR,
	description = "Add Muted/Gagged tag to players (Basecomms edition)",
	version = PLUGIN_VERSION,
	url = ""
};

public OnPluginStart()
{

	RegConsoleCmd("sm_refreshtags", Refresh_Tags, "Refresh the tags");
	Cvar_muted = CreateConVar("bt_muted", "[Muted]", "Tag to display if client muted default [Muted]");
	Cvar_gagged = CreateConVar("bt_gagged", "[Gagged]", "Tag to display if client gagged default [Gagged]");
	Cvar_silenced = CreateConVar("bt_silenced", "[Silenced]", "Tag to display if client sileneced default [Silenced]");
	AutoExecConfig(true, "Basecomm_tags");
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
	
	blnGagged = BaseComm_IsClientGagged(client);
	blnMuted = BaseComm_IsClientMuted(client);
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








