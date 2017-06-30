// pull in desired CSS/SASS files
// require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var app = Elm.Main.embed( document.getElementById( 'main' ) );

app.ports.fileSelected.subscribe(function (id) {

  var node = document.getElementById(id);
  if (node === null) {
    return;
  }

  var file = node.files[0];
  var reader = new FileReader();

  // FileReader API is event based. Once a file is selected
  // it fires events. We hook into the `onload` event for our reader.
  reader.onload = (function(event) {
    var fileString = event.target.result;

    var portData = {
      contents: fileString,
      filename: file.name
    };

    app.ports.fileContentRead.send(portData);
  });

  // Connect our FileReader with the file that was selected in our `input` node.
  reader.readAsText(file);
});
