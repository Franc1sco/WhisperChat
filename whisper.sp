/*  SM Whisper chat
 *
 *  Copyright (C) 2017 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <colors>


#define DATA "0.1b"

new Handle:Ratio;


public Plugin:myinfo =
{
    name = "SM Whisper chat",
    author = "Franc1sco steam: franug",
    description = "For Whisper chat",
    version = DATA,
    url = "http://steamcommunity.com/id/franug"
};

public OnPluginStart()
{
    

    Ratio = CreateConVar("sm_whisper_distance", "100.0", "Distance for listen whisper.");


    RegConsoleCmd("sm_w", WhisperDo);


    CreateConVar("sm_whisper_version", DATA, "plugin", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	

}

public IsValidClient( client ) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}

public Action:WhisperDo(client, args)
{
        if(!IsValidClient(client))
             return Plugin_Handled;


        if(args < 1) // Not enough parameters
        {
           ReplyToCommand(client, "[SM] use: sm_w <text>");
           return Plugin_Handled;
        }


        if(!IsPlayerAlive(client))
        {
             PrintToChat(client, "\x04[SM_Whisper] \x05you must be alive for use whisper chat.");
             return Plugin_Handled;
        }


	decl String:SayText[192];
        GetCmdArg(1, SayText,sizeof(SayText));
	
	StripQuotes(SayText);


        decl Float:Origin[3],Float:TargetOrigin[3], Float:Distance;
        GetClientAbsOrigin(client, Origin);
        for (new X = 1; X <= MaxClients; X++)
        {
                if(IsValidClient(X) && GetClientTeam(X) != 1 && IsPlayerAlive(X)) 
                {
                    GetClientAbsOrigin(X, TargetOrigin);
                    Distance = GetVectorDistance(TargetOrigin,Origin);
                    if(Distance <= GetConVarFloat(Ratio))
                    { 
                         CPrintToChatEx(X, client, "{default}*WHISPER* {teamcolor}%N: {default}%s", client,SayText);
                    }
                }
        }
        return Plugin_Handled;

}