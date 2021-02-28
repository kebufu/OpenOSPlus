local component = require("component")
local fs = require("filesystem")
local shell = require("shell")
local i18n = require("i18n").get("System")

local args = shell.parse(...)
if #args == 0 then
  io.write(i18n['ln.usage'])
  return 1
end

local target_name = args[1]
local target = shell.resolve(target_name)

-- don't link from target if it doesn't exist, unless it is a broken link
if not fs.exists(target) and not fs.isLink(target) then
  io.stderr:write(string.format(i18n['ln.nosuchfile'], target_name))
  return 1
end

local linkpath
if #args > 1 then
  linkpath = shell.resolve(args[2])
else
  linkpath = fs.concat(shell.getWorkingDirectory(), fs.name(target))
end

if fs.isDirectory(linkpath) then
  linkpath = fs.concat(linkpath, fs.name(target))
end

local result, reason = fs.link(target_name, linkpath)
if not result then
  io.stderr:write(reason..'\n')
  return 1
end