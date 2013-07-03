component {

	public void function init(required String id, required Struct config, required DirectoryListener listener) {
		variables.state = "stopped"
		variables.id = arguments.id
		variables.config = arguments.config
		variables.listener = arguments.listener

		variables.methods = {
			ENTRY_CREATE: "entryCreated",
			ENTRY_MODIFY: "entryModified",
			ENTRY_DELETE: "entryDeleted"
		}
	}

	public void function start() {

		if (variables.state != "running") {
			// when restart() is called, we enter this loop until the previous execution has ended
			while (variables.state == "stopping") {
				Sleep(10)
			}
			variables.watcher = new DirectoryWatcher(config.directory, config.recursive)
			variables.state = "running"

			while (variables.state == "running") {
				var events = variables.watcher.poll()
				if (!events.isEmpty()) {
					for (var event in events) {
						var method = variables.methods[event.type]
						variables.listener[method](event.file)
					}
				}

				// sleep until the next run, but cut it into half seconds, so we can stop the gateway easily
				var sleepStep = 500
				var time = 0
				while (time < variables.config.interval) {
					sleepStep = Min(sleepStep, variables.config.interval - time)
					time += sleepStep
					Sleep(sleepStep)
					if (variables.state != "running") {
						break;
					}
				}
			}
			variables.watcher.close()
		}
	}

	public void function stop() {
		if (!IsNull(variables.watcher)) {
			variables.state = "stopping"
		}
	}

	public void function restart() {
		if (variables.state == "running") {
			stop()
		}
		start()
	}

	public String function getState() {
		return variables.state
	}

	public String function sendMessage(required Struct data) {
		Throw("Not supported")
	}

}