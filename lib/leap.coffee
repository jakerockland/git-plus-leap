#!
# * LeapJS v0.6.3
# * http://github.com/leapmotion/leapjs/
# *
# * Copyright 2013 LeapMotion, Inc. and other contributors
# * Released under the Apache-2.0 license
# * http://github.com/leapmotion/leapjs/blob/master/LICENSE.txt
#
not (a, b, c) ->
  d = (c, f) ->
    unless b[c]
      unless a[c]
        g = "function" is typeof require and require
        return g(c, not 0)  if not f and g
        return e(c, not 0)  if e
        throw new Error("Cannot find module '" + c + "'")
      h = b[c] = exports: {}
      a[c][0].call h.exports, ((b) ->
        e = a[c][1][b]
        d (if e then e else b)
      ), h, h.exports
    b[c].exports
  e = "function" is typeof require and require
  f = 0

  while f < c.length
    d c[f]
    f++
  d
(
  1: [ (a, b) ->
    c = (a("./pointable")
    a("gl-matrix")
    )
    d = c.vec3
    e = c.mat3
    f = c.mat4
    g = (a("underscore")
    b.exports = (a, b) ->
      @finger = a
      @_center = null
      @_matrix = null
      @type = b.type
      @prevJoint = b.prevJoint
      @nextJoint = b.nextJoint
      @width = b.width

      c = new Array(3)
      d.sub(c, b.nextJoint, b.prevJoint)
      @length = d.length(c)
      @basis = b.basis

    )
    g::left = ->
      (if @_left then @_left else (@_left = e.determinant(@basis[0].concat(@basis[1]).concat(@basis[2])) < 0
      @_left
      ))

    g::matrix = ->
      return @_matrix  if @_matrix
      a = @basis
      b = @_matrix = f.create()
      b[0] = a[0][0]
      b[1] = a[0][1]
      b[2] = a[0][2]
      b[4] = a[1][0]
      b[5] = a[1][1]
      b[6] = a[1][2]
      b[8] = a[2][0]
      b[9] = a[2][1]
      b[10] = a[2][2]
      b[3] = @center()[0]
      b[7] = @center()[1]
      b[11] = @center()[2]
      @left() and (b[0] *= -1
      b[1] *= -1
      b[2] *= -1
      )
      @_matrix

    g::lerp = (a, b) ->
      d.lerp a, @prevJoint, @nextJoint, b

    g::center = ->
      return @_center  if @_center
      a = d.create()
      @lerp(a, .5)
      @_center = a
      a

    g::direction = ->
      [ -1 * @basis[2][0], -1 * @basis[2][1], -1 * @basis[2][2] ]
  ,
    "./pointable": 14
    "gl-matrix": 23
    underscore: 24
   ]
  2: [ (a, b) ->
    c = b.exports = (a) ->
      @pos = 0
      @_buf = []
      @size = a

    c::get = (a) ->
      undefined is a and (a = 0)
      (if a >= @size then undefined else (if a >= @_buf.length then undefined else @_buf[(@pos - a - 1) % @size]))

    c::push = (a) ->
      @_buf[@pos % @size] = a
      @pos++
  , {} ]
  3: [ (a, b) ->
    c = a("../protocol").chooseProtocol
    d = a("events").EventEmitter
    e = a("underscore")
    f = b.exports = (a) ->
      @opts = e.defaults(a or {},
        host: "127.0.0.1"
        enableGestures: not 1
        scheme: @getScheme()
        port: @getPort()
        background: not 1
        optimizeHMD: not 1
        requestProtocolVersion: f.defaultProtocolVersion
      )
      @host = @opts.host
      @port = @opts.port
      @scheme = @opts.scheme
      @protocolVersionVerified = not 1
      @background = null
      @optimizeHMD = null
      @on("ready", ->
        @enableGestures(@opts.enableGestures)
        @setBackground(@opts.background)
        @setOptimizeHMD(@opts.optimizeHMD)
        console.log((if @opts.optimizeHMD then "Optimized for head mounted display usage." else "Optimized for desktop usage."))
      )

    f.defaultProtocolVersion = 6
    f::getUrl = ->
      @scheme + "//" + @host + ":" + @port + "/v" + @opts.requestProtocolVersion + ".json"

    f::getScheme = ->
      "ws:"

    f::getPort = ->
      6437

    f::setBackground = (a) ->
      @opts.background = a
      @protocol and @protocol.sendBackground and @background isnt @opts.background and (@background = @opts.background
      @protocol.sendBackground(this, @opts.background)
      )

    f::setOptimizeHMD = (a) ->
      @opts.optimizeHMD = a
      @protocol and @protocol.sendOptimizeHMD and @optimizeHMD isnt @opts.optimizeHMD and (@optimizeHMD = @opts.optimizeHMD
      @protocol.sendOptimizeHMD(this, @opts.optimizeHMD)
      )

    f::handleOpen = ->
      @connected or (@connected = not 0
      @emit("connect")
      )

    f::enableGestures = (a) ->
      @gesturesEnabled = (if a then not 0 else not 1)
      @send(@protocol.encode(enableGestures: @gesturesEnabled))

    f::handleClose = (a) ->
      @connected and (@disconnect()
      1001 is a and @opts.requestProtocolVersion > 1 and ((if @protocolVersionVerified then @protocolVersionVerified = not 1 else @opts.requestProtocolVersion--))
      @startReconnection()
      )

    f::startReconnection = ->
      a = this
      @reconnectionTimer or (@reconnectionTimer = setInterval(->
        a.reconnect()
      , 500))

    f::stopReconnection = ->
      @reconnectionTimer = clearInterval(@reconnectionTimer)

    f::disconnect = (a) ->
      a or @stopReconnection()
      (if @socket then (@socket.close()
      delete @socket

      delete @protocol

      delete @background

      delete @optimizeHMD

      delete @focusedState

      @connected and (@connected = not 1
      @emit("disconnect")
      )
      not 0
      ) else undefined)

    f::reconnect = ->
      (if @connected then @stopReconnection() else (@disconnect(not 0)
      @connect()
      ))

    f::handleData = (a) ->
      b = undefined
      d = JSON.parse(a)
      (if undefined is @protocol then (b = @protocol = c(d)
      @protocolVersionVerified = not 0
      @emit("ready")
      ) else b = @protocol(d))
      @emit(b.type, b)

    f::connect = ->
      (if @socket then undefined else (@socket = @setupSocket()
      not 0
      ))

    f::send = (a) ->
      @socket.send a

    f::reportFocus = (a) ->
      @connected and @focusedState isnt a and (@focusedState = a
      @emit((if @focusedState then "focus" else "blur"))
      @protocol and @protocol.sendFocused and @protocol.sendFocused(this, @focusedState)
      )

    e.extend(f::, d::)
  ,
    "../protocol": 15
    events: 21
    underscore: 24
   ]
  4: [ (a, b) ->
    c = b.exports = a("./base")
    d = a("underscore")
    e = b.exports = (a) ->
      c.call this, a
      b = this
      @on("ready", ->
        b.startFocusLoop()
      )
      @on("disconnect", ->
        b.stopFocusLoop()
      )

    d.extend(e::, c::)
    e.__proto__ = c
    e::useSecure = ->
      "https:" is location.protocol

    e::getScheme = ->
      (if @useSecure() then "wss:" else "ws:")

    e::getPort = ->
      (if @useSecure() then 6436 else 6437)

    e::setupSocket = ->
      a = this
      b = new WebSocket(@getUrl())
      b.onopen = ->
        a.handleOpen()

      b.onclose = (b) ->
        a.handleClose b.code, b.reason

      b.onmessage = (b) ->
        a.handleData b.data

      b.onerror = ->
        a.useSecure() and "wss:" is a.scheme and (a.scheme = "ws:"
        a.port = 6437
        a.disconnect()
        a.connect()
        )

      b

    e::startFocusLoop = ->
      unless @focusDetectorTimer
        a = this
        b = null
        b = (if "undefined" isnt typeof document.hidden then "hidden" else (if "undefined" isnt typeof document.mozHidden then "mozHidden" else (if "undefined" isnt typeof document.msHidden then "msHidden" else (if "undefined" isnt typeof document.webkitHidden then "webkitHidden" else undefined))))
        undefined is a.windowVisible and (a.windowVisible = (if undefined is b then not 0 else document[b] is not 1))

        c = window.addEventListener("focus", ->
          a.windowVisible = not 0
          e()
        )
        d = window.addEventListener("blur", ->
          a.windowVisible = not 1
          e()
        )
        @on "disconnect", ->
          window.removeEventListener("focus", c)
          window.removeEventListener("blur", d)

        e = ->
          c = (if undefined is b then not 0 else document[b] is not 1)
          a.reportFocus c and a.windowVisible

        e()
        @focusDetectorTimer = setInterval(e, 100)

    e::stopFocusLoop = ->
      @focusDetectorTimer and (clearTimeout(@focusDetectorTimer)
      delete @focusDetectorTimer

      )
  ,
    "./base": 3
    underscore: 24
   ]
  5: [ (a, b) ->
    c = a("__browserify_process")
    d = a("./frame")
    e = a("./hand")
    f = a("./pointable")
    g = a("./finger")
    h = a("./circular_buffer")
    i = a("./pipeline")
    j = a("events").EventEmitter
    k = a("./gesture").gestureListener
    l = a("./dialog")
    m = a("underscore")
    n = b.exports = (b) ->
      e = "undefined" isnt typeof c and c.versions and c.versions.node
      f = this
      b = m.defaults(b or {},
        inNode: e
      )
      @inNode = b.inNode
      b = m.defaults(b or {},
        frameEventName: (if @useAnimationLoop() then "animationFrame" else "deviceFrame")
        suppressAnimationLoop: not @useAnimationLoop()
        loopWhileDisconnected: not 1
        useAllPlugins: not 1
        checkVersion: not 0
      )
      @animationFrameRequested = not 1
      @onAnimationFrame = ->
        f.emit("animationFrame", f.lastConnectionFrame)
        (if f.loopWhileDisconnected and (f.connection.focusedState or f.connection.opts.background) then window.requestAnimationFrame(f.onAnimationFrame) else f.animationFrameRequested = not 1)

      @suppressAnimationLoop = b.suppressAnimationLoop
      @loopWhileDisconnected = b.loopWhileDisconnected
      @frameEventName = b.frameEventName
      @useAllPlugins = b.useAllPlugins
      @history = new h(200)
      @lastFrame = d.Invalid
      @lastValidFrame = d.Invalid
      @lastConnectionFrame = d.Invalid
      @accumulatedGestures = []
      @checkVersion = b.checkVersion
      @connectionType = (if undefined is b.connectionType then a((if @inBrowser() then "./connection/browser" else "./connection/node")) else b.connectionType)
      @connection = new @connectionType(b)
      @streamingCount = 0
      @devices = {}
      @plugins = {}
      @_pluginPipelineSteps = {}
      @_pluginExtendedMethods = {}
      b.useAllPlugins and @useRegisteredPlugins()
      @setupFrameEvents(b)
      @setupConnectionEvents()

    n::gesture = (a, b) ->
      c = k(this, a)
      undefined isnt b and c.stop(b)
      c

    n::setBackground = (a) ->
      @connection.setBackground(a)
      this

    n::setOptimizeHMD = (a) ->
      @connection.setOptimizeHMD(a)
      this

    n::inBrowser = ->
      not @inNode

    n::useAnimationLoop = ->
      @inBrowser() and not @inBackgroundPage()

    n::inBackgroundPage = ->
      "undefined" isnt typeof chrome and chrome.extension and chrome.extension.getBackgroundPage and chrome.extension.getBackgroundPage() is window

    n::connect = ->
      @connection.connect()
      this

    n::streaming = ->
      @streamingCount > 0

    n::connected = ->
      !!@connection.connected

    n::runAnimationLoop = ->
      @suppressAnimationLoop or @animationFrameRequested or (@animationFrameRequested = not 0
      window.requestAnimationFrame(@onAnimationFrame)
      )

    n::disconnect = ->
      @connection.disconnect()
      this

    n::frame = (a) ->
      @history.get(a) or d.Invalid

    n::loop = (a) ->
      a and ((if "function" is typeof a then @on(@frameEventName, a) else @setupFrameEvents(a)))
      @connect()

    n::addStep = (a) ->
      @pipeline or (@pipeline = new i(this))
      @pipeline.addStep(a)

    n::processFrame = (a) ->
      a.gestures and (@accumulatedGestures = @accumulatedGestures.concat(a.gestures))
      @lastConnectionFrame = a
      @runAnimationLoop()
      @emit("deviceFrame", a)

    n::processFinishedFrame = (a) ->
      if @lastFrame = a
      a.valid and (@lastValidFrame = a)
      a.controller = this
      a.historyIdx = @history.push(a)
      a.gestures
        a.gestures = @accumulatedGestures
        @accumulatedGestures = []

        b = 0

        while b isnt a.gestures.length
          @emit "gesture", a.gestures[b], a
          b++
      @pipeline and (a = @pipeline.run(a)
      a or (a = d.Invalid)
      )
      @emit("frame", a)
      @emitHandEvents(a)

    n::emitHandEvents = (a) ->
      b = 0

      while b < a.hands.length
        @emit "hand", a.hands[b]
        b++

    n::setupFrameEvents = (a) ->
      a.frame and @on("frame", a.frame)
      a.hand and @on("hand", a.hand)

    n::setupConnectionEvents = ->
      a = this
      @connection.on("frame", (b) ->
        a.processFrame b
      )
      @on(@frameEventName, (b) ->
        a.processFinishedFrame b
      )

      b = ->
        if a.connection.opts.requestProtocolVersion < 5 and 0 is a.streamingCount
          a.streamingCount = 1
          c =
            attached: not 0
            streaming: not 0
            type: "unknown"
            id: "Lx00000000000"

          a.devices[c.id] = c
          a.emit("deviceAttached", c)
          a.emit("deviceStreaming", c)
          a.emit("streamingStarted", c)
          a.connection.removeListener("frame", b)

      c = ->
        if a.streamingCount > 0
          for b of a.devices
            a.emit("deviceStopped", a.devices[b])
            a.emit("deviceRemoved", a.devices[b])
          a.emit("streamingStopped", a.devices[b])
          a.streamingCount = 0

          for b of a.devices
            delete a.devices[b]

      @connection.on("focus", ->
        a.emit "focus"
      )
      @connection.on("blur", ->
        a.emit "blur"
      )
      @connection.on("protocol", (b) ->
        b.on("beforeFrameCreated", (b) ->
          a.emit "beforeFrameCreated", b
        )
        b.on("afterFrameCreated", (b, c) ->
          a.emit "afterFrameCreated", b, c
        )
        a.emit("protocol", b)
      )
      @connection.on("ready", ->
        a.checkVersion and not a.inNode and a.checkOutOfDate()
        a.emit("ready")
      )
      @connection.on("connect", ->
        a.emit("connect")
        a.connection.removeListener("frame", b)
        a.connection.on("frame", b)
      )
      @connection.on("disconnect", ->
        a.emit("disconnect")
        c()
      )
      @connection.on("deviceConnect", (d) ->
        (if d.state then (a.emit("deviceConnected")
        a.connection.removeListener("frame", b)
        a.connection.on("frame", b)
        ) else (a.emit("deviceDisconnected")
        c()
        ))
      )
      @connection.on("deviceEvent", (b) ->
        c = b.state
        d = a.devices[c.id]
        e = {}
        for f of c
          d and d.hasOwnProperty(f) and d[f] is c[f] or (e[f] = not 0)
        a.devices[c.id] = c
        e.attached and a.emit((if c.attached then "deviceAttached" else "deviceRemoved"), c)
        e.streaming and ((if c.streaming then (a.streamingCount++
        a.emit("deviceStreaming", c)
        1 is a.streamingCount and a.emit("streamingStarted", c)
        e.attached or a.emit("deviceConnected")
        ) else e.attached and c.attached or (a.streamingCount--
        a.emit("deviceStopped", c)
        0 is a.streamingCount and a.emit("streamingStopped", c)
        a.emit("deviceDisconnected")
        )))
      )
      @on("newListener", (a) ->
        ("deviceConnected" is a or "deviceDisconnected" is a) and console.warn(a + " events are depricated.  Consider using 'streamingStarted/streamingStopped' or 'deviceStreaming/deviceStopped' instead")
      )

    n::checkOutOfDate = ->
      console.assert @connection and @connection.protocol
      a = @connection.protocol.serviceVersion
      b = @connection.protocol.version
      c = @connectionType.defaultProtocolVersion
      (if c > b then (console.warn("Your Protocol Version is v" + b + ", this app was designed for v" + c)
      l.warnOutOfDate(
        sV: a
        pV: b
      )
      not 0
      ) else not 1)

    n._pluginFactories = {}
    n.plugin = (a, b) ->
      @_pluginFactories[a] and console.warn("Plugin \"" + a + "\" already registered")
      @_pluginFactories[a] = b

    n.plugins = ->
      m.keys @_pluginFactories


    o = (a, b, c) ->
      (if -1 isnt [ "beforeFrameCreated", "afterFrameCreated" ].indexOf(b) then @on(b, c) else (@pipeline or (@pipeline = new i(this))
      @_pluginPipelineSteps[a] or (@_pluginPipelineSteps[a] = [])
      @_pluginPipelineSteps[a].push(@pipeline.addWrappedStep(b, c))
      ))

    p = (a, b, c) ->
      h = undefined
      switch @_pluginExtendedMethods[a] or (@_pluginExtendedMethods[a] = [])
      b

        when "frame"
          h = d
        when "hand"
          h = e
        when "pointable"
          h = f
          m.extend(g::, c)
          m.extend(g.Invalid, c)
        when "finger"
          h = g
        else
          throw a + " specifies invalid object type \"" + b + "\" for prototypical extension"
      m.extend(h::, c)
      m.extend(h.Invalid, c)
      @_pluginExtendedMethods[a].push([ h, c ])

    n::use = (a, b) ->
      c = undefined
      d = undefined
      e = undefined
      f = undefined
      throw "Leap Plugin " + a + " not found."  if d = (if "function" is typeof a then a else n._pluginFactories[a])
      not d

      if b or (b = {})
      @plugins[a]
        return m.extend(@plugins[a], b)
        this
      @plugins[a] = b
      f = d.call(this, b)

      for e of f
        c = f[e]
        (if "function" is typeof c then o.call(this, a, e, c) else p.call(this, a, e, c))
      this

    n::stopUsing = (a) ->
      b = undefined
      c = undefined
      d = @_pluginPipelineSteps[a]
      e = @_pluginExtendedMethods[a]
      f = 0
      if @plugins[a]
        if d
          f = 0
          while f < d.length
            @pipeline.removeStep d[f]
            f++
        if e
          f = 0
          while f < e.length
            b = e[f][0]
            c = e[f][1]

            for g of c
              delete b::[g]

              delete b.Invalid[g]
            f++
        delete @plugins[a]

        this

    n::useRegisteredPlugins = ->
      for a of n._pluginFactories
        @use a

    m.extend(n::, j::)
  ,
    "./circular_buffer": 2
    "./connection/browser": 4
    "./connection/node": 20
    "./dialog": 6
    "./finger": 7
    "./frame": 8
    "./gesture": 9
    "./hand": 10
    "./pipeline": 13
    "./pointable": 14
    __browserify_process: 22
    events: 21
    underscore: 24
   ]
  6: [ (a, b) ->
    c = a("__browserify_process")
    d = b.exports = (a, b) ->
      @options = b or {}
      @message = a
      @createElement()

    d::createElement = ->
      @element = document.createElement("div")
      @element.className = "leapjs-dialog"
      @element.style.position = "fixed"
      @element.style.top = "8px"
      @element.style.left = 0
      @element.style.right = 0
      @element.style.textAlign = "center"
      @element.style.zIndex = 1e3

      a = document.createElement("div")
      @element.appendChild(a)
      a.style.className = "leapjs-dialog"
      a.style.display = "inline-block"
      a.style.margin = "auto"
      a.style.padding = "8px"
      a.style.color = "#222"
      a.style.background = "#eee"
      a.style.borderRadius = "4px"
      a.style.border = "1px solid #999"
      a.style.textAlign = "left"
      a.style.cursor = "pointer"
      a.style.whiteSpace = "nowrap"
      a.style.transition = "box-shadow 1s linear"
      a.innerHTML = @message
      @options.onclick and a.addEventListener("click", @options.onclick)
      @options.onmouseover and a.addEventListener("mouseover", @options.onmouseover)
      @options.onmouseout and a.addEventListener("mouseout", @options.onmouseout)
      @options.onmousemove and a.addEventListener("mousemove", @options.onmousemove)

    d::show = ->
      document.body.appendChild(@element)
      this

    d::hide = ->
      document.body.removeChild(@element)
      this

    d.warnOutOfDate = (a) ->
      a or (a = {})
      b = "http://developer.leapmotion.com?"
      a.returnTo = window.location.href
      for c of a
        b += c + "=" + encodeURIComponent(a[c]) + "&"
      e = undefined
      f = (a) ->
        unless "leapjs-decline-upgrade" is a.target.id
          c = window.open(b, "_blank", "height=800,width=1000,location=1,menubar=1,resizable=1,status=1,toolbar=1,scrollbars=1")
          window.focus and c.focus()
        e.hide()
        not 0

      g = "This site requires Leap Motion Tracking V2.<button id='leapjs-accept-upgrade'  style='color: #444; transition: box-shadow 100ms linear; cursor: pointer; vertical-align: baseline; margin-left: 16px;'>Upgrade</button><button id='leapjs-decline-upgrade' style='color: #444; transition: box-shadow 100ms linear; cursor: pointer; vertical-align: baseline; margin-left: 8px; '>Not Now</button>"
      e = new d(g,
        onclick: f
        onmousemove: (a) ->
          (if a.target is document.getElementById("leapjs-decline-upgrade") then (document.getElementById("leapjs-decline-upgrade").style.color = "#000"
          document.getElementById("leapjs-decline-upgrade").style.boxShadow = "0px 0px 2px #5daa00"
          document.getElementById("leapjs-accept-upgrade").style.color = "#444"
          document.getElementById("leapjs-accept-upgrade").style.boxShadow = "none"
          ) else (document.getElementById("leapjs-accept-upgrade").style.color = "#000"
          document.getElementById("leapjs-accept-upgrade").style.boxShadow = "0px 0px 2px #5daa00"
          document.getElementById("leapjs-decline-upgrade").style.color = "#444"
          document.getElementById("leapjs-decline-upgrade").style.boxShadow = "none"
          ))

        onmouseout: ->
          document.getElementById("leapjs-decline-upgrade").style.color = "#444"
          document.getElementById("leapjs-decline-upgrade").style.boxShadow = "none"
          document.getElementById("leapjs-accept-upgrade").style.color = "#444"
          document.getElementById("leapjs-accept-upgrade").style.boxShadow = "none"
      )
      e.show()

    d.hasWarnedBones = not 1
    d.warnBones = ->
      @hasWarnedBones or (@hasWarnedBones = not 0
      console.warn("Your Leap Service is out of date")
      "undefined" isnt typeof c and c.versions and c.versions.node or @warnOutOfDate(reason: "bones")
      )
  ,
    __browserify_process: 22
   ]
  7: [ (a, b) ->
    c = a("./pointable")
    d = a("./bone")
    e = a("./dialog")
    f = a("underscore")
    g = b.exports = (a) ->
      c.call(this, a)
      @dipPosition = a.dipPosition
      @pipPosition = a.pipPosition
      @mcpPosition = a.mcpPosition
      @carpPosition = a.carpPosition
      @extended = a.extended
      @type = a.type
      @finger = not 0
      @positions = [ @carpPosition, @mcpPosition, @pipPosition, @dipPosition, @tipPosition ]
      (if a.bases then @addBones(a) else e.warnBones())

    f.extend(g::, c::)
    g::addBones = (a) ->
      @metacarpal = new d(this,
        type: 0
        width: @width
        prevJoint: @carpPosition
        nextJoint: @mcpPosition
        basis: a.bases[0]
      )
      @proximal = new d(this,
        type: 1
        width: @width
        prevJoint: @mcpPosition
        nextJoint: @pipPosition
        basis: a.bases[1]
      )
      @medial = new d(this,
        type: 2
        width: @width
        prevJoint: @pipPosition
        nextJoint: @dipPosition
        basis: a.bases[2]
      )
      @distal = new d(this,
        type: 3
        width: @width
        prevJoint: @dipPosition
        nextJoint: a.btipPosition
        basis: a.bases[3]
      )
      @bones = [ @metacarpal, @proximal, @medial, @distal ]

    g::toString = ->
      "Finger [ id:" + @id + " " + @length + "mmx | width:" + @width + "mm | direction:" + @direction + " ]"

    g.Invalid = valid: not 1
  ,
    "./bone": 1
    "./dialog": 6
    "./pointable": 14
    underscore: 24
   ]
  8: [ (a, b) ->
    c = a("./hand")
    d = a("./pointable")
    e = a("./gesture").createGesture
    f = a("gl-matrix")
    g = f.mat3
    h = f.vec3
    i = a("./interaction_box")
    j = a("./finger")
    k = a("underscore")
    l = b.exports = (a) ->
      if @valid = not 0
      @id = a.id
      @timestamp = a.timestamp
      @hands = []
      @handsMap = {}
      @pointables = []
      @tools = []
      @fingers = []
      a.interactionBox and (@interactionBox = new i(a.interactionBox))
      @gestures = []
      @pointablesMap = {}
      @_translation = a.t
      @_rotation = k.flatten(a.r)
      @_scaleFactor = a.s
      @data = a
      @type = "frame"
      @currentFrameRate = a.currentFrameRate
      a.gestures
        b = 0
        c = a.gestures.length

        while b isnt c
          @gestures.push e(a.gestures[b])
          b++
      @postprocessData a

    l::postprocessData = (a) ->
      a or (a = @data)
      b = 0
      e = a.hands.length

      while b isnt e
        f = new c(a.hands[b])
        f.frame = this
        @hands.push(f)
        @handsMap[f.id] = f
        b++
      a.pointables = k.sortBy(a.pointables, (a) ->
        a.id
      )
      g = 0
      h = a.pointables.length

      while g isnt h
        i = a.pointables[g]
        l = (if i.dipPosition then new j(i) else new d(i))
        l.frame = this
        @addPointable(l)
        g++

    l::addPointable = (a) ->
      if @pointables.push(a)
      @pointablesMap[a.id] = a
      ((if a.tool then @tools else @fingers)).push(a)
      undefined isnt a.handId and @handsMap.hasOwnProperty(a.handId)
        b = @handsMap[a.handId]
        switch b.pointables.push(a)
        ((if a.tool then b.tools else b.fingers)).push(a)
        a.type

          when 0
            b.thumb = a
          when 1
            b.indexFinger = a
          when 2
            b.middleFinger = a
          when 3
            b.ringFinger = a
          when 4
            b.pinky = a

    l::tool = (a) ->
      b = @pointable(a)
      (if b.tool then b else d.Invalid)

    l::pointable = (a) ->
      @pointablesMap[a] or d.Invalid

    l::finger = (a) ->
      b = @pointable(a)
      (if b.tool then d.Invalid else b)

    l::hand = (a) ->
      @handsMap[a] or c.Invalid

    l::rotationAngle = (a, b) ->
      return 0  if not @valid or not a.valid
      c = @rotationMatrix(a)
      d = .5 * (c[0] + c[4] + c[8] - 1)
      e = Math.acos(d)
      if e = (if isNaN(e) then 0 else e)
      undefined isnt b
        f = @rotationAxis(a)
        e *= h.dot(f, h.normalize(h.create(), b))
      e

    l::rotationAxis = (a) ->
      (if @valid and a.valid then h.normalize(h.create(), [ @_rotation[7] - a._rotation[5], @_rotation[2] - a._rotation[6], @_rotation[3] - a._rotation[1] ]) else h.create())

    l::rotationMatrix = (a) ->
      return g.create()  if not @valid or not a.valid
      b = g.transpose(g.create(), @_rotation)
      g.multiply g.create(), a._rotation, b

    l::scaleFactor = (a) ->
      (if @valid and a.valid then Math.exp(@_scaleFactor - a._scaleFactor) else 1)

    l::translation = (a) ->
      (if @valid and a.valid then h.subtract(h.create(), @_translation, a._translation) else h.create())

    l::toString = ->
      a = "Frame [ id:" + @id + " | timestamp:" + @timestamp + " | Hand count:(" + @hands.length + ") | Pointable count:(" + @pointables.length + ")"
      @gestures and (a += " | Gesture count:(" + @gestures.length + ")")
      a += " ]"

    l::dump = ->
      a = ""
      a += "Frame Info:<br/>"
      a += @toString()
      a += "<br/><br/>Hands:<br/>"

      b = 0
      c = @hands.length

      while b isnt c
        a += "  " + @hands[b].toString() + "<br/>"
        b++
      a += "<br/><br/>Pointables:<br/>"
      d = 0
      e = @pointables.length

      while d isnt e
        a += "  " + @pointables[d].toString() + "<br/>"
        d++
      if @gestures
        a += "<br/><br/>Gestures:<br/>"
        f = 0
        g = @gestures.length

        while f isnt g
          a += "  " + @gestures[f].toString() + "<br/>"
          f++
      a += "<br/><br/>Raw JSON:<br/>"
      a += JSON.stringify(@data)

    l.Invalid =
      valid: not 1
      hands: []
      fingers: []
      tools: []
      gestures: []
      pointables: []
      pointable: ->
        d.Invalid

      finger: ->
        d.Invalid

      hand: ->
        c.Invalid

      toString: ->
        "invalid frame"

      dump: ->
        @toString()

      rotationAngle: ->
        0

      rotationMatrix: ->
        g.create()

      rotationAxis: ->
        h.create()

      scaleFactor: ->
        1

      translation: ->
        h.create()
  ,
    "./finger": 7
    "./gesture": 9
    "./hand": 10
    "./interaction_box": 12
    "./pointable": 14
    "gl-matrix": 23
    underscore: 24
   ]
  9: [ (a, b, c) ->
    d = a("gl-matrix")
    e = d.vec3
    f = a("events").EventEmitter
    g = a("underscore")
    h = (c.createGesture = (a) ->
      b = undefined
      switch a.type
        when "circle"
          b = new i(a)
        when "swipe"
          b = new j(a)
        when "screenTap"
          b = new k(a)
        when "keyTap"
          b = new l(a)
        else
          throw "unknown gesture type"
      b.id = a.id
      b.handIds = a.handIds.slice()
      b.pointableIds = a.pointableIds.slice()
      b.duration = a.duration
      b.state = a.state
      b.type = a.type
      b

    c.gestureListener = (a, b) ->
      c = {}
      d = {}
      a.on "gesture", (a, e) ->
        if a.type is b
          if ("start" is a.state or "stop" is a.state) and undefined is d[a.id]
            f = new h(a, e)
            d[a.id] = f
            g.each(c, (a, b) ->
              f.on b, a
            )
          d[a.id].update(a, e)
          "stop" is a.state and delete d[a.id]

      e =
        start: (a) ->
          c.start = a
          e

        stop: (a) ->
          c.stop = a
          e

        complete: (a) ->
          c.stop = a
          e

        update: (a) ->
          c.update = a
          e

      e

    c.Gesture = (a, b) ->
      @gestures = [ a ]
      @frames = [ b ]

    )
    h::update = (a, b) ->
      @lastGesture = a
      @lastFrame = b
      @gestures.push(a)
      @frames.push(b)
      @emit(a.state, this)

    h::translation = ->
      e.subtract e.create(), @lastGesture.startPosition, @lastGesture.position

    g.extend(h::, f::)

    i = (a) ->
      @center = a.center
      @normal = a.normal
      @progress = a.progress
      @radius = a.radius

    i::toString = ->
      "CircleGesture [" + JSON.stringify(this) + "]"

    j = (a) ->
      @startPosition = a.startPosition
      @position = a.position
      @direction = a.direction
      @speed = a.speed

    j::toString = ->
      "SwipeGesture [" + JSON.stringify(this) + "]"

    k = (a) ->
      @position = a.position
      @direction = a.direction
      @progress = a.progress

    k::toString = ->
      "ScreenTapGesture [" + JSON.stringify(this) + "]"

    l = (a) ->
      @position = a.position
      @direction = a.direction
      @progress = a.progress

    l::toString = ->
      "KeyTapGesture [" + JSON.stringify(this) + "]"
  ,
    events: 21
    "gl-matrix": 23
    underscore: 24
   ]
  10: [ (a, b) ->
    c = a("./pointable")
    d = a("./bone")
    e = a("gl-matrix")
    f = e.mat3
    g = e.vec3
    h = a("underscore")
    i = b.exports = (a) ->
      @id = a.id
      @palmPosition = a.palmPosition
      @direction = a.direction
      @palmVelocity = a.palmVelocity
      @palmNormal = a.palmNormal
      @sphereCenter = a.sphereCenter
      @sphereRadius = a.sphereRadius
      @valid = not 0
      @pointables = []
      @fingers = []
      @arm = (if a.armBasis then new d(this,
        type: 4
        width: a.armWidth
        prevJoint: a.elbow
        nextJoint: a.wrist
        basis: a.armBasis
      ) else null)
      @tools = []
      @_translation = a.t
      @_rotation = h.flatten(a.r)
      @_scaleFactor = a.s
      @timeVisible = a.timeVisible
      @stabilizedPalmPosition = a.stabilizedPalmPosition
      @type = a.type
      @grabStrength = a.grabStrength
      @pinchStrength = a.pinchStrength
      @confidence = a.confidence

    i::finger = (a) ->
      b = @frame.finger(a)
      (if b and b.handId is @id then b else c.Invalid)

    i::rotationAngle = (a, b) ->
      return 0  if not @valid or not a.valid
      c = a.hand(@id)
      return 0  unless c.valid
      d = @rotationMatrix(a)
      e = .5 * (d[0] + d[4] + d[8] - 1)
      f = Math.acos(e)
      if f = (if isNaN(f) then 0 else f)
      undefined isnt b
        h = @rotationAxis(a)
        f *= g.dot(h, g.normalize(g.create(), b))
      f

    i::rotationAxis = (a) ->
      return g.create()  if not @valid or not a.valid
      b = a.hand(@id)
      (if b.valid then g.normalize(g.create(), [ @_rotation[7] - b._rotation[5], @_rotation[2] - b._rotation[6], @_rotation[3] - b._rotation[1] ]) else g.create())

    i::rotationMatrix = (a) ->
      return f.create()  if not @valid or not a.valid
      b = a.hand(@id)
      return f.create()  unless b.valid
      c = f.transpose(f.create(), @_rotation)
      d = f.multiply(f.create(), b._rotation, c)
      d

    i::scaleFactor = (a) ->
      return 1  if not @valid or not a.valid
      b = a.hand(@id)
      (if b.valid then Math.exp(@_scaleFactor - b._scaleFactor) else 1)

    i::translation = (a) ->
      return g.create()  if not @valid or not a.valid
      b = a.hand(@id)
      (if b.valid then [ @_translation[0] - b._translation[0], @_translation[1] - b._translation[1], @_translation[2] - b._translation[2] ] else g.create())

    i::toString = ->
      "Hand (" + @type + ") [ id: " + @id + " | palm velocity:" + @palmVelocity + " | sphere center:" + @sphereCenter + " ] "

    i::pitch = ->
      Math.atan2 @direction[1], -@direction[2]

    i::yaw = ->
      Math.atan2 @direction[0], -@direction[2]

    i::roll = ->
      Math.atan2 @palmNormal[0], -@palmNormal[1]

    i.Invalid =
      valid: not 1
      fingers: []
      tools: []
      pointables: []
      left: not 1
      pointable: ->
        c.Invalid

      finger: ->
        c.Invalid

      toString: ->
        "invalid frame"

      dump: ->
        @toString()

      rotationAngle: ->
        0

      rotationMatrix: ->
        f.create()

      rotationAxis: ->
        g.create()

      scaleFactor: ->
        1

      translation: ->
        g.create()
  ,
    "./bone": 1
    "./pointable": 14
    "gl-matrix": 23
    underscore: 24
   ]
  11: [ (a, b) ->
    b.exports =
      Controller: a("./controller")
      Frame: a("./frame")
      Gesture: a("./gesture")
      Hand: a("./hand")
      Pointable: a("./pointable")
      Finger: a("./finger")
      InteractionBox: a("./interaction_box")
      CircularBuffer: a("./circular_buffer")
      UI: a("./ui")
      JSONProtocol: a("./protocol").JSONProtocol
      glMatrix: a("gl-matrix")
      mat3: a("gl-matrix").mat3
      vec3: a("gl-matrix").vec3
      loopController: undefined
      version: a("./version.js")
      loop: (a, b) ->
        not a or undefined isnt b or a.frame or a.hand or (b = a
        a = {}
        )
        (if @loopController then a and @loopController.setupFrameEvents(a) else @loopController = new @Controller(a))
        @loopController.loop(b)
        @loopController

      plugin: (a, b) ->
        @Controller.plugin a, b
  ,
    "./circular_buffer": 2
    "./controller": 5
    "./finger": 7
    "./frame": 8
    "./gesture": 9
    "./hand": 10
    "./interaction_box": 12
    "./pointable": 14
    "./protocol": 15
    "./ui": 16
    "./version.js": 19
    "gl-matrix": 23
   ]
  12: [ (a, b) ->
    c = a("gl-matrix")
    d = c.vec3
    e = b.exports = (a) ->
      @valid = not 0
      @center = a.center
      @size = a.size
      @width = a.size[0]
      @height = a.size[1]
      @depth = a.size[2]

    e::denormalizePoint = (a) ->
      d.fromValues (a[0] - .5) * @size[0] + @center[0], (a[1] - .5) * @size[1] + @center[1], (a[2] - .5) * @size[2] + @center[2]

    e::normalizePoint = (a, b) ->
      c = d.fromValues((a[0] - @center[0]) / @size[0] + .5, (a[1] - @center[1]) / @size[1] + .5, (a[2] - @center[2]) / @size[2] + .5)
      b and (c[0] = Math.min(Math.max(c[0], 0), 1)
      c[1] = Math.min(Math.max(c[1], 0), 1)
      c[2] = Math.min(Math.max(c[2], 0), 1)
      )
      c

    e::toString = ->
      "InteractionBox [ width:" + @width + " | height:" + @height + " | depth:" + @depth + " ]"

    e.Invalid = valid: not 1
  ,
    "gl-matrix": 23
   ]
  13: [ (a, b) ->
    c = b.exports = (a) ->
      @steps = []
      @controller = a

    c::addStep = (a) ->
      @steps.push a

    c::run = (a) ->
      b = @steps.length
      c = 0

      while c isnt b and a
        a = @steps[c](a)
        c++
      a

    c::removeStep = (a) ->
      b = @steps.indexOf(a)
      throw "Step not found in pipeline"  if -1 is b
      @steps.splice b, 1

    c::addWrappedStep = (a, b) ->
      c = @controller
      d = (d) ->
        e = undefined
        f = undefined
        g = undefined
        e = (if "frame" is a then [ d ] else d[a + "s"] or [])
        f = 0
        g = e.length

        while g > f
          b.call c, e[f]
          f++
        d

      @addStep(d)
      d
  , {} ]
  14: [ (a, b) ->
    c = a("gl-matrix")
    d = (c.vec3
    b.exports = (a) ->
      @valid = not 0
      @id = a.id
      @handId = a.handId
      @length = a.length
      @tool = a.tool
      @width = a.width
      @direction = a.direction
      @stabilizedTipPosition = a.stabilizedTipPosition
      @tipPosition = a.tipPosition
      @tipVelocity = a.tipVelocity
      @touchZone = a.touchZone
      @touchDistance = a.touchDistance
      @timeVisible = a.timeVisible

    )
    d::toString = ->
      "Pointable [ id:" + @id + " " + @length + "mmx | width:" + @width + "mm | direction:" + @direction + " ]"

    d::hand = ->
      @frame.hand @handId

    d.Invalid = valid: not 1
  ,
    "gl-matrix": 23
   ]
  15: [ (a, b, c) ->
    d = a("./frame")
    e = (a("./hand")
    a("./pointable")
    a("./finger")
    a("underscore")
    )
    f = a("events").EventEmitter
    g = (a) ->
      @type = a.type
      @state = a.state

    c.chooseProtocol = (a) ->
      b = undefined
      switch a.version
        when 1, 2
      , 3
      , 4
      , 5
      , 6
          b = h(a)
          b.sendBackground = (a, c) ->
            a.send b.encode(background: c)

          b.sendFocused = (a, c) ->
            a.send b.encode(focused: c)

          b.sendOptimizeHMD = (a, c) ->
            a.send b.encode(optimizeHMD: c)
        else
          throw "unrecognized version"
      b

    h = c.JSONProtocol = (a) ->
      b = (a) ->
        return new g(a.event)  if a.event
        b.emit "beforeFrameCreated", a
        c = new d(a)
        b.emit("afterFrameCreated", c, a)
        c

      b.encode = (a) ->
        JSON.stringify a

      b.version = a.version
      b.serviceVersion = a.serviceVersion
      b.versionLong = "Version " + a.version
      b.type = "protocol"
      e.extend(b, f::)
      b
  ,
    "./finger": 7
    "./frame": 8
    "./hand": 10
    "./pointable": 14
    events: 21
    underscore: 24
   ]
  16: [ (a, b, c) ->
    c.UI =
      Region: a("./ui/region")
      Cursor: a("./ui/cursor")
  ,
    "./ui/cursor": 17
    "./ui/region": 18
   ]
  17: [ (a, b) ->
    b.exports = ->
      (a) ->
        b = a.pointables.sort((a, b) ->
          a.z - b.z
        )[0]
        b and b.valid and (a.cursorPosition = b.tipPosition)
        a
  , {} ]
  18: [ (a, b) ->
    c = a("events").EventEmitter
    d = a("underscore")
    e = b.exports = (a, b) ->
      @start = new Vector(a)
      @end = new Vector(b)
      @enteredFrame = null

    e::hasPointables = (a) ->
      b = 0

      while b isnt a.pointables.length
        c = a.pointables[b].tipPosition
        return not 0  if c.x >= @start.x and c.x <= @end.x and c.y >= @start.y and c.y <= @end.y and c.z >= @start.z and c.z <= @end.z
        b++
      not 1

    e::listener = (a) ->
      b = this
      a and a.nearThreshold and @setupNearRegion(a.nearThreshold)
      (a) ->
        b.updatePosition a

    e::clipper = ->
      a = this
      (b) ->
        a.updatePosition(b)
        (if a.enteredFrame then b else null)

    e::setupNearRegion = (a) ->
      b = @nearRegion = new e([ @start.x - a, @start.y - a, @start.z - a ], [ @end.x + a, @end.y + a, @end.z + a ])
      c = this
      b.on("enter", (a) ->
        c.emit "near", a
      )
      b.on("exit", (a) ->
        c.emit "far", a
      )
      c.on("exit", (a) ->
        c.emit "near", a
      )

    e::updatePosition = (a) ->
      @nearRegion and @nearRegion.updatePosition(a)
      (if @hasPointables(a) and null is @enteredFrame then (@enteredFrame = a
      @emit("enter", @enteredFrame)
      ) else @hasPointables(a) or null is @enteredFrame or (@enteredFrame = null
      @emit("exit", @enteredFrame)
      ))
      a

    e::normalize = (a) ->
      new Vector([ (a.x - @start.x) / (@end.x - @start.x), (a.y - @start.y) / (@end.y - @start.y), (a.z - @start.z) / (@end.z - @start.z) ])

    e::mapToXY = (a, b, c) ->
      d = @normalize(a)
      e = d.x
      f = d.y
      (if e > 1 then e = 1 else -1 > e and (e = -1))
      (if f > 1 then f = 1 else -1 > f and (f = -1))
      [ (e + 1) / 2 * b, (1 - f) / 2 * c, d.z ]

    d.extend(e::, c::)
  ,
    events: 21
    underscore: 24
   ]
  19: [ (a, b) ->
    b.exports =
      full: "0.6.3"
      major: 0
      minor: 6
      dot: 3
  , {} ]
  20: [ ->
  , {} ]
  21: [ (a, b, c) ->
    d = (a, b) ->
      return a.indexOf(b)  if a.indexOf
      c = 0

      while c < a.length
        return c  if b is a[c]
        c++
      -1
    e = a("__browserify_process")
    e.EventEmitter or (e.EventEmitter = ->
    )
    f = c.EventEmitter = e.EventEmitter
    g = (if "function" is typeof Array.isArray then Array.isArray else (a) ->
      "[object Array]" is Object::toString.call(a)
    )
    h = 10
    f::setMaxListeners = (a) ->
      @_events or (@_events = {})
      @_events.maxListeners = a

    f::emit = (a) ->
      throw (if arguments[1] instanceof Error then arguments[1] else new Error("Uncaught, unspecified 'error' event."))  if "error" is a and (not @_events or not @_events.error or g(@_events.error) and not @_events.error.length)
      return not 1  unless @_events
      b = @_events[a]
      return not 1  unless b
      if "function" is typeof b
        switch arguments.length
          when 1
            b.call this
          when 2
            b.call this, arguments[1]
          when 3
            b.call this, arguments[1], arguments[2]
          else
            c = Array::slice.call(arguments, 1)
            b.apply this, c
        return not 0
      if g(b)
        c = Array::slice.call(arguments, 1)
        d = b.slice()
        e = 0
        f = d.length

        while f > e
          d[e].apply this, c
          e++
        return not 0
      not 1

    f::addListener = (a, b) ->
      throw new Error("addListener only takes instances of Function")  unless "function" is typeof b
      if @_events or (@_events = {})
      @emit("newListener", a, b)
      @_events[a]
        if g(@_events[a])
          unless @_events[a].warned
            c = undefined
            c = (if undefined isnt @_events.maxListeners then @_events.maxListeners else h)
            c and c > 0 and @_events[a].length > c and (@_events[a].warned = not 0
            console.error("(node) warning: possible EventEmitter memory leak detected. %d listeners added. Use emitter.setMaxListeners() to increase limit.", @_events[a].length)
            console.trace()
            )
          @_events[a].push b
        else
          @_events[a] = [ @_events[a], b ]
      else
        @_events[a] = b
      this

    f::on = f::addListener
    f::once = (a, b) ->
      c = this
      c.on(a, d = ->
        c.removeListener(a, d)
        b.apply(this, arguments)
      )
      this

    f::removeListener = (a, b) ->
      throw new Error("removeListener only takes instances of Function")  unless "function" is typeof b
      return this  if not @_events or not @_events[a]
      c = @_events[a]
      if g(c)
        e = d(c, b)
        return this  if 0 > e
        c.splice(e, 1)
        0 is c.length and delete @_events[a]
      else
        @_events[a] is b and delete @_events[a]
      this

    f::removeAllListeners = (a) ->
      (if 0 is arguments.length then (@_events = {}
      this
      ) else (a and @_events and @_events[a] and (@_events[a] = null)
      this
      ))

    f::listeners = (a) ->
      @_events or (@_events = {})
      @_events[a] or (@_events[a] = [])
      g(@_events[a]) or (@_events[a] = [ @_events[a] ])
      @_events[a]

    f.listenerCount = (a, b) ->
      c = undefined
      c = (if a._events and a._events[b] then (if "function" is typeof a._events[b] then 1 else a._events[b].length) else 0)
  ,
    __browserify_process: 22
   ]
  22: [ (a, b) ->
    c = b.exports = {}
    c.nextTick = ->
      a = "undefined" isnt typeof window and window.setImmediate
      b = "undefined" isnt typeof window and window.postMessage and window.addEventListener
      if a
        return (a) ->
          window.setImmediate a
      if b
        c = []
        return window.addEventListener("message", (a) ->
          b = a.source
          if (b is window or null is b) and "process-tick" is a.data and (a.stopPropagation()
          c.length > 0
          )
            d = c.shift()
            d()
        , not 0)
        (a) ->
          c.push(a)
          window.postMessage("process-tick", "*")
      (a) ->
        setTimeout a, 0
    ()
    c.title = "browser"
    c.browser = not 0
    c.env = {}
    c.argv = []
    c.binding = ->
      throw new Error("process.binding is not supported")

    c.cwd = ->
      "/"

    c.chdir = ->
      throw new Error("process.chdir is not supported")
  , {} ]
  23: [ (a, b, c) ->
    not (a) ->
      "use strict"
      b = {}
      (if "undefined" is typeof c then (if "function" is typeof define and "object" is typeof define.amd and define.amd then (b.exports = {}
      define(->
        b.exports
      )
      ) else b.exports = (if "undefined" isnt typeof window then window else a)) else b.exports = c)
      (a) ->
        b = 1e-6  unless b
        c = (if "undefined" isnt typeof Float32Array then Float32Array else Array)  unless c
        d = Math.random  unless d
        e = {}
        e.setMatrixArrayType = (a) ->
          c = a

        "undefined" isnt typeof a and (a.glMatrix = e)

        f = Math.PI / 180
        e.toRadian = (a) ->
          a * f

        g = {}
        g.create = ->
          a = new c(2)
          a[0] = 0
          a[1] = 0
          a

        g.clone = (a) ->
          b = new c(2)
          b[0] = a[0]
          b[1] = a[1]
          b

        g.fromValues = (a, b) ->
          d = new c(2)
          d[0] = a
          d[1] = b
          d

        g.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a

        g.set = (a, b, c) ->
          a[0] = b
          a[1] = c
          a

        g.add = (a, b, c) ->
          a[0] = b[0] + c[0]
          a[1] = b[1] + c[1]
          a

        g.subtract = (a, b, c) ->
          a[0] = b[0] - c[0]
          a[1] = b[1] - c[1]
          a

        g.sub = g.subtract
        g.multiply = (a, b, c) ->
          a[0] = b[0] * c[0]
          a[1] = b[1] * c[1]
          a

        g.mul = g.multiply
        g.divide = (a, b, c) ->
          a[0] = b[0] / c[0]
          a[1] = b[1] / c[1]
          a

        g.div = g.divide
        g.min = (a, b, c) ->
          a[0] = Math.min(b[0], c[0])
          a[1] = Math.min(b[1], c[1])
          a

        g.max = (a, b, c) ->
          a[0] = Math.max(b[0], c[0])
          a[1] = Math.max(b[1], c[1])
          a

        g.scale = (a, b, c) ->
          a[0] = b[0] * c
          a[1] = b[1] * c
          a

        g.scaleAndAdd = (a, b, c, d) ->
          a[0] = b[0] + c[0] * d
          a[1] = b[1] + c[1] * d
          a

        g.distance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          Math.sqrt c * c + d * d

        g.dist = g.distance
        g.squaredDistance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          c * c + d * d

        g.sqrDist = g.squaredDistance
        g.length = (a) ->
          b = a[0]
          c = a[1]
          Math.sqrt b * b + c * c

        g.len = g.length
        g.squaredLength = (a) ->
          b = a[0]
          c = a[1]
          b * b + c * c

        g.sqrLen = g.squaredLength
        g.negate = (a, b) ->
          a[0] = -b[0]
          a[1] = -b[1]
          a

        g.normalize = (a, b) ->
          c = b[0]
          d = b[1]
          e = c * c + d * d
          e > 0 and (e = 1 / Math.sqrt(e)
          a[0] = b[0] * e
          a[1] = b[1] * e
          )
          a

        g.dot = (a, b) ->
          a[0] * b[0] + a[1] * b[1]

        g.cross = (a, b, c) ->
          d = b[0] * c[1] - b[1] * c[0]
          a[0] = a[1] = 0
          a[2] = d
          a

        g.lerp = (a, b, c, d) ->
          e = b[0]
          f = b[1]
          a[0] = e + d * (c[0] - e)
          a[1] = f + d * (c[1] - f)
          a

        g.random = (a, b) ->
          b = b or 1
          c = 2 * d() * Math.PI
          a[0] = Math.cos(c) * b
          a[1] = Math.sin(c) * b
          a

        g.transformMat2 = (a, b, c) ->
          d = b[0]
          e = b[1]
          a[0] = c[0] * d + c[2] * e
          a[1] = c[1] * d + c[3] * e
          a

        g.transformMat2d = (a, b, c) ->
          d = b[0]
          e = b[1]
          a[0] = c[0] * d + c[2] * e + c[4]
          a[1] = c[1] * d + c[3] * e + c[5]
          a

        g.transformMat3 = (a, b, c) ->
          d = b[0]
          e = b[1]
          a[0] = c[0] * d + c[3] * e + c[6]
          a[1] = c[1] * d + c[4] * e + c[7]
          a

        g.transformMat4 = (a, b, c) ->
          d = b[0]
          e = b[1]
          a[0] = c[0] * d + c[4] * e + c[12]
          a[1] = c[1] * d + c[5] * e + c[13]
          a

        g.forEach = ->
          a = g.create()
          (b, c, d, e, f, g) ->
            h = undefined
            i = undefined
            c or (c = 2)
            d or (d = 0)
            i = (if e then Math.min(e * c + d, b.length) else b.length)
            h = d

            while i > h
              a[0] = b[h]
              a[1] = b[h + 1]
              f(a, a, g)
              b[h] = a[0]
              b[h + 1] = a[1]
              h += c
            b
        ()
        g.str = (a) ->
          "vec2(" + a[0] + ", " + a[1] + ")"

        "undefined" isnt typeof a and (a.vec2 = g)

        h = {}
        h.create = ->
          a = new c(3)
          a[0] = 0
          a[1] = 0
          a[2] = 0
          a

        h.clone = (a) ->
          b = new c(3)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b

        h.fromValues = (a, b, d) ->
          e = new c(3)
          e[0] = a
          e[1] = b
          e[2] = d
          e

        h.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a

        h.set = (a, b, c, d) ->
          a[0] = b
          a[1] = c
          a[2] = d
          a

        h.add = (a, b, c) ->
          a[0] = b[0] + c[0]
          a[1] = b[1] + c[1]
          a[2] = b[2] + c[2]
          a

        h.subtract = (a, b, c) ->
          a[0] = b[0] - c[0]
          a[1] = b[1] - c[1]
          a[2] = b[2] - c[2]
          a

        h.sub = h.subtract
        h.multiply = (a, b, c) ->
          a[0] = b[0] * c[0]
          a[1] = b[1] * c[1]
          a[2] = b[2] * c[2]
          a

        h.mul = h.multiply
        h.divide = (a, b, c) ->
          a[0] = b[0] / c[0]
          a[1] = b[1] / c[1]
          a[2] = b[2] / c[2]
          a

        h.div = h.divide
        h.min = (a, b, c) ->
          a[0] = Math.min(b[0], c[0])
          a[1] = Math.min(b[1], c[1])
          a[2] = Math.min(b[2], c[2])
          a

        h.max = (a, b, c) ->
          a[0] = Math.max(b[0], c[0])
          a[1] = Math.max(b[1], c[1])
          a[2] = Math.max(b[2], c[2])
          a

        h.scale = (a, b, c) ->
          a[0] = b[0] * c
          a[1] = b[1] * c
          a[2] = b[2] * c
          a

        h.scaleAndAdd = (a, b, c, d) ->
          a[0] = b[0] + c[0] * d
          a[1] = b[1] + c[1] * d
          a[2] = b[2] + c[2] * d
          a

        h.distance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          e = b[2] - a[2]
          Math.sqrt c * c + d * d + e * e

        h.dist = h.distance
        h.squaredDistance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          e = b[2] - a[2]
          c * c + d * d + e * e

        h.sqrDist = h.squaredDistance
        h.length = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          Math.sqrt b * b + c * c + d * d

        h.len = h.length
        h.squaredLength = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          b * b + c * c + d * d

        h.sqrLen = h.squaredLength
        h.negate = (a, b) ->
          a[0] = -b[0]
          a[1] = -b[1]
          a[2] = -b[2]
          a

        h.normalize = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = c * c + d * d + e * e
          f > 0 and (f = 1 / Math.sqrt(f)
          a[0] = b[0] * f
          a[1] = b[1] * f
          a[2] = b[2] * f
          )
          a

        h.dot = (a, b) ->
          a[0] * b[0] + a[1] * b[1] + a[2] * b[2]

        h.cross = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = c[0]
          h = c[1]
          i = c[2]
          a[0] = e * i - f * h
          a[1] = f * g - d * i
          a[2] = d * h - e * g
          a

        h.lerp = (a, b, c, d) ->
          e = b[0]
          f = b[1]
          g = b[2]
          a[0] = e + d * (c[0] - e)
          a[1] = f + d * (c[1] - f)
          a[2] = g + d * (c[2] - g)
          a

        h.random = (a, b) ->
          b = b or 1
          c = 2 * d() * Math.PI
          e = 2 * d() - 1
          f = Math.sqrt(1 - e * e) * b
          a[0] = Math.cos(c) * f
          a[1] = Math.sin(c) * f
          a[2] = e * b
          a

        h.transformMat4 = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          a[0] = c[0] * d + c[4] * e + c[8] * f + c[12]
          a[1] = c[1] * d + c[5] * e + c[9] * f + c[13]
          a[2] = c[2] * d + c[6] * e + c[10] * f + c[14]
          a

        h.transformMat3 = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          a[0] = d * c[0] + e * c[3] + f * c[6]
          a[1] = d * c[1] + e * c[4] + f * c[7]
          a[2] = d * c[2] + e * c[5] + f * c[8]
          a

        h.transformQuat = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = c[0]
          h = c[1]
          i = c[2]
          j = c[3]
          k = j * d + h * f - i * e
          l = j * e + i * d - g * f
          m = j * f + g * e - h * d
          n = -g * d - h * e - i * f
          a[0] = k * j + n * -g + l * -i - m * -h
          a[1] = l * j + n * -h + m * -g - k * -i
          a[2] = m * j + n * -i + k * -h - l * -g
          a

        h.rotateX = (a, b, c, d) ->
          e = []
          f = []
          e[0] = b[0] - c[0]
          e[1] = b[1] - c[1]
          e[2] = b[2] - c[2]
          f[0] = e[0]
          f[1] = e[1] * Math.cos(d) - e[2] * Math.sin(d)
          f[2] = e[1] * Math.sin(d) + e[2] * Math.cos(d)
          a[0] = f[0] + c[0]
          a[1] = f[1] + c[1]
          a[2] = f[2] + c[2]
          a

        h.rotateY = (a, b, c, d) ->
          e = []
          f = []
          e[0] = b[0] - c[0]
          e[1] = b[1] - c[1]
          e[2] = b[2] - c[2]
          f[0] = e[2] * Math.sin(d) + e[0] * Math.cos(d)
          f[1] = e[1]
          f[2] = e[2] * Math.cos(d) - e[0] * Math.sin(d)
          a[0] = f[0] + c[0]
          a[1] = f[1] + c[1]
          a[2] = f[2] + c[2]
          a

        h.rotateZ = (a, b, c, d) ->
          e = []
          f = []
          e[0] = b[0] - c[0]
          e[1] = b[1] - c[1]
          e[2] = b[2] - c[2]
          f[0] = e[0] * Math.cos(d) - e[1] * Math.sin(d)
          f[1] = e[0] * Math.sin(d) + e[1] * Math.cos(d)
          f[2] = e[2]
          a[0] = f[0] + c[0]
          a[1] = f[1] + c[1]
          a[2] = f[2] + c[2]
          a

        h.forEach = ->
          a = h.create()
          (b, c, d, e, f, g) ->
            h = undefined
            i = undefined
            c or (c = 3)
            d or (d = 0)
            i = (if e then Math.min(e * c + d, b.length) else b.length)
            h = d

            while i > h
              a[0] = b[h]
              a[1] = b[h + 1]
              a[2] = b[h + 2]
              f(a, a, g)
              b[h] = a[0]
              b[h + 1] = a[1]
              b[h + 2] = a[2]
              h += c
            b
        ()
        h.str = (a) ->
          "vec3(" + a[0] + ", " + a[1] + ", " + a[2] + ")"

        "undefined" isnt typeof a and (a.vec3 = h)

        i = {}
        i.create = ->
          a = new c(4)
          a[0] = 0
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a

        i.clone = (a) ->
          b = new c(4)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b[3] = a[3]
          b

        i.fromValues = (a, b, d, e) ->
          f = new c(4)
          f[0] = a
          f[1] = b
          f[2] = d
          f[3] = e
          f

        i.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a

        i.set = (a, b, c, d, e) ->
          a[0] = b
          a[1] = c
          a[2] = d
          a[3] = e
          a

        i.add = (a, b, c) ->
          a[0] = b[0] + c[0]
          a[1] = b[1] + c[1]
          a[2] = b[2] + c[2]
          a[3] = b[3] + c[3]
          a

        i.subtract = (a, b, c) ->
          a[0] = b[0] - c[0]
          a[1] = b[1] - c[1]
          a[2] = b[2] - c[2]
          a[3] = b[3] - c[3]
          a

        i.sub = i.subtract
        i.multiply = (a, b, c) ->
          a[0] = b[0] * c[0]
          a[1] = b[1] * c[1]
          a[2] = b[2] * c[2]
          a[3] = b[3] * c[3]
          a

        i.mul = i.multiply
        i.divide = (a, b, c) ->
          a[0] = b[0] / c[0]
          a[1] = b[1] / c[1]
          a[2] = b[2] / c[2]
          a[3] = b[3] / c[3]
          a

        i.div = i.divide
        i.min = (a, b, c) ->
          a[0] = Math.min(b[0], c[0])
          a[1] = Math.min(b[1], c[1])
          a[2] = Math.min(b[2], c[2])
          a[3] = Math.min(b[3], c[3])
          a

        i.max = (a, b, c) ->
          a[0] = Math.max(b[0], c[0])
          a[1] = Math.max(b[1], c[1])
          a[2] = Math.max(b[2], c[2])
          a[3] = Math.max(b[3], c[3])
          a

        i.scale = (a, b, c) ->
          a[0] = b[0] * c
          a[1] = b[1] * c
          a[2] = b[2] * c
          a[3] = b[3] * c
          a

        i.scaleAndAdd = (a, b, c, d) ->
          a[0] = b[0] + c[0] * d
          a[1] = b[1] + c[1] * d
          a[2] = b[2] + c[2] * d
          a[3] = b[3] + c[3] * d
          a

        i.distance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          e = b[2] - a[2]
          f = b[3] - a[3]
          Math.sqrt c * c + d * d + e * e + f * f

        i.dist = i.distance
        i.squaredDistance = (a, b) ->
          c = b[0] - a[0]
          d = b[1] - a[1]
          e = b[2] - a[2]
          f = b[3] - a[3]
          c * c + d * d + e * e + f * f

        i.sqrDist = i.squaredDistance
        i.length = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          e = a[3]
          Math.sqrt b * b + c * c + d * d + e * e

        i.len = i.length
        i.squaredLength = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          e = a[3]
          b * b + c * c + d * d + e * e

        i.sqrLen = i.squaredLength
        i.negate = (a, b) ->
          a[0] = -b[0]
          a[1] = -b[1]
          a[2] = -b[2]
          a[3] = -b[3]
          a

        i.normalize = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = c * c + d * d + e * e + f * f
          g > 0 and (g = 1 / Math.sqrt(g)
          a[0] = b[0] * g
          a[1] = b[1] * g
          a[2] = b[2] * g
          a[3] = b[3] * g
          )
          a

        i.dot = (a, b) ->
          a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3]

        i.lerp = (a, b, c, d) ->
          e = b[0]
          f = b[1]
          g = b[2]
          h = b[3]
          a[0] = e + d * (c[0] - e)
          a[1] = f + d * (c[1] - f)
          a[2] = g + d * (c[2] - g)
          a[3] = h + d * (c[3] - h)
          a

        i.random = (a, b) ->
          b = b or 1
          a[0] = d()
          a[1] = d()
          a[2] = d()
          a[3] = d()
          i.normalize(a, a)
          i.scale(a, a, b)
          a

        i.transformMat4 = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          a[0] = c[0] * d + c[4] * e + c[8] * f + c[12] * g
          a[1] = c[1] * d + c[5] * e + c[9] * f + c[13] * g
          a[2] = c[2] * d + c[6] * e + c[10] * f + c[14] * g
          a[3] = c[3] * d + c[7] * e + c[11] * f + c[15] * g
          a

        i.transformQuat = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = c[0]
          h = c[1]
          i = c[2]
          j = c[3]
          k = j * d + h * f - i * e
          l = j * e + i * d - g * f
          m = j * f + g * e - h * d
          n = -g * d - h * e - i * f
          a[0] = k * j + n * -g + l * -i - m * -h
          a[1] = l * j + n * -h + m * -g - k * -i
          a[2] = m * j + n * -i + k * -h - l * -g
          a

        i.forEach = ->
          a = i.create()
          (b, c, d, e, f, g) ->
            h = undefined
            i = undefined
            c or (c = 4)
            d or (d = 0)
            i = (if e then Math.min(e * c + d, b.length) else b.length)
            h = d

            while i > h
              a[0] = b[h]
              a[1] = b[h + 1]
              a[2] = b[h + 2]
              a[3] = b[h + 3]
              f(a, a, g)
              b[h] = a[0]
              b[h + 1] = a[1]
              b[h + 2] = a[2]
              b[h + 3] = a[3]
              h += c
            b
        ()
        i.str = (a) ->
          "vec4(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ")"

        "undefined" isnt typeof a and (a.vec4 = i)

        j = {}
        j.create = ->
          a = new c(4)
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a

        j.clone = (a) ->
          b = new c(4)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b[3] = a[3]
          b

        j.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a

        j.identity = (a) ->
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a

        j.transpose = (a, b) ->
          if a is b
            c = b[1]
            a[1] = b[2]
            a[2] = c
          else
            a[0] = b[0]
            a[1] = b[2]
            a[2] = b[1]
            a[3] = b[3]
          a

        j.invert = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = c * f - e * d
          (if g then (g = 1 / g
          a[0] = f * g
          a[1] = -d * g
          a[2] = -e * g
          a[3] = c * g
          a
          ) else null)

        j.adjoint = (a, b) ->
          c = b[0]
          a[0] = b[3]
          a[1] = -b[1]
          a[2] = -b[2]
          a[3] = c
          a

        j.determinant = (a) ->
          a[0] * a[3] - a[2] * a[1]

        j.multiply = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = c[0]
          i = c[1]
          j = c[2]
          k = c[3]
          a[0] = d * h + f * i
          a[1] = e * h + g * i
          a[2] = d * j + f * k
          a[3] = e * j + g * k
          a

        j.mul = j.multiply
        j.rotate = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = Math.sin(c)
          i = Math.cos(c)
          a[0] = d * i + f * h
          a[1] = e * i + g * h
          a[2] = d * -h + f * i
          a[3] = e * -h + g * i
          a

        j.scale = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = c[0]
          i = c[1]
          a[0] = d * h
          a[1] = e * h
          a[2] = f * i
          a[3] = g * i
          a

        j.str = (a) ->
          "mat2(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ")"

        j.frob = (a) ->
          Math.sqrt Math.pow(a[0], 2) + Math.pow(a[1], 2) + Math.pow(a[2], 2) + Math.pow(a[3], 2)

        j.LDU = (a, b, c, d) ->
          a[2] = d[2] / d[0]
          c[0] = d[0]
          c[1] = d[1]
          c[3] = d[3] - a[2] * c[1]
          [ a, b, c ]

        "undefined" isnt typeof a and (a.mat2 = j)

        k = {}
        k.create = ->
          a = new c(6)
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a[4] = 0
          a[5] = 0
          a

        k.clone = (a) ->
          b = new c(6)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b[3] = a[3]
          b[4] = a[4]
          b[5] = a[5]
          b

        k.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a[4] = b[4]
          a[5] = b[5]
          a

        k.identity = (a) ->
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a[4] = 0
          a[5] = 0
          a

        k.invert = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = c * f - d * e
          (if i then (i = 1 / i
          a[0] = f * i
          a[1] = -d * i
          a[2] = -e * i
          a[3] = c * i
          a[4] = (e * h - f * g) * i
          a[5] = (d * g - c * h) * i
          a
          ) else null)

        k.determinant = (a) ->
          a[0] * a[3] - a[1] * a[2]

        k.multiply = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = c[0]
          k = c[1]
          l = c[2]
          m = c[3]
          n = c[4]
          o = c[5]
          a[0] = d * j + f * k
          a[1] = e * j + g * k
          a[2] = d * l + f * m
          a[3] = e * l + g * m
          a[4] = d * n + f * o + h
          a[5] = e * n + g * o + i
          a

        k.mul = k.multiply
        k.rotate = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = Math.sin(c)
          k = Math.cos(c)
          a[0] = d * k + f * j
          a[1] = e * k + g * j
          a[2] = d * -j + f * k
          a[3] = e * -j + g * k
          a[4] = h
          a[5] = i
          a

        k.scale = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = c[0]
          k = c[1]
          a[0] = d * j
          a[1] = e * j
          a[2] = f * k
          a[3] = g * k
          a[4] = h
          a[5] = i
          a

        k.translate = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = c[0]
          k = c[1]
          a[0] = d
          a[1] = e
          a[2] = f
          a[3] = g
          a[4] = d * j + f * k + h
          a[5] = e * j + g * k + i
          a

        k.str = (a) ->
          "mat2d(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ", " + a[4] + ", " + a[5] + ")"

        k.frob = (a) ->
          Math.sqrt Math.pow(a[0], 2) + Math.pow(a[1], 2) + Math.pow(a[2], 2) + Math.pow(a[3], 2) + Math.pow(a[4], 2) + Math.pow(a[5], 2) + 1

        "undefined" isnt typeof a and (a.mat2d = k)

        l = {}
        l.create = ->
          a = new c(9)
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 1
          a[5] = 0
          a[6] = 0
          a[7] = 0
          a[8] = 1
          a

        l.fromMat4 = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[4]
          a[4] = b[5]
          a[5] = b[6]
          a[6] = b[8]
          a[7] = b[9]
          a[8] = b[10]
          a

        l.clone = (a) ->
          b = new c(9)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b[3] = a[3]
          b[4] = a[4]
          b[5] = a[5]
          b[6] = a[6]
          b[7] = a[7]
          b[8] = a[8]
          b

        l.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a[4] = b[4]
          a[5] = b[5]
          a[6] = b[6]
          a[7] = b[7]
          a[8] = b[8]
          a

        l.identity = (a) ->
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 1
          a[5] = 0
          a[6] = 0
          a[7] = 0
          a[8] = 1
          a

        l.transpose = (a, b) ->
          if a is b
            c = b[1]
            d = b[2]
            e = b[5]
            a[1] = b[3]
            a[2] = b[6]
            a[3] = c
            a[5] = b[7]
            a[6] = d
            a[7] = e
          else
            a[0] = b[0]
            a[1] = b[3]
            a[2] = b[6]
            a[3] = b[1]
            a[4] = b[4]
            a[5] = b[7]
            a[6] = b[2]
            a[7] = b[5]
            a[8] = b[8]
          a

        l.invert = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = b[6]
          j = b[7]
          k = b[8]
          l = k * g - h * j
          m = -k * f + h * i
          n = j * f - g * i
          o = c * l + d * m + e * n
          (if o then (o = 1 / o
          a[0] = l * o
          a[1] = (-k * d + e * j) * o
          a[2] = (h * d - e * g) * o
          a[3] = m * o
          a[4] = (k * c - e * i) * o
          a[5] = (-h * c + e * f) * o
          a[6] = n * o
          a[7] = (-j * c + d * i) * o
          a[8] = (g * c - d * f) * o
          a
          ) else null)

        l.adjoint = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = b[6]
          j = b[7]
          k = b[8]
          a[0] = g * k - h * j
          a[1] = e * j - d * k
          a[2] = d * h - e * g
          a[3] = h * i - f * k
          a[4] = c * k - e * i
          a[5] = e * f - c * h
          a[6] = f * j - g * i
          a[7] = d * i - c * j
          a[8] = c * g - d * f
          a

        l.determinant = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          e = a[3]
          f = a[4]
          g = a[5]
          h = a[6]
          i = a[7]
          j = a[8]
          b * (j * f - g * i) + c * (-j * e + g * h) + d * (i * e - f * h)

        l.multiply = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = b[6]
          k = b[7]
          l = b[8]
          m = c[0]
          n = c[1]
          o = c[2]
          p = c[3]
          q = c[4]
          r = c[5]
          s = c[6]
          t = c[7]
          u = c[8]
          a[0] = m * d + n * g + o * j
          a[1] = m * e + n * h + o * k
          a[2] = m * f + n * i + o * l
          a[3] = p * d + q * g + r * j
          a[4] = p * e + q * h + r * k
          a[5] = p * f + q * i + r * l
          a[6] = s * d + t * g + u * j
          a[7] = s * e + t * h + u * k
          a[8] = s * f + t * i + u * l
          a

        l.mul = l.multiply
        l.translate = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = b[6]
          k = b[7]
          l = b[8]
          m = c[0]
          n = c[1]
          a[0] = d
          a[1] = e
          a[2] = f
          a[3] = g
          a[4] = h
          a[5] = i
          a[6] = m * d + n * g + j
          a[7] = m * e + n * h + k
          a[8] = m * f + n * i + l
          a

        l.rotate = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = b[6]
          k = b[7]
          l = b[8]
          m = Math.sin(c)
          n = Math.cos(c)
          a[0] = n * d + m * g
          a[1] = n * e + m * h
          a[2] = n * f + m * i
          a[3] = n * g - m * d
          a[4] = n * h - m * e
          a[5] = n * i - m * f
          a[6] = j
          a[7] = k
          a[8] = l
          a

        l.scale = (a, b, c) ->
          d = c[0]
          e = c[1]
          a[0] = d * b[0]
          a[1] = d * b[1]
          a[2] = d * b[2]
          a[3] = e * b[3]
          a[4] = e * b[4]
          a[5] = e * b[5]
          a[6] = b[6]
          a[7] = b[7]
          a[8] = b[8]
          a

        l.fromMat2d = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = 0
          a[3] = b[2]
          a[4] = b[3]
          a[5] = 0
          a[6] = b[4]
          a[7] = b[5]
          a[8] = 1
          a

        l.fromQuat = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = c + c
          h = d + d
          i = e + e
          j = c * g
          k = d * g
          l = d * h
          m = e * g
          n = e * h
          o = e * i
          p = f * g
          q = f * h
          r = f * i
          a[0] = 1 - l - o
          a[3] = k - r
          a[6] = m + q
          a[1] = k + r
          a[4] = 1 - j - o
          a[7] = n - p
          a[2] = m - q
          a[5] = n + p
          a[8] = 1 - j - l
          a

        l.normalFromMat4 = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = b[6]
          j = b[7]
          k = b[8]
          l = b[9]
          m = b[10]
          n = b[11]
          o = b[12]
          p = b[13]
          q = b[14]
          r = b[15]
          s = c * h - d * g
          t = c * i - e * g
          u = c * j - f * g
          v = d * i - e * h
          w = d * j - f * h
          x = e * j - f * i
          y = k * p - l * o
          z = k * q - m * o
          A = k * r - n * o
          B = l * q - m * p
          C = l * r - n * p
          D = m * r - n * q
          E = s * D - t * C + u * B + v * A - w * z + x * y
          (if E then (E = 1 / E
          a[0] = (h * D - i * C + j * B) * E
          a[1] = (i * A - g * D - j * z) * E
          a[2] = (g * C - h * A + j * y) * E
          a[3] = (e * C - d * D - f * B) * E
          a[4] = (c * D - e * A + f * z) * E
          a[5] = (d * A - c * C - f * y) * E
          a[6] = (p * x - q * w + r * v) * E
          a[7] = (q * u - o * x - r * t) * E
          a[8] = (o * w - p * u + r * s) * E
          a
          ) else null)

        l.str = (a) ->
          "mat3(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ", " + a[4] + ", " + a[5] + ", " + a[6] + ", " + a[7] + ", " + a[8] + ")"

        l.frob = (a) ->
          Math.sqrt Math.pow(a[0], 2) + Math.pow(a[1], 2) + Math.pow(a[2], 2) + Math.pow(a[3], 2) + Math.pow(a[4], 2) + Math.pow(a[5], 2) + Math.pow(a[6], 2) + Math.pow(a[7], 2) + Math.pow(a[8], 2)

        "undefined" isnt typeof a and (a.mat3 = l)

        m = {}
        m.create = ->
          a = new c(16)
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 0
          a[5] = 1
          a[6] = 0
          a[7] = 0
          a[8] = 0
          a[9] = 0
          a[10] = 1
          a[11] = 0
          a[12] = 0
          a[13] = 0
          a[14] = 0
          a[15] = 1
          a

        m.clone = (a) ->
          b = new c(16)
          b[0] = a[0]
          b[1] = a[1]
          b[2] = a[2]
          b[3] = a[3]
          b[4] = a[4]
          b[5] = a[5]
          b[6] = a[6]
          b[7] = a[7]
          b[8] = a[8]
          b[9] = a[9]
          b[10] = a[10]
          b[11] = a[11]
          b[12] = a[12]
          b[13] = a[13]
          b[14] = a[14]
          b[15] = a[15]
          b

        m.copy = (a, b) ->
          a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a[4] = b[4]
          a[5] = b[5]
          a[6] = b[6]
          a[7] = b[7]
          a[8] = b[8]
          a[9] = b[9]
          a[10] = b[10]
          a[11] = b[11]
          a[12] = b[12]
          a[13] = b[13]
          a[14] = b[14]
          a[15] = b[15]
          a

        m.identity = (a) ->
          a[0] = 1
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 0
          a[5] = 1
          a[6] = 0
          a[7] = 0
          a[8] = 0
          a[9] = 0
          a[10] = 1
          a[11] = 0
          a[12] = 0
          a[13] = 0
          a[14] = 0
          a[15] = 1
          a

        m.transpose = (a, b) ->
          if a is b
            c = b[1]
            d = b[2]
            e = b[3]
            f = b[6]
            g = b[7]
            h = b[11]
            a[1] = b[4]
            a[2] = b[8]
            a[3] = b[12]
            a[4] = c
            a[6] = b[9]
            a[7] = b[13]
            a[8] = d
            a[9] = f
            a[11] = b[14]
            a[12] = e
            a[13] = g
            a[14] = h
          else
            a[0] = b[0]
            a[1] = b[4]
            a[2] = b[8]
            a[3] = b[12]
            a[4] = b[1]
            a[5] = b[5]
            a[6] = b[9]
            a[7] = b[13]
            a[8] = b[2]
            a[9] = b[6]
            a[10] = b[10]
            a[11] = b[14]
            a[12] = b[3]
            a[13] = b[7]
            a[14] = b[11]
            a[15] = b[15]
          a

        m.invert = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = b[6]
          j = b[7]
          k = b[8]
          l = b[9]
          m = b[10]
          n = b[11]
          o = b[12]
          p = b[13]
          q = b[14]
          r = b[15]
          s = c * h - d * g
          t = c * i - e * g
          u = c * j - f * g
          v = d * i - e * h
          w = d * j - f * h
          x = e * j - f * i
          y = k * p - l * o
          z = k * q - m * o
          A = k * r - n * o
          B = l * q - m * p
          C = l * r - n * p
          D = m * r - n * q
          E = s * D - t * C + u * B + v * A - w * z + x * y
          (if E then (E = 1 / E
          a[0] = (h * D - i * C + j * B) * E
          a[1] = (e * C - d * D - f * B) * E
          a[2] = (p * x - q * w + r * v) * E
          a[3] = (m * w - l * x - n * v) * E
          a[4] = (i * A - g * D - j * z) * E
          a[5] = (c * D - e * A + f * z) * E
          a[6] = (q * u - o * x - r * t) * E
          a[7] = (k * x - m * u + n * t) * E
          a[8] = (g * C - h * A + j * y) * E
          a[9] = (d * A - c * C - f * y) * E
          a[10] = (o * w - p * u + r * s) * E
          a[11] = (l * u - k * w - n * s) * E
          a[12] = (h * z - g * B - i * y) * E
          a[13] = (c * B - d * z + e * y) * E
          a[14] = (p * t - o * v - q * s) * E
          a[15] = (k * v - l * t + m * s) * E
          a
          ) else null)

        m.adjoint = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = b[4]
          h = b[5]
          i = b[6]
          j = b[7]
          k = b[8]
          l = b[9]
          m = b[10]
          n = b[11]
          o = b[12]
          p = b[13]
          q = b[14]
          r = b[15]
          a[0] = h * (m * r - n * q) - l * (i * r - j * q) + p * (i * n - j * m)
          a[1] = -(d * (m * r - n * q) - l * (e * r - f * q) + p * (e * n - f * m))
          a[2] = d * (i * r - j * q) - h * (e * r - f * q) + p * (e * j - f * i)
          a[3] = -(d * (i * n - j * m) - h * (e * n - f * m) + l * (e * j - f * i))
          a[4] = -(g * (m * r - n * q) - k * (i * r - j * q) + o * (i * n - j * m))
          a[5] = c * (m * r - n * q) - k * (e * r - f * q) + o * (e * n - f * m)
          a[6] = -(c * (i * r - j * q) - g * (e * r - f * q) + o * (e * j - f * i))
          a[7] = c * (i * n - j * m) - g * (e * n - f * m) + k * (e * j - f * i)
          a[8] = g * (l * r - n * p) - k * (h * r - j * p) + o * (h * n - j * l)
          a[9] = -(c * (l * r - n * p) - k * (d * r - f * p) + o * (d * n - f * l))
          a[10] = c * (h * r - j * p) - g * (d * r - f * p) + o * (d * j - f * h)
          a[11] = -(c * (h * n - j * l) - g * (d * n - f * l) + k * (d * j - f * h))
          a[12] = -(g * (l * q - m * p) - k * (h * q - i * p) + o * (h * m - i * l))
          a[13] = c * (l * q - m * p) - k * (d * q - e * p) + o * (d * m - e * l)
          a[14] = -(c * (h * q - i * p) - g * (d * q - e * p) + o * (d * i - e * h))
          a[15] = c * (h * m - i * l) - g * (d * m - e * l) + k * (d * i - e * h)
          a

        m.determinant = (a) ->
          b = a[0]
          c = a[1]
          d = a[2]
          e = a[3]
          f = a[4]
          g = a[5]
          h = a[6]
          i = a[7]
          j = a[8]
          k = a[9]
          l = a[10]
          m = a[11]
          n = a[12]
          o = a[13]
          p = a[14]
          q = a[15]
          r = b * g - c * f
          s = b * h - d * f
          t = b * i - e * f
          u = c * h - d * g
          v = c * i - e * g
          w = d * i - e * h
          x = j * o - k * n
          y = j * p - l * n
          z = j * q - m * n
          A = k * p - l * o
          B = k * q - m * o
          C = l * q - m * p
          r * C - s * B + t * A + u * z - v * y + w * x

        m.multiply = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = b[6]
          k = b[7]
          l = b[8]
          m = b[9]
          n = b[10]
          o = b[11]
          p = b[12]
          q = b[13]
          r = b[14]
          s = b[15]
          t = c[0]
          u = c[1]
          v = c[2]
          w = c[3]
          a[0] = t * d + u * h + v * l + w * p
          a[1] = t * e + u * i + v * m + w * q
          a[2] = t * f + u * j + v * n + w * r
          a[3] = t * g + u * k + v * o + w * s
          t = c[4]
          u = c[5]
          v = c[6]
          w = c[7]
          a[4] = t * d + u * h + v * l + w * p
          a[5] = t * e + u * i + v * m + w * q
          a[6] = t * f + u * j + v * n + w * r
          a[7] = t * g + u * k + v * o + w * s
          t = c[8]
          u = c[9]
          v = c[10]
          w = c[11]
          a[8] = t * d + u * h + v * l + w * p
          a[9] = t * e + u * i + v * m + w * q
          a[10] = t * f + u * j + v * n + w * r
          a[11] = t * g + u * k + v * o + w * s
          t = c[12]
          u = c[13]
          v = c[14]
          w = c[15]
          a[12] = t * d + u * h + v * l + w * p
          a[13] = t * e + u * i + v * m + w * q
          a[14] = t * f + u * j + v * n + w * r
          a[15] = t * g + u * k + v * o + w * s
          a

        m.mul = m.multiply
        m.translate = (a, b, c) ->
          d = undefined
          e = undefined
          f = undefined
          g = undefined
          h = undefined
          i = undefined
          j = undefined
          k = undefined
          l = undefined
          m = undefined
          n = undefined
          o = undefined
          p = c[0]
          q = c[1]
          r = c[2]
          (if b is a then (a[12] = b[0] * p + b[4] * q + b[8] * r + b[12]
          a[13] = b[1] * p + b[5] * q + b[9] * r + b[13]
          a[14] = b[2] * p + b[6] * q + b[10] * r + b[14]
          a[15] = b[3] * p + b[7] * q + b[11] * r + b[15]
          ) else (d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = b[4]
          i = b[5]
          j = b[6]
          k = b[7]
          l = b[8]
          m = b[9]
          n = b[10]
          o = b[11]
          a[0] = d
          a[1] = e
          a[2] = f
          a[3] = g
          a[4] = h
          a[5] = i
          a[6] = j
          a[7] = k
          a[8] = l
          a[9] = m
          a[10] = n
          a[11] = o
          a[12] = d * p + h * q + l * r + b[12]
          a[13] = e * p + i * q + m * r + b[13]
          a[14] = f * p + j * q + n * r + b[14]
          a[15] = g * p + k * q + o * r + b[15]
          ))
          a

        m.scale = (a, b, c) ->
          d = c[0]
          e = c[1]
          f = c[2]
          a[0] = b[0] * d
          a[1] = b[1] * d
          a[2] = b[2] * d
          a[3] = b[3] * d
          a[4] = b[4] * e
          a[5] = b[5] * e
          a[6] = b[6] * e
          a[7] = b[7] * e
          a[8] = b[8] * f
          a[9] = b[9] * f
          a[10] = b[10] * f
          a[11] = b[11] * f
          a[12] = b[12]
          a[13] = b[13]
          a[14] = b[14]
          a[15] = b[15]
          a

        m.rotate = (a, c, d, e) ->
          f = undefined
          g = undefined
          h = undefined
          i = undefined
          j = undefined
          k = undefined
          l = undefined
          m = undefined
          n = undefined
          o = undefined
          p = undefined
          q = undefined
          r = undefined
          s = undefined
          t = undefined
          u = undefined
          v = undefined
          w = undefined
          x = undefined
          y = undefined
          z = undefined
          A = undefined
          B = undefined
          C = undefined
          D = e[0]
          E = e[1]
          F = e[2]
          G = Math.sqrt(D * D + E * E + F * F)
          (if Math.abs(G) < b then null else (G = 1 / G
          D *= G
          E *= G
          F *= G
          f = Math.sin(d)
          g = Math.cos(d)
          h = 1 - g
          i = c[0]
          j = c[1]
          k = c[2]
          l = c[3]
          m = c[4]
          n = c[5]
          o = c[6]
          p = c[7]
          q = c[8]
          r = c[9]
          s = c[10]
          t = c[11]
          u = D * D * h + g
          v = E * D * h + F * f
          w = F * D * h - E * f
          x = D * E * h - F * f
          y = E * E * h + g
          z = F * E * h + D * f
          A = D * F * h + E * f
          B = E * F * h - D * f
          C = F * F * h + g
          a[0] = i * u + m * v + q * w
          a[1] = j * u + n * v + r * w
          a[2] = k * u + o * v + s * w
          a[3] = l * u + p * v + t * w
          a[4] = i * x + m * y + q * z
          a[5] = j * x + n * y + r * z
          a[6] = k * x + o * y + s * z
          a[7] = l * x + p * y + t * z
          a[8] = i * A + m * B + q * C
          a[9] = j * A + n * B + r * C
          a[10] = k * A + o * B + s * C
          a[11] = l * A + p * B + t * C
          c isnt a and (a[12] = c[12]
          a[13] = c[13]
          a[14] = c[14]
          a[15] = c[15]
          )
          a
          ))

        m.rotateX = (a, b, c) ->
          d = Math.sin(c)
          e = Math.cos(c)
          f = b[4]
          g = b[5]
          h = b[6]
          i = b[7]
          j = b[8]
          k = b[9]
          l = b[10]
          m = b[11]
          b isnt a and (a[0] = b[0]
          a[1] = b[1]
          a[2] = b[2]
          a[3] = b[3]
          a[12] = b[12]
          a[13] = b[13]
          a[14] = b[14]
          a[15] = b[15]
          )
          a[4] = f * e + j * d
          a[5] = g * e + k * d
          a[6] = h * e + l * d
          a[7] = i * e + m * d
          a[8] = j * e - f * d
          a[9] = k * e - g * d
          a[10] = l * e - h * d
          a[11] = m * e - i * d
          a

        m.rotateY = (a, b, c) ->
          d = Math.sin(c)
          e = Math.cos(c)
          f = b[0]
          g = b[1]
          h = b[2]
          i = b[3]
          j = b[8]
          k = b[9]
          l = b[10]
          m = b[11]
          b isnt a and (a[4] = b[4]
          a[5] = b[5]
          a[6] = b[6]
          a[7] = b[7]
          a[12] = b[12]
          a[13] = b[13]
          a[14] = b[14]
          a[15] = b[15]
          )
          a[0] = f * e - j * d
          a[1] = g * e - k * d
          a[2] = h * e - l * d
          a[3] = i * e - m * d
          a[8] = f * d + j * e
          a[9] = g * d + k * e
          a[10] = h * d + l * e
          a[11] = i * d + m * e
          a

        m.rotateZ = (a, b, c) ->
          d = Math.sin(c)
          e = Math.cos(c)
          f = b[0]
          g = b[1]
          h = b[2]
          i = b[3]
          j = b[4]
          k = b[5]
          l = b[6]
          m = b[7]
          b isnt a and (a[8] = b[8]
          a[9] = b[9]
          a[10] = b[10]
          a[11] = b[11]
          a[12] = b[12]
          a[13] = b[13]
          a[14] = b[14]
          a[15] = b[15]
          )
          a[0] = f * e + j * d
          a[1] = g * e + k * d
          a[2] = h * e + l * d
          a[3] = i * e + m * d
          a[4] = j * e - f * d
          a[5] = k * e - g * d
          a[6] = l * e - h * d
          a[7] = m * e - i * d
          a

        m.fromRotationTranslation = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = d + d
          i = e + e
          j = f + f
          k = d * h
          l = d * i
          m = d * j
          n = e * i
          o = e * j
          p = f * j
          q = g * h
          r = g * i
          s = g * j
          a[0] = 1 - (n + p)
          a[1] = l + s
          a[2] = m - r
          a[3] = 0
          a[4] = l - s
          a[5] = 1 - (k + p)
          a[6] = o + q
          a[7] = 0
          a[8] = m + r
          a[9] = o - q
          a[10] = 1 - (k + n)
          a[11] = 0
          a[12] = c[0]
          a[13] = c[1]
          a[14] = c[2]
          a[15] = 1
          a

        m.fromQuat = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = c + c
          h = d + d
          i = e + e
          j = c * g
          k = d * g
          l = d * h
          m = e * g
          n = e * h
          o = e * i
          p = f * g
          q = f * h
          r = f * i
          a[0] = 1 - l - o
          a[1] = k + r
          a[2] = m - q
          a[3] = 0
          a[4] = k - r
          a[5] = 1 - j - o
          a[6] = n + p
          a[7] = 0
          a[8] = m + q
          a[9] = n - p
          a[10] = 1 - j - l
          a[11] = 0
          a[12] = 0
          a[13] = 0
          a[14] = 0
          a[15] = 1
          a

        m.frustum = (a, b, c, d, e, f, g) ->
          h = 1 / (c - b)
          i = 1 / (e - d)
          j = 1 / (f - g)
          a[0] = 2 * f * h
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 0
          a[5] = 2 * f * i
          a[6] = 0
          a[7] = 0
          a[8] = (c + b) * h
          a[9] = (e + d) * i
          a[10] = (g + f) * j
          a[11] = -1
          a[12] = 0
          a[13] = 0
          a[14] = g * f * 2 * j
          a[15] = 0
          a

        m.perspective = (a, b, c, d, e) ->
          f = 1 / Math.tan(b / 2)
          g = 1 / (d - e)
          a[0] = f / c
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 0
          a[5] = f
          a[6] = 0
          a[7] = 0
          a[8] = 0
          a[9] = 0
          a[10] = (e + d) * g
          a[11] = -1
          a[12] = 0
          a[13] = 0
          a[14] = 2 * e * d * g
          a[15] = 0
          a

        m.ortho = (a, b, c, d, e, f, g) ->
          h = 1 / (b - c)
          i = 1 / (d - e)
          j = 1 / (f - g)
          a[0] = -2 * h
          a[1] = 0
          a[2] = 0
          a[3] = 0
          a[4] = 0
          a[5] = -2 * i
          a[6] = 0
          a[7] = 0
          a[8] = 0
          a[9] = 0
          a[10] = 2 * j
          a[11] = 0
          a[12] = (b + c) * h
          a[13] = (e + d) * i
          a[14] = (g + f) * j
          a[15] = 1
          a

        m.lookAt = (a, c, d, e) ->
          f = undefined
          g = undefined
          h = undefined
          i = undefined
          j = undefined
          k = undefined
          l = undefined
          n = undefined
          o = undefined
          p = undefined
          q = c[0]
          r = c[1]
          s = c[2]
          t = e[0]
          u = e[1]
          v = e[2]
          w = d[0]
          x = d[1]
          y = d[2]
          (if Math.abs(q - w) < b and Math.abs(r - x) < b and Math.abs(s - y) < b then m.identity(a) else (l = q - w
          n = r - x
          o = s - y
          p = 1 / Math.sqrt(l * l + n * n + o * o)
          l *= p
          n *= p
          o *= p
          f = u * o - v * n
          g = v * l - t * o
          h = t * n - u * l
          p = Math.sqrt(f * f + g * g + h * h)
          (if p then (p = 1 / p
          f *= p
          g *= p
          h *= p
          ) else (f = 0
          g = 0
          h = 0
          ))
          i = n * h - o * g
          j = o * f - l * h
          k = l * g - n * f
          p = Math.sqrt(i * i + j * j + k * k)
          (if p then (p = 1 / p
          i *= p
          j *= p
          k *= p
          ) else (i = 0
          j = 0
          k = 0
          ))
          a[0] = f
          a[1] = i
          a[2] = l
          a[3] = 0
          a[4] = g
          a[5] = j
          a[6] = n
          a[7] = 0
          a[8] = h
          a[9] = k
          a[10] = o
          a[11] = 0
          a[12] = -(f * q + g * r + h * s)
          a[13] = -(i * q + j * r + k * s)
          a[14] = -(l * q + n * r + o * s)
          a[15] = 1
          a
          ))

        m.str = (a) ->
          "mat4(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ", " + a[4] + ", " + a[5] + ", " + a[6] + ", " + a[7] + ", " + a[8] + ", " + a[9] + ", " + a[10] + ", " + a[11] + ", " + a[12] + ", " + a[13] + ", " + a[14] + ", " + a[15] + ")"

        m.frob = (a) ->
          Math.sqrt Math.pow(a[0], 2) + Math.pow(a[1], 2) + Math.pow(a[2], 2) + Math.pow(a[3], 2) + Math.pow(a[4], 2) + Math.pow(a[5], 2) + Math.pow(a[6], 2) + Math.pow(a[6], 2) + Math.pow(a[7], 2) + Math.pow(a[8], 2) + Math.pow(a[9], 2) + Math.pow(a[10], 2) + Math.pow(a[11], 2) + Math.pow(a[12], 2) + Math.pow(a[13], 2) + Math.pow(a[14], 2) + Math.pow(a[15], 2)

        "undefined" isnt typeof a and (a.mat4 = m)

        n = {}
        n.create = ->
          a = new c(4)
          a[0] = 0
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a

        n.rotationTo = ->
          a = h.create()
          b = h.fromValues(1, 0, 0)
          c = h.fromValues(0, 1, 0)
          (d, e, f) ->
            g = h.dot(e, f)
            (if -.999999 > g then (h.cross(a, b, e)
            h.length(a) < 1e-6 and h.cross(a, c, e)
            h.normalize(a, a)
            n.setAxisAngle(d, a, Math.PI)
            d
            ) else (if g > .999999 then (d[0] = 0
            d[1] = 0
            d[2] = 0
            d[3] = 1
            d
            ) else (h.cross(a, e, f)
            d[0] = a[0]
            d[1] = a[1]
            d[2] = a[2]
            d[3] = 1 + g
            n.normalize(d, d)
            )))
        ()
        n.setAxes = ->
          a = l.create()
          (b, c, d, e) ->
            a[0] = d[0]
            a[3] = d[1]
            a[6] = d[2]
            a[1] = e[0]
            a[4] = e[1]
            a[7] = e[2]
            a[2] = -c[0]
            a[5] = -c[1]
            a[8] = -c[2]
            n.normalize(b, n.fromMat3(b, a))
        ()
        n.clone = i.clone
        n.fromValues = i.fromValues
        n.copy = i.copy
        n.set = i.set
        n.identity = (a) ->
          a[0] = 0
          a[1] = 0
          a[2] = 0
          a[3] = 1
          a

        n.setAxisAngle = (a, b, c) ->
          c = .5 * c
          d = Math.sin(c)
          a[0] = d * b[0]
          a[1] = d * b[1]
          a[2] = d * b[2]
          a[3] = Math.cos(c)
          a

        n.add = i.add
        n.multiply = (a, b, c) ->
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = c[0]
          i = c[1]
          j = c[2]
          k = c[3]
          a[0] = d * k + g * h + e * j - f * i
          a[1] = e * k + g * i + f * h - d * j
          a[2] = f * k + g * j + d * i - e * h
          a[3] = g * k - d * h - e * i - f * j
          a

        n.mul = n.multiply
        n.scale = i.scale
        n.rotateX = (a, b, c) ->
          c *= .5
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = Math.sin(c)
          i = Math.cos(c)
          a[0] = d * i + g * h
          a[1] = e * i + f * h
          a[2] = f * i - e * h
          a[3] = g * i - d * h
          a

        n.rotateY = (a, b, c) ->
          c *= .5
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = Math.sin(c)
          i = Math.cos(c)
          a[0] = d * i - f * h
          a[1] = e * i + g * h
          a[2] = f * i + d * h
          a[3] = g * i - e * h
          a

        n.rotateZ = (a, b, c) ->
          c *= .5
          d = b[0]
          e = b[1]
          f = b[2]
          g = b[3]
          h = Math.sin(c)
          i = Math.cos(c)
          a[0] = d * i + e * h
          a[1] = e * i - d * h
          a[2] = f * i + g * h
          a[3] = g * i - f * h
          a

        n.calculateW = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          a[0] = c
          a[1] = d
          a[2] = e
          a[3] = -Math.sqrt(Math.abs(1 - c * c - d * d - e * e))
          a

        n.dot = i.dot
        n.lerp = i.lerp
        n.slerp = (a, b, c, d) ->
          e = undefined
          f = undefined
          g = undefined
          h = undefined
          i = undefined
          j = b[0]
          k = b[1]
          l = b[2]
          m = b[3]
          n = c[0]
          o = c[1]
          p = c[2]
          q = c[3]
          f = j * n + k * o + l * p + m * q
          0 > f and (f = -f
          n = -n
          o = -o
          p = -p
          q = -q
          )
          (if 1 - f > 1e-6 then (e = Math.acos(f)
          g = Math.sin(e)
          h = Math.sin((1 - d) * e) / g
          i = Math.sin(d * e) / g
          ) else (h = 1 - d
          i = d
          ))
          a[0] = h * j + i * n
          a[1] = h * k + i * o
          a[2] = h * l + i * p
          a[3] = h * m + i * q
          a

        n.invert = (a, b) ->
          c = b[0]
          d = b[1]
          e = b[2]
          f = b[3]
          g = c * c + d * d + e * e + f * f
          h = (if g then 1 / g else 0)
          a[0] = -c * h
          a[1] = -d * h
          a[2] = -e * h
          a[3] = f * h
          a

        n.conjugate = (a, b) ->
          a[0] = -b[0]
          a[1] = -b[1]
          a[2] = -b[2]
          a[3] = b[3]
          a

        n.length = i.length
        n.len = n.length
        n.squaredLength = i.squaredLength
        n.sqrLen = n.squaredLength
        n.normalize = i.normalize
        n.fromMat3 = (a, b) ->
          c = undefined
          d = b[0] + b[4] + b[8]
          unless d > 0
            e = 0
            b[4] > b[0] and (e = 1)
            b[8] > b[3 * e + e] and (e = 2)

            f = (e + 1) % 3
            g = (e + 2) % 3
            c = Math.sqrt(b[3 * e + e] - b[3 * f + f] - b[3 * g + g] + 1)
            a[e] = .5 * c
            c = .5 / c
            a[3] = (b[3 * g + f] - b[3 * f + g]) * c
            a[f] = (b[3 * f + e] + b[3 * e + f]) * c
            a[g] = (b[3 * g + e] + b[3 * e + g]) * c
          a

        n.str = (a) ->
          "quat(" + a[0] + ", " + a[1] + ", " + a[2] + ", " + a[3] + ")"

        "undefined" isnt typeof a and (a.quat = n)
      (b.exports)
    (this)
  , {} ]
  24: [ (a, b, c) ->
    (->
      a = this
      d = a._
      e = {}
      f = Array::
      g = Object::
      h = Function::
      i = f.push
      j = f.slice
      k = f.concat
      l = g.toString
      m = g.hasOwnProperty
      n = f.forEach
      o = f.map
      p = f.reduce
      q = f.reduceRight
      r = f.filter
      s = f.every
      t = f.some
      u = f.indexOf
      v = f.lastIndexOf
      w = Array.isArray
      x = Object.keys
      y = h.bind
      z = (a) ->
        (if a instanceof z then a else (if this instanceof z then undefined else new z(a)))

      (if "undefined" isnt typeof c then ("undefined" isnt typeof b and b.exports and (c = b.exports = z)
      c._ = z
      ) else a._ = z)
      z.VERSION = "1.4.4"

      A = z.each = z.forEach = (a, b, c) ->
        unless null is a
          if n and a.forEach is n
            a.forEach b, c
          else if a.length is +a.length
            d = 0
            f = a.length

            while f > d
              return  if b.call(c, a[d], d, a) is e
              d++
          else
            for g of a
              return  if z.has(a, g) and b.call(c, a[g], g, a) is e

      z.map = z.collect = (a, b, c) ->
        d = []
        (if null is a then d else (if o and a.map is o then a.map(b, c) else (A(a, (a, e, f) ->
          d[d.length] = b.call(c, a, e, f)
        )
        d
        )))

      B = "Reduce of empty array with no initial value"
      z.reduce = z.foldl = z.inject = (a, b, c, d) ->
        e = arguments.length > 2
        if null is a and (a = [])
        p and a.reduce is p
          return d and (b = z.bind(b, d))
          (if e then a.reduce(b, c) else a.reduce(b))
        throw new TypeError(B)  if A(a, (a, f, g) ->
          (if e then c = b.call(d, c, a, f, g) else (c = a
          e = not 0
          ))
        )
        not e

        c

      z.reduceRight = z.foldr = (a, b, c, d) ->
        e = arguments.length > 2
        if null is a and (a = [])
        q and a.reduceRight is q
          return d and (b = z.bind(b, d))
          (if e then a.reduceRight(b, c) else a.reduceRight(b))
        f = a.length
        if f isnt +f
          g = z.keys(a)
          f = g.length
        throw new TypeError(B)  if A(a, (h, i, j) ->
          i = (if g then g[--f] else --f)
          (if e then c = b.call(d, c, a[i], i, j) else (c = a[i]
          e = not 0
          ))
        )
        not e

        c

      z.find = z.detect = (a, b, c) ->
        d = undefined
        C(a, (a, e, f) ->
          (if b.call(c, a, e, f) then (d = a
          not 0
          ) else undefined)
        )
        d

      z.filter = z.select = (a, b, c) ->
        d = []
        (if null is a then d else (if r and a.filter is r then a.filter(b, c) else (A(a, (a, e, f) ->
          b.call(c, a, e, f) and (d[d.length] = a)
        )
        d
        )))

      z.reject = (a, b, c) ->
        z.filter a, ((a, d, e) ->
          not b.call(c, a, d, e)
        ), c

      z.every = z.all = (a, b, c) ->
        b or (b = z.identity)
        d = not 0
        (if null is a then d else (if s and a.every is s then a.every(b, c) else (A(a, (a, f, g) ->
          (if (d = d and b.call(c, a, f, g)) then undefined else e)
        )
        !!d
        )))


      C = z.some = z.any = (a, b, c) ->
        b or (b = z.identity)
        d = not 1
        (if null is a then d else (if t and a.some is t then a.some(b, c) else (A(a, (a, f, g) ->
          (if d or (d = b.call(c, a, f, g)) then e else undefined)
        )
        !!d
        )))

      z.contains = z.include = (a, b) ->
        (if null is a then not 1 else (if u and a.indexOf is u then -1 isnt a.indexOf(b) else C(a, (a) ->
          a is b
        )))

      z.invoke = (a, b) ->
        c = j.call(arguments, 2)
        d = z.isFunction(b)
        z.map a, (a) ->
          ((if d then b else a[b])).apply a, c


      z.pluck = (a, b) ->
        z.map a, (a) ->
          a[b]


      z.where = (a, b, c) ->
        (if z.isEmpty(b) then (if c then null else []) else z[(if c then "find" else "filter")](a, (a) ->
          for c of b
            return not 1  if b[c] isnt a[c]
          not 0
        ))

      z.findWhere = (a, b) ->
        z.where a, b, not 0

      z.max = (a, b, c) ->
        return Math.max.apply(Math, a)  if not b and z.isArray(a) and a[0] is +a[0] and a.length < 65535
        return -1 / 0  if not b and z.isEmpty(a)
        d =
          computed: -1 / 0
          value: -1 / 0

        A(a, (a, e, f) ->
          g = (if b then b.call(c, a, e, f) else a)
          g >= d.computed and (d =
            value: a
            computed: g
          )
        )
        d.value

      z.min = (a, b, c) ->
        return Math.min.apply(Math, a)  if not b and z.isArray(a) and a[0] is +a[0] and a.length < 65535
        return 1 / 0  if not b and z.isEmpty(a)
        d =
          computed: 1 / 0
          value: 1 / 0

        A(a, (a, e, f) ->
          g = (if b then b.call(c, a, e, f) else a)
          g < d.computed and (d =
            value: a
            computed: g
          )
        )
        d.value

      z.shuffle = (a) ->
        b = undefined
        c = 0
        d = []
        A(a, (a) ->
          b = z.random(c++)
          d[c - 1] = d[b]
          d[b] = a
        )
        d


      D = (a) ->
        (if z.isFunction(a) then a else (b) ->
          b[a]
        )

      z.sortBy = (a, b, c) ->
        d = D(b)
        z.pluck z.map(a, (a, b, e) ->
          value: a
          index: b
          criteria: d.call(c, a, b, e)
        ).sort((a, b) ->
          c = a.criteria
          d = b.criteria
          if c isnt d
            return 1  if c > d or undefined is c
            return -1  if d > c or undefined is d
          (if a.index < b.index then -1 else 1)
        ), "value"

      E = (a, b, c, d) ->
        e = {}
        f = D(b or z.identity)
        A(a, (b, g) ->
          h = f.call(c, b, g, a)
          d e, h, b
        )
        e

      z.groupBy = (a, b, c) ->
        E a, b, c, (a, b, c) ->
          ((if z.has(a, b) then a[b] else a[b] = [])).push c


      z.countBy = (a, b, c) ->
        E a, b, c, (a, b) ->
          z.has(a, b) or (a[b] = 0)
          a[b]++


      z.sortedIndex = (a, b, c, d) ->
        c = (if null is c then z.identity else D(c))
        e = c.call(d, b)
        f = 0
        g = a.length

        while g > f
          h = f + g >>> 1
          (if c.call(d, a[h]) < e then f = h + 1 else g = h)
        f

      z.toArray = (a) ->
        (if a then (if z.isArray(a) then j.call(a) else (if a.length is +a.length then z.map(a, z.identity) else z.values(a))) else [])

      z.size = (a) ->
        (if null is a then 0 else (if a.length is +a.length then a.length else z.keys(a).length))

      z.first = z.head = z.take = (a, b, c) ->
        (if null is a then undefined else (if null is b or c then a[0] else j.call(a, 0, b)))

      z.initial = (a, b, c) ->
        j.call a, 0, a.length - ((if null is b or c then 1 else b))

      z.last = (a, b, c) ->
        (if null is a then undefined else (if null is b or c then a[a.length - 1] else j.call(a, Math.max(a.length - b, 0))))

      z.rest = z.tail = z.drop = (a, b, c) ->
        j.call a, (if null is b or c then 1 else b)

      z.compact = (a) ->
        z.filter a, z.identity


      F = (a, b, c) ->
        A(a, (a) ->
          (if z.isArray(a) then (if b then i.apply(c, a) else F(a, b, c)) else c.push(a))
        )
        c

      z.flatten = (a, b) ->
        F a, b, []

      z.without = (a) ->
        z.difference a, j.call(arguments, 1)

      z.uniq = z.unique = (a, b, c, d) ->
        z.isFunction(b) and (d = c
        c = b
        b = not 1
        )
        e = (if c then z.map(a, c, d) else a)
        f = []
        g = []
        A(e, (c, d) ->
          ((if b then d and g[g.length - 1] is c else z.contains(g, c))) or (g.push(c)
          f.push(a[d])
          )
        )
        f

      z.union = ->
        z.uniq k.apply(f, arguments)

      z.intersection = (a) ->
        b = j.call(arguments, 1)
        z.filter z.uniq(a), (a) ->
          z.every b, (b) ->
            z.indexOf(b, a) >= 0



      z.difference = (a) ->
        b = k.apply(f, j.call(arguments, 1))
        z.filter a, (a) ->
          not z.contains(b, a)


      z.zip = ->
        a = j.call(arguments)
        b = z.max(z.pluck(a, "length"))
        c = new Array(b)
        d = 0

        while b > d
          c[d] = z.pluck(a, "" + d)
          d++
        c

      z.object = (a, b) ->
        return {}  if null is a
        c = {}
        d = 0
        e = a.length

        while e > d
          (if b then c[a[d]] = b[d] else c[a[d][0]] = a[d][1])
          d++
        c

      z.indexOf = (a, b, c) ->
        return -1  if null is a
        d = 0
        e = a.length
        if c
          unless "number" is typeof c
            return d = z.sortedIndex(a, b)
            (if a[d] is b then d else -1)
          d = (if 0 > c then Math.max(0, e + c) else c)
        return a.indexOf(b, c)  if u and a.indexOf is u
        while e > d
          return d  if a[d] is b
          d++
        -1

      z.lastIndexOf = (a, b, c) ->
        return -1  if null is a
        d = null isnt c
        return (if d then a.lastIndexOf(b, c) else a.lastIndexOf(b))  if v and a.lastIndexOf is v
        e = (if d then c else a.length)

        while e--
          return e  if a[e] is b
        -1

      z.range = (a, b, c) ->
        arguments.length <= 1 and (b = a or 0
        a = 0
        )
        c = arguments[2] or 1

        d = Math.max(Math.ceil((b - a) / c), 0)
        e = 0
        f = new Array(d)

        while d > e
          f[e++] = a
          a += c
        f

      z.bind = (a, b) ->
        return y.apply(a, j.call(arguments, 1))  if a.bind is y and y
        c = j.call(arguments, 2)
        ->
          a.apply b, c.concat(j.call(arguments))

      z.partial = (a) ->
        b = j.call(arguments, 1)
        ->
          a.apply this, b.concat(j.call(arguments))

      z.bindAll = (a) ->
        b = j.call(arguments, 1)
        0 is b.length and (b = z.functions(a))
        A(b, (b) ->
          a[b] = z.bind(a[b], a)
        )
        a

      z.memoize = (a, b) ->
        c = {}
        b or (b = z.identity)
        ->
          d = b.apply(this, arguments)
          (if z.has(c, d) then c[d] else c[d] = a.apply(this, arguments))

      z.delay = (a, b) ->
        c = j.call(arguments, 2)
        setTimeout (->
          a.apply null, c
        ), b

      z.defer = (a) ->
        z.delay.apply z, [ a, 1 ].concat(j.call(arguments, 1))

      z.throttle = (a, b) ->
        c = undefined
        d = undefined
        e = undefined
        f = undefined
        g = 0
        h = ->
          g = new Date
          e = null
          f = a.apply(c, d)

        ->
          i = new Date
          j = b - (i - g)
          c = this
          d = arguments
          (if 0 >= j then (clearTimeout(e)
          e = null
          g = i
          f = a.apply(c, d)
          ) else e or (e = setTimeout(h, j)))
          f

      z.debounce = (a, b, c) ->
        d = undefined
        e = undefined
        ->
          f = this
          g = arguments
          h = ->
            d = null
            c or (e = a.apply(f, g))

          i = c and not d
          clearTimeout(d)
          d = setTimeout(h, b)
          i and (e = a.apply(f, g))
          e

      z.once = (a) ->
        b = undefined
        c = not 1
        ->
          (if c then b else (c = not 0
          b = a.apply(this, arguments)
          a = null
          b
          ))

      z.wrap = (a, b) ->
        ->
          c = [ a ]
          i.apply(c, arguments)
          b.apply(this, c)

      z.compose = ->
        a = arguments
        ->
          b = arguments
          c = a.length - 1

          while c >= 0
            b = [ a[c].apply(this, b) ]
            c--
          b[0]

      z.after = (a, b) ->
        (if 0 >= a then b() else ->
          (if --a < 1 then b.apply(this, arguments) else undefined)
        )

      z.keys = x or (a) ->
        throw new TypeError("Invalid object")  if a isnt Object(a)
        b = []
        for c of a
          z.has(a, c) and (b[b.length] = c)
        b

      z.values = (a) ->
        b = []
        for c of a
          z.has(a, c) and b.push(a[c])
        b

      z.pairs = (a) ->
        b = []
        for c of a
          z.has(a, c) and b.push([ c, a[c] ])
        b

      z.invert = (a) ->
        b = {}
        for c of a
          z.has(a, c) and (b[a[c]] = c)
        b

      z.functions = z.methods = (a) ->
        b = []
        for c of a
          z.isFunction(a[c]) and b.push(c)
        b.sort()

      z.extend = (a) ->
        A(j.call(arguments, 1), (b) ->
          if b
            for c of b
              a[c] = b[c]
        )
        a

      z.pick = (a) ->
        b = {}
        c = k.apply(f, j.call(arguments, 1))
        A(c, (c) ->
          c of a and (b[c] = a[c])
        )
        b

      z.omit = (a) ->
        b = {}
        c = k.apply(f, j.call(arguments, 1))
        for d of a
          z.contains(c, d) or (b[d] = a[d])
        b

      z.defaults = (a) ->
        A(j.call(arguments, 1), (b) ->
          if b
            for c of b
              null is a[c] and (a[c] = b[c])
        )
        a

      z.clone = (a) ->
        (if z.isObject(a) then (if z.isArray(a) then a.slice() else z.extend({}, a)) else a)

      z.tap = (a, b) ->
        b(a)
        a


      G = (a, b, c, d) ->
        return 0 isnt a or 1 / a is 1 / b  if a is b
        return a is b  if null is a or null is b
        a instanceof z and (a = a._wrapped)
        b instanceof z and (b = b._wrapped)

        e = l.call(a)
        return not 1  unless e is l.call(b)
        switch e
          when "[object String]"
            return a is String(b)
          when "[object Number]"
            return (if a isnt +a then b isnt +b else (if 0 is a then 1 / a is 1 / b else a is +b))
          when "[object Date]", "[object Boolean]"
            return +a is +b
          when "[object RegExp]"
            return a.source is b.source and a.global is b.global and a.multiline is b.multiline and a.ignoreCase is b.ignoreCase
        return not 1  if "object" isnt typeof a or "object" isnt typeof b
        f = c.length

        while f--
          return d[f] is b  if c[f] is a
        c.push(a)
        d.push(b)

        g = 0
        h = not 0
        if "[object Array]" is e
          while g-- and (h = G(a[g], b[g], c, d))  if g = a.length
          h = g is b.length
        else
          i = a.constructor
          j = b.constructor
          return not 1  if i isnt j and not (z.isFunction(i) and i instanceof i and z.isFunction(j) and j instanceof j)
          for k of a
            break  if z.has(a, k) and (g++
            not (h = z.has(b, k) and G(a[k], b[k], c, d))
            )
          if h
            for k of b
              break  if z.has(b, k) and not g--
            h = not g
        c.pop()
        d.pop()
        h

      z.isEqual = (a, b) ->
        G a, b, [], []

      z.isEmpty = (a) ->
        return not 0  if null is a
        return 0 is a.length  if z.isArray(a) or z.isString(a)
        for b of a
          return not 1  if z.has(a, b)
        not 0

      z.isElement = (a) ->
        not (not a or 1 isnt a.nodeType)

      z.isArray = w or (a) ->
        "[object Array]" is l.call(a)

      z.isObject = (a) ->
        a is Object(a)

      A([ "Arguments", "Function", "String", "Number", "Date", "RegExp" ], (a) ->
        z["is" + a] = (b) ->
          l.call(b) is "[object " + a + "]"
      )
      z.isArguments(arguments) or (z.isArguments = (a) ->
        not (not a or not z.has(a, "callee"))
      )
      "function" isnt typeof /./ and (z.isFunction = (a) ->
        "function" is typeof a
      )
      z.isFinite = (a) ->
        isFinite(a) and not isNaN(parseFloat(a))

      z.isNaN = (a) ->
        z.isNumber(a) and a isnt +a

      z.isBoolean = (a) ->
        a is not 0 or a is not 1 or "[object Boolean]" is l.call(a)

      z.isNull = (a) ->
        null is a

      z.isUndefined = (a) ->
        undefined is a

      z.has = (a, b) ->
        m.call a, b

      z.noConflict = ->
        a._ = d
        this

      z.identity = (a) ->
        a

      z.times = (a, b, c) ->
        d = Array(a)
        e = 0

        while a > e
          d[e] = b.call(c, e)
          e++
        d

      z.random = (a, b) ->
        null is b and (b = a
        a = 0
        )
        a + Math.floor(Math.random() * (b - a + 1))


      H = escape:
        "&": "&amp;"
        "<": "&lt;"
        ">": "&gt;"
        "\"": "&quot;"
        "'": "&#x27;"
        "/": "&#x2F;"

      H.unescape = z.invert(H.escape)
      I =
        escape: new RegExp("[" + z.keys(H.escape).join("") + "]", "g")
        unescape: new RegExp("(" + z.keys(H.unescape).join("|") + ")", "g")

      z.each([ "escape", "unescape" ], (a) ->
        z[a] = (b) ->
          (if null is b then "" else ("" + b).replace(I[a], (b) ->
            H[a][b]
          ))
      )
      z.result = (a, b) ->
        return null  if null is a
        c = a[b]
        (if z.isFunction(c) then c.call(a) else c)

      z.mixin = (a) ->
        A z.functions(a), (b) ->
          c = z[b] = a[b]
          z::[b] = ->
            a = [ @_wrapped ]
            i.apply(a, arguments)
            N.call(this, c.apply(z, a))



      J = 0
      z.uniqueId = (a) ->
        b = ++J + ""
        (if a then a + b else b)

      z.templateSettings =
        evaluate: /<%([\s\S]+?)%>/g
        interpolate: /<%=([\s\S]+?)%>/g
        escape: /<%-([\s\S]+?)%>/g


      K = /(.)^/
      L =
        "'": "'"
        "\\": "\\"
        "\r": "r"
        "\n": "n"
        "    ": "t"
        " ": "u2028"
        " ": "u2029"

      M = /\\|'|\r|\n|\t|\u2028|\u2029/g
      z.template = (a, b, c) ->
        d = undefined
        c = z.defaults({}, c, z.templateSettings)
        e = new RegExp([ (c.escape or K).source, (c.interpolate or K).source, (c.evaluate or K).source ].join("|") + "|$", "g")
        f = 0
        g = "__p+='"
        a.replace(e, (b, c, d, e, h) ->
          g += a.slice(f, h).replace(M, (a) ->
            "\\" + L[a]
          )
          c and (g += "'+\n((__t=(" + c + "))==null?'':_.escape(__t))+\n'")
          d and (g += "'+\n((__t=(" + d + "))==null?'':__t)+\n'")
          e and (g += "';\n" + e + "\n__p+='")
          f = h + b.length
          b
        )
        g += "';\n"
        c.variable or (g = "with(obj||{}){\n" + g + "}\n")
        g = "var __t,__p='',__j=Array.prototype.join,print=function(){__p+=__j.call(arguments,'');};\n" + g + "return __p;\n"

        try
          d = new Function(c.variable or "obj", "_", g)
        catch h
          throw h.source = g
          h
        return d(b, z)  if b
        i = (a) ->
          d.call this, a, z

        i.source = "function(" + (c.variable or "obj") + "){\n" + g + "}"
        i

      z.chain = (a) ->
        z(a).chain()


      N = (a) ->
        (if @_chain then z(a).chain() else a)

      z.mixin(z)
      A([ "pop", "push", "reverse", "shift", "sort", "splice", "unshift" ], (a) ->
        b = f[a]
        z::[a] = ->
          c = @_wrapped
          b.apply(c, arguments)
          "shift" isnt a and "splice" isnt a or 0 isnt c.length or delete c[0]

          N.call(this, c)
      )
      A([ "concat", "join", "slice" ], (a) ->
        b = f[a]
        z::[a] = ->
          N.call this, b.apply(@_wrapped, arguments)
      )
      z.extend(z::,
        chain: ->
          @_chain = not 0
          this

        value: ->
          @_wrapped
      )
    ).call this
  , {} ]
  25: [ (a) ->
    "undefined" isnt typeof window and "function" isnt typeof window.requestAnimationFrame and (window.requestAnimationFrame = window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (a) ->
      setTimeout a, 1e3 / 60
    )
    Leap = a("../lib/index")
  ,
    "../lib/index": 11
   ]
, {}, [ 25 ])
