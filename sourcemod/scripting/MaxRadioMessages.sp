#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define GAMEDATA_FILE   "MaxRadioMessages.games"

public Plugin myinfo =
{
	name        = "MaxRadioMessages",
	author      = "Lojka",
	description = "Sets a custom limit on max allowed radio messages per player's spawn",
	version     = "1.0.0",
	url         = "https://github.com/L0jk4/MaxRadioMessages"
};

ConVar g_cv_MaxRadioMessages;
Address g_Addr_MaxRadioMessages;

public void OnPluginStart()
{
	GameData hGameData = new GameData(GAMEDATA_FILE);
	if (hGameData == null)
	{
	    delete hGameData;
		SetFailState("Could not load gamedata \"%s\"", GAMEDATA_FILE);
	}

	g_Addr_MaxRadioMessages = hGameData.GetAddress("MaxRadioMessages");
	delete hGameData;
	if (g_Addr_MaxRadioMessages == Address_Null)
		SetFailState("Failed to get \"MaxRadioMessages\" address");
	
	g_cv_MaxRadioMessages = CreateConVar("max_radio_messages", "133337", "Max radio messages per player's spawn");
	HookConVarChange(g_cv_MaxRadioMessages, MaxRadioMessages_ChangeCallback);

	StoreToAddress(g_Addr_MaxRadioMessages, g_cv_MaxRadioMessages.IntValue, NumberType_Int32);
}

void MaxRadioMessages_ChangeCallback(ConVar convar, const char[] oldValue, const char[] newValue)
{
	PrintToServer("[SM] max_radio_messages set to %d\n", g_cv_MaxRadioMessages.IntValue);
	StoreToAddress(g_Addr_MaxRadioMessages, g_cv_MaxRadioMessages.IntValue, NumberType_Int32);
}