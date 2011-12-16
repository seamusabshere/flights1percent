(function() {
  var Application;

  Application = (function() {

    function Application() {}

    Application.prototype.start = function() {
      var originalFootPrintsHeight, resizeTags;
      console.log('App started');
      resizeTags = function(tag, height, parentHeight) {
        var max, min;
        max = 42;
        return min = 14;
      };
      $(".offState h1").each(function() {
        var height, parentHeight, tag;
        tag = $(this);
        height = function() {
          return tag.innerHeight();
        };
        parentHeight = function() {
          return tag.closest(".offState").innerHeight();
        };
        return resizeTags(tag, height(), parentHeight());
      });
      $(".footPrintPanes").css({
        position: "absolute",
        width: "100%"
      });
      originalFootPrintsHeight = $(".footPrintPanes").offset().top;
      console.log(originalFootPrintsHeight);
      $(".show_me").click(function() {
        $(".footPrintPanes").animate({
          top: $(".banner").outerHeight()
        }, 400);
        $(".dataPaneTitle").css({
          cursor: "pointer"
        }).animate({
          opacity: .6
        }, 400, "linear");
        $(".downArrow").animate({
          opacity: 1
        }, 600, "linear");
        return $(".footPrintPanes").addClass("enabled");
      });
      return $(".downArrow").click(function() {
        if (!$(".footPrintPanes").hasClass("enabled")) return;
        $(".footPrintPanes").animate({
          top: originalFootPrintsHeight
        }, 400);
        $(".dataPaneTitle, .downArrow").css({
          cursor: "auto"
        }).animate({
          opacity: 0
        }, 400, "linear");
        return $(".footPrintPanes").removeClass("enabled");
      });
    };

    return Application;

  })();

  this.Application = Application;

}).call(this);
