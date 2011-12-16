(function() {
  var Application;

  Application = (function() {

    function Application() {}

    Application.prototype.start = function() {
      var compiled, originalFootPrintsHeight, resizeTags;
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
      $(".downArrow").click(function() {
        if (!$(".footPrintPanes").hasClass("enabled")) return;
        $(".footPrintPanes").animate({
          top: originalFootPrintsHeight
        }, 400);
        $(".dataPaneTitle, .downArrow").css({
          cursor: "auto"
        }).animate({
          opacity: 0
        }, 400, "linear");
        $(".footPrintPanes").removeClass("enabled");
        return $(".overlay").addClass("hide");
      });
      compiled = _.template($("#overlayBoxTmpl").html());
      $(".box.offState").click(function() {
        var addition, className, data, front, index, offsetAmount, personObj;
        var _this = this;
        $(".overlay").removeClass("hide");
        data = JSON.parse($("#data").html());
        index = $(this).data("index");
        personObj = data[index];
        className = personObj["name"].toLowerCase().replace(/[\s\W]+/g, '');
        addition = {
          class_name: className,
          color_index: index + 2
        };
        offsetAmount = function() {
          return $(".banner").offset();
        };
        front = function() {
          return $(".overlay").find(".front");
        };
        front().html(compiled(_.extend({}, personObj, addition))).css({
          top: "" + (offsetAmount().top) + "px"
        });
        $(window).scroll(function() {
          console.log(offsetAmount());
          return front().css({
            top: "" + (offsetAmount().top) + "px"
          });
        });
        $(".overlay").find(".bg").height($(".container").height());
        return $(".dataPaneTitle").css({
          cursor: "pointer"
        }).animate({
          opacity: .6
        }, 400, "linear");
      });
      return $(".overlay .bg").click(function() {
        $(".overlay").addClass("hide");
        return $(".dataPaneTitle").css({
          cursor: "auto"
        }).animate({
          opacity: 0
        }, 400, "linear");
      });
    };

    return Application;

  })();

  this.Application = Application;

}).call(this);
