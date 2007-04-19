
qx.OO.defineClass("Widely.TreeView", qx.component.AbstractApplication,
function () {
	qx.component.AbstractApplication.call(this);
});
/*
qx.Settings.setDefault("resourceUri", "./resource");


qx.Proto.initialize = function(e)
{
	// Define alias for custom resource path
	qx.manager.object.AliasManager.getInstance().add("Widely", qx.Settings.getValueOfClass("Widely.Application", "resourceUri"));
};

qx.Proto.main = function(e)
{
	var trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Root");
	  var t = new qx.ui.treefullcontrol.Tree(trs);

	  with(t)
	  {
		setBackgroundColor(255);
		setBorder(qx.renderer.border.BorderPresets.getInstance().inset);
		setOverflow("scrollY");

		setHeight(null);
		setTop(48);
		setLeft(20);
		setWidth(200);
		setBottom(48);
	  };

	  qx.ui.core.ClientDocument.getInstance().add(t);
	  // One icon for selected and one for unselected states
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Desktop", "icon/16/places/user-desktop.png", "icon/16/apps/accessories-dictionary.png");
	  var te1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  t.add(te1);

	  desktop = te1;

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Files");
	  var te1_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Workspace");
	  var te1_2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Network");
	  var te1_3 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Trash");
	  var te1_4 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  te1.add(te1_1, te1_2, te1_3, te1_4);

	  // One icon specified, and used for both selected unselected states
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Windows (C:)", "icon/16/devices/drive-harddisk.png");
	  var te1_2_1 = new qx.ui.treefullcontrol.TreeFile(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Documents (D:)", "icon/16/devices/drive-harddisk.png");
	  var te1_2_2 = new qx.ui.treefullcontrol.TreeFile(trs);

	  te1_2.add(te1_2_1, te1_2_2);

	  arbeitsplatz = te1_2;


	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Inbox");
	  var te2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  posteingang = te2;

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Presets");
	  var te2_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Sent");
	  var te2_2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Trash", "icon/16/places/user-trash.png");
	  var te2_3 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Data");
	  var te2_4 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Edit");
	  var te2_5 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  editieren = te2_5;

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Chat");
	  var te2_5_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Pustefix");
	  var te2_5_2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("TINC");
	  var te2_5_3 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Announce");
	  var te2_5_3_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Devel");
	  var te2_5_3_2 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  te2_5_3.add(te2_5_3_1, te2_5_3_2);

	  te2_5.add(te2_5_1, te2_5_2, te2_5_3);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Lists");
	  var te2_6 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Relations");
	  var te2_6_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Company");
	  var te2_6_2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Questions");
	  var te2_6_3 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Internal");
	  var te2_6_4 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Products");
	  var te2_6_5 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Press");
	  var te2_6_6 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Development");
	  var te2_6_7 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Competition");
	  var te2_6_8 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  te2_6.add(te2_6_1, te2_6_2, te2_6_3, te2_6_4, te2_6_5, te2_6_6, te2_6_7, te2_6_8);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Personal");
	  var te2_7 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Bugs");
	  var te2_7_1 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Family");
	  var te2_7_2 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Projects");
	  var te2_7_3 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Holiday");
	  var te2_7_4 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  te2_7.add(te2_7_1, te2_7_2, te2_7_3, te2_7_4);

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Big");
	  var te2_8 = new qx.ui.treefullcontrol.TreeFolder(trs);

	  for (var i=0;i<50; i++) {
		trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Item " + i);
		te2_8.add(new qx.ui.treefullcontrol.TreeFolder(trs));
	  };

	  trs = qx.ui.treefullcontrol.TreeRowStructure.getInstance().standard("Spam");
	  var te2_9 = new qx.ui.treefullcontrol.TreeFolder(trs);
	  spam = te2_9;

	  te2.add(te2_1, te2_2, te2_3, te2_4, te2_5, te2_6, te2_7, te2_8, te2_9);

	  t.add(te2);
	  qx.ui.core.ClientDocument.getInstance().add(t);






	  var commandFrame = new qx.ui.groupbox.GroupBox("Control");

	  with(commandFrame)
	  {
		setTop(48);
		setLeft(250);

		setWidth("auto");
		setHeight("auto");
	  };

	  qx.ui.core.ClientDocument.getInstance().add(commandFrame);




	  var tCurrentLabel = new qx.ui.basic.Atom("Current Folder: ");

	  with(tCurrentLabel)
	  {
		setLeft(0);
		setTop(0);
	  };

	  commandFrame.add(tCurrentLabel);



	  var tCurrentInput = new qx.ui.form.TextField;

	  with(tCurrentInput)
	  {
		setLeft(0);
		setRight(0);
		setTop(20);

		setReadOnly(true);
	  };

	  commandFrame.add(tCurrentInput);

	  t.getManager().addEventListener("changeSelection", function(e) {
		tCurrentInput.setValue(e.getData()[0]._labelObject.getHtml());
	  });



	  var tDoubleClick = new qx.ui.form.CheckBox("Use double click?");

	  with(tDoubleClick) {
		setTop(60);
		setLeft(0);
	  };

	  commandFrame.add(tDoubleClick);

	  tDoubleClick.addEventListener("changeChecked", function(e) { t.setUseDoubleClick(e.getData()); });




	  var tTreeLines = new qx.ui.form.CheckBox("Use tree lines?");

	  with(tTreeLines) {
		setTop(80);
		setLeft(0);
		setChecked(true);
	  };

	  commandFrame.add(tTreeLines);

	  tTreeLines.addEventListener("changeChecked", function(e) { t.setUseTreeLines(e.getData()); });


	  var tHideNode = new qx.ui.form.CheckBox("Hide the root node?");

	  with(tHideNode) {
		setTop(100);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tHideNode);

	  tHideNode.addEventListener("changeChecked", function(e) { t.setHideNode(e.getData()); });

	  var tIncludeRootOpenClose =
		new qx.ui.form.CheckBox("Include root open/close button?");

	  with(tIncludeRootOpenClose) {
		setTop(120);
		setLeft(0);
		setChecked(true);
	  };

	  commandFrame.add(tIncludeRootOpenClose);

	  tIncludeRootOpenClose.addEventListener("changeChecked", function(e) { t.setRootOpenClose(e.getData()); });

	  tExcludeTreeLines0 =
		new qx.ui.form.CheckBox("Exclude tree lines at level 0?");

	  with(tExcludeTreeLines0) {
		setTop(140);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tExcludeTreeLines0);

	  tExcludeTreeLines0.addEventListener(
		  "changeChecked",
		  function(e)
		  {
			  var excl = t.getExcludeSpecificTreeLines();
			  if (e.getData()) {
				  excl[0] = true;
			  } else {
				  delete(excl[0]);
			  }
			  t.setExcludeSpecificTreeLines(excl);
		  });

	  tExcludeTreeLines1 =
		new qx.ui.form.CheckBox("Exclude tree lines at level 1?");

	  with(tExcludeTreeLines1) {
		setTop(160);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tExcludeTreeLines1);

	  tExcludeTreeLines1.addEventListener(
		  "changeChecked",
		  function(e)
		  {
			  var excl = t.getExcludeSpecificTreeLines();
			  if (e.getData()) {
				  excl[1] = true;
			  } else {
				  delete(excl[1]);
			  }
			  t.setExcludeSpecificTreeLines(excl);
		  });

	  tExcludeTreeLines2 =
		new qx.ui.form.CheckBox("Exclude tree lines at level 2?");

	  with(tExcludeTreeLines2) {
		setTop(180);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tExcludeTreeLines2);

	  tExcludeTreeLines2.addEventListener(
		  "changeChecked",
		  function(e)
		  {
			  var excl = t.getExcludeSpecificTreeLines();
			  if (e.getData()) {
				  excl[2] = true;
			  } else {
				  delete(excl[2]);
			  }
			  t.setExcludeSpecificTreeLines(excl);
		  });

	  tExcludeTreeLines3 =
		new qx.ui.form.CheckBox("Exclude tree lines at level 3?");

	  with(tExcludeTreeLines3) {
		setTop(200);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tExcludeTreeLines3);

	  tExcludeTreeLines3.addEventListener(
		  "changeChecked",
		  function(e)
		  {
			  var excl = t.getExcludeSpecificTreeLines();
			  if (e.getData()) {
				  excl[3] = true;
			  } else {
				  delete(excl[3]);
			  }
			  t.setExcludeSpecificTreeLines(excl);
		  });

	  tExcludeTreeLines4 =
		new qx.ui.form.CheckBox("Exclude tree lines at level 4?");

	  with(tExcludeTreeLines4) {
		setTop(220);
		setLeft(0);
		setChecked(false);
	  };

	  commandFrame.add(tExcludeTreeLines4);

	  tExcludeTreeLines4.addEventListener(
		  "changeChecked",
		  function(e)
		  {
			  var excl = t.getExcludeSpecificTreeLines();
			  if (e.getData()) {
				  excl[4] = true;
			  } else {
				  delete(excl[4]);
			  }
			  t.setExcludeSpecificTreeLines(excl);
		  });






















	var frame = new qx.ui.layout.CanvasLayout;
	frame.setLocation(0, 0);
	frame.setBottom(0);
	frame.setRight(0);
	frame.setPadding(10);
	frame.addToDocument();

	// the splitpane itself
	var splitpane = new qx.ui.splitpane.HorizontalSplitPane("1*", "2*");
	splitpane.setEdge(0);
	splitpane.setLiveResize(true);
	frame.add(splitpane);
	
	var tf1 = new qx.ui.pageview.tabview.TabView;
	tf1.set({ left: 0, top: 0, right: 0, bottom: 0 });
	
	var t1_1 = new qx.ui.pageview.tabview.Button("Edit");
	var t1_2 = new qx.ui.pageview.tabview.Button("Find");
	
	// set tab 1 active
	t1_1.setChecked(true);
	
	// add close images to tab
	t1_1.setShowCloseButton(true);
	t1_2.setShowCloseButton(true);
	
	// add an eventlistener on the buttons
	t1_1.addEventListener("closetab", _ontabclose);
	t1_2.addEventListener("closetab", _ontabclose);
	
	
	// this handler gets called if a tab-button fires a "closetab" event
	function _ontabclose(e){
		var btn = e.getData();
		btn.getManager().remove(btn);
		tf1.getBar().remove(btn);
		btn.dispose();
		
		var pagesArray = tf1.getPane().getChildren();
		var pageSearched = null;
		
		e.stopPropagation();
	}
	
	tf1.getBar().add(t1_1, t1_2);
	
	var p1_1 = new qx.ui.pageview.tabview.Page(t1_1);
	var p1_2 = new qx.ui.pageview.tabview.Page(t1_2);
	
	tf1.getPane().add(p1_1, p1_2);
	
	splitpane.addRight(tf1);
};

qx.Proto.finalize = function(e)
{
  // After initial rendering...
};

qx.Proto.close = function(e)
{
  // Prompt user
  // e.returnValue = "[qooxdoo application: Do you really want to close the application?]";
};

qx.Proto.terminate = function(e)
{
  // alert("terminated");
};
*/