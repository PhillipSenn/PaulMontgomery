<cfscript>
include '/Inc/header.cfm'
</cfscript>

<cfoutput>
<form class="card">
	<div class="card-header alert-primary">
	</div>
	<div class="card-body">
	</div>
	<div class="card-footer">
	</div>
	<input hidden name="id" value="#request.usr.id#" />
</form>
<cfinclude template="/Inc/footer.cfm">
</cfoutput>
