using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Diagnostics;
using System.IO.IsolatedStorage;



namespace WPCordovaClassLib.Cordova.Commands
{

    public class AM : BaseCommand
    {

        private const string _token = "token";
        private const string _username = "username";
        private const string _password = "password";

        public void clear(string options)
        {
            try
            {
                AppSettings[_token] = null;
                AppSettings[_username] = null;
                AppSettings[_password] = null;
                AppSettings.Save();
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
            }
            catch (Exception ex)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, ex.Message));
            }
        }

        public void setToken(string options)
        {
            setProperty(_token, options);
        }

        public void getToken(string options)
        {
            getProperty(_token);
        }

        public void setPassword(string options)
        {
            setProperty(_password, options);
        }

        public void getPassword(string options)
        {
            getProperty(_password);
        }

        public void setUsername(string options)
        {
            setProperty(_username, options);
        }

        public void getUsername(string options)
        {
            getProperty(_username);
        }

        public void enableSharing(string options)
        {
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
        }

        public void setPackage(string options)
        {
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
        }

        public void getDeviceId(string options)
        {
            try
            {
                byte[] id = (byte[])Microsoft.Phone.Info.DeviceExtendedProperties.GetValue("DeviceUniqueId");
                string deviceID = Convert.ToBase64String(id);
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK, deviceID));
            }
            catch (Exception ex)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, ex.Message));
            }
        }



        private IsolatedStorageSettings AppSettings
        {
            get
            {
                return IsolatedStorageSettings.ApplicationSettings;
            }
        }

        private void setProperty(string name, string options)
        {
            try
            {
                if (options != null)
                {
                    string[] args = JSON.JsonHelper.Deserialize<string[]>(options);
                    AppSettings[name] = args[0];
                    AppSettings.Save();
                }
                else {
                    AppSettings[name] = null;
                }
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK));
            }
            catch (Exception ex)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, ex.Message));
            }
        }


        private void getProperty(string name)
        {
            try
            {
                if (AppSettings.Contains(name))
                {
                    DispatchCommandResult(new PluginResult(PluginResult.Status.OK, (string)AppSettings[name]));
                }
                DispatchCommandResult(new PluginResult(PluginResult.Status.OK, null));
            }
            catch (Exception ex)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, ex.Message));
            }
        }


        public void loginPrompt(string options)
        {
            DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, "LoginPrompt not implemented"));
        }

    }
}
