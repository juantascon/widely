Layout = function() {
	Layout.superclass.constructor.call(this, document.body, {
		hideOnLayout: true,
		north: { split:false, initialSize: 25, titlebar: false },
		west: { split:true, initialSize: 200, minSize: 175, maxSize: 400,
			titlebar: true, collapsible: true, animate: true },
		east: { split:true, initialSize: 202, minSize: 175, maxSize: 400,
			titlebar: true, collapsible: true, animate: true },
		south: { split:true, initialSize: 100, minSize: 100, maxSize: 200,
			titlebar: true, collapsible: true, animate: true },
		center: { titlebar: true, autoScroll:true } });
	
	this.beginUpdate();
	this.add('north', new Ext.ContentPanel('north', 'North'));
	this.add('south', new Ext.ContentPanel('south', {title: 'South', closable: true}));
	this.add('west', new Ext.ContentPanel('filetreeview', {title: 'West', fitToFrame:true}));
	this.add('east', new Ext.ContentPanel('east', {title: 'East'}));
	this.add('center', new Ext.ContentPanel('center', {title: 'Center', closable: false}));
	this.endUpdate();
};

Ext.extend ( Layout, Ext.BorderLayout, {
	toggle_region: function(name) {
		var region = layout.getRegion(name);
		if(region.isVisible()) {
			region.hide();
		}
		else{
			region.show();
		}
	}
});
