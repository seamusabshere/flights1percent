class Application
  constructor: ->
  start: ->
    console.log 'App started'  
    
    
    # Resize the h1 tags according to pane height
    resizeTags = (tag,height,parentHeight)->
      # console.log(height,parentHeight)
      max = 42
      min = 14
      
      
    
    $(".offState h1").each ->
      tag = $(@)
      height = -> tag.innerHeight()
      parentHeight = -> tag.closest(".offState").innerHeight()
      
      resizeTags(tag, height(),parentHeight())
    
    
    
    
    $(".footPrintPanes").css(
      position: "absolute",
      width:"100%" 
    )    
    originalFootPrintsHeight = $(".footPrintPanes").offset().top
    console.log originalFootPrintsHeight
    # Flip to on state
    $(".show_me").click ->
      # Move foot print panes to the top below the banner
      $(".footPrintPanes").animate(
        {
          top: $(".banner").outerHeight(), 
        }, 400
      )
      # Fade in the banner text
      $(".dataPaneTitle").css({cursor: "pointer"}).animate(
        {opacity:.6},
        400, "linear"
      )
      
      # Fade in the down arrow button
      $(".downArrow").animate({opacity:1}, 600, "linear")
      
      # Signify enabled state
      $(".footPrintPanes").addClass("enabled")
      
    # Flip to off state
    $(".downArrow").click(->
      return unless $(".footPrintPanes").hasClass("enabled")
      $(".footPrintPanes").animate(
        {
          top: originalFootPrintsHeight, 
        }, 400
      )
      # Fade in the banner text
      $(".dataPaneTitle, .downArrow").css({cursor: "auto"}).animate({opacity:0},400, "linear")
      $(".footPrintPanes").removeClass("enabled")
    )
    
@Application = Application