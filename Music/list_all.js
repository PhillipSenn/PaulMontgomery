const myModal = document.getElementById('myModal')
const songimg = document.getElementById('songimg')

myModal.addEventListener('shown.bs.modal', shown_bs_modal)
function shown_bs_modal() {
	songimg.focus()
	$(songimg).select()
}

$(document).on('click','.activate_modal1',activate_modal1)
function activate_modal1() {
	var songid = $(this).closest('tr').data('songid')
	var text = $(this).find('img').attr('src')
	$('[name=songimg]').val(text)	
	$('[name=songid]').val(songid)
}