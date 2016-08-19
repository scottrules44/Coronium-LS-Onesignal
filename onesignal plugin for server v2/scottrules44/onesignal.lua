-- copyright Scott Harrison(scottrules44) Aug 3 2016
local http = require("ssl.https")
local json = require("cjson")
local ltn12 = require("ltn12")
local mime = require("mime")
local url = require("socket.url")
--local http = require("resty.http")
--local http = require("socket.http")
local config - require("configOS")
local m = {}

local restKey = config.restKey

function m.formatResponse(result, status)
    pcall(function()
        result = json.decode(result)
    end)
    if result == "" or not result then
        result = "Invalid Response"
    end
    if status ~= 200 then
        return nil, result.message or result
    end
    return result
end

function m.apiRequest(path, data, myMethod, noHeaders, noAuthAndData)
    local body = cloud.encode.json( data )
    local myNetwork
    local request
    local output = {}
    local result, err
    if (data) then
        myNetwork ={
            url = "https://onesignal.com/api/v1/"..path,
            source = ltn12.source.string(body),
            method = myMethod,
            headers =
            {
                --["Host"] = "api.mailgun.net",
                ["Content-type"] = "application/json",
                ["Content-length"] = #body,
                ["Authorization"] = "Basic " .. restKey--mime.b64("api:" .. apiKey)
            },
            sink = ltn12.sink.table(output),
            protocol = "sslv23"
        }
    elseif (noHeaders and noHeaders == true) then
        myNetwork ={
            url = "https://onesignal.com/api/v1/"..path,
            source = ltn12.source.string(body),
            method = myMethod,
            sink = ltn12.sink.table(output),
            protocol = "sslv23"
        }
    elseif (noAuthAndData and noAuthAndData == true) then
         myNetwork ={
            url = "https://onesignal.com/api/v1/"..path,
            source = ltn12.source.string(body),
            method = myMethod,
            headers =
            {
                --["Host"] = "api.mailgun.net",
                ["Content-type"] = "application/json",
                ["Content-length"] = #body,
                --["Authorization"] = "Basic " .. restKey--mime.b64("api:" .. apiKey)
            },
            sink = ltn12.sink.table(output),
            protocol = "sslv23"
        }
    else
        myNetwork ={
            url = "https://onesignal.com/api/v1/"..path,
            --source = ltn12.source.string(body),
            method = myMethod,
            headers =
            {
                --["Host"] = "api.mailgun.net",
                --["Content-type"] = "application/json",
                --["Content-length"] = #body,
                ["Authorization"] = "Basic " .. restKey--mime.b64("api:" .. apiKey)
            },
            sink = ltn12.sink.table(output),
            protocol = "sslv23"
        }
    end
    --local tempString = cloud.encode.json( request )
    local _, status = http.request(myNetwork)
    return m.formatResponse(table.concat(output), status)
end

function m.viewApps( data )--https://documentation.onesignal.com/docs/apps-view-apps
    --local myData = {}
    return m.apiRequest("apps", nil, "GET")
end
function m.getAppInfo( data )--https://documentation.onesignal.com/docs/appsid
    --local myData = {}
    return m.apiRequest("apps/"..data.id, nil, "GET")
end
function m.makeApp( data )--https://documentation.onesignal.com/docs/apps-create-an-app
    local myData = {
        apns_env = data.apns_env,
        apns_p12 = data.apns_p12,
        apns_p12_password = data.apns_p12_password,
        gcm_key = data.gcm_key,
        chrome_key = data.chrome_key,
        safari_apns_p12 = data.safari_apns_p12,
        chrome_web_key = data.chrome_web_key,
        safari_apns_p12_password = data.safari_apns_p12_password,
        site_name = data.site_name,
        safari_site_origin = data.safari_site_origin,
        safari_icon_16_16 = data.safari_icon_16_16,
        safari_icon_32_32 = data.safari_icon_32_32,
        safari_icon_64_64 = data.safari_icon_64_64,
        safari_icon_128_128 = data.safari_icon_128_128,
        safari_icon_256_256 = data.safari_icon_256_256,
        chrome_web_origin = data.chrome_web_origin,
        chrome_web_gcm_sender_id = data.chrome_web_gcm_sender_id,
        chrome_web_default_notification_icon = data.chrome_web_default_notification_icon,
        chrome_web_sub_domain = data.chrome_web_sub_domain,
    }
    return m.apiRequest("apps", myData, "POST")
