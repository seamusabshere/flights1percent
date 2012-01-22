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
    # COMPONENT # 1
    # Flip to on state
    $(".show_me").click ->
      # Move foot print panes to the top below the banner
      $(".footPrintPanes").animate(
        {
          top: $(".banner").outerHeight(), 
        }, 400
      )
      # Fade in the banner text
      $(".dataPaneTitle").css({cursor: "pointer"}).animate {opacity:.6},400, "linear"
      
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
      # Fade out the banner text and downArrow
      $(".dataPaneTitle, .downArrow").css({cursor: "auto"}).animate({opacity:0},400, "linear")
      $(".footPrintPanes").removeClass("enabled")
      # Hide the overlay
      $(".overlay").addClass("hide")
    )
    
    
    # COMPONENT # 2
    compiled = _.template($("#overlayBoxTmpl").html())
    $(".box.offState").click ->
      $(this).children('.details').show()
    
      # Open overlay
      # $(".overlay").removeClass("hide")
      # Initialize data
      # data = JSON.parse($("#data").html())
      # index = $(this).data("index")
      # personObj = data[index]
      # className = personObj["name"].toLowerCase().replace(/[\s\W]+/g,'')
      # addition = 
      #   class_name: className
      #   color_index: index + 2   
      
      # Position rendered template in overlay
      # offsetAmount = => $(".banner").offset()
      # front = => $(".overlay").find(".front")
      # front().html(compiled(_.extend({}, personObj , addition))).css(
      #   top: "#{offsetAmount().top}px"        
      # )
      # Ensure the rendered box remains stationary
      # $(window).scroll(->
      #   console.log offsetAmount()
      #   front().css(
      #     top: "#{offsetAmount().top}px"
      #   )
      )
      
      # Adjust the height of the overlay background
      $(".overlay").find(".bg").height($(".container").height())
      
      # TODO: Move the overlay with the scroller
      
      # Fade in the banner text
      $(".dataPaneTitle").css({cursor: "pointer"}).animate {opacity:.6},400, "linear"
      
    $(".overlay .bg").click ->
      # Close overlay
      $(".overlay").addClass("hide")
      
      # Fade out the banner text and downArrow
      $(".dataPaneTitle").css({cursor: "auto"}).animate {opacity:0},400, "linear"
    
@Application = Application