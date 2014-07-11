LeafletDesktop is a free, open-source equivalent to EarthDesk, Blue Planet, or OSXplanet.


It uses Leaflet, a popular JavaScript mapping tool. The app loads an HTML page in a hidden window, saves it as an image, and sets the desktop picture.

LeafletDesktop does not run all the time, so it will not automatically update! For that, you must use LaunchControl.

There is no dock icon, the only window is hidden, and the app quits automatically after setting your desktop.

No web server is required, not even to load the map tiles. The app works without Internet access.


### How do I make LeafletDesktop run automatically every minute? 
- LaunchControl is designed for this. It is free (nagware), and relatively easy to use.
- Download, install and open LaunchControl from http://www.soma-zone.com/LaunchControl/
- Click File > New
- Change the label (e.g. peter.leafletdesktop)
- Set the “Program to run” to /Applications/LeafletDesktop.app/Contents/Resources/leafletDesktop.sh
- Drag a StartInterval item from the right hand column, and set the number of seconds between each time the app is launched (60 for every minute).
- Save and exit. It will automatically load the LaunchAgent, and run LeafletDesktop.
- If LeafletDesktop is not located in /Applications, you must change the location in 2 places. Change the LaunchControl path, and edit the shell script using a text editor. It’s quite possible that spaces in the path might break it if they’re not delimited correctly using backslashes. Be careful.

### How do I change the overlays?

If you want to edit the HTML/JavaScript yourself, go ahead! It is fully commented, and hopefully easy to understand. Open the following file:

file:///Applications/LeafletDesktop.app/Contents/Resources/desktop.html


### How do I change the map?

The map is loaded from World3GMaps.js, which is a function to return a base64 encoded mbtiles file. You can use MOBAC (http://mobac.sourceforge.net) to download maps from many sources in MBTiles format. Don’t download too many zoom levels, because it’ll be slow, use a lot of RAM to load it every time, and possibly be infringing copyright. When you have the MBTiles file, run the following Terminal command:
base64 inputFile.mbtiles > outputFile.js
Add the wrapper headers and footers from the original World3GMaps.js file, change the HTML file to use your new mapName.js file, and you’re done!


### How do I change the Cocoa source code to load a different website/save an image but not set the desktop/etc?

For that, you’ll need the Cocoa source as an Xcode project. Download it here:
Source.zip