end
function m.updateApp( data )--https://documentation.onesignal.com/docs/appsid-update-an-app
    --include data.id which is the app id to update
    local myData = {
        apns_env = data.apns_env,
        apns_p12 = data.apns_p12,
        apns_p12_password = data.apns_p12_password,
        gcm_key = data.gcm_key,
        chrome_key = data.chrome_key,
        safari_apns_p12 = data.safari_apns_p12,
        chrome_web_key = data.chrome_web_key,
        safari_apns_p12_password = data.safari_apns_p12_password,
        site_name = data.site_name,
        safari_site_origin = data.safari_site_origin,
        safari_icon_16_16 = data.safari_icon_16_16,
        safari_icon_32_32 = data.safari_icon_32_32,
        safari_icon_64_64 = data.safari_icon_64_64,
        safari_icon_128_128 = data.safari_icon_128_128,
        safari_icon_256_256 = data.safari_icon_256_256,
        chrome_web_origin = data.chrome_web_origin,
        chrome_web_gcm_sender_id = data.chrome_web_gcm_sender_id,
        chrome_web_default_notification_icon = data.chrome_web_default_notification_icon,
        chrome_web_sub_domain = data.chrome_web_sub_domain,
    }
    return m.apiRequest("apps/"..data.id, myData, "PUT")
end
function m.viewDevices( data )--https://documentation.onesignal.com/docs/players-view-devices
    local uri = "players?app_id="..data.app_id
    if (data.limit) then
        uri = uri.."&limit="..data.limit
    end
    if (data.offset) then
        uri = uri.."&offset="..data.offset
    end
    return m.apiRequest(uri, nil, "GET")
end
function m.viewDeviceInfo( data )--https://documentation.onesignal.com/docs/playersid
    local uri = "players/"..data.id.."?app_id="..data.app_id
    return m.apiRequest(uri, nil, "GET")
end
function m.registerDevice( data )--https://documentation.onesignal.com/docs/players-add-a-device
    local myData = {
        app_id = data.app_id,
        device_type = data.device_type,
        identifier = data.identifier,
        language = data.identifier,
        timezone = data.timezone,
        game_version = data.game_version,
        device_model = data.device_model,
        device_os = data.device_os,
        ad_id = data.ad_id,
        sdk = data.sdk,
        session_count = data.session_count,
        tags = data.tags,
        amount_spent = data.amount_spent,
        created_at = data.created_at,
        playtime = data.playtime,
        badge_count = data.badge_count,
        last_active = data.last_active,
        test_type = data.test_type,
    }
    return m.apiRequest("players", myData, "POST")
end
function m.updateDevice( data )--https://documentation.onesignal.com/docs/playersid-1
    local myData = {
        app_id = data.app_id,
        identifier = data.identifier,
        language = data.language,
        timezone = data.timezone,
        device_model = data.device_model,
        device_os = data.device_os,
        game_version = data.game_version,
        ad_id = data.ad_id,
        session_count = data.session_count,
        tags = data.tags,
        amount_spent = data.amount_spent,
        created_at = data.created_at,
        last_active = data.last_active,
        badge_count = data.badge_count,
        playtime = data.playtime,
        sdk = data.sdk,
        notification_types = data.notification_types,
        test_type = data.test_type,
        long = data.long,
        lat = data.lat,
    }
    return m.apiRequest("players/"..data.id, myData, "PUT", nil, true)
end
function m.callSession( data )--https://documentation.onesignal.com/docs/playersidon_session
    --docs say "This method should be called when a device opens your app after they are already registered. This method will automatically increment the player's session_count, and should also be used to update any fields that may have changed (Such as language or timezone)."
    local myData = {
        identifier = data.identifier,
        language = data.language,
        timezone = data.timezone,
        game_version = data.game_version,
        device_os = data.device_os,
        ad_id = data.ad_id,
        sdk = data.sdk,
        tags = data.tags,
    }
    return m.apiRequest("players/"..data.id.."/on_session", myData, "POST", nil, true)
end
function m.purchaseMade( data )--https://documentation.onesignal.com/docs/on_purchase
    local myData = {
        purchases = data.purchases,
        --[[purchases is a table
            from docs:
                purchases[sku]:
                required
                string
                The unique identifier of the purchased item.
                purchases[amount]:
                required
                double
                The amount, in USD, spent purchasing the item.
                purchases[iso]:
                required
                string
                The 3-letter ISO 4217 currency code. Required for correct storage and conversion of amount.
        ]]--
        existing = data.existing,
    }
    return m.apiRequest("players/"..data.id.."/on_purchase", myData, "POST", nil, true)
