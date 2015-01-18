function tmx_parser(name)
	local firstline = "<%?"
	local object = "<[^/].*/>"
	local begintable = "<[^/].*[^/]>"
	local endtable= "</.*>"

	local stack={}
	local courant=1
	local xml={}
	stack[courant]=xml

	local function readattribute(line)
		local k, n, v
		_,k,n=string.find(line, "%s(%w%w*)=")
		if n then
			line=string.sub(line,k+1)
			_,k=string.find(line,".\"" )
			v=string.sub(line,2,k-1)
			line=string.sub(line,k+1)
		end
		return line,n,v
	end

	local function readline(line)
		local object, objectname, k
		_,k,objectname=string.find(line, "<(%w%w*)")
		line=string.sub(line, k+1)

		object={je=objectname}

		local attr={n=nil,v=nil}
		line,attr.n,attr.v=readattribute(line)
		while attr.n and attr.v do
			object[attr.n]=attr.v
			line,attr.n,attr.v=readattribute(line)
		end
		return object
	end

	for line in love.filesystem.lines(name) do
		if line == "</map>" then
			return xml[1]
		elseif string.find(line,firstline) then
		elseif string.find(line,object) then
			table.insert(stack[courant],readline(line))
		elseif string.find(line,begintable) then
			table.insert(stack[courant],readline(line))
			stack[courant+1]=stack[courant][table.getn(stack[courant])]
			courant=courant+1
		elseif string.find(line,endtable) then
			courant=courant-1
		end
	end
end
