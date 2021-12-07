#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

static const char g_sIndex[][] = {
	"b", 
	"b", 
	"c", 
	"d", 
	"e", 
	"h", 
	"j", 
	"k", 
	"m", 
	"o", 
	"s", 
	"w", 
	"z", 
	"o", 
	"l", 
	"i", 
	"g", 
	"e", 
	"d", 
	"c", 
	"c", 
	"b", 
	"b", 
	"b",
};

ConVar g_cvSkyName;

public Plugin myinfo =
{
	name	=	"Dynamic Map Light",
	author	=	"OkyHp",
	version	=	"1.0.0",
	url		=	"OkyHek#2441"
};

public void OnPluginStart()
{
	g_cvSkyName = FindConVar("sv_skyname");

	AddCommandListener(OnChangeTeam, "jointeam");
}

public void OnMapStart()
{
	int iEnt = -1;

	while ((iEnt = FindEntityByClassname(iEnt, "env_cascade_light")) != -1) 
	{ 
		AcceptEntityInput(iEnt, "Kill");
	}

	while ((iEnt = FindEntityByClassname(iEnt, "env_sun")) != -1)
	{
		AcceptEntityInput(iEnt, "TurnOff");
	}

	char szBuffer[64];
	FormatTime(szBuffer, sizeof(szBuffer), "%H");
	int iTime = StringToInt(szBuffer);

	if (iTime > 22 || iTime < 1)
	{
		strcopy(szBuffer, sizeof(szBuffer), "sky_csgo_cloudy01");
	}
	else if (iTime > 19 || iTime < 4)
	{
		strcopy(szBuffer, sizeof(szBuffer), "sky_csgo_night02b");
	}
	else if (iTime > 17 || iTime < 6)
	{
		strcopy(szBuffer, sizeof(szBuffer), "sky_csgo_night02");
	}
	else if (iTime > 16 || iTime < 8)
	{
		strcopy(szBuffer, sizeof(szBuffer), "cs_baggage_skybox_");
	}
	else
	{
		strcopy(szBuffer, sizeof(szBuffer), "sky_day02_05");
	}
	
	g_cvSkyName.SetString(szBuffer);
	SetLightStyle(0, g_sIndex[iTime]);
}

Action OnChangeTeam(int iClient, const char[] szCommand, int iArg)
{
	SetEntProp(iClient, Prop_Send, "m_skybox3d.area", 255);
	return Plugin_Continue;
}