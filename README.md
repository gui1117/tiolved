tiolved.lua
===========

A framework to use [tiled](http://www.mapeditor.org/) in [LÖVE](http://love2d.org).
Note that it doesn't use the lua export of tiled, stupid ? yes, I wasn't aware of it.

mapTable
-------- 

You can create a table that contain all the element in a .tmx file by using `map`:

	maptable=tiolved:map("map.tmx")

the table is generated as below :

* object :

		<element attribute1="value1" attribute2="value2"/> 

 create :

 		{je="element", attribute1="value1", attribute2="value2"}

*  object that contain objects :

		<element1 attr1="value1">
			<element1.1 attr1="value1"/>
			<element1.2 attr1="value1"/>
		</element>

   create :

		{je="element", attr1="value1",
			1={je="element1.1", attr1="value1"}
			2={je="element1.2", attr1="value1"}
		}

* the first line `<?xml version="1.0" encoding="UTF-8"?>` create nothing

mapGid
------

You can create a table that contain all the tile in canvas with the mapTable using :

	mapGid=tiolved:gid(mapTable)

mapGid[1]={canvas=tile1,animation(if any)={{tileid="20",duration="100"},{tileid="21",duration="100"}},properties[1].name=properties[1].value...}

...

mapGid[1]={canvas=lasttile,animation(if any)={{tileid="20",duration="100"},{tileid="21",duration="100"}},properties[1].name=properties[1].value...}

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
