package com.webratio.accountmanager;

import com.webratio.accountmanager.Constants;

import java.io.IOException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.content.SharedPreferences;
import android.content.pm.PackageManager.NameNotFoundException;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class AM extends CordovaPlugin {

    public String packageId;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if ("clear".equals(action)) {

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                SharedPreferences.Editor editor = settings.edit();
                editor.remove("__USERNAME__");
                editor.remove("__PASSWORD__");
                editor.remove("__TOKEN__");
                editor.commit();
                callbackContext.success();
                return true;

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }
        }

        if ("setToken".equals(action)) {

            String token = (args.isNull(0) ? null : args.getString(0));

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                SharedPreferences.Editor editor = settings.edit();
                editor.putString("__TOKEN__", token);
                editor.commit();

                // check if the account information are added correctly to the Preferences
                String tokenVal = settings.getString("__TOKEN__", null);
                if ((token != null && !token.equals(tokenVal)) || (token == null && tokenVal != null)) {
                    callbackContext.error("Token not correctly set");
                    return true;
                }

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }

            callbackContext.success();
            return true;
        }

        if ("getToken".equals(action)) {

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                String token = settings.getString("__TOKEN__", null);
                callbackContext.success(token);
                return true;

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }
        }

        if ("setPassword".equals(action)) {

            String password = (args.isNull(0) ? null : args.getString(0));

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                SharedPreferences.Editor editor = settings.edit();
                editor.putString("__PASSWORD__", password);
                editor.commit();

                // check if the account information are added correctly to the Preferences
                String passwordVal = settings.getString("__PASSWORD__", null);
                if ((password != null && !password.equals(passwordVal)) || (password == null && passwordVal != null)) {
                    callbackContext.error("Password not correctly set");
                    return true;
                }

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }

            callbackContext.success();
            return true;
        }

        if ("getPassword".equals(action)) {

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                String password = settings.getString("__PASSWORD__", null);
                callbackContext.success(password);
                return true;

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }
        }

        if ("setUsername".equals(action)) {

            String username = (args.isNull(0) ? null : args.getString(0));

            // add the username in the Preferences
            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                SharedPreferences.Editor editor = settings.edit();
                editor.putString("__USERNAME__", username);
                editor.commit();

                // check if the account information are added correctly to the Preferences
                String usernameVal = settings.getString("__USERNAME__", null);
                if ((username != null && !username.equals(usernameVal)) || (username == null && usernameVal != null)) {
                    callbackContext.error("Error");
                    return true;
                }

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }

            callbackContext.success();
            return true;
        }

        if ("getUsername".equals(action)) {

            Context myContext;
            try {
                myContext = cordova.getActivity().getApplicationContext().createPackageContext(packageId, 0);
                SharedPreferences settings = myContext.getSharedPreferences(Constants.PREFS_NAME, 0);
                String username = settings.getString("__USERNAME__", null);
                callbackContext.success(username);
                return true;

            } catch (NameNotFoundException e) {
                callbackContext.error("Invalid Package");
                return true;
            }
        }

        if ("setPackage".equals(action)) {
            // check args
            if (args.isNull(0) || args.getString(0).length() == 0) {
                callbackContext.error("Package can not be null or empty");
                return true;
            }

            packageId = args.getString(0);
            callbackContext.success();
            return true;
        }

        if ("enableSharing".equals(action)) {
            callbackContext.success();
            return true;
        }

        if ("loginPrompt".equals(action)) {
            this.loginPrompt(args.isNull(0) ? null : args.getString(0), args.isNull(0) ? null : args.getString(1),
                    args.getJSONArray(2), args.isNull(0) ? null : args.getString(3), args.getBoolean(4), callbackContext);
            return true;
        }

        callbackContext.error("The function called is not present in the plugin.");
        return false;

    }

    private synchronized void loginPrompt(final String message, final String title, final JSONArray buttonLabels,
            final String usernameDefault, final Boolean usernameReadonly, final CallbackContext callbackContext) {

        final CordovaInterface cordova = this.cordova;

        Runnable runnable = new Runnable() {
            public void run() {
                Resources res = cordova.getActivity().getResources();
                LayoutInflater li = LayoutInflater.from(cordova.getActivity());
                View subView = li.inflate(res.getLayout(res.getIdentifier("am_login_prompt", "layout", cordova.getActivity().getPackageName())), null);

                final EditText usernameInput = (EditText) subView.findViewById(cordova.getActivity().getResources().getIdentifier("login_name", "id", cordova.getActivity().getPackageName()));
                final EditText pwdInput = (EditText) subView.findViewById(cordova.getActivity().getResources().getIdentifier("login_password", "id", cordova.getActivity().getPackageName()));

                usernameInput.setEnabled(!usernameReadonly);
                if (usernameDefault != null && usernameDefault.length() > 0) {
                    usernameInput.setText(usernameDefault);
                }

                AlertDialog.Builder dlg = createDialog(cordova);
                dlg.setMessage(message);
                dlg.setTitle(title);
                dlg.setCancelable(true);
                dlg.setView(subView);

                final JSONObject result = new JSONObject();

                // First button
                if (buttonLabels.length() > 0) {
                    try {
                        dlg.setPositiveButton(buttonLabels.getString(0), new AlertDialog.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                try {
                                    result.put("buttonIndex", 1);
                                    result.put("username", usernameInput.getText());
                                    result.put("password", pwdInput.getText());
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                            }
                        });
                    } catch (JSONException e) {
                    }
                }

                // Second button
                if (buttonLabels.length() > 1) {
                    try {
                        dlg.setNegativeButton(buttonLabels.getString(1), new AlertDialog.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                try {
                                    result.put("buttonIndex", 2);
                                    result.put("username", usernameInput.getText());
                                    result.put("password", pwdInput.getText());
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                            }
                        });
                    } catch (JSONException e) {
                    }
                }

                // Third button
                if (buttonLabels.length() > 2) {
                    try {
                        dlg.setNeutralButton(buttonLabels.getString(2), new AlertDialog.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                try {
                                    result.put("buttonIndex", 3);
                                    result.put("username", usernameInput.getText());
                                    result.put("password", pwdInput.getText());
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                            }
                        });
                    } catch (JSONException e) {
                    }
                }
                dlg.setOnCancelListener(new AlertDialog.OnCancelListener() {
                    public void onCancel(DialogInterface dialog) {
                        dialog.dismiss();
                        try {
                            result.put("buttonIndex", 0);
                            result.put("username", usernameInput.getText());
                            result.put("password", pwdInput.getText());
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                    }
                });

                changeTextDirection(dlg);
            };
        };
        this.cordova.getActivity().runOnUiThread(runnable);
    }

    @SuppressLint("NewApi")
    private AlertDialog.Builder createDialog(CordovaInterface cordova) {
        int currentapiVersion = android.os.Build.VERSION.SDK_INT;
        if (currentapiVersion >= android.os.Build.VERSION_CODES.HONEYCOMB) {
            return new AlertDialog.Builder(cordova.getActivity(), AlertDialog.THEME_DEVICE_DEFAULT_LIGHT);
        } else {
            return new AlertDialog.Builder(cordova.getActivity());
        }
    }

    @SuppressLint("NewApi")
    private void changeTextDirection(Builder dlg) {
        int currentapiVersion = android.os.Build.VERSION.SDK_INT;
        dlg.create();
        AlertDialog dialog = dlg.show();
        if (currentapiVersion >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR1) {
            TextView messageview = (TextView) dialog.findViewById(android.R.id.message);
            messageview.setTextDirection(android.view.View.TEXT_DIRECTION_LOCALE);
        }
    }

}