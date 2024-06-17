<cfscript>
dump(form)
include '/Inc/header.cfm'
if (IsDefined('form.songimg')) {
	new dbo.proc().exec('song.update_img',[form.songid,form.songimg])
}
song = new dbo.proc().exec('song.no_img')
</cfscript>

<cfoutput query="song">
<div class="card">
	<div class="card-header alert-primary">
		#songname#
	</div>
	<div class="card-body">
		<table>
			<thead>
				<tr>
					<th width="120px" class="text-center">Album Cover</th>
					<th></th>
					<th class="text-end"></th>
				</tr>
			</thead>
			<tbody id="mybody">
			</tbody>
		</table>
	</div>
	<div class="card-footer">
	</div>
</table>
<input hidden id="songid" value="#songid#">
<cfinclude template="/Inc/footer.cfm">
</cfoutput>
