component {
this.name = 'PaulMontgomery'
this.datasource = 'PaulMontgomery2'
this.sessionmanagement = true

function onRequestStart() {
	request.ico = 'png/icons8-rock-music-96.png' //icons8.com
	request.title = 'Paul Montgomery Music'
	session.usr = new dbo.proc().exec('usr.where_id',session.sessionid)
	request.usr = Duplicate(session.usr)
}

function onSessionStart() {
	session.usr = new dbo.proc().exec('usr.where_id',session.sessionid)
}

}
