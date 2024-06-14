// Create a new XMLHttpRequest object
var xhr = new XMLHttpRequest();

// Configure it: POST-request for the URL /submit-data
xhr.open('POST', '/submit-data', true);

// Set the request header to indicate the type of content being sent
xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');

// Define what happens on successful data submission
xhr.onload = function () {
  if (xhr.status >= 200 && xhr.status < 300) {
    // Parse the JSON response
    var response = JSON.parse(xhr.responseText);
    console.log('Success:', response);
  } else {
    console.error('Error:', xhr.statusText);
  }
};

// Define what happens in case of an error
xhr.onerror = function () {
  console.error('Request failed');
};

// Prepare the data to be sent as a JSON string
var data = JSON.stringify({ key1: 'value1', key2: 'value2' });

// Send the request with the data
xhr.send(data);
