

bot=getBot()
scanblock=0 
scanseed=0 
pack_total=0
kerikil=0

pnbzx = pnbx-1
pnbzy = pnby-1

function webhook(text)
if webhooq then
    RequestINFO={}
    RequestINFO.json = true
    RequestINFO.url=webhookurl
    RequestINFO.method=POST
    RequestINFO.postData = 
    [[
        {
            "content" : "**Bot Information** > ]]..text..[[",
          "embeds": [
            {   
                "title": "Pnb By degssss",
				"description": "<:growbot:992058196439072770>  Bot Name : ]]..bot:getLocal().name..[[\n<:monitorgt:986523288383680512> Bot status : Online\n\n<:wl:1096292560047190066> Current World : ]]..bot:getCurrentWorld():upper()..[[\n<:peppertree:999318156696887378> Block Left : ]]..scanblock..[[\n<:pepper_tree_seed:1012630107715797073> Seed Scan : ]]..scanseed..[[\n<:gems:994218103032520724> Total Buy Pack : ]]..pack_total..[[",
                "color": "]] .. math.random(0, 16777215) .. [[",
              "footer": {
                "text": "Time Up | ]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[[",
                "icon_url": "https://cdn.discordapp.com/emojis/978628955907170314.gif?size=96&quality=lossless",
                "thumbnail": {
                "url": "https://cdn.discordapp.com/attachments/1118664844145594530/1126848269365035150/earth.gif"
                }
              }
            }
          ]
        }
    ]]
    x = httpReq(RequestINFO)
    if x.success then
        --log("Response Body : ",x.body)
        --og("Response Http Status Code : ",x.httpCode)
    else
        --_log("Request Failed Error Msg : ",x.failInfo)
    end
end
end

function onlinehook(text)
if webhooq then
    RequestINFO={}
    RequestINFO.json = true
    RequestINFO.url=webhookurl
    RequestINFO.method=POST
    RequestINFO.postData = 
    [[
        {
            "content" : "**Bot Information** > ]]..text..[[",
          "embeds": [
            {   
                "title": "Pnb By degssss",
				"description": "<:growbot:992058196439072770> Bot Name : ]]..bot:getLocal().name..[[\n<:monitorgt:986523288383680512> Bot Status : Offline",
                           "color": "]] .. math.random(0, 16777215) .. [[",
              "footer": {
                "text": "Time Up | ]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[[",
                "icon_url": "https://cdn.discordapp.com/emojis/978628955907170314.gif?size=96&quality=lossless",
                "thumbnail": {
                "url": "https://cdn.discordapp.com/attachments/1118664844145594530/1126848269365035150/earth.gif"
                }
              }
            }
          ]
        }
    ]]
    x = httpReq(RequestINFO)
    if x.success then
        --log("Response Body : ",x.body)
        --log("Response Http Status Code : ",x.httpCode)
    else
        --log("Request Failed Error Msg : ",x.failInfo)
    end
end
end

function warps(B,P)
    while bot:getCurrentWorld():upper()~=B:upper() or bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
        sleep(500)
        bot:sendPacket("action|join_request\nname|"..B.."|"..P.."\ninvitedWorld|0",3)       
        sleep(5000)
    end
end

function recon1()
    local zposx=math.floor(bot:getLocal().pos.x/32)
    local zposy=math.floor(bot:getLocal().pos.y/32)
    if bot:getEnetStatus()~=Connected then
        onlinehook("Disconnect Try To connect")
        while bot:getEnetStatus()~=Connected do
            bot:reConnect()
            sleep(30000)
                if bot:getEnetStatus()==Connected then
                goto K
                end
        end
        ::K::
        if bot:getEnetStatus()==Connected then
            webhook("Bot Reconnected")
        end
    end
    if bot:getEnetStatus()==Connected and bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 then
        while bot:getTile(math.floor(bot:getLocal().pos.x/32),math.floor(bot:getLocal().pos.y/32)).fg==6 do
            if bot:getCurrentWorld():upper()==droppack:upper() then
                warps(droppack,droppackid)
                sleep(1000)
                
            elseif bot:getCurrentWorld():upper()==droppack:upper() then
                warps(pnbworld,pnbid)
                sleep(1000)
       
            elseif bot:getCurrentWorld():upper()==storage:upper() then
                warps(storage,storageid)
                sleep(1000)
        
            elseif bot:getCurrentWorld():upper()==dropseed:upper() then
                warps(dropseed,dropseedid)
                sleep(1000)
            end
        end
        repeat
            bot:findPath(zposx,zposy)
            sleep(1000)
        until math.floor(bot:getLocal().pos.x/32)==zposx or math.floor(bot:getLocal().pos.y/32)==zposy
    end
end

function take()
    for _,object in pairs(bot:getObjects()) do
        if object.id == idblock then
            local posX = math.floor(object.pos.x / 32)
            local posY = math.floor(object.pos.y / 32)
            bot:autoCollect(3,true)
            sleep(200)
            bot:findPath(posX, posY)
            sleep(2000)
            if bot:getItemCount(idblock) > 0 then
                bot:autoCollect(3,false)
                break
            end
            sleep(50)
        end
    end
end

function buypack()
    sleep(1000)
    local iter=0
    bot:autoCollect(3,false)
    if bot:getCurrentWorld():upper()~=droppack:upper() then
        warps(droppack,droppackid)
        sleep(4500)
        recon1()
    end
    if bot:getCurrentWorld():upper()==droppack:upper() then
        --scanp()
        if bot:inWorld() then
            bot:autoCollect(3,false)
            sleep(1000)
            recon1()
            sleep(1000)
            while bot:getLocal().gems>pricepack do
                sleep(500)
                for B=1,packlimit do
                    if bot:getItemCount(packid[1])~=200 then
                        bot:sendPacket("action|buy\nitem|"..packname,2)
                        sleep(4000)
                        recon1()
                        pack_total = pack_total+1
                    end
                end
                if bot:getItemCount(packid[1])==200 then
                    break
                end
                recon1()
                if bot:getLocal().gems<pricepack then
                    sleep(100)
                    break
                end
                iter=iter+1
                if iter>=3 then iter=0 break end
            end
            for E,V in pairs(bot:getTiles()) do
                if V.fg==iddroppack or V.bg==iddroppack then
                    bot:findPath(V.x,V.y)
                    sleep(1000)
                    for B,E in pairs(packid) do
                        while bot:getItemCount(E)>0 do
                            sleep(1500)
							bot:move(RIGHT,1)
							sleep(1000)
                            droppp(E)
                            sleep(2000)
                            recon1()
                        end
                    end
                end
            end
            sleep(1000)
            recon1()
        end
    end
end

function droppp(B)
local counts=bot:getItemCount(B)
    sleep(1500)
    if bot:inWorld() then
        bot:sendPacket("action|drop\n|itemID|"..B,2)
    	sleep(1500)
        bot:sendPacket("action|dialog_return\ndialog_name|drop_item\nitemID|"..B.."|\ncount|"..counts,2)
        sleep(2000)
    end
end

function dropbijilu(B)
    if bot:getCurrentWorld():upper()~=dropseed:upper() then
        warps(dropseed,dropseedid)
        sleep(4500)
        recon1()
    end
    bot:autoCollect(3,false)
    if bot:inWorld() and bot:getCurrentWorld():upper()==dropseed:upper() then
        recon1()
        for V,c in pairs(bot:getTiles()) do
            if c.fg==iddropseed or c.bg==iddropseed then
                bot:findPath(c.x,c.y)
                sleep(500)
                while bot:getItemCount(B)>0 do
                    sleep(1500)
					bot:move(RIGHT,1)
					sleep(1000)
                    droppp(B)
                    sleep(2000)
                    recon1()
                    if bot:getItemCount(B)==0 then goto C end
                end
            end
        end
        ::C::
        sleep(1000)
    end
end

function trashkontol(B)
    sleep(500)
    bot:sendPacket("action|trash\n|itemID|"..B,2)
    sleep(1000)
    bot:sendPacket("action|dialog_return\ndialog_name|trash_item\nitemID|"..B.."|\ncount|"..bot:getItemCount(B),2)
    sleep(1000)
end


function Scanb()
scanblock = 0
    for _, object in pairs(bot:getObjects()) do
        if object.id == idblock then
            scanblock = scanblock + object.count
        end
    end
    return scanblock
end

function Scans()
scanseed = 0
    for _, object in pairs(bot:getObjects()) do
        if object.id == idseed then
            scanseed = scanseed + object.count
        end
    end
    return scanseed
end

function mf(xy)
    return math.floor(xy / 32)
end
function punch(x,y)
    bot:hitTile(mf(bot:getLocal().pos.x) + x,mf(bot:getLocal().pos.y) + y)
end
function place(id,x,y)
    bot:placeTile(mf(bot:getLocal().pos.x) + x,mf(bot:getLocal().pos.y) + y,id)
end

function pnb2()
    if usegaut then
        bot:autoCollect(3,false)
    else
        bot:autoCollect(3,true)
    end
    if not bot:isInside(pnbzx,pnbzy, 0) then 
    repeat
        bot:findPath(pnbzx,pnbzy)
        sleep(2000)
    until math.floor(bot:getLocal().pos.x/32)==pnbzx and math.floor(bot:getLocal().pos.y/32)==pnbzy
    end
    posx=math.floor(bot:getLocal().pos.x/32)
    posy=math.floor(bot:getLocal().pos.y/32)
    while bot:getItemCount(idblock) == 1 do
            if bot:getItemCount(idseed)>150 then goto A end
            if bot:getTile(posx-1,posy-1).bg==0 or bot:getTile(posx-1,posy-1).fg==0 then
                recon1()
                place(idblock,-1,-1)
                sleep(delayput)
            end
            while bot:getTile(posx-1,posy-1).bg~=0 or bot:getTile(posx-1,posy-1).fg~=0 do
                recon1()
                punch(-1,-1)
                sleep(delaypun)
            end
    end
        ::A::
    sleep(500)
    recon1()
    for d,T in pairs(trashitem) do
        if bot:getItemCount(T)>5 then
            trashkontol(T)
            sleep(500)
        end
    end
end
    

function pnb()
    if usegaut then
        bot:autoCollect(3,false)
    else
        bot:autoCollect(3,true)
    end
    if not bot:isInside(pnbzx,pnbzy, 0) then 
    repeat
        bot:findPath(pnbzx,pnbzy)
        sleep(2000)
    until math.floor(bot:getLocal().pos.x/32)==pnbzx and math.floor(bot:getLocal().pos.y/32)==pnbzy
    end
    posx=math.floor(bot:getLocal().pos.x/32)
    posy=math.floor(bot:getLocal().pos.y/32)
    if custom_tile == 1 then
        while bot:getItemCount(idblock) > 1 do
            if bot:getItemCount(idseed)>150 then goto A end
            if bot:getTile(posx,posy-1).bg==0 or bot:getTile(posx,posy-1).fg==0 then
                recon1()
                place(idblock,0,-1)
                sleep(delayput)
            end
            while bot:getTile(posx,posy-1).bg~=0 or bot:getTile(posx,posy-1).fg~=0 do
                recon1()
                punch(0,-1)
                sleep(delaypun)
            end
        end
    elseif custom_tile == 3 then
        while bot:getItemCount(idblock) > 1 do
            if bot:getItemCount(idseed)>150 then goto A end
            if bot:getTile(posx-1,posy-1).bg==0 or bot:getTile(posx-1,posy-1).fg==0 then
                recon1()
                place(idblock,-1,-1)
                sleep(delayput)
            end
            if bot:getTile(posx,posy-1).bg==0 or bot:getTile(posx,posy-1).fg==0 then
                recon1()
                place(idblock,0,-1)
                sleep(delayput)
            end
            if bot:getTile(posx+1,posy-1).bg==0 or bot:getTile(posx+1,posy-1).fg==0 then
                recon1()
                place(idblock,1,-1)
                sleep(delayput)
            end
            while bot:getTile(posx-1,posy-1).bg~=0 or bot:getTile(posx-1,posy-1).fg~=0 do
                recon1()
                punch(-1,-1)
                sleep(delaypun)
            end
            while bot:getTile(posx,posy-1).bg~=0 or bot:getTile(posx,posy-1).fg~=0 do
                recon1()
                punch(0,-1)
                sleep(delaypun)
            end
            while bot:getTile(posx+1,posy-1).bg~=0 or bot:getTile(posx+1,posy-1).fg~=0 do
                recon1()
                punch(1,-1)
                sleep(delaypun)
            end
        end
    end
    ::A::
    sleep(500)
    recon1()
    for d,T in pairs(trashitem) do
        if bot:getItemCount(T)>5 then
            trashkontol(T)
            sleep(500)
        end
    end
end


function retuts(countssss)
    Botx=math.floor(bot:getLocal().pos.x/32)
    Boty=math.floor(bot:getLocal().pos.y/32)
    sleep(200)
    bot:wrenchTile(Botx,Boty+1)
    sleep(1000)
    bot:sendPacket("action|dialog_return\ndialog_name|itemsucker_block\ntilex|"..Botx.."|\ntiley|".. Boty+1 .."|\nbuttonClicked|retrieveitem\nchk_enablesucking|1",2)
    sleep(2000)
    bot:sendPacket("action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..Botx.."|\ntiley|".. Boty+1 .."|\nitemtoremove|"..countssss,2)
    sleep(1000)
end

function retgaia(countsssss)
    Botx=math.floor(bot:getLocal().pos.x/32)
    Boty=math.floor(bot:getLocal().pos.y/32)
    sleep(200)
    bot:wrenchTile(Botx,Boty+1)
    sleep(1000)
    bot:sendPacket("action|dialog_return\ndialog_name|itemsucker_seed\ntilex|"..Botx.."|\ntiley|".. Boty+1 .."|\nbuttonClicked|retrieveitem\nchk_enablesucking|1",2)
    sleep(2000)
    bot:sendPacket("action|dialog_return\ndialog_name|itemremovedfromsucker\ntilex|"..Botx.."|\ntiley|".. Boty+1 .."|\nitemtoremove|"..countsssss,2)
    sleep(1000)
end

function retrigaut()
    kerikil = kerikil + 200
    recon1()
    if kerikil == 600 and usegaut then
        for _,gayabiken in pairs(bot:getTiles()) do
            if gayabiken.fg == 6946 or gayabiken.bg == 6946 then
                bot:findPath(gayabiken.x,gayabiken.y-1)
                sleep(2000)
                retgaia(amounds)
            end
        end
        sleep(500)
        for _,uteken in pairs(bot:getTiles()) do
            if uteken.fg == 6948 or uteken.bg == 6948 then
                bot:findPath(uteken.x,uteken.y-1)
                sleep(2000)
                retuts(amounds)
            end
        end
        sleep(500)
        kerikil=0
    end
end


function cek()
if bot:getItemCount(idseed) >= 150 then
    bot:autoCollect(3,false)
    warps(dropseed,dropseedid)
    sleep(200)
    dropbijilu(idseed)
    Scans()
    sleep(200)
    webhook("Drop Seed")
    warps(pnbworld,pnbid)
    sleep(500)
    pnb()
end
if bot:getLocal().gems>pricepack*packlimit then
    bot:autoCollect(3,false)
    sleep(1000)
    buypack()
    sleep(500)
    webhook("Buy Pack")
    warps(pnbworld,pnbid)
    sleep(500)
    pnb()
end
end

function startwoi()
    warps(storage,storageid)
    while scanblock > 1 do
        recon1()
        cek()
        if bot:getItemCount(idblock) == 0 then
            warps(storage,storageid)
            sleep(1000)
            bot:autoCollect(3,true)
            sleep(500)
            take()
            sleep(500)
            Scanb()
            webhook("Take Block")
            warps(pnbworld,pnbid)
            sleep(500)
            pnb()
        end
        if bot:getItemCount(idblock) > 1 then
            warps(pnbworld,pnbid)
            pnb()
        end
        if bot:getItemCount(idblock) == 1 then
            if usegaut then
                retrigaut()
            end
            pnb2()
        end
        cek()
    end
end
            
            

