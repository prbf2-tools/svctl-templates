rem Name of the server for the server list
sv.serverName {{ .Values.name | quote }}
rem Password for joining the server
sv.password {{ .Values.password | quote }}
rem 1 for internet servers, 0 for everything else
sv.internet {{ .Values.internet }}
rem IPv4 of the server
sv.serverIP {{ .Values.ip | quote }}
rem Port of the server
sv.serverPort {{ .Values.portGame }}
rem Port to query server information
sv.gameSpyPort {{ .Values.portGamespy }}
rem IPv4:Port of the mumble server to use. Leave empty to disable mumble
sv.voipServerRemoteIP {{ if .Values.murmurIP }}{{ printf "%s:%d" .Values.murmurIP .Values.murmurPort | quote }}{{ else }}""{{ end }}
rem Message displayed in loading screen
sv.welcomeMessage {{ .Values.welcomeMessage | quote }}
rem Message displayed in server browser. User '|' for line breaks and add 'pr_maplist' to add next maps in rotation
sv.sponsorText {{ .Values.sponsorText | quote }}
rem Logo displayed in server browser
sv.sponsorLogoURL {{ .Values.sponsorLogoURL | quote }}
rem Logo displayed in server browser
sv.communityLogoURL {{ .Values.communityLogoURL | quote }}

sv.allowFreeCam 0
sv.allowExternalViews 0
sv.allowNoseCam 0
sv.hitIndicator 0
sv.maxPlayers {{ .Values.maxPlayers }}
sv.numPlayersNeededToStart 1
sv.notEnoughPlayersRestartDelay 15
sv.ticketRatio 100
sv.roundsPerMap 1
sv.timeLimit 0
sv.scoreLimit 0
sv.soldierFriendlyFire 100
sv.vehicleFriendlyFire 100
sv.soldierSplashFriendlyFire 100
sv.vehicleSplashFriendlyFire 100
sv.tkPunishEnabled 1
sv.tkNumPunishToKick 3
sv.tkPunishByDefault 0
sv.votingEnabled {{ .Values.votingEnabled }}
sv.voteTime 90
sv.minPlayersForVoting 1
sv.allowNATNegotiation 0
sv.autoRecord {{ .Values.demoEnabled }}
sv.demoIndexURL {{ .Values.demoIndexURL }}
sv.demoDownloadURL {{ .Values.demoDownloadURL }}
sv.autoDemoHook "adminutils/demo/rotate_demo.exe"
sv.demoQuality {{ .Values.demoQuality }}
sv.timeBeforeRestartMap 30
sv.autoBalanceTeam 0
sv.teamRatioPercent 100
sv.coopBotRatio 50
sv.coopBotCount 48
sv.coopBotDifficulty 90
sv.useGlobalRank 1
sv.useGlobalUnlocks 1
sv.radioSpamInterval 6
sv.radioMaxSpamFlagCount 6
sv.radioBlockedDurationTime 30

{{- with .Values.reservedSlotsNum }}
sv.NumReservedSlots {{ . }}
{{- end }}

rem DO NOT MODIFY
sv.adminScript ""

rem NOT SUPPORTED
sv.startDelay 15
sv.endDelay 15
sv.spawnTime 10
sv.manDownTime 10
sv.endOfRoundDelay 15
sv.punkBuster 0
sv.voipEnabled 0
sv.voipQuality 3
sv.interfaceIP ""
sv.voipServerRemote 0
sv.voipServerPort 55125
sv.voipBFClientPort 55123
sv.voipBFServerPort 55124
sv.voipSharedPassword ""
