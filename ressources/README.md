# generate-service-files-for-thingies - Small cli which generates the appropriate service files for systemd.

# Why?
The toolset for the machine thingy requires such a tool.

# What?
generate-service-files-for-thingies - which generates the appropriate service and socket files for the service thingies on a machine. 

Made for the machine thingy toolset to have the appropriate service files available.  

# How?
Requirements
------------
* [Node.js installed](https://nodejs.org/) ^^nona

Installation
------------

Current git version
``` sh
$ npm install git+https://github.com/JhonnyJason/generate-service-files-for-thingies-output.git
```
Npm Registry
``` sh
$ npm install generate-service-files-for-thingies
```

Usage
-----
Just call the script and provide an first argument being the path to the machine-config.js file.
The second argument would be the directory where we should store the generated files.

```
$ generate-service-files-for-thingies --help

  Usage
      $ generate-service-files-for-thingies <arg1> <arg2>
    
  Options
      required:
      arg1, --machine-config <machine-config>, -c <machine-config>
          path to file which if the machine-config
      arg2, --output-directory <path/to/dir>, -o <path/to/dir>
          path of directory where the generated config files should be stored
    
  TO NOTE:
      The flags will overwrite the flagless argument.

  Examples
      $ generate-service-files-for-thingies  machine-config.js ../systemd-files
      ...

```

machine-config
-----

To be interpreted correctly the machine-config file must meet following requirements:

- hold an array `thingies`
- each thingy may have:
    - `homeUser` - required - used for naming and is part of the path
    - `repository` - required - is part of the path
    - `type` - processed exclsively "service"
    - `socket` - optional - will also create .socket file and set the appropriate environment variable 
    - `port` - optional(required if we donot use a socket) - sets the environment variable
    - `oneshot` - optional - indicates if the service is of type oneshot
```javascript
module.exports = {
    thingies = [
        {
            homeUser: "citysearch-socket",
            repository: "citysearch-on-socket",
            type:"service",
            socket: true
        },
        {
            homeUser: "webhook-handler",
            repository: "webhook-handler-repository",
            type:"service",
            socket: true,
            oneshot: true,
        },
        {
            homeUser: "citysearch",
            repository: "citysearch-repository",
            type:"service",
            port: "3002"
        },
        ...
    ]
    ...
}
```


Result
-----
Produced Config Files:
- File: citysearch-socket.service
```
[Unit]
Description=A thingy service in it's thingy ecosystem :-)

[Service]
User=citysearch-socket
Group=citysearch-socket

ExecStart=/usr/bin/node /home/citysearch-socket/citysearch-on-socket/service.js
WorkingDirectory=/home/citysearch-socket/citysearch-on-socket

Environment=SOCKETMODE=true

Restart=always

[Install]
WantedBy=multi-user.target
```

- File: citysearch-socket.socket
```
[Socket]
ListenStream=/run/citysearch-socket.sk

[Install]
WantedBy=sockets.target
```

- File: webhook-handler.service
```
[Unit]
Description=A thingy service in it's thingy ecosystem :-)

[Service]
User=webhook-handler
Group=webhook-handler

ExecStart=/usr/bin/node /home/webhook-handler/webhook-handler-repository/service.js
WorkingDirectory=/home/webhook-handler/webhook-handler-repository

Environment=SOCKETMODE=true

Type=oneshot
Restart=no

[Install]
WantedBy=multi-user.target
```

- File: webhook-handler.socket
```
[Socket]
ListenStream=/run/webhook-handler.sk

[Install]
WantedBy=sockets.target
```
- File: citysearch.service
```
[Unit]
Description=A thingy service in it's thingy ecosystem :-)

[Service]
User=citysearch
Group=citysearch

ExecStart=/usr/bin/node /home/citysearch/citysearch-repository/service.js
WorkingDirectory=/home/citysearch/citysearch-repository

Environment=PORT=3002

Restart=always

[Install]
WantedBy=multi-user.target
```

- and the others^^
---

# License

## The Unlicense JhonnyJason style

- Information has no ownership.
- Information only has memory to reside in and relations to be meaningful.
- Information cannot be stolen. Only shared or destroyed.

And you whish it has been shared before it is destroyed.

The one claiming copyright or intellectual property either is really evil or probably has some insecurity issues which makes him blind to the fact that he also just connected information which was free available to him.

The value is not in him who "created" the information the value is what is being done with the information.
So the restriction and friction of the informations' usage is exclusively reducing value overall.

The only preceived "value" gained due to restriction is actually very similar to the concept of blackmail (power gradient, control and dependency).

The real problems to solve are all in the "reward/credit" system and not the information distribution. Too much value is wasted because of not solving the right problem.

I can only contribute in that way - none of the information is "mine" everything I "learned" I actually also copied.
I only connect things to have something I feel is missing and share what I consider useful. So please use it without any second thought and please also share whatever could be useful for others. 

I also could give credits to all my sources - instead I use the freedom and moment of creativity which lives therein to declare my opinion on the situation. 

*Unity through Intelligence.*

We cannot subordinate us to the suboptimal dynamic we are spawned in, just because power is actually driving all things around us.
In the end a distributed network of intelligence where all information is transparently shared in the way that everyone has direct access to what he needs right now is more powerful than any brute power lever.

The same for our programs as for us.

It also is peaceful, helpful, friendly - decent. How it should be, because it's the most optimal solution for us human beings to learn, to connect to develop and evolve - not being excluded, let hanging and destroy.

If we really manage to build an real AI which is far superior to us it will unify with this network of intelligence.
We never have to fear superior intelligence, because it's just the better engine connecting information to be most understandable/usable for the other part of the intelligence network.

The only thing to fear is a disconnected unit without a sufficient network of intelligence on its own, filled with fear, hate or hunger while being very powerful. That unit needs to learn and connect to develop and evolve then.

We can always just give information and hints :-) The unit needs to learn by and connect itself.

Have a nice day! :D