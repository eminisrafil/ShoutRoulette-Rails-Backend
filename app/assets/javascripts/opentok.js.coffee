$ ->

  if $('#session').length

    # ----------------------------------
    # track the page
    # ----------------------------------

    mixpanel.track("#{$('.topic').text()}");

    # ----------------------------------
    # Rage Faces and Loading
    # ----------------------------------

    $('#video1').css({ background: "url(/ragefaces/rage#{Math.round(Math.random() * 5) + 1}.jpg)" });

    opts =
      lines: 7
      length: 0
      width: 6
      radius: 14
      corners: 0.9
      rotate: 0
      color: '#d46d4a'
      speed: 1.2
      trail: 47
      shadow: true
      hwaccel: false
      className: 'spinner'
      zIndex: 10
      top: 40
      left: 40
  
    target = document.getElementById('video1')
    spinner = new Spinner(opts).spin(target)
    $('.spinner').css top: 50, left: 50

    # ----------------------------------
    # prompt sharing if nobody is there
    # ----------------------------------

    prompt_social = setTimeout (-> $('.social').fadeIn()), 10000

    # ----------------------------------
    # close the room if people leave
    # ----------------------------------

    fixUnload = ->
      if document.readyState == 'interactive'
        
        stop = ->
          document.detachEvent('onstop', stop)
          unload()

        document.attachEvent('onstop', stop) 
        window.setTimeout (-> document.detachEvent('onstop', stop)), 0
      
    unload = ->
      $.ajax
        type: 'POST'
        url: "/close"
        data: { id: $('.room_id').text(), position: $('.position').text(), observer_id: $('.observer_id').text() }
        async : false
        success: (data) -> console.log data
      
    window.attachEvent('onunload', unload)
    window.attachEvent('onbeforeunload', fixUnload)
    window.onunload = -> unload()

    # -----------------------------------
    # OpenTok Configuration
    # -----------------------------------

    apiKey = 20193772
    sessionId = $('.session-id').text()
    token = $('.token').text()
    position = $('.position').text()
    VIDEO_WIDTH = 466
    VIDEO_HEIGHT = 378

    if position != 'observe'
      idle_timer = setTimeout ->
        $('#flash').append "<div class='flash notice'>You've been sitting around for too long doing nothing. Come back when you're ready to chat!</div>"
        setTimeout (-> window.location.href = 'http://shoutroulette.com'), 2000
      , 90000

    sessionConnectedHandler = (event) ->
      subscribeToStreams(event.streams)
      $('.spinner').remove()
      
      unless position == 'observe'
        $('#video1').append("<div id='#{position}'></div>")
        publisher = TB.initPublisher apiKey, "#{position}", { width: VIDEO_WIDTH, height: VIDEO_HEIGHT }
        session.publish publisher

    streamCreatedHandler = (e) ->
      clearTimeout idle_timer
      console.log 'clicked accept'
      subscribeToStreams e.streams

    appended_one = false

    subscribeToStreams = (streams) ->
      for stream in streams

        # don't subscribe to your own stream
        if stream.connection.connectionId != session.connection.connectionId

          if position == 'observe'
            num = if !appended_one then 1 else 2
            $("#video#{num}").append "<div id='s#{num}'></div>"
            appended_one = true
            session.subscribe stream, "s#{num}", { width: VIDEO_WIDTH, height: VIDEO_HEIGHT }
          else
            $('#video2').append "<div id='sub2'></div>"
            session.subscribe stream, 'sub2', { width: VIDEO_WIDTH, height: VIDEO_HEIGHT }

          # get rid of the social share since someone else is there
          clearTimeout prompt_social
          $('.social').fadeOut()

    exceptionHandler = (e) ->
      console.log "This page is trying to connect a third client to an OpenTok peer-to-peer session. Only two clients can connect to peer-to-peer sessions." if e.code == 1013

    # --------------------------------------------
    # Initialize and connect to session
    # --------------------------------------------

    TB.addEventListener("exception", exceptionHandler)
    session = TB.initSession(sessionId)
    session.addEventListener "sessionConnected", sessionConnectedHandler
    session.addEventListener "streamCreated", streamCreatedHandler
    session.connect apiKey, token