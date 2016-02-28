{$, View} = require 'atom-space-pen-views'

module.exports =
  class StatusView extends View
    @content = (params) ->
      @div class: 'git-plus-leap', =>
        @div class: "#{params.type} message", params.message

    initialize: ->
      @panel ?= atom.workspace.addBottomPanel(item: this)
      setTimeout =>
        @destroy()
      , atom.config.get('git-plus-leap.messageTimeout') * 1000

    destroy: ->
      @panel?.destroy()
