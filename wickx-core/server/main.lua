WKXCore = {}
WKXCore.Config = WKXConfig
WKXCore.Shared = WKXShared
WKXCore.ClientCallbacks = {}
WKXCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return WKXCore
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local WKXCore = exports['wickxcore']:GetCoreObject()
