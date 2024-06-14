drop table if exists song
go
create table dbo.song
(songid int identity primary key nonclustered
,songname varchar(255)
,songimg varchar(512)
)
go
insert into song(songname,songimg) values('Song A','https://ih1.redbubble.net/image.660135901.3507/fposter,small,wall_texture,product,750x1000.u3.jpg')
insert into song(songname,songimg) values('Song B','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxRBrxUTMz_MPzpDG95E7iUf4rQo8LFmjYyQ&s')
insert into song(songname,songimg) values('Song C','https://whsgoldenarrow.com/wp-content/uploads/2019/12/toddrungren.jpg')
go
drop table if exists remoteAddr
go
create table dbo.remoteAddr
(remoteAddrid int identity primary key nonclustered
,remoteAddrname varchar(30) -- 192.158.123.038 or 2001:0db8:85a3::8a2e:0370:7334
)
go
drop table if exists request
go
create table dbo.request
(requestid int identity primary key nonclustered
,request_song int
,requestDate smalldatetime default getutcdate()
,request_remoteAddr int
,requestcount int default 1
)
go
-- select newid() -- 11ED3BEC8867

--create schema song authorization dbo
--create schema request authorization dbo
--create schema remoteAddr authorization dbo
alter proc song.list
(@remoteAddrname varchar(30)
) as
select songid,songname,songimg
	,requestcount
	,isnull(usrcount,0) as usrcount
from song
left join(
	select request_song
		,sum(requestcount) as requestcount
	from request
	where DATEDIFF(hour,requestdate,getutcdate()) < 20
	group by request_song,cast(requestdate as date)
) request
on request_song = songid
left join(
	select request_song as usr_song
		,requestcount as usrcount
	from request
	join remoteAddr on request_remoteAddr=remoteAddrid
	where remoteAddrname=@remoteAddrname
	AND DATEDIFF(hour,requestdate,getutcdate()) < 20
) usr
on usr_song = songid
order by requestcount desc,songid
go
exec song.list '75.137.51.125' 

go
alter proc request.merge_song
(@remoteAddrname varchar(30)
,@songid int
) as
declare @remoteAddrid int=(select remoteAddrid from remoteAddr where remoteAddrname=@remoteAddrname)
if @remoteAddrid is null begin
	insert into remoteAddr(remoteAddrname) values(@remoteAddrname)
	select  @remoteAddrid=scope_identity()
end
declare @requestid int = (
	select requestid from request where request_remoteAddr=@remoteAddrid
	and request_song=@songid
	and datediff(hour,requestDate,getutcdate()) < 20
)
if @requestid is null begin
	insert into request(request_song,request_remoteAddr) values(@songid,@remoteAddrid)
end else begin
	update request set
	requestcount += 1
	where requestid = @requestid
end	 
go
exec request.merge_song '75.137.51.124',1
exec request.merge_song '75.137.51.125',1
go
alter proc remoteAddr.where_remoteAddrname
(@remoteAddrname varchar(30)
) as
declare @remoteAddrid int=(select remoteAddrid from remoteAddr where remoteAddrname=@remoteAddrname)
if @remoteAddrid is null begin
	insert into remoteAddr(remoteAddrname) values(@remoteAddrname)
	select @remoteAddrid = scope_identity()
end
select remoteAddrname as id
from remoteAddr
where remoteAddrid=@remoteAddrid
go
/*
select * from request
delete from request where requestid=6
*/
select * from remoteAddr
select * from song
