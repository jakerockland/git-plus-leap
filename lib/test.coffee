leap = require './leap'

class LeapLoop
  init: ->
    console.log 'hello world!'
    @activate()

  activate: ->
    # Store frame for motion functions
    previousFrame = null
    # var paused = false;
    # var pauseOnGesture = false;
    # Setup Leap loop with frame callback function
    controllerOptions = enableGestures: true
    # to use HMD mode:
    # controllerOptions.optimizeHMD = true;

    # vectorToString = (vector, digits) ->
    #   if `typeof digits == 'undefined'`
    #     digits = 1
    #   '(' + vector[0].toFixed(digits) + ', ' + vector[1].toFixed(digits) + ', ' + vector[2].toFixed(digits) + ')'

    leap.loop controllerOptions, (frame) ->
      `var i`
      `var pointable`
      `var i`
      `var scaleFactor`
      `var rotationAngle`
      `var rotationAxis`
      `var translation`
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
          if `gesture.type == 'circle'`
            if gesture.normal[2] <= 0
              # checks if clockswise
              console.log 'git pull'
            else
              console.log 'git push'
          #   switch (gesture.type) {
          #     case 'circle':
          #       gestureString += 'center: ' + vectorToString(gesture.center) + ' mm, '
          #                     + 'normal: ' + vectorToString(gesture.normal, 2) + ', '
          #                     + 'radius: ' + gesture.radius.toFixed(1) + ' mm, '
          #                     + 'progress: ' + gesture.progress.toFixed(2) + ' rotations';
          #       break;
          #     case 'swipe':
          #       gestureString += 'start position: ' + vectorToString(gesture.startPosition) + ' mm, '
          #                     + 'current position: ' + vectorToString(gesture.position) + ' mm, '
          #                     + 'direction: ' + vectorToString(gesture.direction, 1) + ', '
          #                     + 'speed: ' + gesture.speed.toFixed(1) + ' mm/s';
          #       break;
          #     case 'screenTap':
          #     case 'keyTap':
          #       gestureString += 'position: ' + vectorToString(gesture.position) + ' mm';
          #       break;
          #     default:
          #       gestureString += 'unkown gesture type';
          #   }
          i++
      # Store frame for motion functions
      previousFrame = frame

module.exports = LeapLoop