end
function m.getCsvUrl( data )--https://documentation.onesignal.com/docs/players_csv_export
    return m.apiRequest("players/csv_export?app_id="..data.id, nil, "POST")
end
function m.getNotificationInfo( data )--https://documentation.onesignal.com/docs/notificationsid-view-notification
    return m.apiRequest("notifications/"..data.notificationId.."?app_id="..data.app_id, nil, "GET")
end
function m.getNotifications( data )--https://documentation.onesignal.com/docs/notifications-view-notifications
    local uri = "notifications?app_id="..data.app_id
    if (data.limit) then
        uri = uri.."&limit="..data.limit
    end
    if (data.offset) then
        uri = uri.."&offset="..data.offset
    end
    return m.apiRequest(uri, nil, "GET")
end
function m.trackOpen( data )--https://documentation.onesignal.com/docs/notificationsid-track-open
    --use when notfication read, put in where you process your notfication
    local myData = {
        app_id = data.app_id,
        existing = data.existing,
    }
    return m.apiRequest("notifications/"..data.id, myData, "PUT")
end
function m.createNotfication( data )--https://documentation.onesignal.com/docs/notifications-create-notification
    local myData = {
        app_id = data.app_id,
        contents = data.contents,
        headings = data.headings,
        isIos = data.isIos,
        isAndroid = data.isAndroid,
        isWP = data.isWP, --windows phone 8.0
        isWP_WNS = data.isWP_WNS, --windows phone 8.1+
        isAdm = data.isAdm, -- amazon
        isChrome = data.isChrome,
        isChromeWeb = data.isChromeWeb,
        isSafari = data.isSafari,
        isAnyWeb = data.isAnyWeb,
        included_segments = data.included_segments,
        excluded_segments = data.excluded_segments,
        include_player_ids = data.include_player_ids,
        include_ios_tokens = data.include_ios_tokens,
        include_android_reg_ids = data.include_android_reg_ids,
        include_wp_uris = data.include_wp_uris,--windows phone 8.0
        include_wp_wns_uris = data.include_wp_wns_uris,--windows phone 8.1 +
        include_amazon_reg_ids = data.include_amazon_reg_ids,
        include_chrome_reg_ids = data.include_chrome_reg_ids,
        include_chrome_web_reg_ids = data.include_chrome_web_reg_ids,
        app_ids = data.app_ids,
        tags = data.tags,
        ios_badgeType = data.ios_badgeType,
        ios_badgeCount = data.ios_badgeCount,
        ios_sound = data.ios_sound,
        android_sound = data.android_sound,
        adm_sound = data.adm_sound,
        wp_sound = data.wp_sound,--windows phone 8.0
        wp_wns_sound = data.wp_wns_sound,--windows phone 8.1 +
        data = data.data,
        buttons = data.buttons, -- on ios 8.0+ and android 4.1+
        web_buttons = data.web_buttons,-- on Chrome 48+
        small_icon = data.small_icon, -- android
        large_icon = data.large_icon, -- android
        big_picture = data.big_picture, -- android
        adm_small_icon = data.adm_small_icon, -- amazon
        adm_large_icon = data.adm_large_icon, -- amazon
        adm_big_picture = data.adm_big_picture, -- amazon
        chrome_icon = data.chrome_icon, -- chrome
        chrome_big_picture = data.chrome_big_picture, -- chrome
        chrome_web_icon = data.chrome_web_icon, -- chrome
        firefox_icon = data.firefox_icon, -- firefox
        url = data.firefox_icon,
        send_after = data.send_after,
        delayed_option = data.delayed_option,
        delivery_time_of_day = data.delivery_time_of_day,
        android_led_color = data.android_led_color,-- android
        android_accent_color = data.android_accent_color,-- android
        android_visibility = data.android_visibility,-- android
        content_available = data.content_available,-- ios
        amazon_background_data = data.amazon_background_data,-- amazon
        template_id = data.template_id,
        android_group = data.android_group,-- android
        android_group_message = data.android_group_message,-- android
        adm_group = data.adm_group,-- amazon
        adm_group_message = data.adm_group,-- amazon
        ttl = data.ttl,
        priority = data.priority,
        ios_category = data.ios_category, -- ios
        ios_category = data.ios_category, -- ios
    }
    return m.apiRequest("notifications", myData, "POST")
end
function m.cancelNotfication( data )--https://documentation.onesignal.com/docs/notificationsid-cancel-notification
    return m.apiRequest("notifications/"..data.id.."?app_id="..data.app_id, nil, "DELETE")
end
return m