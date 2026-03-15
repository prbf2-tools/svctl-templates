import host
import realityadmin as radmin
import realitycore as rcore
import realityzones as rzones


def init():
    host.registerHandler('PlayerEnemyKilled', onPlayerEnemyKilled)


def onPlayerEnemyKilled(victim, attacker, weapon, assists, obj):
    try:
        attackerVehicle = attacker.getVehicle()
        victimVehicle = victim.getVehicle()
        victimPosition = victimVehicle.getPosition()
    except:
        return

    team = victim.getTeam()
    if len(rzones.getPointDODs(victimPosition, team, (rzones.ALL,))) == 0:
        return

    distance = int(
        rcore.getVectorDistance(
            attackerVehicle.getPosition(),
            victimPosition
        )
    )
    radmin.adminPM("DODKILL: %s [%s : %s m] %s" % (
        attacker.getName(), weapon, distance, victim.getName()
    ), None, history=False)
