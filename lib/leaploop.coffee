<<<<<<< HEAD:lib/leaploop.coffee
leapjs = require 'leapjs'
=======
Leap = require './leap'
>>>>>>> f3224c39b3554d8b844b4c2e50e2318e92e107ad:lib/test.coffee

class leaploop
  init: ->
<<<<<<< HEAD:lib/leaploop.coffee
=======
    console.log 'hello world!'
    console.log Leap
>>>>>>> f3224c39b3554d8b844b4c2e50e2318e92e107ad:lib/test.coffee
    @activate()

  activate: ->
    # Store frame for motion functions
    previousFrame = null

    # Setup Leap loop with frame callback function
    controllerOptions = enableGestures: true

<<<<<<< HEAD:lib/leaploop.coffee
    leapjs.loop controllerOptions, (frame) ->
=======
    Leap.loop controllerOptions, (frame) ->
      `var i`
      `var pointable`
      `var i`
      `var scaleFactor`
      `var rotationAngle`
      `var rotationAxis`
      `var translation`
>>>>>>> f3224c39b3554d8b844b4c2e50e2318e92e107ad:lib/test.coffee
      # Frame motion factors
      if previousFrame and previousFrame.valid
        translation = frame.translation(previousFrame)
        rotationAxis = frame.rotationAxis(previousFrame)
        rotationAngle = frame.rotationAngle(previousFrame)
        scaleFactor = frame.scaleFactor(previousFrame)
      # Display Hand object data
      if frame.hands.length > 0
        i = 0
        while i < frame.hands.length
          hand = frame.hands[i]
          # Hand motion factors
          if previousFrame and previousFrame.valid
            translation = hand.translation(previousFrame)
            rotationAxis = hand.rotationAxis(previousFrame, 2)
            rotationAngle = hand.rotationAngle(previousFrame)
            scaleFactor = hand.scaleFactor(previousFrame)
          # IDs of pointables associated with this hand
          if hand.pointables.length > 0
            fingerIds = []
            j = 0
            while j < hand.pointables.length
              pointable = hand.pointables[j]
              fingerIds.push pointable.id
              j++
          i++
      # Display Pointable (finger and tool) object data
      if frame.pointables.length > 0
        fingerTypeMap = [
          'Thumb'
          'Index finger'
          'Middle finger'
          'Ring finger'
          'Pinky finger'
        ]
        boneTypeMap = [
          'Metacarpal'
          'Proximal phalanx'
          'Intermediate phalanx'
          'Distal phalanx'
        ]
        i = 0
        while i < frame.pointables.length
          pointable = frame.pointables[i]
          i++
      # Display Gesture object data
      if frame.gestures.length > 0
        i = 0
        while i < frame.gestures.length
          gesture = frame.gestures[i]
          if gesture.type == 'circle'
            if gesture.normal[2] <= 0 # checks if clockswise
              console.log 'git pull'
            else
              console.log 'git push'
          i++

      # Store frame for motion functions
      previousFrame = frame

module.exports = leaploop
