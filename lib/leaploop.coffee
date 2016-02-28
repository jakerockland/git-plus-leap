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
          # if gesture.type == 'circle'
          #   if gesture.normal[2] <= 0
          #     console.log 'git commit' # clockwise circle
          #     break
          #   else
          #     console.log 'git revert' # counterclockwise circle
          #     break
          # console.log gesture #if gesture.type is "swipe" #and (gesture.state is "stop")
          if (gesture.type is "swipe" and gesture.state is "stop")
            #Classify swipe as either horizontal or vertical
            isHorizontal = Math.abs(gesture.direction[0]) > Math.abs(gesture.direction[1])
            #Classify as right-left or up-down
            if isHorizontal
              if gesture.direction[0] > 0
                console.log 'git push' # right swipe
                atom.commands.dispatch(document.querySelector('atom-text-editor'), 'git-plus-leap:push')
              else
                console.log 'git pull' # left swipe
                atom.commands.dispatch(document.querySelector('atom-text-editor'), 'git-plus-leap:pull')
            else
              #vertical
              if gesture.direction[1] > 0
                console.log 'git commit -a' # up swipe
                atom.commands.dispatch(document.querySelector('atom-text-editor'), 'git-plus-leap:commit-all')
              else
                console.log 'git add -a' # down swipe
                atom.commands.dispatch(document.querySelector('atom-text-editor'), 'git-plus-leap:add-all')
          i++

      # Store frame for motion functions
      previousFrame = frame

module.exports = leaploop
