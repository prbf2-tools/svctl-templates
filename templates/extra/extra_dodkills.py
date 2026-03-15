import host
import realityadmin as radmin
import realitycore as rcore
import realityzones as rzones


def init():
    host.registerHandler('PlayerEnemyKilled', onPlayerEnemyKilled)


def onPlayerEnemyKilled(victim, attacker, weapon, assists, obj):
    if victim.getVehicle():
        victimPosition = victim.getVehicle().getPosition()
        if rzones.getPointDODs(victimPosition, victim.getTeam(), (rzones.ALL,)):
            return
    else:
        return

    distance = "?"
    if attacker.getVehicle() and victim.getVehicle():
        distance = int(
            rcore.getVectorDistance(
                attacker.getVehicle().getPosition(),
                victim.getVehicle().getPosition()
            )
        )

    radmin.adminPM("DODKILL: %s [%s : %s m] %s" % (
        attacker.getName(), weapon, distance, victim.getName()
    ), None, history=False)
