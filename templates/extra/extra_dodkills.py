import host
import realityadmin as radmin
import realitycore as rcore
import realityzones as rzones


def init():
    host.registerHandler('PlayerEnemyKilled', onPlayerEnemyKilled)


def onPlayerEnemyKilled(victim, attacker, weapon, assists, obj):
    if attacker == victim:  # Is a suicide
        return

    team = victim.getTeam()
    if len(rzones.getPointDODs(victim.getPosition(), team, (rzones.ALL,))) == 0:
        return

    if attacker.getVehicle() and victim.getVehicle():
        distance = int(
            rcore.getVectorDistance(
                attacker.getVehicle().getPosition(),
                victim.getVehicle().getPosition()
            )
        )

        team = victim.getTeam()
        if rzones.getPointDODs(victim.getPosition(), team, (rzones.ALL,)):
            radmin.adminPM("DODKILL: %s [%s : %s m] %s" % (
                attacker.getName(), weapon, distance, victim.getName()
            ), None, history=False)
