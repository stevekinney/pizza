// psQuery
// http://pseudosavant.com
// License: MIT

(function (global) {
    'use strict';

    var start = +new Date();
    
    var debug = true;
    var type_string = 'string';
    var typeMatch = function(o, type){
        return (typeof o === type);
    };

    var utils = {
        isFunction: function(fn) {
            return (!!fn && typeMatch(fn, 'function'));
        },
        lastArgumentCallback: function (args, invoke) {
            var lastArgument = args[args.length - 1];

            if (utils.isFunction(lastArgument)){
                if (invoke) {
                    lastArgument();
                }
                return lastArgument;
            } else {
                return undefined;
            }
        },
        extend: function (target) {
            Array.prototype.slice.call(arguments, 1)
                .forEach(function (source) {
                    for (var key in source) {
                        if (source[key] !== undefined) {
                            target[key] = source[key];
                        }
                    }
            });
            return target;
        }
    };

    var featureDetect = function () {
        var requiredFeatures = [
            JSON,
            document.querySelectorAll,
            global.XMLHttpRequest
        ];

        for (var i = 0; i < requiredFeatures.length; i++) {
            if (!requiredFeatures[i]) {
                return false;
            }
        }

        return true;
    };

    var psQuery = function (selector) {
        return new psQuery.fn.init(selector);
    };

    psQuery.fn = psQuery.prototype = {
        constructor: psQuery,
        init: function (selector) {
            if (!featureDetect()) {
                throw 'Error: Cannot load psQuery. Required browser features are not available.';
            }

            try {
                if (!selector) {
                    throw 'Error: Invalid selector';
                } else if (!!selector.nodeType && (selector.nodeType === 1 || selector.nodeType === 9)) {
                    this.els = [selector];
                } else if (typeMatch(selector, type_string)) {
                    this.els = document.querySelectorAll(selector);
                }

                this.length = this.els.length;

                if (this.length === 0) {
                    throw 'Error: No elements found with that selector.';
                }

                return this;
            } catch (e) {
                if (!debug) {
                    return undefined;
                } else {
                    throw e;
                }
            }
        },
        each: function (fn) {
            var els = this.els,
                trueFalseCount = 0;

            if (!utils.isFunction(fn)) {
                throw 'Error: no function supplied to loop.';
            }

            for (var i = 0, l = els.length; i < l; i++) {
                if (fn.call(els[i], i) === false) {
                    trueFalseCount--;
                } else {
                    trueFalseCount++;
                }
            }

            return trueFalseCount;
        },
        nth: function(n) {
            var pos = (n < 0 ? this.els.length + n : n);
            return psQuery.fn.init(this.els[pos]);
        },
        get: function(n) {
            return this.nth(n);
        },
        first: function () {
            return this.nth(0);
        },
        last: function () {
            return this.nth(-1);
        },
        parent: function () {
            return psQuery(this.els[0]);
        },
        children: function(){

        },
        val: function(val) {
            if (val) {
                this.each(function () {
                    this.value = val;
                });
            } else {
                return this.els[0].value;
            }
        },
        html: function (html) {
            if (typeMatch(html, type_string)) {
                this.each(function () {
                    this.innerHTML = html;
                });

                return this;
            } else {
                return this.els[0].innerHTML;
            }
        },
        text: function(text) {
            if (typeMatch(text, type_string)) {
                this.each(function () {
                    this.innerText = text;
                });

                return this;
            } else {
                return this.els[0].innerText;
            }
        },
        hide: function() {
            var set = function () {
                this.style.display = 'none';
            };

            this.each(set);
        },
        show: function() {
            var set = function () {
                this.style.display = '';
            };

            this.each(set);
        },
        remove: function(){
            this.each(function () {
                this.parentElement.removeChild(this);
            });

            return this;
        },
        hasClass: function (className) {
            className = className.trim();

            var result = this.each(function () {
                return (this.className.indexOf(className) > -1);
            });

            return ((result + this.length) > 0);
        },
        toggleClass: function(className){
            className = className.trim();

            this.each(function () {
                var $this = $(this);
                if ($this.hasClass(className)) {
                    $this.removeClass(className);
                } else {
                    $this.addClass(className);
                }
            });

            return this;
        },
        addClass: function (classes) {
            var add = function () {
                var merged = (this.className + ' ' + classes.trim()).split(' '),
                    uniques = {},
                    union = [];
                
                for (var i = 0, l = merged.length; i < l; i++) {
                    uniques[merged[i]] = true;
                }

                for (var j in uniques) {
                    if (typeMatch(j, type_string)) {
                        union.push(j);
                    }
                }

                this.className = union.join(' ').trim();
            };

            if (typeMatch(classes, type_string)) {
                this.each(add);
            }
            return this;
        },
        removeClass: function(classes){
            var remove = function () {
                var existing = this.className + '';
                var removing = classes.trim().split(' ');

                for (var i = 0; i < removing.length; i++) {
                    existing = existing.replace(removing[i], '');
                }

                this.className = existing;
            };

            this.each(remove);
            return this;
        },
        css: function (css) {
            var set = function () {
                return undefined;
            };

            if (css) { // Set
                this.each(set);
            } else { // Get css for first element
                return '';
            }
            return this;
        },
        click: function(callback) {
            this.on('click', callback);
        },
        on: function (events) {
            var callback = utils.lastArgumentCallback(arguments),
                ev = events.split(' ');

            this.each(function () {
                for (var i = 0; i < ev.length; i++) {
                    this.addEventListener(ev[i], callback, false);
                }
            });

            return this;
        },
        off: function (events) {
            var callback = utils.lastArgumentCallback(arguments),
                ev = events.split(' ');

            this.each(function () {
                for (var i = 0; i < ev.length; i++) {
                    this.removeEventListener(ev[i], callback, false);
                }
            });

            return this;
        },
        data: function () {

        },
        attr: function (attributeName, val) {
            if (!val || !typeMatch(val, type_string)) {
                return this.els[0].getAttribute(attributeName);
            } else {
                this.each(function () {
                    this.setAttribute(attributeName, val);
                });
            }

            return this;
        }
    };

    psQuery.ajax = function (url, settings) {
        var args = arguments;
        settings = (args.length === 1 ? args[0] : args[1]);

        var emptyFunction = function () { };

        var defaultSettings = {
            url: (args.length === 2 && typeMatch(url, type_string) ? url : '.'),
            cache: true,
            data: {},
            headers: {},
            context: null,
            type: 'GET',
            success: emptyFunction,
            error: emptyFunction,
            complete: emptyFunction
        };

        settings = utils.extend(defaultSettings, settings || {});

        var mimeTypes = {
            'application/json': 'json',
            'text/html': 'html',
            'text/plain': 'text'
        };

        if (!settings.cache) {
            settings.url = settings.url +
                            (settings.url.indexOf('?') ? '&' : '?') +
                            'noCache=' +
                            Math.floor(Math.random() * 9e9);
        }

        var success = function (data, xhr, settings) {
            var status = 'success';
            settings.success.call(settings.context, data, status, xhr);
            complete(status, xhr, settings);
        };

        var error = function (error, type, xhr, settings) {
            settings.error.call(settings.context, xhr, type, error);
            complete(type, xhr, settings);
        };

        var complete = function (status, xhr, settings) {
            settings.complete.call(settings.context, xhr, status);
        };

        var xhr = new XMLHttpRequest();

        xhr.addEventListener('readystatechange', function () {
            if (xhr.readyState === 4) {
                var result, dataType;

                if ((xhr.status >= 200 && xhr.status < 300) || xhr.status === 304) {
                    var mime = xhr.getResponseHeader('content-type');
                    dataType = mimeTypes[mime] || 'text';
                    result = xhr.responseText;

                    try {
                        if (dataType === 'json') {
                            result = JSON.parse(result);
                        }

                        success(result, xhr, settings);
                        return;
                    } catch (e) {
                        
                    }
                }

                error(null, 'error', xhr, settings);
                return;
            }
        }, false);


        xhr.open(settings.type, settings.url);

        if (settings.type === 'POST') {
            settings.headers = utils.extend(settings.headers, {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-type': 'application/x-www-form-urlencoded'
            });
        }

        for (var key in settings.headers) {
            xhr.setRequestHeader(key, settings.headers[key]);
        }

        xhr.send(settings.data);

        return this;
    };

    psQuery.fn.init.prototype = psQuery.fn;

    global.psQuery = psQuery;
    if (!global.$) {
        global.$ = psQuery;
    }

    if (debug) {
        global.utils = utils;
    }

    global.ps = global.ps || {};
    global.ps.timings = global.ps.timings || {};
    global.ps.timings.psQuery = {
        start: start,
        end: +new Date()
    };

})(this);
