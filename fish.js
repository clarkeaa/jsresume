var CTX = null;
var WIDTH = 640;
var HEIGHT = 480;
function draw() {
    CTX.clearRect(0, 0, 640, 480);
    CTX.fillStyle = '#0000ff';
    return CTX.fillRect(0, 0, 640, 480);
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
