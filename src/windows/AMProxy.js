/*global Windows:true */

var cordova = require('cordova');

var _token = "token";
var _username = "username";
var _password = "password";
var localSettings = Windows.Storage.ApplicationData.current.localSettings;

module.exports = {
    clear: function(successCallback, errorCallback) {
    	try {
       		localSettings.values[_token] = null;
       		localSettings.values[_username] = null;
       		localSettings.values[_password] = null;
       		if (successCallback) {
       			successCallback();
       		};
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    setToken: function(successCallback, errorCallback, args) {
    	try {
        	localSettings.values[_token] = args[0];
        	if (successCallback) {
       			successCallback();
       		};
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    getToken: function(successCallback, errorCallback) {
    	try {
        	if (successCallback) {
       			successCallback(localSettings.values[_token]);
       		};
       		return;
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    setPassword: function(successCallback, errorCallback, args) {
        try {
            localSettings.values[_password] = args[0];;
        	if (successCallback) {
       			successCallback();
       		};
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    getPassword: function(successCallback, errorCallback) {
        try {
        	if (successCallback) {
       			successCallback(localSettings.values[_password]);
       		};
       		return;
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    setUsername: function(successCallback, errorCallback, args) {
        try {
            localSettings.values[_username] = args[0];;
        	if (successCallback) {
       			successCallback();
       		};
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    getUsername: function(successCallback, errorCallback) {
        try {
        	if (successCallback) {
       			successCallback(localSettings.values[_username]);
       		};
       		return;
       	}catch(err){
       		if (errorCallback) {
       			errorCallback(err);
       		}
       	}
    },

    enableSharing: function(successCallback, errorCallback, args) {
        if (successCallback) {
   			successCallback();
   		};
    },

    setPackage: function(successCallback, errorCallback, args) {
        if (successCallback) {
   			successCallback();
   		};
    },

    getDeviceId: function(successCallback, errorCallback) {
    	var deviceId = "";
	    var packageSpecificToken = Windows.System.Profile.HardwareIdentification.getPackageSpecificToken(null);
	    var hardwareId = packageSpecificToken.id;
	    var dataReader = Windows.Storage.Streams.DataReader.fromBuffer(hardwareId);
	    var array = new Array(hardwareId.length);
	    dataReader.readBytes(array);
	    for (var i = 0; i < array.length; i++) {
	        deviceId += array[i].toString();
	    }
	    deviceId = Convert.ToBase64String(id);
	    successCallback(deviceId);
    },

    loginPrompt: function(message, successCallback, args) {
        throw "LoginPrompt not implemented";
    }
};

require("cordova/exec/proxy").add("AM",module.exports);
