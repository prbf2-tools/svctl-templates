# ------------------------------------------------------------------
#
# PROJECT REALITY SERVER INIT
#
# This file can be edited by any server (public or private).
#
import realityinit

realityinit.init(False)  # Switch to True if using debugger executables (PRLauncher.exe will automatically modify this value accordingly)

# ------------------------------------------------------------------
# Add your custom script's initilization below
{{- if .Values.acsysCustomTypes }}
try:
    import extra_vehicletypes
except:
    import realitydebug
    realitydebug.errorMessage()
{{- end }}

{{- if and .Values.dodKills .Values.dodKills.enabled }}
try:
    import extra_dodkills
    extra_dodkills.init()
except:
    import realitydebug
    realitydebug.errorMessage()
{{- end }}

{{- if and .Values.firstFlag .Values.firstFlag.enabled }}
try:
    import extra_firstflag
    extra_firstflag.init()
except:
    import realitydebug
    realitydebug.errorMessage()
{{- end }}

{{- if .Values.password }}
  {{- with .Values.debugPlayers }}
import realitydebug

    {{- range . }}
realitydebug.PRDEBUG_DEVS["{{ .name }}"] = {{ .hash | quote }}
    {{- end }}
  {{- end }}
{{- end }}
try:
    {{- range $name, $command := .Values.extraCommands }}
    {{- if $command.enabled }}
    import command_{{ $name }}
    command_{{ $name }}.init()
    {{- end }}
    {{- end }}
    pass
except:
    import realitydebug
    realitydebug.errorMessage()
