drop table if exists song
go
create table dbo.song
(songid int identity primary key nonclustered
,songname varchar(255)
,songimg varchar(512)
)
go
insert into song(songname) values('Allentown')
insert into song(songname) values('American Girl')
insert into song(songname) values('Back In The USSR')
insert into song(songname) values('Bad Moon Rising')
insert into song(songname) values('Beer In Mexico')
insert into song(songname) values('Birthday (for occasions)')
insert into song(songname) values('Black Water')
insert into song(songname) values('Breakdown')
insert into song(songname) values('Brown Eyed Girl')
insert into song(songname) values('Can You Feel The Love Tonight')
insert into song(songname) values('Can’t You See')
insert into song(songname) values('Come Together')
insert into song(songname) values('Country Roads')
insert into song(songname) values('Don’t Fear The Reaper')
insert into song(songname) values('Drive')
insert into song(songname) values('Falling Slowly')
insert into song(songname) values('Fast Car')
insert into song(songname) values('Fire And Rain')
insert into song(songname) values('Fly Like An Eagle')
insert into song(songname) values('Free Fallin’')
insert into song(songname) values('Good To Be Home')
insert into song(songname) values('Greyhound (Original)')
insert into song(songname) values('Have You Ever Seen The Rain')
insert into song(songname) values('Here Comes The Sun')
insert into song(songname) values('Here Comes The Sun')
insert into song(songname) values('Here Is Gone')
insert into song(songname) values('Hey You')
insert into song(songname) values('Hit The Road Jack')
insert into song(songname) values('Hotel Cailfornia')
insert into song(songname) values('I Have To Say I Love You In A Song')
insert into song(songname) values('I need You')
insert into song(songname) values('I Saw Her Standing There')
insert into song(songname) values('I’m Still Standing')
insert into song(songname) values('I’ve Got A Name')
insert into song(songname) values('Iris')
insert into song(songname) values('Just The Way You Are')
insert into song(songname) values('Just What I Needed')
insert into song(songname) values('Lay Down Sally')
insert into song(songname) values('Learning To Fly')
insert into song(songname) values('Long Neck Bottle')
insert into song(songname) values('Long Train Runnin’')
insert into song(songname) values('Mary Jane’s Last Dance')
insert into song(songname) values('One Less Set Of Footsteps')
insert into song(songname) values('One Of These Nights')
insert into song(songname) values('Operator')
insert into song(songname) values('Ophelia')
insert into song(songname) values('Pretty Woman')
insert into song(songname) values('Pride And Joy')
insert into song(songname) values('Riding the Storm Out')
insert into song(songname) values('Roadhouse Blues')
insert into song(songname) values('Rock The Casbah')
insert into song(songname) values('Shake It Up')
insert into song(songname) values('She’s Everything')
insert into song(songname) values('Slide')
insert into song(songname) values('Small Town')
insert into song(songname) values('Smooth')
insert into song(songname) values('Space Oddity')
insert into song(songname) values('Still The One')
insert into song(songname) values('Stray Cat Strut')
insert into song(songname) values('Sweet Caroline')
insert into song(songname) values('Take It Easy')
insert into song(songname) values('Tell Her About It')
insert into song(songname) values('Tennessee Whiskey')
insert into song(songname) values('That Smell')
insert into song(songname) values('The House Is A Rockin’')
insert into song(songname) values('The Rising')
insert into song(songname) values('This Time I Will (Original)')
insert into song(songname) values('Wish Were You Here')
insert into song(songname) values('Won’t back Down')
insert into song(songname) values('Wonderful Tonight')
insert into song(songname) values('Wonderwall')
insert into song(songname) values('You Don’t Mess Around With Jim')
insert into song(songname) values('You Should Probably Leave')
go
drop table if exists usr
go
create table dbo.usr
(usrid int identity primary key nonclustered
,id varchar(32) -- sessionid
)
go
drop table if exists request
go
create table dbo.request
(requestid int identity primary key nonclustered
,request_song int
,requestDate smalldatetime default getutcdate()
,request_usr int
,requestcount int default 1
)
go
-- select newid() -- 11ED3BEC8867

--create schema song authorization dbo
--create schema request authorization dbo
--create schema usr authorization dbo
alter proc song.list
(@id varchar(32)
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
	join usr on request_usr=usrid
	where id=@id
	AND DATEDIFF(hour,requestdate,getutcdate()) < 20
) usr
on usr_song = songid
order by requestcount desc,songid
go
exec song.list '75.137.51.125' 
go
alter proc request.merge_song
(@id varchar(32)
,@songid int
) as
declare @usrid int=(select usrid from usr where id=@id)
if @usrid is null begin
	insert into usr(id) values(@id)
	select  @usrid=scope_identity()
end
declare @requestid int = (
	select requestid from request where request_usr=@usrid
	and request_song=@songid
	and datediff(hour,requestDate,getutcdate()) < 20
)
if @requestid is null begin
	insert into request(request_song,request_usr) values(@songid,@usrid)
end else begin
	update request set
	requestcount += 1
	where requestid = @requestid
end	 
go
alter proc usr.where_id
(@id varchar(30)
) as
declare @usrid int=(select usrid from usr where id=@id)
if @usrid is null begin
	insert into usr(id) values(@id)
	select @usrid = scope_identity()
end
select id as id
from usr
where usrid=@usrid
go
/*
select * from request
delete from request where requestid=6
*/
alter proc song.list_all as
select songid,songname,songimg
	,requestcount
from song
left join(
	select request_song
		,sum(requestcount) as requestcount
	from request
	group by request_song
) request
on request_song = songid
order by requestcount desc,songid
go
exec song.list_all
go
alter proc song.update_img
(@songid int
,@songimg varchar(512)
) as 
update song set
 songimg=@songimg
where songid=@songid
go
alter proc song.update_name
(@songid int
,@songname varchar(512)
) as 
update song set
 songname=@songname
where songid=@songid
go
alter proc song.no_img as
select top 1 songid,songname
from song
where songimg is null
go
exec song.no_img 

select * from usr
select * from song
