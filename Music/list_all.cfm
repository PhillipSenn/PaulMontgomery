<cfscript>
include '/Inc/header.cfm'
if (IsDefined('form.songimg')) {
	new dbo.proc().exec('song.update_img',[form.songid,form.songimg])
} else if (IsDefined('form.songname')) {
	new dbo.proc().exec('song.update_name',[form.songid,form.songname])
}
song = new dbo.proc().exec('song.list_all')
</cfscript>

<cfoutput>
<form class="card">
	<div class="card-header alert-primary">
		<div class="row">
			<div class="col-10">
				<input name="newSong" autofocus>
			</div>
			<div class="col-2 text-end">
				<button class="btn-primary">New Song</button>
			</div>
		</div>
	</div>
	<div class="card-body">
		<table>
			<thead class="table-light">
				<tr>
					<th></th>
					<th class="text-end">
						Total<br>
						Requests
					</th>
					<th colspan="2">Song</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="song">
					<form>
						<tr id="row#currentRow#" data-songid="#songid#">
							<td>
								<cfif Len(songimg)>
									<a class="activate_modal1" href="JavaScript:" data-bs-toggle="modal" data-bs-target=".modal1">
										<img src="#songimg#" width="50px">
									</a>
								<cfelse>
									<a href="JavaScript:" data-bs-toggle="modal" data-bs-target=".modal1">
										Image
									</a>
								</cfif>
							</td>
							<td class="text-end">
								#requestcount#
							</td>
							<td>
								<input name="songname" value="#songname#">
							</td>
							<td class="text-end">
								<button class="btn-outline-primary">Save</button>
								<input hidden name="songid" value="#songid#">
							</td>
						</tr>
					</form>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th>
						<a href="JavaScript:">Image</a>
					</th>
					<th></th>
					<th>
						<input name="songname">
					</th>
				</tr>
			</tfoot>
		</table>
	</div>
	<input hidden name="songid">
</form>

<!-- Modal -->
<form id="myModal" class="modal1 modal fade" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="exampleModalLabel">Picture</h1>
			</div>
			<div class="modal-body">
				<textarea name="songimg" id="songimg"></textarea>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary">Save</button>
			</div>
		</div>
	</div>
</form>
<script src="/Inc/js/autosize.js"></script>
<cfinclude template="/Inc/footer.cfm">
</cfoutput>
