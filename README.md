# Coronium-LS-Onesignal
send push and register devices, also analytics 


Installation


note:please setup app at onesignal.com before getting started (also setup ios certficate and andorid info for push)

1.Install Coronium LS

2. Once signed into your server, run the following command to install LuaSec on your server: sudo luarocks install luasec (if you have 1.3 this is no longer need)

3. update the following info

----v2
-onesignal plugin for server

--configOS.lua

---restKey (onesignal.com>login in> choose app>app settings> key and ids>REST API Key)

-onesignal demo

--main.lua

---hostIP (Your cloud host IP)

---appId (OneSignal App ID(onesignal.com>login in> choose app>app settings> key and ids>OneSignal App ID)

---appName (Your app name)

---- v1 
-onesignal plugin for server

--onesignal.lua

---restKey (onesignal.com>login in> choose app>app settings> key and ids>REST API Key)

-onesignal demo

--main.lua

---hostIP (Your cloud host IP)

---appId (OneSignal App ID(onesignal.com>login in> choose app>app settings> key and ids>OneSignal App ID)

---appName (Your app name)

4.

--1.2.3 and below (v1)

put all the stuff in(inside the folder only, do not just throw in the folder) the "onesignal plugin for server" folder in the
app of your choice

--1.3 and above

Place scottrules44 inside plugins folder

Docs:

coming soon

for now please look at "onesignal plugin for server>onesignal.lua" for api info
