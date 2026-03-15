import bf2
import host
import realityadmin as radmin
import realitycore as rcore
import realitytimer as rtimer
import realityserver


g_first_flags = {1: [], 2: []}

PROTECTION_TIME = 10 * 60  # 10 minutes


def init():
    host.registerGameStatusHandler(onGameStatusChanged)


def onGameStatusChanged(status):
    if status == bf2.GameStatus.Playing:
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
    g_first_flags = {1: [], 2: []}

    sgid_groups = {}
    for cp in rcore.getControlPoints():
        if cp.cp_getParam('unableToChangeTeam') == 1:
            continue
        sgid_groups.setdefault(cp.sgid, []).append(cp.sgid)

    if not sgid_groups:
        return

    sgids = sorted(sgid_groups.keys())

    # Team 1 advances from low sgid toward high sgid:
    # their first flag to capture is the lowest sgid group
    # Team 2 advances from high sgid toward low sgid:
    # their first flag to capture is the highest sgid group
    g_first_flags[1] = sgid_groups[sgids[0]]
    g_first_flags[2] = sgid_groups[sgids[-1]]


def onEnterControlPoint(player, cp):
    team = player.getTeam()

    if cp.cp_getParam('team') == team:
        return

    enemyTeam = 1 if team == 2 else 2

    if cp.sgid not in g_first_flags[enemyTeam]:
        return

    if cp.cp_getParam('allowCaptureByTeam', team):
        return

    # Player entered the first flag of the opposing team's main base side
    squad = player.getSquadId()
    radmin.adminPM("FIRSTFLAG: %s [team %s sq %s] entered first flag %s" % (
        player.getName(), team, squad, cp.templateName
    ), None, history=False)


def onPlayerEnemyKilled(victim, attacker, weapon, assists, obj):
    victimTeam = victim.getTeam()
    attackerTeam = attacker.getTeam()

    try:
        victimCP = victim.insideCP
        if victimCP is None:
            return
    except:
        return

    if victimCP.sgid not in g_first_flags[victimTeam]:
        return

    if victimCP.cp_getParam('allowCaptureByTeam', attackerTeam):
        return

    try:
        attackerVehicle = attacker.getVehicle()
        victimVehicle = victim.getVehicle()
    except:
        return

    distance = int(
        rcore.getVectorDistance(
            attackerVehicle.getPosition(),
            victimVehicle.getPosition()
        )
    )

    radmin.adminPM("FIRSTFLAGKILL: %s [%s : %s m] %s" % (
        attacker.getName(), weapon, distance, victim.getName()
    ), None, history=False)
