local hostIP = "hostIP" -- Your cloud host IP
local appKey = "0000000-0000-0000-0000-0000000000" -- Your cloud app key
local appName = "echo" -- Your app name
local appId = "appId" -- OneSignal App ID
local pushToken
local deviceType = 0 -- default ios
local os = system.getInfo( "platformName" )
local notifications = require( "plugin.notifications" )
if os == "Android" then
    deviceType = 1
elseif os ~= "iPhone OS" then
    --error( "platform not supported for OneSignal" )
else
    notifications.registerForPushNotifications()
end
local launchArgs = ...
if ( launchArgs and launchArgs.notification ) then
    print( launchArgs.notification.type )
    print( launchArgs.notification.name )
    print( launchArgs.notification.sound )
    print( launchArgs.notification.alert )
    print( launchArgs.notification.badge )
    print( launchArgs.notification.applicationState )
end
local json = require("json")
local data = require("data")

-- Require and initialize your Coronium LS Cloud
local coronium = require('coronium.cloud')
local cloud = coronium:new(
{
    host = hostIP,
    app_key = appKey,
    is_local = false, -- true when working on a local server, false when on AWS/DigitalOcean
    https = true -- false when working on a local server, true when on AWS/DigitalOcean
})
local function check(event)
    if event.phase == "ended" then
        local response = event.response
        print( "check" )
        print( "------------------" )
        print(json.encode(event))
        print("-------------------")
    end
end
cloud:request("/" .. appName .. "/test", {
        name = "bob",
}, check)
-- Create a sendEmail listener function
local function check1(event)
    if event.phase == "ended" then
        local response = event.response
        print( "check 1" )
        print( "------------------" )
        print(json.encode(event))
        print("-------------------")
    end
end

local function check2(event)
    if event.phase == "ended" then
        local response = event.response
        print( "check 2" )
        print( "------------------" )
        print(json.encode(response))
    end
end
local button = display.newGroup( )
button.rect = display.newRect( button, 0, 0, 100, 30 )
button.rect:setFillColor( 1 )
button.myText = display.newText( button, "push", 0, 0 , native.systemFont , 12 )
button.myText:setFillColor( 0 )
button.x,button.y = display.contentCenterX, display.contentCenterY
button.rect:addEventListener( "tap", function (  )
    if (os == "Android") then
        cloud:request("/" .. appName .. "/createNotfication", {
            app_id = appId,
            contents = {en="hello from OneSignal"},
            isAndroid = true,
            included_segments = {"All"}
        }, check2)
    else -- IOS
        cloud:request("/" .. appName .. "/createNotfication", {
            app_id = appId,
            contents = {en="hello from OneSignal"},
            isIos = true,
            included_segments = {"All"}
        }, check2)
    end
end )
local function notificationListener( event )

    if ( event.type == "remote" or event.type == "local" ) then
        print( "push info" )
        print( "------------------" )
        print( json.encode( event ) )

    elseif ( event.type == "remoteRegistration" ) then
        print("token:"..event.token.."/ deviceType:"..deviceType)
        deviceToken = event.token
        cloud:request("/" .. appName .. "/registerDevice", {
            app_id = appId,
            device_type = deviceType,
            identifier = deviceToken,
            language = "en",
            sdk = "corona",
            device_model = system.getInfo( "model" )
        }, check1)
    end
    print("notification running")
end

Runtime:addEventListener( "notification", notificationListener )