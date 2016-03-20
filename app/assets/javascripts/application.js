// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require moment
//= require moment/en-gb
//= require godmin
//= require godmin-tags
//= require_tree .


function fixedFooter() {
    var footer = $("#footer"); //or your footer class
    height = footer.height();
    paddingTop = parseInt(footer.css('padding-top'), 10);
    paddingBottom = parseInt(footer.css('padding-bottom'), 10);
    totalHeight = (height + paddingTop + paddingBottom);
    footerPosition = footer.position();
    windowHeight = $(window).height();
    height = (windowHeight - footerPosition.top) - totalHeight;
    if (height > 0) {
        footer.css({
            'margin-top': (height) + 'px'
        });
    }
}