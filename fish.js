var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
var POSITION = 0;
var LOCWIDGETHEIGHT = 20;
var LOCWIDGETKNOBWIDTH = 20;
var GROUNDHEIGHT = 100;
var FPS = 30;
var FRAME = 0;
var FISHDIRECTION = 1;
var FISHWIDTH = 240;
var FISHHEIGHT = 160;
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
        POSITION -= 1;
        return FISHDIRECTION = -1;
    case 39:
        POSITION += 1;
        return FISHDIRECTION = 1;
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
            var depth = 1.0 + 0.5 * Math.sin(x * 1 + 7 * y * y + POSITION);
            pix[index] = depth * 200;
            pix[1 + index] = depth * 100;
            pix[2 + index] = 0;
        };
    };
    return CTX.putImageData(imgData, 0, groundTop);
};
function drawAaronFish() {
    var fishIndex = Math.floor(FRAME / 10) % 3;
    var fish = null;
    switch (fishIndex) {
    case 0:
        fish = document.getElementById('fish1');
        break;
    case 1:
        fish = document.getElementById('fish2');
        break;
    case 2:
        fish = document.getElementById('fish3');
    };
    CTX.save();
    switch (FISHDIRECTION) {
    case -1:
        CTX.translate(300, 0);
        CTX.scale(-1, 1);
        break;
    case 1:
        CTX.scale(1, 1);
    };
    var yoffset = 2 * Math.sin(2 * Math.PI * 0.5 * (FRAME / FPS));
    CTX.translate(0, yoffset);
    CTX.drawImage(fish, 0, 0);
    return CTX.restore();
};
function draw() {
    CTX.clearRect(0, 0, WIDTH, HEIGHT);
    FRAME += 1;
    CTX.fillStyle = '#0000ff';
    CTX.fillRect(0, 0, WIDTH, HEIGHT);
    drawGround();
    drawAaronFish();
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
            return setInterval(draw, FPS);
        };
    };
};
