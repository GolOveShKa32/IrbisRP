function replaceModel()
	
	txd = engineLoadTXD('yacht_tatuitret.txd',454)
	engineImportTXD(txd,454)
	dff = engineLoadDFF('yacht_tatuitret.dff',454)
	engineReplaceModel(dff,454)
	
	txd = engineLoadTXD('lampadati_toro.txd',493)
	engineImportTXD(txd,493)
	dff = engineLoadDFF('lampadati_toro.dff',493)
	engineReplaceModel(dff,493)
	
	txd = engineLoadTXD('reefer_gtaiv.txd',453)
	engineImportTXD(txd,453)
	dff = engineLoadDFF('reefer_gtaiv.dff',453)
	engineReplaceModel(dff,453)
	
	txd = engineLoadTXD('wellcraft38scarab.txd',446)
	engineImportTXD(txd,446)
	dff = engineLoadDFF('wellcraft38scarab.dff',446)
	engineReplaceModel(dff,446)
	
	txd = engineLoadTXD('tropic_gtaiv.txd',472)
	engineImportTXD(txd,472)
	dff = engineLoadDFF('tropic_gtaiv.dff',472)
	engineReplaceModel(dff,472)
	
	txd = engineLoadTXD('blade_gtaiv.txd',595)
	engineImportTXD(txd,595)
	dff = engineLoadDFF('blade_gtaiv.dff',595)
	engineReplaceModel(dff,595)
end
addEventHandler ( 'onClientResourceStart', resourceRoot, replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )