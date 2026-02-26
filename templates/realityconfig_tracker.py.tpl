# ========================================================================================================
#
# PROJECT REALITY SERVER SETTINGS DEFINITION FOR THE REALITYTRACKER SCRIPT
#
# This file can be fully edited and it's automatically used by local and single-player servers.
#
#
#
C = {}

{{- with .Values.tracker }}
# Set to false to completely disable the tracker
C['ENABLE'] = {{ pyBool .enabled }}

# TRACKER UPDATE INTERVAL
# Every [UPDATE_INTERVAL] the server calls an update that function that collects all the relevant
# data from the server and writes it to a file
C['UPDATE_INTERVAL'] = {{ .interval }}


# ================= Local work mode settings

# Folder to write incomplete recordings into. Keep folder private to prevent ghosting!
C['TMP_FOLDER'] = '{{ .tmpFolder }}'


# FILE NAME
# available parameters:
# - '/map' '/mode' '/layer'
# - date related strings that are parsed by strftime (
# https://docs.python.org/2/library/datetime.html#strftime-strptime-behavior)
C['FILE_NAME'] = '{{ .filename }}'


# ========PUBLIC TRACKER FILE
C['TRACKER_FILE_PUBLIC'] = {{ pyBool .public.enabled }}

# Folder to move complete public recordings into.
C['PUBLIC_FOLDER'] = '{{ .public.path }}'

# Public file private data selection:

# Write player's IP to the public file.
C['FILE_PRIVATEDATA_IP'] = {{ pyBool .public.writeIPs }}
# Write player's HASH to the public file.
C['FILE_PRIVATEDATA_HASH'] = {{ pyBool .public.writeHashes }}

# Enable any chat recording
C['CHAT_ENABLE'] = {{ pyBool .public.chat.enabled }}
# Enable Team chat recording
C['CHAT_TEAM'] = {{ pyBool .public.chat.team }}
# Enable squad chat recording
C['CHAT_SQUAD'] = {{ pyBool .public.chat.squad }}


# ==== PRIVATE TRACKER FILE
# Create an extra file without filtering any private information
C['TRACKER_FILE_PRIVATE'] = {{ pyBool .private.enabled }}
C['PRIVATE_FOLDER'] = '{{ .private.path }}'

# ===== JSON Summary
# Write a summary at end of round.
C['JSON_ENABLE'] = {{ pyBool .json.enabled }}
# Folder for the JSON files. This must be set to something if JSON is enabled.
C['JSON_FOLDER'] = '{{ .json.path }}'

C['JSON_WRITE_IP'] = {{ pyBool .json.writeIPs }}
C['JSON_WRITE_HASH'] = {{ pyBool .json.writeHashes }}

# ===== Advanced options
# Flush to file every recording tick, useful if you're having another program read the file.
C['OUTPUT_FLUSH_EVERY_TICK'] = {{ pyBool .flushEveryTick }}

# Work in progress, doesn't work:

# ===== Networking work mode settings
# TRACKER NETWORKING
# Specify if you want to run the tracker with a remote connection
C['TRACKER_NETWORKING'] = False

# TRACKER TCP SERVER PORT
# Edit this setting to set the port that the server will listen to.
# If you change this setting to anything other than None it will be used instead.
C['SERVER_PORT'] = 6669
{{- end }}
