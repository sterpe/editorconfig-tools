var errorFactory = require('./errorFactory');

var map = {
    lf: '\n',
    crlf: '\r\n',
    cr: '\r',
    vt: '\u000B',
    ff: '\u000C',
    nel: '\u0085',
    ls: '\u2028',
    ps: '\u2029'
};

var reverseMap = {};

var chars = Object.keys(map).map(function (key) {
    var character = map[key];
    reverseMap[character] = key;
    return character;
});

var Newline = (function () {
    function Newline(Character) {
        this.Character = Character;
        if (!Newline.pattern.test(Character)) {
            throw new Newline.InvalidNewlineError('Invalid or unsupported newline character.');
        }
    }
    Object.defineProperty(Newline.prototype, "Name", {
        get: function () {
            return reverseMap[this.Character];
        },
        set: function (value) {
            this.Character = map[value];
        },
        enumerable: true,
        configurable: true
    });


    Object.defineProperty(Newline.prototype, "Length", {
        get: function () {
            return this.Character && this.Character.length;
        },
        enumerable: true,
        configurable: true
    });

    Newline.prototype.toString = function () {
        return this.Character;
    };

    Newline.pattern = /\n|\r(?!\n)|\u2028|\u2029|\r\n/;

    Newline.map = map;

    Newline.reverseMap = reverseMap;

    Newline.chars = chars;

    Newline.InvalidNewlineError = errorFactory.create({
        name: 'InvalidNewlineError'
    });
    return Newline;
})();

module.exports = Newline;
