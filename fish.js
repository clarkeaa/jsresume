var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
var POSITION = 0;
var LOCWIDGETHEIGHT = 20;
var LOCWIDGETKNOBWIDTH = 20;
function drawLocWidget() {
    CTX.fillStyle = '#ff0000';
    CTX.lineWidth = 1;
    CTX.strokeStyle = '#00ff00';
    var locWidgetTop = HEIGHT - LOCWIDGETHEIGHT;
    CTX.fillRect(0, locWidgetTop, WIDTH, LOCWIDGETHEIGHT);
    CTX.strokeRect(0, locWidgetTop, WIDTH, LOCWIDGETHEIGHT);
    CTX.fillStyle = '#000000';
    return CTX.fillRect(POSITION - LOCWIDGETKNOBWIDTH / 2, locWidgetTop, LOCWIDGETKNOBWIDTH, LOCWIDGETHEIGHT);
};
function handleKeyboard(event) {
    switch (event.keyCode) {
    case 37:
        return POSITION -= 1;
    case 39:
        return POSITION += 1;
    };
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
            document.onkeydown = handleKeyboard;
            return setInterval(draw, 30);
        };
    };
};
