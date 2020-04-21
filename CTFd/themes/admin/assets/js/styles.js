import "bootstrap/dist/js/bootstrap.bundle";
import { makeSortableTables } from "core/utils";
import $ from "jquery";

export default () => {
  // TODO: This is kind of a hack to mimic a React-like state construct.
  // It should be removed once we have a real front-end framework in place.
  $(":input").each(function() {
    $(this).data("initial", $(this).val());
  });

  $(".form-control").bind({
    focus: function() {
      $(this).addClass("input-filled-valid");
    },
    blur: function() {
      if ($(this).val() === "") {
        $(this).removeClass("input-filled-valid");
      }
    }
  });

  $(".modal").on("show.bs.modal", function(e) {
    $(".form-control").each(function() {
      if ($(this).val()) {
        $(this).addClass("input-filled-valid");
      }
    });
  });

  $(function() {
    $(".form-control").each(function() {
      if ($(this).val()) {
        $(this).addClass("input-filled-valid");
      }
    });

    $("tr[data-href]").click(function() {
      var sel = getSelection().toString();
      if (!sel) {
        var href = $(this).attr("data-href");
        if (href) {
          window.location = href;
        }
      }
      return false;
    });

    $("tr[data-href] a, tr[data-href] button").click(function(e) {
      // TODO: This is a hack to allow modal close buttons to work
      if (!$(this).attr("data-dismiss")) {
        e.stopPropagation();
      }
    });

    makeSortableTables();
    $('[data-toggle="tooltip"]').tooltip();
  });
};
