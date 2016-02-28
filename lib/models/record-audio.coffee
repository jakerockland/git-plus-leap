Recorder = require("../recorder")
fs = require('fs')
path = require('path')
wav  = require('wav')
WavEncoder = require('wav-encoder')

startUserMedia = (stream) ->
    input = exports.audio_context.createMediaStreamSource(stream)
    console.log "media stream... DONE"
    exports.recorder = new Recorder(input)
    console.log "recorder... DONE"
    startRecording()
    console.log "record start"
    setTimeout(->
        stopRecording()
        console.log "record stop"
    , 1000)

startRecording = ->
    exports.recorder && exports.recorder.record()

stopRecording = ->
    exports.recorder && exports.recorder.stop()
    exports.recorder && exports.recorder.getBuffer((buffers) ->
        console.log "buff"
        audioData = {
            sampleRate: exports.audio_context.sampleRate,
            channelData: [
                buffers[0],
                buffers[1]
            ]
        }

        WavEncoder.encode(audioData).then (buffer) ->
            fs.writeFileSync "test.wav", buffer
            console.log "save"
    )

module.exports = ->
    exports.audio_context = new AudioContext
    console.log "audio context activated"

    navigator.webkitGetUserMedia({audio: true}, startUserMedia, (err) ->
        console.log "you fail"
    )
