leap = require './leap'

# Store frame for motion functions
previousFrame = null
paused = false
pauseOnGesture = false
# Setup Leap loop with frame callback function
controllerOptions = enableGestures: true
# to use HMD mode:
# controllerOptions.optimizeHMD = true;

vectorToString = (vector, digits) ->
  if typeof digits == 'undefined'
    digits = 1
  '(' + vector[0].toFixed(digits) + ', ' + vector[1].toFixed(digits) + ', ' + vector[2].toFixed(digits) + ')'

Leap.loop controllerOptions, (frame) ->
  # Display Hand object data
  handString = ''
  if frame.hands.length > 0
    i = 0
    while i < frame.hands.length
      hand = frame.hands[i]
      handString += '<div style=\'width:300px; float:left; padding:5px\'>'
      handString += 'Hand ID: ' + hand.id + '<br />'
      handString += 'Type: ' + hand.type + ' hand' + '<br />'
      handString += 'Direction: ' + vectorToString(hand.direction, 2) + '<br />'
      handString += 'Palm position: ' + vectorToString(hand.palmPosition) + ' mm<br />'
      handString += 'Grab strength: ' + hand.grabStrength + '<br />'
      handString += 'Pinch strength: ' + hand.pinchStrength + '<br />'
      handString += 'Confidence: ' + hand.confidence + '<br />'
      handString += 'Arm direction: ' + vectorToString(hand.arm.direction()) + '<br />'
      handString += 'Arm center: ' + vectorToString(hand.arm.center()) + '<br />'
      handString += 'Arm up vector: ' + vectorToString(hand.arm.basis[1]) + '<br />'
      # Hand motion factors
      if previousFrame and previousFrame.valid
        translation = hand.translation(previousFrame)
        handString += 'Translation: ' + vectorToString(translation) + ' mm<br />'
        rotationAxis = hand.rotationAxis(previousFrame, 2)
        rotationAngle = hand.rotationAngle(previousFrame)
        handString += 'Rotation axis: ' + vectorToString(rotationAxis) + '<br />'
        handString += 'Rotation angle: ' + rotationAngle.toFixed(2) + ' radians<br />'
        scaleFactor = hand.scaleFactor(previousFrame)
        handString += 'Scale factor: ' + scaleFactor.toFixed(2) + '<br />'
      # IDs of pointables associated with this hand
      if hand.pointables.length > 0
        fingerIds = []
                j = 0
        while j < hand.pointables.length
          pointable = hand.pointables[j]
          fingerIds.push pointable.id
          j++
        if fingerIds.length > 0
          handString += 'Fingers IDs: ' + fingerIds.join(', ') + '<br />'
      handString += '</div>'
      i++
  else
    handString += 'No hands'
  handOutput.innerHTML = handString
  # Display Pointable (finger and tool) object data
  pointableOutput = document.getElementById('pointableData')
  pointableString = ''
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
      pointableString += '<div style=\'width:250px; float:left; padding:5px\'>'
      if pointable.tool
        pointableString += 'Pointable ID: ' + pointable.id + '<br />'
        pointableString += 'Classified as a tool <br />'
        pointableString += 'Length: ' + pointable.length.toFixed(1) + ' mm<br />'
        pointableString += 'Width: ' + pointable.width.toFixed(1) + ' mm<br />'
        pointableString += 'Direction: ' + vectorToString(pointable.direction, 2) + '<br />'
        pointableString += 'Tip position: ' + vectorToString(pointable.tipPosition) + ' mm<br />'
        pointableString += '</div>'
      else
        pointableString += 'Pointable ID: ' + pointable.id + '<br />'
        pointableString += 'Type: ' + fingerTypeMap[pointable.type] + '<br />'
        pointableString += 'Belongs to hand with ID: ' + pointable.handId + '<br />'
        pointableString += 'Classified as a finger<br />'
        pointableString += 'Length: ' + pointable.length.toFixed(1) + ' mm<br />'
        pointableString += 'Width: ' + pointable.width.toFixed(1) + ' mm<br />'
        pointableString += 'Direction: ' + vectorToString(pointable.direction, 2) + '<br />'
        pointableString += 'Extended?: ' + pointable.extended + '<br />'
        pointable.bones.forEach (bone) ->
          `var i`
          pointableString += boneTypeMap[bone.type] + ' bone <br />'
          pointableString += 'Center: ' + vectorToString(bone.center()) + '<br />'
          pointableString += 'Direction: ' + vectorToString(bone.direction()) + '<br />'
          pointableString += 'Up vector: ' + vectorToString(bone.basis[1]) + '<br />'
          return
        pointableString += 'Tip position: ' + vectorToString(pointable.tipPosition) + ' mm<br />'
        pointableString += '</div>'
      i++
  else
    pointableString += '<div>No pointables</div>'
  pointableOutput.innerHTML = pointableString
  # Display Gesture object data
  gestureOutput = document.getElementById('gestureData')
  gestureString = ''
  if frame.gestures.length > 0
    if pauseOnGesture
      togglePause()
    i = 0
    while i < frame.gestures.length
      gesture = frame.gestures[i]
      gestureString += 'Gesture ID: ' + gesture.id + ', ' + 'type: ' + gesture.type + ', ' + 'state: ' + gesture.state + ', ' + 'hand IDs: ' + gesture.handIds.join(', ') + ', ' + 'pointable IDs: ' + gesture.pointableIds.join(', ') + ', ' + 'duration: ' + gesture.duration + ' &micro;s, '
      if gesture.type == 'circle'
        if gesture.normal[2] <= 0
          # checks if clockswise
          console.log 'git pull'
        else
          console.log 'git push'
      switch gesture.type
        when 'circle'
          gestureString += 'center: ' + vectorToString(gesture.center) + ' mm, ' + 'normal: ' + vectorToString(gesture.normal, 2) + ', ' + 'radius: ' + gesture.radius.toFixed(1) + ' mm, ' + 'progress: ' + gesture.progress.toFixed(2) + ' rotations'
        when 'swipe'
          gestureString += 'start position: ' + vectorToString(gesture.startPosition) + ' mm, ' + 'current position: ' + vectorToString(gesture.position) + ' mm, ' + 'direction: ' + vectorToString(gesture.direction, 1) + ', ' + 'speed: ' + gesture.speed.toFixed(1) + ' mm/s'
        when 'screenTap', 'keyTap'
          gestureString += 'position: ' + vectorToString(gesture.position) + ' mm'
        else
          gestureString += 'unkown gesture type'
      gestureString += '<br />'
      i++
  else
    gestureString += 'No gestures'
  gestureOutput.innerHTML = gestureString
  # Store frame for motion functions
  previousFrame = frame
  return
