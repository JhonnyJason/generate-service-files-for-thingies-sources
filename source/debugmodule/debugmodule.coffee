debugmodule = {name: "debugmodule"}

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
debugmodule.initialize = () ->
    return
    console.log "debugmodule.initialize - nothing to do"

debugmodule.modulesToDebug = 
    unbreaker: true
    # cliargumentsmodule: true
    # genconfigprocessmodule: true
    # nginxconfigmodule: true
    # pathhandlermodule: true
    # startupmodule: true

#region exposed variables

module.exports = debugmodule