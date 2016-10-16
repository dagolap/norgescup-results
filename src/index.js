'use strict';

global.jQuery = require('jquery');
require('bootstrap');
require('bootstrap/dist/css/bootstrap.min.css');
require('./index.html');


var Elm = require('./Main.elm');
var mountNode = document.getElementById('app-container');

var app = Elm.Main.embed(mountNode);
