var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
var POSITION = 0;
var LOCWIDGETHEIGHT = 20;
var LOCWIDGETKNOBWIDTH = 26;
var GROUNDHEIGHT = 100;
var FPS = 30;
var FRAME = 0;
var FISHDIRECTION = 1;
var FISHWIDTH = 240;
var FISHHEIGHT = 160;
var INPUTTIME = 0;
var MINPOSITION = -100;
var MAXPOSITION = 3800;
var MOVESPEED = 10;
function drawLocWidget() {
    CTX.lineWidth = 2;
    CTX.strokeStyle = '#00ff00';
    var locWidgetTop = HEIGHT - LOCWIDGETHEIGHT;
    var locWidget = document.getElementById('locwidget');
    CTX.drawImage(locWidget, 0, locWidgetTop);
    return CTX.strokeRect((WIDTH - LOCWIDGETKNOBWIDTH) * ((POSITION - MINPOSITION) / (MAXPOSITION - MINPOSITION)), locWidgetTop, LOCWIDGETKNOBWIDTH, LOCWIDGETHEIGHT);
};
function handleKeyboard(event) {
    switch (event.keyCode) {
    case 37:
        POSITION = Math.max(POSITION - MOVESPEED, MINPOSITION);
        FISHDIRECTION = -1;
        return INPUTTIME = FRAME;
    case 39:
        POSITION = Math.min(POSITION + MOVESPEED, MAXPOSITION);
        FISHDIRECTION = 1;
        return INPUTTIME = FRAME;
    };
};
function drawGround() {
    CTX.fillStyle = '#996600';
    var groundTop = HEIGHT - LOCWIDGETHEIGHT - GROUNDHEIGHT;
    CTX.fillRect(0, groundTop, WIDTH, GROUNDHEIGHT);
    var g13560 = CTX.getImageData(0, groundTop, WIDTH, GROUNDHEIGHT);
    var pix = g13560.data;
    for (var y = 0; y < GROUNDHEIGHT; y += 1) {
        for (var x = 0; x < WIDTH; x += 1) {
            var index = 4 * (x + WIDTH * y);
            var depth = 1.0 + 0.5 * Math.sin(x * 1 + 7 * y * y + POSITION);
            pix[index] = depth * 200;
            pix[1 + index] = depth * 100;
            pix[2 + index] = 0;
        };
    };
    return CTX.putImageData(g13560, 0, groundTop);
};
function drawAaronFish() {
    var fishIndex = Math.floor(FRAME / 10) % 3;
    var fish = null;
    if (FRAME - INPUTTIME < 10) {
        switch (fishIndex) {
        case 0:
            fish = document.getElementById('fish1swim');
            break;
        case 1:
            fish = document.getElementById('fish2swim');
            break;
        case 2:
            fish = document.getElementById('fish3swim');
        };
    } else {
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
    };
    CTX.save();
    var scalar = 0.5;
    CTX.translate(FISHWIDTH / 2, 80);
    switch (FISHDIRECTION) {
    case -1:
        CTX.scale(-1 * scalar, scalar);
        break;
    case 1:
        CTX.scale(scalar, scalar);
    };
    CTX.translate(0, 20);
    CTX.translate(FISHWIDTH / -2, -80);
    var yoffset = 4 * Math.sin(2 * Math.PI * 0.5 * (FRAME / FPS));
    CTX.translate(0, yoffset);
    CTX.drawImage(fish, 0, 0);
    return CTX.restore();
};
function drawWater() {
    var waterHeight = HEIGHT - GROUNDHEIGHT - LOCWIDGETHEIGHT;
    var grad = CTX.createLinearGradient(0, 0, 0, waterHeight);
    grad.addColorStop(0, '#3377ff');
    grad.addColorStop(1, '#0000AA');
    CTX.fillStyle = grad;
    return CTX.fillRect(0, 0, WIDTH, waterHeight);
};
function drawImage(idName, xOffset) {
    var title = document.getElementById(idName);
    CTX.save();
    CTX.translate(-1 * POSITION, 0);
    CTX.drawImage(title, xOffset, 0);
    return CTX.restore();
};
function drawWeed(scalar, xOffset, yOffset, parallax, repeatBuffer, animSpeed) {
    var weedIndex = Math.floor(FRAME / animSpeed) % 3;
    var weed = null;
    switch (weedIndex) {
    case 0:
        weed = document.getElementById('weed1');
        break;
    case 1:
        weed = document.getElementById('weed2');
        break;
    case 2:
        weed = document.getElementById('weed3');
    };
    CTX.save();
    CTX.translate((WIDTH + repeatBuffer / 2) - (parallax * POSITION + xOffset) % (WIDTH + repeatBuffer), yOffset);
    CTX.scale(scalar, scalar);
    CTX.drawImage(weed, 0, 0);
    return CTX.restore();
};
function draw() {
    CTX.clearRect(0, 0, WIDTH, HEIGHT);
    FRAME += 1;
    drawWater();
    drawGround();
    drawWeed(0.2, 0, 300, 0.5, 700, 13);
    drawWeed(0.2, 0, 300, 0.5, 300, 11);
    drawWeed(0.2, 0, 300, 0.5, 30, 10.5);
    drawImage('title', 0);
    drawImage('lpt', 900);
    drawImage('techsmith', 2 * 900);
    drawImage('education', 3 * 900);
    drawImage('contact', 4 * 900);
    drawAaronFish();
    drawLocWidget();
    drawWeed(0.5, 1000, 280, 2.0, 700, 13);
    return drawWeed(0.5, 200, 280, 2.0, 300, 11);
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
