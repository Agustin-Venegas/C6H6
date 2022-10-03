-- contains essential methods for handling pObjects and pBullets
local objSystems = {}
local self = objSystems

function objSystems.getNewOID()
    local OID = nextOID
    -- avoid ID clashes (try to only use as backup)
    while pObjects[OID] ~= nil do OID = OID + 1 end
    nextOID = OID + 1
    return OID
end

function objSystems.getNewBID()
    local BID = nextBID
    -- avoid ID clashes (try to only use as backup)
    while pBullets[BID] ~= nil do BID = BID + 1 end
    nextBID = BID + 1
    return BID
end

function objSystems.despawnObj(OID)
    table.remove(pObjects, OID)
    nextOID = nextOID - 1
end

function objSystems.despawnBul(BID)
    table.remove(pBullets, BID)
    nextBID = nextBID - 1
end

-- prototype of all pObjects
objPrototype = { type = "unknown", x = 0, y = 0, color = {1,1,1,1}, size = 8}

function objPrototype:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function objPrototype:Update(dt)
end

function objPrototype:Enter(other)
end


-- basis for all pObjects - needs x,y,type parameters
-- "type" is an identifying string used to choose specific behavior;
    -- it can be left blank, which will give it no behavior
    -- and simply draw a circle on the screen until it is manually despawned
	
function objSystems.createObject(x, y, type, color, size)
    local newObj = objPrototype:new(nil)
	
    local OID = self.getNewOID()
    pObjects[OID] = newObj
	
	newObj.x = x or newObj.x
	newObj.y = y or newObj.y
	newObj.type = type or "unknown"
	newObj.color = color or {1,1,1,1}
	newObj.size = size or newObj.size
	
    return newObj
end

-- basis for all pBullets - needs existing origin and type parameters
-- "type" is an identifying string used to choose specific behavior;
    -- it can be left blank, which will give it no behavior
    -- and simply draw a circle on the screen until it is manually despawned
function objSystems.createBullet(origin, type, decay, color, size)
    local newBul = {}
    local BID = self.getNewBID()
    pBullets[BID] = newBul
    newBul["type"] = type or "unknown"
    newBul["origin"] = origin
    newBul["x"] = origin.x
    newBul["y"] = origin.y
    newBul["decay"] = decay or 10000
    newBul["color"] = color or {1,1,1,1}
    newBul["size"] = size or 4
    return newBul
end

-- alternate basis for pBullet that sets x and y independently of the origin object
function objSystems.createFreeBullet(x, y, origin, type, decay, color, size)
    local newBul = {}
    local BID = self.getNewBID()
    pBullets[BID] = newBul
    newBul["type"] = type or "unknown"
    newBul["origin"] = origin
    newBul["x"] = x
    newBul["y"] = y
    newBul["decay"] = decay or 10000
    newBul["color"] = color or {1,1,1,1}
    newBul["size"] = size or 4
    return newBul
end

function objSystems.checkCollideBullet(obj,bul)
    local radius = 0
    -- use obj size if it doesn't have a hitbox specified
    if obj.hitbox == nil then radius = obj.size else radius = obj.hitbox end
	
    if math.dist(obj.x,obj.y,bul.x,bul.y) <= (obj.hitbox+bul.size) then return true else return false end
end

return objSystems