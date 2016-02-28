leapjs = require 'leapjs'

class leaploop
  init: ->
    @activate()

  activate: ->
    # Store frame for motion functions
    previousFrame = null

    # Setup Leap loop with frame callback function
    controllerOptions = enableGestures: true

    leapjs.loop controllerOptions, (frame) ->
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
          console.log fingerIds
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
