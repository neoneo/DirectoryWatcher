DirectoryWatcher
================

A directory watcher gateway for Railo that uses the java WatchService API introduced in Java 1.7.

Let your listener cfc implement DirectoryListener. If a file change occurs, the appropriate method receives a File object.

Create the gateway as follows:

    admin action="updateGatewayEntry" type="web" password="{password}"
    startupMode="automatic"
    id="{gateway id}"
    class=""
    cfcpath="mapping.to.DirectoryWatcherGateway"
    listenerCfcPath="mapping.to.Listener"
    custom='#{
        directory="{directory}",
        recursive=true,
        interval=10000
    }#'
    readOnly=false;

It seems the WatchService API reports in intervals of 10 seconds, so setting the interval to less than this will be less useful.

Starting/stopping/restarting the gateway:

    admin action="gateway" type="web" password="{password}"
	id="{gateway id}"
	gatewayaction="start|restart|stop";

Removing the gateway:

	admin action="removeGatewayEntry" type="web" password="{password}"
    id="{gateway id}";
