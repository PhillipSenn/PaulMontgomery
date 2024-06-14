<cfscript>
param url.id = '';
request.ico = 'png/icons8-rock-music-96.png' //icons8.com
request.title = 'Paul Montgomery Music'
include '/Inc/header.cfm'
remoteAddrname = Left(cgi.REMOTE_ADDR,30)
request.usr = new dbo.proc().exec('remoteAddr.where_remoteAddrname',remoteAddrname)
if (IsDefined('url.songid')) {
	song = Val(url.songid)
	if (song) {
		new dbo.proc().usr('request.merge_song',song)
	}
}
song = new dbo.proc().usr('song.list')
</cfscript>

<cfoutput>
<div class="card">
	<div class="card-header alert-primary">
	</div>
	<div class="card-body">
		<table>
			<thead class="table-light">
				<tr>
					<th></th>
					<th class="text-end">Requests</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="song">
					<tr id="row#currentRow#"<cfif usrcount> class="table-primary table-active"</cfif>>
						<td>
							<cfif Len(songimg)>
								<cfif url.id eq "11ED3BEC8867">
									<a href="admin.cfm?id=#url.id#&songid=#songid###row#currentRow-1#">
										<img src="#songimg#" width="50px">
									</a>
								<cfelse>
									<a href="index.cfm?songid=#songid###row#currentRow-1#">
										<img src="#songimg#" width="50px">
									</a>
								</cfif>
							</cfif>
						</td>
						<td class="text-end">
							#requestcount#
						</td>
						<td>
							<a href="index.cfm?songid=#songid###row#currentRow-1#">#songname#</a>
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
	<div class="card-footer">
	</div>
</div>
<cfinclude template="/Inc/footer.cfm">
</cfoutput>
