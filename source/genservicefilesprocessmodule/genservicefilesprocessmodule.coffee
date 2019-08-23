genservicefilesprocessmodule = {name: "genservicefilesprocessmodule"}

#region node_modules
fs = require "fs"
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["genservicefilesprocessmodule"]?  then console.log "[genservicefilesprocessmodule]: " + arg
    return

#region internal variables
pathHandler = null
serviceFileGen = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
genservicefilesprocessmodule.initialize = () ->
    log "genservicefilesprocessmodule.initialize"
    pathHandler = allModules.pathhandlermodule
    serviceFileGen = allModules.servicefilegenmodule


#region internal functions
processAllThingies = () ->
    log "processAllThingies"
    requirePath = pathHandler.getConfigRequirePath() 
    config = require(requirePath)
    
    promises = (serviceFileGen.generateForThingy(thingy) for thingy in config.thingies)
    await Promise.all(promises)    

#endregion

#region exposed functions
genservicefilesprocessmodule.execute = (configPath, outputDirectory) ->
    log "genservicefilesprocessmodule.execute"
    await pathHandler.setConfigFilePath(configPath)
    await pathHandler.setOutputDirectory(outputDirectory)
    await processAllThingies()
    return true
#endregion

module.exports = genservicefilesprocessmodule
