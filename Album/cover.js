dom.tbody = $('#mybody')
var songname = $.trim($('.card-header').text())
var songid = +$('#songid').val()
const searchUrl = 'https://itunes.apple.com/search?term=' + encodeURIComponent(songname) // + ' ' + artistName) + '&limit=1'

fetch(searchUrl)
	.then(handleResponse)
	.then(displayAlbumCover)
	.catch(handleError)

function handleResponse(response) {
	return response.json()
}

function displayAlbumCover(data) {
	if (data.results && data.results.length > 0) {
		data.results.forEach(each)
	} else {
		$('.card-header').text('Album cover not found.')
	}
}
function each(response) {
	console.log(response)
	var songimg = response.artworkUrl100
	var str = '<tr>'
		+ '<td><img src="' + songimg + '"></td>'
		+ '<td>'
		+ '<button class="btn btn-primary">This</button>'
		+ '<input hidden name="songimg" value="' + songimg + '">'
		+ '<input hidden name="songid" value="' + songid + '">'
		+ '</td>'
		+ '<td class="text-end">'
		+ songimg.length
		+ '</td>'
		+ '</tr>'
	dom.tbody.append(str)
}

function handleError(error) {
	$('.card-header').text('Error retrieving album cover.')
	console.error('Error:', error);
}
