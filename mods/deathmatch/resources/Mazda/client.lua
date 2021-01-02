function replaceModel()

	local txd = engineLoadTXD('mazda626.txd',567)
	engineImportTXD(txd,567)
	local dff = engineLoadDFF('mazda626.dff',567)
	engineReplaceModel(dff,567)
	
	txd = engineLoadTXD('6.txd',466)
	engineImportTXD(txd,466)
	dff = engineLoadDFF('6.dff',466)
	engineReplaceModel(dff,466)
end
addEventHandler ( 'onClientResourceStart', resourceRoot, replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )