local sX, sY	= guiGetScreenSize()
local x, y		= sX/1366,sY/768
local fontsize	= sX/1920

local lp = {
			hasAccount		= true,
			blur			= {
							shader 			= dxCreateShader("img/blur.fx"),
							screensource	= dxCreateScreenSource(sX,sY),
							--update			= true,
			},
			
			login			= {
							showpass		= false,
							savepass		= false,
			},
			
			register 		= {
							
			},
			
			forgotpass		= {
			
			},

}

function init()
	triggerServerEvent("server:init",localPlayer)
end

function showLogin(username,password)
	showChat(false)
	setPlayerHudComponentVisible("all",false)
	showCursor(true)
	
	lp.gridlist = guiCreateGridList((sX/2 - (400*x)/2) + (430*x) + (12*x),sY/2 - (250*y)/2 + 12*y,226*x,226*y,false)
	guiGridListAddColumn(lp.gridlist,"Имя",0.5)
	guiGridListAddColumn(lp.gridlist,"Ранг",0.4)
	
	lp.login.button = dxCreateButton(sX/2 - (150*x)/2,( sY/2 - (410*y)/2 ) + (260*y),150*x,30*y,"Войти",tocolor(0,0,0,255))
	lp.login.username = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + 105*y,270*x,30*y,1.5*fontsize,"Введите логин")
	--dxSetEditEnabled(lp.login.username,false)
	if username and #username > 0 then
		dxSetEditText(lp.login.username,username)
	else
		lp.hasAccount = false
	end
	lp.login.password = dxCreateEdit(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,270*x,30*y,1.5*fontsize,"Пароль")
	dxSetEditMask(lp.login.password,true)
	if password and #password > 0 then
		dxSetEditText(lp.login.password,password)
		lp.login.savepass = true
	end
	
	lp.register.button = dxCreateButton((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (100*x)/2,( sY/2 - (250*y)/2 ) + (200*y),100*x,30*y,"Готово",tocolor(0,0,0,255))
	lp.register.username = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (60*y),170*x,30*y,1.5*fontsize,"Введите логин")
	lp.register.password = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (100*y),170*x,30*y,1.5*fontsize,"Пвроль")
	dxSetEditMask(lp.register.password,true)
	lp.register.repassword = dxCreateEdit((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (140*y),170*x,30*y,1.5*fontsize,"Повторите пароль")
	dxSetEditMask(lp.register.repassword,true)
	
	lp.forgotpass.fpass = dxCreateButton(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,"Забыли пароль?",tocolor(41,130,206,255),1*fontsize)
	lp.forgotpass.pass = dxCreateEdit((sX/2 - (230*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 20*y,230*x,30*y,1.5*fontsize,"Новый пароль")
	lp.forgotpass.button = dxCreateButton((sX/2 - (100*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 70*y,100*x,20*y,"Сбросить пароль",tocolor(0,0,0,255),1*fontsize)
	
	setTime(0,0)
	
	addEventHandler("onClientRender",root,blurRender)
	addEventHandler("onClientRender",root,drawLogin)
	addEventHandler("onClientRender",root,drawRegister)
	addEventHandler("onClientRender",root,drawAdmins)
	
	triggerServerEvent("server:getOnlineAdmins",localPlayer)
end

addEvent("client:init:callBack",true)
addEventHandler("client:init:callBack",root,
function(username,password)
	showLogin(username,password)
end
)

addEvent("client:loggedIn",true)
addEventHandler("client:loggedIn",root,
function(username)
	if username then
		removeEventHandler("onClientRender",root,blurRender)
		removeEventHandler("onClientRender",root,drawLogin)
		removeEventHandler("onClientRender",root,drawRegister)
		removeEventHandler("onClientRender",root,drawAdmins)
		removeEventHandler("onClientRender",root,drawForgot)
		destroyElement(lp.blur.screensource)
		destroyElement(lp.blur.shader)
		destroyElement(lp.gridlist)
		showCursor(false)
		showChat(true)
	else
		dxSetButtonEnabled(lp.login.button,true)
	end
end
)

addEvent("client:Registered",true)
addEventHandler("client:Registered",root,
function(username)
	if username then
		dxSetEditText(lp.login.username,username)
		lp.hasAccount = true
	else
		dxSetButtonEnabled(lp.register.button,true)
	end
end
)

addEvent("client:forgotpass:callBack",true)
addEventHandler("client:forgotpass:callBack",root,
function(username)
	addEventHandler("onClientRender",root,drawForgot)
end
)

addEvent("client:getOnlineAdmins:callBack",true)
addEventHandler("client:getOnlineAdmins:callBack",root,
function(admins)
	outputChatBox(#admins)
	for k,v in ipairs(admins) do
		local row = guiGridListAddRow(lp.gridlist)
		guiGridListSetItemText(lp.gridlist,row,1,v.name,false,false)
		guiGridListSetItemColor(lp.gridlist,row,1,0,255,0)
		guiGridListSetItemText(lp.gridlist,row,2,v.rank,false,false)
		guiGridListSetItemColor(lp.gridlist,row,2,0,255,0)
	end
end
)

addEvent("onClientdxButtonClick",true)
addEventHandler("onClientdxButtonClick",root,
function(plr)
	if plr == localPlayer then
		if source == lp.login.button then
			local username = dxGetEditText(lp.login.username)
			local password = dxGetEditText(lp.login.password)
			if #username > 0 and #password > 0 then
				triggerServerEvent("server:login",plr,username,password,lp.login.savepass)
				dxSetButtonEnabled(lp.login.button,false)
			else
				exports["guimessages"]:outputServer("* Enter name and password!", 255, 128, 0)
			end
		elseif source == lp.register.button then
			local username = dxGetEditText(lp.register.username)
			local password = dxGetEditText(lp.register.password)
			local repassword = dxGetEditText(lp.register.repassword)
			if #username > 0 and #password > 0 then
				if password == repassword then
					triggerServerEvent("server:register",plr,username,password)
					dxSetButtonEnabled(lp.register.button,false)
				end
			else
				exports["guimessages"]:outputServer("* Enter name and password!", 255, 128, 0)
			end
		elseif source == lp.forgotpass.fpass then
			triggerServerEvent("server:forgotpass",plr)
		elseif source == lp.forgotpass.button then
			local username = dxGetEditText(lp.login.username)
			if #username > 0 then
				local password = dxGetEditText(lp.forgotpass.pass)
				if #password > 0 then
					triggerServerEvent("server:changePassword",plr,username,password,lp.login.savepass)
					removeEventHandler("onClientRender",root,drawForgot)
				else
					exports["guimessages"]:outputServer( "* Введите новый пароль!", 255, 128, 0)
				end
			else
				exports["guimessages"]:outputServer( "* Введите имя пользователя!", 255, 128, 0)
			end
		end
	end
end
)

addEventHandler("onClientClick",root,
function(bttn,state)
	if bttn == "left" and state == "down" then
		if isMouseInPosition(sX/2 - (62*x)/2,( sY/2 - (410*y)/2 ) + (190*y),62*x,26*y) then
			lp.login.showpass = not lp.login.showpass
			dxSetEditMask(lp.login.password, not lp.login.showpass)
		elseif isMouseInPosition(sX/2 - (62*x)/2,( sY/2 - (410*y)/2 ) + (190*y) + 31*y,62*x,26*y) then
			lp.login.savepass = not lp.login.savepass
		end	
	end
end
)

function blurRender ()
    if ( lp.blur.shader ) then
		--if lp.blur.update then
			dxUpdateScreenSource(lp.blur.screensource)
			
			dxSetShaderValue(lp.blur.shader, "ScreenSource", lp.blur.screensource);
			dxSetShaderValue(lp.blur.shader, "UVSize", sX, sY);
			dxSetShaderValue(lp.blur.shader, "BlurStrength", 9 );
			
			--lp.blur.update = false
		--end
					
        dxDrawImage(0, 0, sX, sY, lp.blur.shader)
    end
end

function drawLogin()
	dxDrawText2("Добро Пожаловать!",sX/2 - (400*x)/2,0,400*x,160*y,tocolor(255,255,255,255),5*fontsize,"arial","center","bottom")
	dxDrawRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle(sX/2 - (400*x)/2,sY/2 - (410*y)/2,400*x,410*y,tocolor(0,0,0,100),8*x)
	
	--dxDrawRectangle(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + 105*y,270*x,30*y,tocolor(231,231,239,255))
	dxDrawEdit(lp.login.username)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + 105*y,30*y,30*y,"img/username.png")
	
	--dxDrawRectangle(sX/2 - (270*x)/2,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,270*x,30*y,tocolor(231,231,239,255))
	dxDrawEdit(lp.login.password)
	dxDrawImage(sX/2 - (270*x)/2 - 35*y,( sY/2 - (410*y)/2 ) + (105*y) + (30*y) + 7*y,30*y,30*y,"img/password.png")
	
	dxDrawText2("Показать пароль",sX/2 - (62*x)/2 - 105*x,( sY/2 - (410*y)/2 ) + (190*y),62*x,26*y,tocolor(255,255,255,255),1.5*fontsize,"arial","left","center")
	dxDrawImage(sX/2 - (62*x)/2,( sY/2 - (410*y)/2 ) + (190*y),62*x,26*y,lp.login.showpass and "img/on.png" or "img/off.png")
	
	dxDrawText2("Запомнить пароль",sX/2 - (62*x)/2 - 105*x,( sY/2 - (410*y)/2 ) + (190*y) + 31*y,62*x,26*y,tocolor(255,255,255,255),1.5*fontsize,"arial","left","center")
	dxDrawImage(sX/2 - (62*x)/2,( sY/2 - (410*y)/2 ) + (190*y) + 31*y,62*x,26*y,lp.login.savepass and "img/on.png" or "img/off.png")
	
	--dxDrawRectangle(sX/2 - (150*x)/2,( sY/2 - (410*y)/2 ) + (260*y),150*x,30*y,tocolor(0,0,0,255))
	--dxDrawText2("Login",sX/2 - (150*x)/2,( sY/2 - (410*y)/2 ) + (260*y),150*x,30*y,tocolor(255,255,255,255),2,"default-bold","center","center")
	dxDrawButton(lp.login.button)
	
	--dxDrawRectangle(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,tocolor(41,130,206,255))
	--dxDrawText2("Forgot your password?",sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,tocolor(255,255,255,255),1,"default-bold","center","center")
	dxDrawButton(lp.forgotpass.fpass)
	dxDrawEmptyRectangle(sX/2 - (200*x)/2,( sY/2 - (410*y)/2 ) + (330*y),200*x,20*y,tocolor(0,0,0,255),1)
end

function drawRegister()
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 25*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 125*y,22*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) - 30*x,sY/2 - (250*y)/2 + 225*y,22*x,2,tocolor(0,0,0,150))
	dxDrawText2("Панель Регистрации",(sX/2 - (400*x)/2) - 280*x,0,250*x,250*y,tocolor(255,255,255,255),3*fontsize,"arial","center","bottom")
	dxDrawRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(0,0,0,100),1)
	
	if not lp.hasAccount then
		--dxDrawRectangle((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (60*y),170*x,30*y,tocolor(231,231,239,255))
		dxDrawEdit(lp.register.username)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (60*y),30*y,30*y,"img/username.png")
		
		--dxDrawRectangle((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (100*y),170*x,30*y,tocolor(231,231,239,255))
		dxDrawEdit(lp.register.password)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (100*y),30*y,30*y,"img/password.png")
		
		--dxDrawRectangle((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2,( sY/2 - (250*y)/2 ) + (140*y),170*x,30*y,tocolor(231,231,239,255))
		dxDrawEdit(lp.register.repassword)
		dxDrawImage(((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (170*x)/2) - 35*y,( sY/2 - (250*y)/2 ) + (140*y),30*y,30*y,"img/password.png")
		
		--dxDrawRectangle((sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (100*x)/2,( sY/2 - (250*y)/2 ) + (200*y),100*x,30*y,tocolor(0,0,0,255))
		--dxDrawText2("Register",(sX/2 - (400*x)/2 - 280*x) + (250*x)/2 - (100*x)/2,( sY/2 - (250*y)/2 ) + (200*y),100*x,30*y,tocolor(255,255,255,255),2,"default-bold","center","center")
		dxDrawButton(lp.register.button)
	else
		dxDrawText2("Вы не можете зарегистрировать более одной учетной записи",(sX/2 - (400*x)/2) - 280*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,0,0,255),1.3*fontsize,"default-bold","center","center")
	end
end

function drawAdmins()
	dxDrawRectangle((sX/2 - (400*x)/2) + 405*x,sY/2 - (250*y)/2 + 25*y,25*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) + 405*x,sY/2 - (250*y)/2 + 125*y,25*x,2,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (400*x)/2) + 405*x,sY/2 - (250*y)/2 + 225*y,25*x,2,tocolor(0,0,0,150))
	dxDrawText2("Админы Онлайн",(sX/2 - (400*x)/2) + 430*x,0,250*x,250*y,tocolor(255,255,255,255),3*fontsize,"arial","center","bottom")
	dxDrawRectangle((sX/2 - (400*x)/2) + 430*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (400*x)/2) + 430*x,sY/2 - (250*y)/2,250*x,250*y,tocolor(0,0,0,100),1)
	
	dxDrawRectangle((sX/2 - (400*x)/2) + (430*x) + (10*x),sY/2 - (250*y)/2 + 10*y,230*x,230*y,tocolor(57,52,57,255))
end

function drawForgot()
	dxDrawRectangle((sX/2 - (400*x)/2) + 200*x,sY/2 + (410*y)/2 + 8*x,2,22*x,tocolor(0,0,0,150))
	dxDrawRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(255,255,255,20))
	dxDrawEmptyRectangle((sX/2 - (250*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x,250*x,100*y,tocolor(0,0,0,100),1)
	
	--dxDrawRectangle((sX/2 - (230*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 20*y,230*x,30*y)
	dxDrawEdit(lp.forgotpass.pass)
	
	--dxDrawRectangle((sX/2 - (100*x)/2),sY/2 + (410*y)/2  + 8*x + 22*x + 70*y,100*x,20*y)
	dxDrawButton(lp.forgotpass.button)
end

addEventHandler("onClientResourceStart",resourceRoot,
function()
	init()
end
)