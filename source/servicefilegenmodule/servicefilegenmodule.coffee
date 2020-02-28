servicefilegenmodule = {name: "servicefilegenmodule"}

#region node_modules
fs = require("fs").promises
c = require("chalk")
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["servicefilegenmodule"]?  then console.log "[servicefilegenmodule]: " + arg
    return


#region internal variables
errLog = (arg) -> console.log(c.red(arg))
successLog = (arg) -> console.log(c.green(arg))
pathHandler = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
servicefilegenmodule.initialize = () ->
    log "servicefilegenmodule.initialize"
    pathHandler = allModules.pathhandlermodule

#region internal functions
generateDescriptionLine = (thingy) ->
    log "generateDescriptionLine"
    result = ""
    result += "Description=A thingy service in it's thingy ecosystem :-)\n"
    return result

generatePermissionLine = (thingy) ->
    log "generatePermissionLine"
    result = ""
    result += "User=" + thingy.homeUser + "\n"
    result += "Group=" + thingy.homeUser + "\n"
    return result

generateExecutionLine = (thingy) ->
    log "generateExecutionLine"
    result = ""
    result += "ExecStart=/usr/bin/node "
    result += "/home/" + thingy.homeUser + "/" + thingy.repository + "/service.js\n"
    result += "WorkingDirectory=/home/" + thingy.homeUser + "/" + thingy.repository + "\n"
    return result

generateInstallerExecutionLine = (thingy) ->
    log "generateInstallerExecutionLine"
    result = ""
    result += "ExecStart=/usr/bin/node "
    result += "/root/" + thingy.repository + "/installer.js update\n"
    result += "WorkingDirectory=/root/" + thingy.repository + "\n"
    return result

generateEnvironmentLine = (thingy) ->
    log "generateEnvironmentLine"
    result = ""
    if thingy.socket
        result += "Environment=SOCKETMODE=true\n"
    else if thingy.port
        result += "Environment=PORT=" + thingy.port + "\n"
    else throw new Error("Neither socket nor port was defined!")
    return result

generateControlLine = (thingy) ->
    log "generateControlLine"
    result = ""
    if thingy.oneshot
        result += "Type=oneshot\n"
        result += "Restart=no\n"
    else
        result += "Restart=always\n"
    return result

generateInstallerServiceFile = (thingy) ->
    log "generateInstallerServiceFile"
    if !(thingy.homeUser == "root") then throw new Error("Installer homeUser is not root!")
    if !thingy.repository then throw new Error("Installer has no repository defined!")
    thingy.oneshot = true
    fileContent = "[Unit]\n"
    fileContent += generateDescriptionLine(thingy) + "\n"
    fileContent += "[Service]\n"
    fileContent += generatePermissionLine(thingy) + "\n"
    fileContent += generateInstallerExecutionLine(thingy) + "\n"
    fileContent += generateControlLine(thingy) + "\n"
    fileContent += "[Install]\n"
    fileContent += "WantedBy=multi-user.target\n"
    filePath = pathHandler.getServiceOutputPath("installer")
    await fs.writeFile(filePath, fileContent)
    return

generateServiceFile = (thingy) ->
    log "generateServiceFile"
    if !thingy.homeUser then throw new Error("Service thingy has no homeUser defined!")
    if !thingy.repository then throw new Error("Service thingy has no repository defined!")
    fileContent = "[Unit]\n"
    fileContent += generateDescriptionLine(thingy) + "\n"
    fileContent += "[Service]\n"
    fileContent += generatePermissionLine(thingy) + "\n"
    fileContent += generateExecutionLine(thingy) + "\n"
    fileContent += generateEnvironmentLine(thingy) + "\n"
    fileContent += generateControlLine(thingy) + "\n"
    fileContent += "[Install]\n"
    fileContent += "WantedBy=multi-user.target\n"
    filePath = pathHandler.getServiceOutputPath(thingy.homeUser)
    await fs.writeFile(filePath, fileContent)
    return

generateSocketFile = (thingy) ->
    return unless thingy.socket
    log "generateSocketFile"
    fileContent = ""
    fileContent += "[Socket]\n"
    fileContent += "ListenStream=/run/" + thingy.homeUser + ".sk\n\n"
    fileContent += "[Install]\n"
    fileContent += "WantedBy=sockets.target\n"
    filePath = pathHandler.getSocketOutputPath(thingy.homeUser)
    await fs.writeFile(filePath, fileContent)
#endregion

#region exposed functions
servicefilegenmodule.generateForThingy = (thingy) ->
    log "servicefilegenmodule.generateForThingy"
    if thingy.type == "installer" then return await generateInstallerServiceFile(thingy)
    # log "\n" + JSON.stringify(thingy, null, 2)
    return if thingy.type != "service"
    try
        await generateServiceFile(thingy)
        await generateSocketFile(thingy)
        successLog thingy.homeUser  + " - service files generated"
    catch err
        errorMessage = thingy.homeUser + " - could not generate service files"
        errorMessage += "\nReason: " + err 
        errLog errorMessage
#endregion

module.exports = servicefilegenmodule