

function main() {
    var elem = document.getElementById('resume-canvas');
 
    if (elem && elem.getContext) {
        var ctx = elem.getContext('2d');
        if (ctx) {
            ctx.fillStyle = '#0000ff';
            ctx.fillRect(0, 0, 640, 480);
        }
    }
}
