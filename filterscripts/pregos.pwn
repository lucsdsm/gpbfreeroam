//by JR_Junior

#include <a_samp>

#define TireDano(%1,%2,%3,%4) %1 | (%2 << 1) | (%3 << 2) | (%4 << 3)

#define grey  0xAFAFAFAA
#define white 0xFFFFFFAA

new TapeteCOP[MAX_PLAYERS];
new CrieiTapete[MAX_PLAYERS];
new TempoTapete[MAX_PLAYERS];
new PassandoTapete[MAX_PLAYERS];
new Float:AnguloTapete, Float:TapeteX, Float:TapeteY, Float:TapeteZ;



public OnPlayerDisconnect(playerid, reason) {
    DeletarTapete(playerid);
}

//Se algu�m est� passando pelo tapete soltado
forward FurandoPneu();
public FurandoPneu() {
    for(new i; i < MAX_PLAYERS; i++) {
        new Dano[4];
        if(IsPlayerInAnyVehicle(i)) {
            if(PlayerToPoint(4.0, i,TapeteX,TapeteY,TapeteZ)) {
                //4.0 a dist�ncia ideal entre o ve�culo e o tapete, para furar os pneus
                GetVehicleDamageStatus(GetPlayerVehicleID(i), Dano[0], Dano[1], Dano[2], Dano[3]);
                UpdateVehicleDamageStatus(GetPlayerVehicleID(i), Dano[0], Dano[1], Dano[2], TireDano(1, 1, 1, 1));
                return 1;
            }

        }
            }
    return 0;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
    if (strcmp("/tc", cmdtext, true, 10) == 0) {
        if(CrieiTapete[playerid] == 1) {
            SendClientMessage(playerid, grey, "Voc� j� colocou um tapete de pregos. Remova-o para jogar outro.");
        }
        else {
            GetPlayerPos(playerid,TapeteX,TapeteY,TapeteZ);
            if(IsPlayerInAnyVehicle(playerid)) {
                SendClientMessage(playerid, grey, "Voc� n�o pode jogar um tapete de pregos dentro de um ve�culo.");
            }
            else {
                GetPlayerFacingAngle(playerid, AnguloTapete);
                CrieiTapete[playerid] = 1;
                TapeteCOP[playerid] = CreateObject(2899, TapeteX,TapeteY,TapeteZ-0.9, 0, 0, AnguloTapete+268.0);
                KillTimer(PassandoTapete[playerid]);
                PassandoTapete[playerid] = SetTimer("FurandoPneu",199,1);
                SendClientMessage(playerid, grey, "Tapete de pregos criado.");
            }
            return 1;
        }
    }
    if (strcmp("/tr", cmdtext, true, 10) == 0) {
        if(CrieiTapete[playerid] == 0) {
            SendClientMessage(playerid, grey, "Voc� n�o criou nenhum tapete de pregos.");
            return 1;
        }
        else {
            CrieiTapete[playerid] = 0;
            DestroyObject(TapeteCOP[playerid]);
            KillTimer(TempoTapete[playerid]);
            KillTimer(PassandoTapete[playerid]);
            //Evita que os pneus sejam furados depois que o Tapete for retirado!
            TapeteX = 0.000000, TapeteY = 0.000000, TapeteZ = 0.000000;
            SendClientMessage(playerid, grey, "Tapete de pregos removido.");
        }
        return 1;
    }
    return 0;
}


forward DeletarTapete(playerid);
public DeletarTapete(playerid) {
    if(CrieiTapete[playerid] == 1) {
        CrieiTapete[playerid] = 0;
        DestroyObject(TapeteCOP[playerid]);
        GameTextForPlayer(playerid,"~y~Tapete de pregos ~n~~r~foi removido",5000,1);
        KillTimer(PassandoTapete[playerid]);
        KillTimer(TempoTapete[playerid]);
        TapeteX = 0.000000, TapeteY = 0.000000, TapeteZ = 0.000000;
    }
    return 1;
}

forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
    {

        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        tempposx = (oldposx -x);
        tempposy = (oldposy -y);
        tempposz = (oldposz -z);
        if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) &&
        (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
        {

            return 1;
        }
    }
    return 0;
}