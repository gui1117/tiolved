Tiölved.lua
===========

[[ I no longer use it, may not works.
See [STI](https://github.com/karai17/Simple-Tiled-Implementation) that seem to achieve the 
same goal. ]]

A library to use [Tiled](http://www.mapeditor.org/) in [LÖVE](http://love2d.org).

A basic use is described in the main.lua

It provide 3 objects and 2 functions :

mapGid
------

You can create a table that contain for each tile :

* identifier ( absolute like noted in layers )
* canvas
* properties
* animation : array of {tileid,duration}

I use it locally to gather information

``` mapGid=tiolved:gid(mapTable,repertory-of-tileset-images) ```

exemple :

		mapGid[i]={
			id=i,
			canvas=tile i
			animation(if any)={
				{tileid=k,duration=100},
				{tileid=l,duration=100}},
			first-property=it's-value
			...
			last-propery=it's-value
			}

tileset
-------

You can create a tileset a table that contain each tile :

		tileset[1]=canvas-of-first-tile
		tileset[n]=canvas-of-last-tile

and three methods

		tileset:update(dt) : change the canvas of animated tiles
		tileset:add( z, id, x, y, r, sx, sy, ox, oy, kx, ky ) : add the tile id to draw at z
		tileset:draw() draw tiles and clean the batch

to understand better here is the structure of tileset :

A complex table :

		{
	 		animated={
		 		nexttime
		 		current
		 		1={canvas,duration}
		 		2={canvas,duration}
		 	}
		 	batch={}
		 	batch[12]={}
		 	batch[12][16]=spritebatch <-- the tile 16 must be drawn at height z=12
		 	z={
 				5, <-- the z height ordered ( used for drawing in order)
 				125,
 				...
 			}
			1=canvas-of-first-tile
			2=canvas-of-second-tile
			last=canvas-of-last-tile
		}

the three properties :

		 update(dt) : change the canvas of animated tile and the texture of sripteBatch of the tile
		 add( z, id, x, y, z, .. , kx, ky) : add a sprite in batch[z][id] and the z in z table if not already there
		 draw() : draw and clear all spritebatch

layers
------

You can  generate a table that contain a draw function and for each layer a table with the attributes and a function that add sprite in tileset batch by using

``` layers=tiolved:layers(map,tileset) ```

layers is a table with :

		an array of layer
		draw : method that call all layer.draw

layer is a table with :

		name
		number ( order in tiled )
		tile = {
			{id,x,y}
			{id,x,y}
		}
		property1=value1
		property2=value2
		...
		draw : function that add tile in tileset batch by using tileset:add

trick: the layer that must be interpreted and not drawn must be removed from the mapTable or you can change the .je=layer for something else

usefulfunc
----------

Use :

``` toMap,toRender=tiolved:usefulfunc(map) ```

* map coordinate are : 1 tile measure 1*1
* render coordinate are : 1 tile measure Xpixel*Ypixel

exemple
-------

the main love.load contain the basic way to use tiolved

issue
-----

for any inform me at my [github](https://github.com/thiolliere/tiolved)

to do
-----
* Isometric must be done, so it changes the tileset structure because tile must be drawned from up left to down right.
* spritebatch capacity extended
