---@type FieldTypes
T = require("app.fui.FieldTypes")

---@type UIObjectFactory
UIObjectFactory = require("app.fui.UIObjectFactory")

---@type ToolSet
ToolSet = require("app.fui.utils.ToolSet")

---@type TextFormat
TextFormat = require("app.fui.node.TextFormat")

---@type UIConfig
UIConfig = require("app.fui.UIConfig")

---@type UIPackage
UIPackage = require("app.fui.UIPackage")

---@type DragDropManager
DragDropManager = require("app.fui.DragDropManager")

---@type GActionManager
GActionManager = require("app.fui.action.ActionManager")

--PublicUtils = require("app.publicUtil.PublicUtils")
--require("app.publicUtil.QCoroutine")

---@param obj GObject
CALL_LATER = function(obj, func, dt)

    if not UIRoot then
        return
    end

    UIRoot:RemoveRoutine(obj, func)

    if dt == nil then
        dt = 0 / 60
    end

    UIRoot:PlayRoutine(obj, func, dt)
end

CALL_LATER_CANCEL = function(obj, func)

    if not UIRoot then
        return
    end

    UIRoot:RemoveRoutine(obj, func)
end

-------@param obj GObject
--CALL_LATER = function(obj, func,dt)
--
--    if dt == nil then
--        dt = 1/60
--    end
--
--    performWithDelay(obj._displayObject, function()
--        func(obj)
--    end, dt)
--end

math.clamp = function(p, min, max)
    if min > max then
        min, max = max, min
    end

    return (p < min) and (min) or (p < max and p or max)
end


--重新加载一个模块，如果加载失败则返回nil
function require_ex(_mname)

    local __G__TRACKBACK__ = function(msg)
        printError("----------------------------------------")
        printError("LUA ERROR: " .. tostring(msg) .. "\n")
        printError(debug.traceback())
        printError("----------------------------------------")
        return msg
    end

    local require_reload = function()
        printInfo("require_ex = %s", _mname)
        if package.loaded[_mname] then
            printInfo("require_ex module[%s] reload", _mname)
        end
        package.loaded[_mname] = nil
        return require(_mname)
    end

    local status, msg = xpcall(require_reload, __G__TRACKBACK__)
    if not status then
        return nil,msg
    end
    if status == true then
        return msg
    end

end

---@param obj GObject
G_doDestory = function(obj)
    if obj then
        obj:doDestory()
    end
end

function isnan(x)
    return x ~= x
end

function isinf(x)
    return x == math.hage or x == -math.hage
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function LUA_MOD(i, m)
    local v = i % m
    if v == 0 then
        return m
    end
    return v
end

INT_MAX = 2147483647

-- require("framework.cc.utils.bit")


transition = transition or {}

-- start --

--------------------------------
-- 在显示对象上循环播放动画，并返回 Action 动作对象。
-- @function [parent=#transition] playAnimationForever
-- @param cc.Node target 显示对象
-- @param cc.Node animation 动作对象
-- @param number delay 播放前等待的时间
-- @return table#table ret (return value: table)  动作表格对象

--[[--

在显示对象上循环播放动画，并返回 Action 动作对象。

~~~ lua

local frames = display.newFrames("Walk%04d.png", 1, 20)
local animation = display.newAnimation(frames, 0.5 / 20) -- 0.5s play 20 frames
sprite:playAnimationForever(animation)

~~~

]]
-- end --

function transition.playAnimationForever(target, animation, delay)
    local animate = cc.Animate:create(animation)
    local action
    if type(delay) == "number" and delay > 0 then
        target:setVisible(false)
        local sequence = transition.sequence({
            cc.DelayTime:create(delay),
            cc.Show:create(),
            animate,
        })
        action = cc.RepeatForever:create(sequence)
    else
        action = cc.RepeatForever:create(animate)
    end
    target:runAction(action)
    return action
end