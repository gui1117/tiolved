tiolved.lua
===========

A framework to use [tiled](http://www.mapeditor.org/) in [LÖVE](http://love2d.org).

mapTable
-------- 

You can create a table that contain all the element in a .tmx file by using `map`:

	maptable=tiolved:map("map.tmx")

the table is generated as below :
* `<element attribute1="value1" attribute2="value2"/>` create :
 `{je="element", attribute1="value1", attribute2="value2"}`
* `<element1 attr1="value1">
	<element1.1 attr1="value1"/>
	<element1.2 attr1="value1"/>
   </element>`
   create :
   `{je="element", attr1="value1",
   		1={je="element1.1", attr1="value1"}
		2={je="element1.2", attr1="value1"}
   }`
* `<?xml version="1.0" encoding="UTF-8"?>` create nothing

mapGid
------

You can create a table that contain all the tile in canvas with the mapTable using :

	mapGid=tiolved:gid(mapTable)

mapGid[1]=tile1
...
mapGid[lastTile]=lastTile

layers
------

You can  generate table that contain for each layer a table with the canvas of the layer and the attributes of the layer using :

	layers=tiolved:layers(mapTable,mapGid)

layers[i]={ attr1=value1, property1=valueproperty1, canvas=canvas }

trick: the layer that must be interpreted and not drawn must be removed from the mapTable or you can change the .je=layer for something else

usefulfunc
----------

Use :

	toMap,toRender=tiolved:usefulfunc(map)

useful especially for isometric map, see in the exemple.

exemple
-------

the main love.load contain the basic way to use tiolved

issue
-----

for any inform me at my [github](https://github.com/thiolliere/tiolved)
