; Murmur configuration file.
;
; General notes:
; * Settings in this file are default settings and many of them can be overridden
;   with virtual server specific configuration via the Ice or DBus interface.
; * Due to the way this configuration file is read some rules have to be
;   followed when specifying variable values (as in variable = value):
;     * Make sure to quote the value when using commas in strings or passwords.
;        NOT variable = super,secret BUT variable = "super,secret"
;     * Make sure to escape special characters like '\' or '"' correctly
;        NOT variable = """ BUT variable = "\""
;        NOT regex = \w* BUT regex = \\w*

; Path to database. If blank, will search for
; murmur.sqlite in default locations or create it if not found.
database=/murmurdata/mumble-server.sqlite

; Murmur defaults to using SQLite with its default rollback journal.
; In some situations, using SQLite's write-ahead log (WAL) can be
; advantageous.
; If you encounter slowdowns when moving between channels and similar
; operations, enabling the SQLite write-ahead log might help.
;
; To use SQLite's write-ahead log, set sqlite_wal to one of the following
; values:
;
; 0 - Use SQLite's default rollback journal.
; 1 - Use write-ahead log with synchronous=NORMAL.
;     If Murmur crashes, the database will be in a consistent state, but
;     the most recent changes might be lost if the operating system did
;     not write them to disk yet. This option can improve Murmur's
;     interactivity on busy servers, or servers with slow storage.
; 2 - Use write-ahead log with synchronous=FULL.
;     All database writes are synchronized to disk when they are made.
;     If Murmur crashes, the database will be include all completed writes.
sqlite_wal=1

; If you wish to use something other than SQLite, you'll need to set the name
; of the database above, and also uncomment the below.
; Sticking with SQLite is strongly recommended, as it's the most well tested
; and by far the fastest solution.
;
;dbDriver=QMYSQL
;dbUsername=
;dbPassword=
;dbHost=
;dbPort=
;dbPrefix=murmur_
;dbOpts=

; Murmur defaults to not using D-Bus. If you wish to use dbus, which is one of the
; RPC methods available in Murmur, please specify so here.
;
;dbus=system

; Alternate D-Bus service name. Only use if you are running distinct
; murmurd processes connected to the same D-Bus daemon.
;dbusservice=net.sourceforge.mumble.murmur

; If you want to use ZeroC Ice to communicate with Murmur, you need
; to specify the endpoint to use. Since there is no authentication
; with ICE, you should only use it if you trust all the users who have
; shell access to your machine.
; Please see the ICE documentation on how to specify endpoints.
#ice="tcp -h 127.0.0.1 -p 6502"

; Ice primarily uses local sockets. This means anyone who has a
; user account on your machine can connect to the Ice services.
; You can set a plaintext "secret" on the Ice connection, and
; any script attempting to access must then have this secret
; (as context with name "secret").
; Access is split in read (look only) and write (modify)
; operations. Write access always includes read access,
; unless read is explicitly denied (see note below).
;
; Note that if this is uncommented and with empty content,
; access will be denied.

;icesecretread=
icesecretwrite=

; If you want to expose Murmur's experimental gRPC API, you
; need to specify an address to bind on.
; Note: not all builds of Murmur support gRPC. If gRPC is not
; available, Murmur will warn you in its log output.
;grpc="127.0.0.1:50051"
; Specifying both a certificate and key file below will cause gRPC to use
; secured, TLS connections.
;grpccert=""
;grpckey=""

; How many login attempts do we tolerate from one IP
; inside a given timeframe before we ban the connection?
; Note that this is global (shared between all virtual servers), and that
; it counts both successfull and unsuccessfull connection attempts.
; Set either Attempts or Timeframe to 0 to disable.
;autobanAttempts = 10
;autobanTimeframe = 120
;autobanTime = 300

; Specifies the file Murmur should log to. By default, Murmur
; logs to the file 'murmur.log'. If you leave this field blank
; on Unix-like systems, Murmur will force itself into foreground
; mode which logs to the console.
logfile=/murmurdata/logs/server.log

; If set, Murmur will write its process ID to this file
; when running in daemon mode (when the -fg flag is not
; specified on the command line). Only available on
; Unix-like systems.
pidfile=/run/mumble-server/mumble-server.pid

; The below will be used as defaults for new configured servers.
; If you're just running one server (the default), it's easier to
; configure it here than through D-Bus or Ice.
;
; Welcome message sent to clients when they connect.
; If the welcome message is set to an empty string,
; no welcome message will be sent to clients.
welcometext="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"

; Port to bind TCP and UDP sockets to.
port=64738

; Specific IP or hostname to bind to.
; If this is left blank (default), Murmur will bind to all available addresses.
;host=

; Password to join server.
serverpassword={{.Env.SERVER_PASSWORD}}

; Maximum bandwidth (in bits per second) clients are allowed
; to send speech at.
bandwidth=72000

; Maximum number of concurrent clients allowed.
users={{getenv "SERVER_USERS" "100"}}

; Per-user rate limiting
;
; These two settings allow to configure the per-user rate limiter for some
; command messages sent from the client to the server. The messageburst setting
; specifies an amount of messages which are allowed in short bursts. The
; messagelimit setting specifies the number of messages per second allowed over
; a longer period. If a user hits the rate limit, his packages are then ignored
; for some time. Both of these settings have a minimum of 1 as setting either to
; 0 could render the server unusable.
messageburst=5
messagelimit=1

; Respond to UDP ping packets.
;
; Setting to true exposes the current user count, the maximum user count, and
; the server's maximum bandwidth per client to unauthenticated users. In the
; Mumble client, this information is shown in the Connect dialog.
allowping=true

; Amount of users with Opus support needed to force Opus usage, in percent.
; 0 = Always enable Opus, 100 = enable Opus if it's supported by all clients.
;opusthreshold=100

; Maximum depth of channel nesting. Note that some databases like MySQL using
; InnoDB will fail when operating on deeply nested channels.
;channelnestinglimit=10

; Maximum number of channels per server. 0 for unlimited. Note that an
; excessive number of channels will impact server performance
;channelcountlimit=1000

; Regular expression used to validate channel names.
; (Note that you have to escape backslashes with \ )
;channelname=[ \\-=\\w\\#\\[\\]\\{\\}\\(\\)\\@\\|]+

; Regular expression used to validate user names.
; (Note that you have to escape backslashes with \ )
;username=[-=\\w\\[\\]\\{\\}\\(\\)\\@\\|\\.]+

; Maximum length of text messages in characters. 0 for no limit.
;textmessagelength=5000

; Maximum length of text messages in characters, with image data. 0 for no limit.
;imagemessagelength=131072

; Allow clients to use HTML in messages, user comments and channel descriptions?
;allowhtml=true

; Murmur retains the per-server log entries in an internal database which
; allows it to be accessed over D-Bus/ICE.
; How many days should such entries be kept?
; Set to 0 to keep forever, or -1 to disable logging to the DB.
;logdays=31

; To enable public server registration, the serverpassword must be blank, and
; this must all be filled out.
; The password here is used to create a registry for the server name; subsequent
; updates will need the same password. Don't lose your password.
; The URL is your own website, and only set the registerHostname for static IP
; addresses.
; Only uncomment the 'registerName' parameter if you wish to give your "Root" channel a custom name.
;
;registerName=Mumble Server
;registerPassword=secret
;registerUrl=http://www.mumble.info/
;registerHostname=

; If this option is enabled, the server will announce its presence via the
; bonjour service discovery protocol. To change the name announced by bonjour
; adjust the registerName variable.
; See http://developer.apple.com/networking/bonjour/index.html for more information
; about bonjour.
;bonjour=True

; If you have a proper SSL certificate, you can provide the filenames here.
; Otherwise, Murmur will create its own certificate automatically.
{{ $tlsdisabled := env.Getenv "NO_TLS" ""}}
{{- if $tlsdisabled }}
{{- else}}
sslCert=/etc/letsencrypt/live/{{.Env.SERVER_DOMAIN}}/fullchain.pem
sslKey=/etc/letsencrypt/live/{{.Env.SERVER_DOMAIN}}/privkey.pem
{{- end }}

; The sslDHParams option allows you to specify a PEM-encoded file with
; Diffie-Hellman parameters, which will be used as the default Diffie-
; Hellman parameters for all virtual servers.
;
; Instead of pointing sslDHParams to a file, you can also use the option
; to specify a named set of Diffie-Hellman parameters for Murmur to use.
; Murmur comes bundled with the Diffie-Hellman parameters from RFC 7919.
; These parameters are available by using the following names:
;
; @ffdhe2048, @ffdhe3072, @ffdhe4096, @ffdhe6144, @ffdhe8192
;
; By default, Murmur uses @ffdhe2048.
;sslDHParams=@ffdhe2048

; The sslCiphers option chooses the cipher suites to make available for use
; in SSL/TLS. This option is server-wide, and cannot be set on a
; per-virtual-server basis.
;
; This option is specified using OpenSSL cipher list notation (see
; https://www.openssl.org/docs/apps/ciphers.html#CIPHER-LIST-FORMAT).
;
; It is recommended that you try your cipher string using 'openssl ciphers <string>'
; before setting it here, to get a feel for which cipher suites you will get.
;
; After setting this option, it is recommend that you inspect your Murmur log
; to ensure that Murmur is using the cipher suites that you expected it to.
;
; Note: Changing this option may impact the backwards compatibility of your
; Murmur server, and can remove the ability for older Mumble clients to be able
; to connect to it.
;sslCiphers=EECDH+AESGCM:EDH+aRSA+AESGCM:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:AES256-SHA:AES128-SHA

; If Murmur is started as root, which user should it switch to?
; This option is ignored if Murmur isn't started with root privileges.
uname=mumble-server

; If this options is enabled, only clients which have a certificate are allowed
; to connect.
;certrequired=False

; If enabled, clients are sent information about the servers version and operating
; system.
;sendversion=True

; This sets password hash storage to legacy mode (1.2.4 and before)
; (Note that setting this to true is insecure and should not be used unless absolutely necessary)
;legacyPasswordHash=false

; By default a strong amount of PBKDF2 iterations are chosen automatically. If >0 this setting
; overrides the automatic benchmark and forces a specific number of iterations.
; (Note that you should only change this value if you know what you are doing)
;kdfIterations=-1

; You can configure any of the configuration options for Ice here. We recommend
; leave the defaults as they are.
; Please note that this section has to be last in the configuration file.
;
[Ice]
Ice.Warn.UnknownProperties=1
Ice.MessageSizeMax=65536
