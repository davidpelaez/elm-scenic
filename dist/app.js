/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__(1);


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	// Require index.html so it gets copied to dist
	__webpack_require__(2);


	var Elm = __webpack_require__(!(function webpackMissingModule() { var e = new Error("Cannot find module \"./Main.elm\""); e.code = 'MODULE_NOT_FOUND'; throw e; }()));
	var mountNode = document.getElementById('main');

	var cacheKey = 'appCache';
	var defaultCache = {apiKey: null};
	var storedCacheJSON = localStorage.getItem(cacheKey);

	// TODO handle JSON parse exception or boot can fail!
	var appCache = storedCacheJSON ? JSON.parse(storedCacheJSON) : defaultCache;

	// The third value on embed are the initial values for incomming ports into Elm
	var app = Elm.Main.embed(mountNode, appCache );

	app.ports.setStorage.subscribe(function(newCache) {
	  localStorage.setItem(cacheKey, JSON.stringify(newCache));
	});

	app.ports.removeStorage.subscribe(function() {
	  localStorage.removeItem(cacheKey);
	});


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__.p + "index.html";

/***/ }
/******/ ]);