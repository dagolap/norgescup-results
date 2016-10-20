'use strict';

global.$ = global.jQuery = require('jquery');
require('bootstrap');
require('./styles/main.scss');


var Elm = require('../elm/Main');
Elm.Main.embed(document.getElementById('app-container'));
