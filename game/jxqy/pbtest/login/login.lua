module('Login', package.seeall)


function login(player)
    Pbtest.send(player, 'login.ENTER', {uid = player.uid, params = '3333'})
    local reply = Pbtest.recv(player, 'login.ENTER')
end
