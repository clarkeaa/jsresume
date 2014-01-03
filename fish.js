var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
var POSITION = 0;
var LOCWIDGETHEIGHT = 20;
function drawLocWidget() {
    CTX.fillStyle = '#ff0000';
    CTX.lineWidth = 1;
    CTX.strokeStyle = '#00ff00';
    var locWidgetTop = HEIGHT - LOCWIDGETHEIGHT;
    CTX.fillRect(0, locWidgetTop, WIDTH, LOCWIDGETHEIGHT);
    return CTX.strokeRect(0, locWidgetTop, WIDTH, LOCWIDGETHEIGHT);
};
function draw() {
    CTX.clearRect(0, 0, WIDTH, HEIGHT);
    CTX.fillStyle = '#0000ff';
    CTX.fillRect(0, 0, WIDTH, HEIGHT);
    return drawLocWidget();
};
function main() {
    var elem = document.getElementById('resume-canvas');
    if (elem) {
        var ctx = elem.getContext('2d');
        if (ctx) {
            CTX = ctx;
            draw();
            return setInterval(draw, 30);
        };
    };
};
