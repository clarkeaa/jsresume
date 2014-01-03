var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
var POSITION = 0;
var LOCWIDGETHEIGHT = 20;
var LOCWIDGETKNOBWIDTH = 20;
var GROUNDHEIGHT = 100;
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
function drawGround() {
    CTX.fillStyle = '#996600';
    var groundTop = HEIGHT - LOCWIDGETHEIGHT - GROUNDHEIGHT;
    CTX.fillRect(0, groundTop, WIDTH, GROUNDHEIGHT);
    var imgData = CTX.getImageData(0, groundTop, WIDTH, GROUNDHEIGHT);
    var pix = imgData.data;
    var specks = [[0.5, 0.5], [0.2, 0.7], [0.25, 0.1]];
    for (var y = 0; y < GROUNDHEIGHT; y += 1) {
        for (var x = 0; x < WIDTH; x += 1) {
            var index = 4 * (x + WIDTH * y);
            var depth = 1.0 + 0.5 * Math.sin(x * 1 + 7 * y + POSITION);
            pix[0 + index] = depth * 200;
            pix[1 + index] = depth * 100;
            pix[2 + index] = 0;
        };
    };
    return CTX.putImageData(imgData, 0, groundTop);
};
function draw() {
    CTX.clearRect(0, 0, WIDTH, HEIGHT);
    CTX.fillStyle = '#0000ff';
    CTX.fillRect(0, 0, WIDTH, HEIGHT);
    drawGround();
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
