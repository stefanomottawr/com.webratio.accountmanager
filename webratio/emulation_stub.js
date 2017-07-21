function createStubs() {

    var STORAGE_KEY = "com.webratio.accountmanager.data";
    var INITIAL_DATA = {
        username: null,
        password: null,
        token: null
    };
    var $ = window.top.jQuery;
    var loginDialog = null;

    function log() {
        var args = [].slice.call(arguments, 0);
        args.unshift("[accountmanager]");
        console.log.apply(console, args);
    }

    function save(data) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    }

    function load() {
        var s = localStorage.getItem(STORAGE_KEY);
        return s ? JSON.parse(s) : INITIAL_DATA;
    }

    function promptLogin(message, title, buttonLabels, username, readonly) {

        if (!loginDialog) { // create dialog
            var loginPrompt = $('<div id="am-login-prompt" title="Login">' + '<p class="msg"></p>' + '<form>' + '<fieldset>'
                    + '<label for="name" style="display: block;">Username</label>'
                    + '<input type="text" name="username" id="username" class="text ui-corner-all" style="width: 100%;">'
                    + '<label for="password" style="display: block;">Password</label>'
                    + '<input type="password" name="password" id="password" class="text ui-corner-all" style="width: 100%;">'
                    + '</fieldset>' + '</form>' + '</div>');

            $('#overlay-views').append(loginPrompt);
            loginDialog = loginPrompt.dialog({
                appendTo: "#overlay-views",
                autoOpen: false,
                closeOnEscape: false,
                modal: true,
                position: { my: "center", at: "center", of: $('#viewport-container') },
                close: function() {
                    var result = {
                        "buttonIndex": loginDialog.data("clickedButton"),
                        "username": $("#username", loginDialog).val(),
                        "password": $("#password", loginDialog).val()
                    }
                    loginDialog.data("resolver")(result);
                }
            });

        }
        
        loginDialog.data("clickedButton", 0);
        loginDialog.data("resolver", null);

        // configure dialog options
        loginDialog.dialog("option", "title", title);
        $(".msg", loginDialog).text(message);
        $("#username", loginDialog).val((username && username.length) ? username : "");
        if (readonly) {
            $("#username", loginDialog).prop("disabled", "disabled");
        } else {
            $("#username", loginDialog).removeProp("disabled");
        }

        $("#password", loginDialog).val("");

        return new Promise(function(resolve, reject) {
            loginDialog.data("resolver", resolve);
            var buttons = [];
            var buttonCreate = function(label, i) {
                var index = i + 1;
                return {
                    text: label,
                    click: function() {
                        loginDialog.data("clickedButton", index);
                        loginDialog.dialog("close");
                    }
                }
            }

            for (var i = 0; i < buttonLabels.length; i++) {
                buttons.push(buttonCreate(buttonLabels[i], i))
            }
            
            $('#platform-events-fire-back').css("display", "none");
            $('#platform-events-fire-suspend').before("<button id=\"platform-events-fire-back-contacts\">Back</button>");
            $('#platform-events-fire-back-contacts').button().css("width", "90px").click(function(evt) {
                $('#platform-events-fire-back-contacts').remove();
                $('#platform-events-fire-back').css("display", "");
                loginDialog.dialog("close");
            });
            

            loginDialog.dialog("option", "buttons", buttons);
            loginDialog.dialog("open");
        })
    }

    return {
        AM: {
            setPackage: function(packageName) {
                log("Set package", packageName);
            },
            enableSharing: function(groupId, teamId) {
                log("Enabled sharing", groupId, teamId);
            },
            clear: function() {
                save(INITIAL_DATA);
                log("Cleared", load());
            },
            setUsername: function(username) {
                var data = load();
                data.username = username;
                save(data);
                log("Updated username", load());
            },
            getUsername: function() {
                var username = load().username;
                log("Read username");
                return username;
            },
            setPassword: function(password) {
                var data = load();
                data.password = password;
                save(data);
                log("Updated password", load());
            },
            getPassword: function() {
                var password = load().password;
                log("Read password");
                return password;
            },
            setToken: function(token) {
                var data = load();
                data.token = token;
                save(data);
                log("Updated token", load());
            },
            getToken: function() {
                var token = load().token;
                log("Read token");
                return token;
            },
            getDeviceId: function() {
                return device.uuid;
            },
            loginPrompt: function(message, title, buttonLabels, username, readonly) {
                log("Login Prompt");
                return promptLogin(message, title, buttonLabels, username, readonly);
            }
        }
    };
};