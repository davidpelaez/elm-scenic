'use strict';

// Require index.html so it gets copied to dist
require('./index.html');
require('./../dist/main.css');


var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode);
