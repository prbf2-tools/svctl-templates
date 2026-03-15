import bf2
import host
import realityadmin as radmin
import realitygamemode as rgamemode
import realitycore as rcore
import realitytimer as rtimer
import realityserver


g_first_flags = {1: None, 2: None}

PROTECTION_TIME = {{ .Values.firstFlag.protectionTime }}


def init():
    host.registerGameStatusHandler(onGameStatusChanged)


def onGameStatusChanged(status):
    if status == bf2.GameStatus.Playing:
        if rgamemode.getCurrentGameModeType() != "aas":
            return

        unregisterHandlers()
        buildFirstFlags()

        host.registerHandler('EnterControlPoint', onEnterControlPoint)
        host.registerHandler('PlayerEnemyKilled', onPlayerEnemyKilled)

        rtimer.fireOnce(unregisterHandlers, realityserver.C(
            'STARTDELAY') + PROTECTION_TIME)


def unregisterHandlers(data=None):
    host.unregisterHandler(onEnterControlPoint)
    host.unregisterHandler(onPlayerEnemyKilled)


def buildFirstFlags():
    global g_first_flags
    g_first_flags = {1: None, 2: None}

    sgids = []
    for cp in rcore.getControlPoints():
        if cp.cp_getParam('unableToChangeTeam') == 1:
            continue
        sgids.append(cp.sgid)

    if not sgids:
        return

    sgids = sorted(sgids)

    # Team 1 advances from low sgid toward high sgid:
    # their first flag to capture is the lowest sgid group
    # Team 2 advances from high sgid toward low sgid:
    # their first flag to capture is the highest sgid group
    g_first_flags[1] = sgids[0]
    g_first_flags[2] = sgids[-1]


def onEnterControlPoint(player, cp):
    team = player.getTeam()

    gpm = rgamemode.getCurrentGameMode()

    if cp.cp_getParam('team') == team:
        return

    enemyTeam = 1 if team == 2 else 2

    if cp.sgid != g_first_flags[enemyTeam]:
        return

    if gpm.isCPCapturableByTeam(cp, team):
        return

    # Player entered the first flag of the opposing team's main base side
    radmin.adminPM("FIRSTFLAG: %s (%s, %s) entered first flag %s" % (
        player.getName(), rcore.getTeamName(team), player.getSquadId(), cp.text
    ), None, history=False)


def onPlayerEnemyKilled(victim, attacker, weapon, assists, obj):
    victimTeam = victim.getTeam()
    attackerTeam = attacker.getTeam()

    gpm = rgamemode.getCurrentGameMode()

    victimCP = gpm.getOccupyingCP(victim)
    if not victimCP:
        return

    if gpm.isCPCapturableByTeam(victimCP, attackerTeam):
        return

    if victimCP.sgid != g_first_flags[victimTeam]:
        return

    if attacker.getVehicle() and victim.getVehicle():
        distance = int(
            rcore.getVectorDistance(
                attacker.getVehicle().getPosition(),
                victim.getVehicle().getPosition()
            )
        )

        radmin.adminPM("FIRSTFLAGKILL: %s [%s : %s m] %s" % (
            attacker.getName(), weapon, distance, victim.getName()
        ), None, history=False)
