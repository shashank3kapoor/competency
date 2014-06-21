{literal}
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '/extjs/resources/images/default/s.gif';
Ext.onReady(function() {
  
  Ext.QuickTips.init();
  
  var gv_compSessionIdList = "{/literal}{$compSessionIdList}{literal}";
  var gv_tempSessionIdList = gv_compSessionIdList;
  
  var ary_dep_pos = [
		     ['',''],
		     ['l', '{/literal}{$_.EDT.COMPETENCY_LEVEL}{literal}'],
		     ['d', '{/literal}{$org_department}{literal}'],
		     ['e', '{/literal}{$_.TRAINING.EMPLOYEE}{literal}'],
		     ['g', '{/literal}{$_.TRAINING.GAP}{literal}'],
		     ['p', '{/literal}{$_.TRAINING.POSITION}{literal}'],
		     ['s', '{/literal}{$org_shift}{literal}']
		    ];
  var dep_pos_store = new Ext.data.SimpleStore({
    fields: ['id', 'txt'],
    data: ary_dep_pos
  });
    
    var levelListStore = new Ext.data.JsonStore({
      url: '/edit/competencies/getLevelList',
      root: 'items',
      fields: ['comp_lv_id','comp_lv_level_id','comp_lv_name','comp_lv_colour','comp_lv_value']
    });
    levelListStore.load();
    
    var gapsStore = new Ext.data.JsonStore({
      url: '/edit/competencies/getGaps',
      root: 'items',
      fields: ['id','val']
    });
    gapsStore.load();
    
    var shiftListStore = new Ext.data.JsonStore({
      url: '/edit/competencies/getShiftList',
      root: 'items',
      fields: ['s_id','s_name']
    });
    shiftListStore.load();
    
  //----------------Function related to 'Find Department / Position / Employee'-----------------//
  
  fn_selectPerson = function() {
      
      var lv_row = Ext.getCmp('fndEmpGrdExt').getSelectionModel().getSelected();
      
      if( lv_row ) {
	    
	  Ext.getCmp('id_dp_pos_name').setValue( lv_row.data.employee_id );
	  Ext.getCmp('txt_dp_pos_name').setText( lv_row.data.name );
	  
	  return true;
      }
      else {
	  Ext.Msg.alert( "{/literal}{$_.INFORMATION}{literal}", "{/literal}{$_.PLEASE_SELECT_A_ROW}{literal}" );
	  return false;
      }
  }
  
  findEmpDblClick = function(g, rowIndex, e){
      if( fn_selectPerson() ) {
	var lv_findWin = Ext.getCmp("findDepPosWin");
	  lv_findWin.close();
      }
  }
  
  fn_findDepPosWin = function( obj, e ) {
    var lv_seld_dp = Ext.getCmp('cmb_dp_pos_name').value;
    
    if( lv_seld_dp == 'd' ) {
      findDepPosWin = new Ext.Window({  
	id: 'findDepPosWin',  
	title: '{/literal}{$_.EDT.FIND_DEPARTMENT}{literal}',  
	width: 543,  
	height: 301,  
	closeAction:'close',
	modal: true,
	autoLoad : {
	  url : '/common/popwin/findDepartmentExt?field=dp',  
	  scripts: true  
	}
      });
    }
    else if( lv_seld_dp == 'p' ) {
      findDepPosWin = new Ext.Window({  
	id: 'findDepPosWin',  
	title: '{/literal}{$_.EDT.FIND_POSITION}{literal}',  
	width: 743,  
	height: 301,  
	closeAction:'close',
	modal: true,
	autoLoad : {
	  url : '/common/popwin/findPositionExt?field=dp',  
	  scripts: true  
	}
      });
    }
    else if( lv_seld_dp == 'e' ) {
      findDepPosWin = new Ext.Window({  
	id: 'findDepPosWin',  
	title: '{/literal}{$_.FIND_EMPLOYEE}{literal}',  
	width: 820,  
	height: 420,  
	closeAction:'close',
	modal: true,
	autoLoad : {
	  url : '/common/popwin/findEmployeeExt?emptab=0',
	  scripts: true  
	},
	buttons: [{
	    text: '{/literal}{$_.SELECT}{literal}',
	    id: 'btnselect',
	    handler: function(){
	      if( fn_selectPerson() ) {
		  findDepPosWin.close();
	      }
	    }
	  } ,{
	    text: '{/literal}{$_.CANCEL}{literal}',
	    handler: function(){
	      findDepPosWin.close();
	    }
	}]
      });
    }
    else {
      Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_ATLEAST_ONE_VALUE}{literal}');
      return false;
    }
    
    findDepPosWin.show();
    
    findDepPosWin.addListener( 'close', function( p ) {
	submitSrchForm();
	fn_saveSearchParams();
      }
    );
  }
//----------------End of Function related to 'Find Department / Position / Employee'-----------------//
  
  var srchFrm = new Ext.FormPanel({
      frame: false,
      id: 'srchFrm',
      monitorValid: true,
      layoutConfig: {
	columns: 2
      },
      border: false,
      layout: 'table',
      items: [{
	  xtype:'fieldset',
	  width: 253,
	  title: '{/literal}{$_.TRAINING.SHOW_ON_GRID}{literal}',
	  height: 79,
	  defaults: {
	      anchor: '-20' // leave room for error icon
	  },
	  items: [{
	    layoutConfig: { columns: 2 },
	    layout: 'table',
	    items: [{
	      xtype: 'label',
	      text: '{/literal}{$_.TRAINING.TEXT}{literal}\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0'
	    },{
	      layoutConfig: { columns: 6 },
	      layout: 'table',
	      items: [{
		xtype: 'radio',
		id: 'lt_ac',
		name: 'ltname',
		checked: true,
		handler: function(){					
		  submitSrchForm();
		  fn_saveSearchParams();
		}
	      },{
		xtype: 'label',
		id: 'lb_ac',
		text: '{/literal}{$_.TRAINING.ACTUAL}{literal}\xa0\xa0\xa0'
	      },{
		xtype: 'radio',
		id: 'lt_tg',
		name: 'ltname',
		handler: function(){					
		  submitSrchForm();
		  fn_saveSearchParams();
		}
	      },{
		xtype: 'label',
		id: 'lb_tg',
		text: '{/literal}{$_.TRAINING.TARGET}{literal}\xa0\xa0\xa0'
	      },{
		xtype: 'radio',
		id: 'lt_gp',
		name: 'ltname',
		handler: function(){					
		  submitSrchForm();
		  fn_saveSearchParams();
		}
	      },{
		xtype: 'label',
		id: 'lb_gp',
		text: '{/literal}{$_.TRAINING.GAP}{literal}'
	      }]
	      
	    },{
	      xtype: 'label',
	      text: '{/literal}{$_.TRAINING.COLOUR}{literal}\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0'
	    },{
		layoutConfig: { columns: 6 },
		layout: 'table',
		items: [{
		  xtype: 'radio',
		  id: 'co_ac',
		  name: 'coname',
		  handler: function(){					
		    submitSrchForm();
		    fn_saveSearchParams();
		  }
		},{
		  xtype: 'label',
		  id: 'co_lb_ac',
		  text: '{/literal}{$_.TRAINING.ACTUAL}{literal}\xa0\xa0\xa0'
		},{
		  xtype: 'radio',
		  id: 'co_tg',
		  name: 'coname',
		  checked: true,
		  handler: function(){					
		    submitSrchForm();
		    fn_saveSearchParams();
		  }
		},{
		  xtype: 'label',
		  id: 'co_lb_tg',
		  text: '{/literal}{$_.TRAINING.TARGET}{literal}\xa0\xa0\xa0'
		},{
		  xtype: 'radio',
		  id: 'co_gp',
		  name: 'coname',
		  handler: function(){					
		    submitSrchForm();
		    fn_saveSearchParams();
		  }
		},{
		  xtype: 'label',
		  id: 'co_lb_gp',
		  text: '{/literal}{$_.TRAINING.GAP}{literal}'
		}]
	    }]
	  }]
      },{
	  xtype:'fieldset',
	  width: 360,
	  title: '{/literal}{$_.TRAINING.FILTER_BY}{literal}',
	  height: 79,
	  defaults: {
	      anchor: '-20' // leave room for error icon
	  },
	  items: [{
	    layoutConfig: { columns: 2 },
	    layout: 'table',
	    items: [{
		  xtype: 'combo',
		  id: 'cmb_dp_pos_name',
		  hiddenName: 'cmb_dp_pos_id',
		  typeAhead: true,
		  triggerAction: 'all',
		  width: 143,
		  forceSelection: true,
		  allowBlank: true,
		  store: dep_pos_store,
		  displayField: 'txt',
		  valueField: 'id',
		  mode: 'local',
		  emptyText: '{/literal}{$_.EDT.SELECT}{literal}',
		  tpl : '<tpl for="."><div class="x-combo-list-item">{txt}&nbsp;</div></tpl>',
		  listeners: {
		    select: function( obj, rec, idx ) {
		      Ext.getCmp('txt_dp_pos_name').setText('');
		      Ext.getCmp('id_dp_pos_name').setValue('');
		      switch( rec.data.id ) {
			case 'l' :
			  Ext.getCmp('btn_dp_pos').hide();
			  Ext.getCmp('cmb_comp_lv_name').show();
			  Ext.getCmp('cmb_gaps_val').hide();
			  Ext.getCmp('cmb_shifts_val').hide();
			  break;
			case 'g' :
			  Ext.getCmp('btn_dp_pos').hide();
			  Ext.getCmp('cmb_comp_lv_name').hide();
			  Ext.getCmp('cmb_gaps_val').show();
			  Ext.getCmp('cmb_shifts_val').hide();
			  break;
			case 'd' :
			case 'p' :
			case 'e' :
			  Ext.getCmp('cmb_comp_lv_name').hide();
			  Ext.getCmp('cmb_gaps_val').hide();
			  Ext.getCmp('btn_dp_pos').show();
			  Ext.getCmp('cmb_shifts_val').hide();
			  break;
			case 's':
			  Ext.getCmp('cmb_comp_lv_name').hide();
			  Ext.getCmp('cmb_gaps_val').hide();
			  Ext.getCmp('btn_dp_pos').hide();
			  Ext.getCmp('cmb_shifts_val').show();
			  break;
			default :
			  Ext.getCmp('cmb_comp_lv_name').hide();
			  Ext.getCmp('cmb_gaps_val').hide();
			  Ext.getCmp('btn_dp_pos').hide();
			  Ext.getCmp('cmb_shifts_val').hide();
		      }
			  submitSrchForm();
			  fn_saveSearchParams();
		    }
		  }
	    },{
		  layoutConfig: { columns: 5 },
		  layout: 'table',
		  items: [{
		    layoutConfig: { columns: 2 },
		    layout: 'table',
		    items: [{
		      xtype: 'combo',
		      id: 'cmb_comp_lv_name',
		      hiddenName: 'cmb_comp_lv_id',
		      typeAhead: true,
		      hidden: true,
		      triggerAction: 'all',
		      width: 143,
		      listWidth: 250,
		      foreceSelection: true,
		      allowBlank: true,
		      store: levelListStore,
		      displayField: 'comp_lv_name',
		      valueField: 'comp_lv_id',
		      mode: 'local',
		      emptyText: '{/literal}{$_.EDT.SELECT}{literal}',
		      tpl : '<tpl for="."><div class="x-combo-list-item">{comp_lv_name}&nbsp;</div></tpl>',
		      listeners: {
			select: function( obj, rec, idx ){
			  submitSrchForm();
			  fn_saveSearchParams();
			}
		      }
		    },{
		      xtype: 'combo',
		      id: 'cmb_gaps_val',
		      hiddenName: 'cmb_gaps_id',
		      typeAhead: true,
		      hidden: true,
		      triggerAction: 'all',
		      width: 143,
		      foreceSelection: true,
		      allowBlank: true,
		      store: gapsStore,
		      displayField: 'val',
		      valueField: 'id',
		      mode: 'local',
		      emptyText: '{/literal}{$_.EDT.SELECT}{literal}',
		      tpl : '<tpl for="."><div class="x-combo-list-item">{val}&nbsp;</div></tpl>',
		      listeners: {
			select: function( obj, rec, idx ){
			  submitSrchForm();
			  fn_saveSearchParams();
			}
		      }
		    },{
		      xtype: 'combo',
		      id: 'cmb_shifts_val',
		      hiddenName: 'cmb_shifts_id',
		      typeAhead: true,
		      hidden: true,
		      triggerAction: 'all',
		      width: 143,
		      forceSelection: true,
		      allowBland: true,
		      store: shiftListStore,
		      displayField: 's_name',
		      valueField: 's_id',
		      mode: 'local',
		      emptyText: '{/literal}{$_.EDT.SELECT}{literal}',
		      tpl : '<tpl for="."><div class="x-combo-list-item">{s_name}&nbsp;</div></tpl>',
		      listeners: {
			select: function( obj, rec, idx ){
			  submitSrchForm();
			  fn_saveSearchParams();
			}
		      }
		    }]
		  },{
		    xtype: 'button',
		    id: 'btn_dp_pos',
		    hidden: true,
		    text: '{/literal}{$_.EDT.FIND}{literal}',
		    listeners: {
		      click: fn_findDepPosWin
		    }
		  },{
		    xtype: 'label',
		    text: '\xa0\xa0\xa0'
		  },{
		    xtype: 'label',
		    id: 'txt_dp_pos_name'
		  },{
		    xtype: 'hidden',
		    id: 'id_dp_pos_name',
		    listeners: {
		      change: function( obj, newVal, oldVal ){
			submitSrchForm();
			fn_saveSearchParams();
		      }
		    }
		  }]
	    }]
	  }]
      }]
      
  });
    
  //----------------Function related to select 'Category / Competency'-----------------//
  
  
  fn_setSessionVar = function( lv_varName, lv_varValue ) {
    Ext.Ajax.request({
	  url: '/edit/competencies/setSessionVar',
	  params: {
	    varName: lv_varName,
	    varValue: lv_varValue
	  },
	  callback: function() {
	    window.location.reload(true);
	  }
    });
    
  }
  
  fn_delSessionVar = function( lv_varName ) {
    Ext.Ajax.request({
	  url: '/edit/competencies/delSessionVar',
	  params: {
	    varName: lv_varName
	  }
    });
    
  }
  
  selCatCompFn = function( obj, e ) {

    var catAllStore = new Ext.data.JsonStore({
	url: '/edit/competencies/getCat',
	root: 'items',
	fields: ['comp_cat_id','comp_cat_name']
    });
    catAllStore.setDefaultSort('comp_cat_name','asc');
    catAllStore.load({
      params: {
	blank: true
      }
      });
    
    var catCompStore = new Ext.data.JsonStore({
      url: '/edit/competencies/getCatComp',
      root: 'items',
      remoteSort: true,
      totalProperty: 'totalCount',
      fields: ['comp_id','comp_name','comp_cat_id','comp_cat_name'],
      listeners: {
	load: function( obj, recs, opts ) {
	  var lv_session = gv_tempSessionIdList;
	  var lv_sessionArry = [];
	  
	  if( ( lv_session != null ) && ( lv_session != '' ) ) {
	    lv_sessionArry = lv_session.split(',');
	  }
	  
	  var idx = -1;
	  var rowIds = [];
	  var ctr = 0;
	  
	  for( var i=0; i<lv_sessionArry.length; i++ ) {
	    idx = -1;
	    
	    ctr = 0;
	    
	    obj.each( function( rec ) {
	      if( rec.data.comp_id == lv_sessionArry[i] ) {
		idx = ctr;
		return;
	      }
	      ctr++;
	    });
	    
	    if( idx >=0 ) {
	      rowIds.push(idx);
	    }
	  }
	  
	  Ext.getCmp('selCatCompGrid').getSelectionModel().selectRows(rowIds);
	}
      }
    });
    catCompStore.setDefaultSort( 'comp_cat_name', 'asc' );
    catCompStore.load({
      params: {
	start: 0,
	limit: 20
      }
    });
    
    var smCatComp = new Ext.grid.CheckboxSelectionModel({
	      singleSelect: false,
	      listeners: {
		rowselect: function( obj, rwIdx, rec ) {
		  var lv_session = gv_tempSessionIdList;
		  var lv_sessionArry = [];
		  
		  if( ( lv_session != null ) && ( lv_session != '' ) ) {
		    lv_sessionArry = lv_session.split(',');
		  }
		  
		  var fg = true;
		  
		  for( var i=0; i<lv_sessionArry.length; i++ ) {
		    lv_sessionArry[i] = parseInt( lv_sessionArry[i], 10 );
		    if( rec.data.comp_id == lv_sessionArry[i] ) {
		      fg = false;
		    }
		  }
		  
		  if( fg ) {
		    lv_sessionArry.push(rec.data.comp_id);
		    if( lv_sessionArry.length > 30 ){
		      Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_LESS_THAN_30}{literal}');
		      obj.deselectRow(rwIdx);
		    }
		    else {
		      lv_session = lv_sessionArry.join(',');
		      lv_session.replace(/^\s+|\s+$/g,'');
		      
		      gv_tempSessionIdList = lv_session;
		    }
		  }
		},
		rowdeselect: function( obj, rwIdx, rec ) {
		  var lv_session = gv_tempSessionIdList;
		  var lv_sessionArry = [];
		  
		  if( ( lv_session != null ) && ( lv_session != '' ) ) {
		    lv_sessionArry = lv_session.split(',');
		  }
		  
		  var idx = -1;
		  
		  for( var i=0; i<lv_sessionArry.length; i++ ) {
		    lv_sessionArry[i] = parseInt( lv_sessionArry[i], 10 );
		    if( rec.data.comp_id == lv_sessionArry[i] ) {
		      idx = i;
		    }
		  }
		  
		  if( idx != -1) {
		    lv_sessionArry.splice( idx, 1 );
		  }
		  
		  if( lv_sessionArry.length > 0 ) {
		    lv_session = lv_sessionArry.join(',');
		    lv_session.replace(/^\s+|\s+$/g,'');
		    
		    gv_tempSessionIdList = lv_session;
		  }
		  else {
		    gv_tempSessionIdList = "";
		    fn_delSessionVar( 'competencyAnalysis_e' );
		  }
		}
	      }
	});
    
    var cm_catComp = new Ext.grid.ColumnModel([
	smCatComp
      ,{
	header: "{/literal}{$_.EDT.CATEGORY}{literal}",
	dataIndex: 'comp_cat_name',
	sortable: true,
	width:40 
    },{
	header: "{/literal}{$_.EDT.COMPETENCY}{literal}",
	dataIndex: 'comp_name',
	sortable: true,
	width:40 
    }]);
    
    selCatCompGrid = new Ext.grid.GridPanel({
	id: 'selCatCompGrid',
	height:343,
	store: catCompStore,
	cm: cm_catComp,
	trackMouseOver:false,
	stripeRows: true,
	sm: smCatComp,
	viewConfig: {
	  autoFill: true,
	  forceFit:true
	},
	bbar: new Ext.PagingToolbar({
	    pageSize: 20,
	    store: catCompStore,
	    displayInfo: true,
	    displayMsg: '{/literal}{$_.TRAINING.CATEGORIES_COMPETENCIES}{literal} {0} - {1} {/literal}{$_.EDT.OF}{literal} {2}',
	    emptyMsg: '{/literal}{$_.TRAINING.NO_CATEGORY_COMPETENCY}{literal}'
	})
    });
    
    
    selCatCompWin = new Ext.Window({  
      id: 'selCatCompWin',  
      title: '{/literal}{$_.TRAINING.SELECT_CAT_COMP}{literal}',  
      width: 643,  
      height: 443,  
      closeAction: 'close',
      modal: true,
      items: [{
	  layoutConfig: { columns: 4 },
	  layout: 'table',
	  items: [{
	    xtype: 'label',
	    text: '\xa0\xa0\xa0\xa0\xa0\xa0{/literal}{$_.EDT.CATEGORY}{literal} :\xa0\xa0\xa0'
	  },{
	    xtype: 'combo',
	    store: catAllStore,
	    allowBlank: true,
	    forceSelection: true,
	    typeAhead: true,
	    triggerAction: 'all',
	    width: 243,
	    id: 'cat_name',
	    hiddenName: 'cat_id',
	    displayField: 'comp_cat_name',
	    valueField: 'comp_cat_id',
	    mode: 'local',
	    emptyText: '{/literal}{$_.EDT.SELECT_CATEGORY}{literal}',
	    tpl : '<tpl for="."><div class="x-combo-list-item">{comp_cat_name}&nbsp;</div></tpl>',
	    listeners: {
	      select: function( obj, rec, idx ) {
		catCompStore.load({
		    params: {
		      start: 0,
		      limit: 20,
		      comp_cat_id: rec.data.comp_cat_id
		    }
		  });
	      }
	    }
	  },{
	    xtype: 'button',
	    id: 'deselectAllComp',
	    text: '{/literal}{$_.TRAINING.DESELECT_ALL}{literal}',
	    handler: function() {
	      var ctr = 0;
	      Ext.getCmp('selCatCompGrid').getStore().each( function( rec ) {
		Ext.getCmp('selCatCompGrid').getSelectionModel().deselectRow(ctr);
		ctr++;
	      });
	      gv_tempSessionIdList = '';
	      fn_delSessionVar( 'competencyAnalysis_e' );
	    }
	  }]
      },
      selCatCompGrid],
      buttons: [{
	    text: '{/literal}{$_.TRAINING.DONE}{literal}',
	    id: 'btnSelCatCompDone',
	    handler: function(){
	      var lv_session = gv_tempSessionIdList;
	      
	      if( ( lv_session == 'NaN' ) || ( lv_session == '' ) || ( lv_session == null ) ){
		Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_ATLEAST_ONE_VALUE}{literal}');
		return false;
	      }
		fn_setSessionVar( 'competencyAnalysis_e', gv_tempSessionIdList );
	      selCatCompWin.close();
	    }
	  }]
    });
    
    selCatCompWin.show();
  }
//----------------End of Function related to select 'Category / Competency'-----------------//
    
    var srchFrmPnl = new Ext.Panel({ 
	renderTo: 'srchFrmPnl',
	width: 630,
	height: 115,
	activeTab: 0,
	frame:true,
	autoScroll: true,
	defaults:{autoHeight: true},
	resizeTabs:true,
	items: [ srchFrm ]
	
    });
    
    var expSelCompPnl = new Ext.Panel({
	renderTo: 'expSelCompPnl', 
	width: 180,
	height: 115,
	activeTab: 0,
	frame:true,
	autoScroll: true,
	defaults:{autoHeight: true},
	resizeTabs:true,
	items: [{
	  layoutConfig: { columns: 1 },
	  layout: 'table',
	  items: [{
	    xtype: 'button',
	    text: '{/literal}{$_.TRAINING.CATEGORY_COMPETENCY}{literal}',
	    id: 'btnCatCompSel',
	    handler: function() {
	      selCatCompFn();
	    }
	  },{
	    xtype: 'button',
	    text: '{/literal}{$_.TRAINING.EXPORT_DATA}{literal}',
	    id: 'btnExpData',
	    menu     : [
		  {
			  text    : '{/literal}{$_.TRAINING.EXPORT_ALL_COMP_DATA3}{literal}',
			  handler : function(){
			    var href_url_string = "";
			    href_url_string = "/training/competencies/exportTrainingEmployeeMatrix?all=1&exceltype=0";
			    href_url_string+= "&tr_ac=" + Ext.getCmp('lt_ac').getValue();
			    href_url_string+= "&tr_tg=" + Ext.getCmp('lt_tg').getValue();
			    href_url_string+= "&tr_gp=" + Ext.getCmp('lt_gp').getValue();
			    href_url_string+= "&co_ac=" + Ext.getCmp('co_ac').getValue();
			    href_url_string+= "&co_tg=" + Ext.getCmp('co_tg').getValue();
			    href_url_string+= "&co_gp=" + Ext.getCmp('co_gp').getValue();
			    href_url_string+= "&cmb_dp_pos_name=" + Ext.getCmp('cmb_dp_pos_name').getValue();
			    href_url_string+= "&id_dp_pos_name=" + Ext.getCmp('id_dp_pos_name').getValue();
			    href_url_string+= "&cmb_comp_lv_name=" + Ext.getCmp('cmb_comp_lv_name').getValue();
			    href_url_string+= "&cmb_gaps_val=" + Ext.getCmp('cmb_gaps_val').getValue();
			    href_url_string+= "&cmb_shifts_val=" + Ext.getCmp('cmb_shifts_val').getValue();
			    
			   Ext.Ajax.request({
			       url: '/training/competencies/chkCompNumber',
			       success: function(response, opts) {
				  
				  var v_tot = Ext.decode( response.responseText );
				  
				  if( v_tot[0].total < 256 ) {
				    location.href = href_url_string;
				  }
				  else {
				    Ext.Msg.confirm('{/literal}{$_.TRAINING.CONFIRM_EXTRACTION}{literal}','{/literal}{$_.TRAINING.EXTRACTION_CONFIRMATION_MSG}{literal}', function(btn, text){
				      if(btn == 'yes') {
					location.href = href_url_string;
				      }
				    });
				  }
			       }
			   });
			    
			  }
		  },{
			  text    : '{/literal}{$_.TRAINING.EXPORT_ALL_COMP_DATA7}{literal}',
			  handler : function(){
			    var href_url_string = "";
			    href_url_string = "/training/competencies/exportTrainingEmployeeMatrix?all=1&exceltype=1";
			    href_url_string+= "&tr_ac=" + Ext.getCmp('lt_ac').getValue();
			    href_url_string+= "&tr_tg=" + Ext.getCmp('lt_tg').getValue();
			    href_url_string+= "&tr_gp=" + Ext.getCmp('lt_gp').getValue();
			    href_url_string+= "&co_ac=" + Ext.getCmp('co_ac').getValue();
			    href_url_string+= "&co_tg=" + Ext.getCmp('co_tg').getValue();
			    href_url_string+= "&co_gp=" + Ext.getCmp('co_gp').getValue();
			    href_url_string+= "&cmb_dp_pos_name=" + Ext.getCmp('cmb_dp_pos_name').getValue();
			    href_url_string+= "&id_dp_pos_name=" + Ext.getCmp('id_dp_pos_name').getValue();
			    href_url_string+= "&cmb_comp_lv_name=" + Ext.getCmp('cmb_comp_lv_name').getValue();
			    href_url_string+= "&cmb_gaps_val=" + Ext.getCmp('cmb_gaps_val').getValue();
			    href_url_string+= "&cmb_shifts_val=" + Ext.getCmp('cmb_shifts_val').getValue();
			    
			    location.href = href_url_string;
			  }
		  },{
			  text    : '{/literal}{$_.TRAINING.EXPORT_COMP_DATA3}{literal}',
			  handler : function(){
			    var href_url_string = "";
			    href_url_string = "/training/competencies/exportTrainingEmployeeMatrix?exceltype=0";
			    href_url_string+= "&tr_ac=" + Ext.getCmp('lt_ac').getValue();
			    href_url_string+= "&tr_tg=" + Ext.getCmp('lt_tg').getValue();
			    href_url_string+= "&tr_gp=" + Ext.getCmp('lt_gp').getValue();
			    href_url_string+= "&co_ac=" + Ext.getCmp('co_ac').getValue();
			    href_url_string+= "&co_tg=" + Ext.getCmp('co_tg').getValue();
			    href_url_string+= "&co_gp=" + Ext.getCmp('co_gp').getValue();
			    href_url_string+= "&cmb_dp_pos_name=" + Ext.getCmp('cmb_dp_pos_name').getValue();
			    href_url_string+= "&id_dp_pos_name=" + Ext.getCmp('id_dp_pos_name').getValue();
			    href_url_string+= "&cmb_comp_lv_name=" + Ext.getCmp('cmb_comp_lv_name').getValue();
			    href_url_string+= "&cmb_gaps_val=" + Ext.getCmp('cmb_gaps_val').getValue();
			    href_url_string+= "&cmb_shifts_val=" + Ext.getCmp('cmb_shifts_val').getValue();
			    
			    location.href = href_url_string;
			  }
		  },{
			  text    : '{/literal}{$_.TRAINING.EXPORT_COMP_DATA7}{literal}',
			  handler : function(){
			    var href_url_string = "";
			    href_url_string = "/training/competencies/exportTrainingEmployeeMatrix?exceltype=1";
			    href_url_string+= "&tr_ac=" + Ext.getCmp('lt_ac').getValue();
			    href_url_string+= "&tr_tg=" + Ext.getCmp('lt_tg').getValue();
			    href_url_string+= "&tr_gp=" + Ext.getCmp('lt_gp').getValue();
			    href_url_string+= "&co_ac=" + Ext.getCmp('co_ac').getValue();
			    href_url_string+= "&co_tg=" + Ext.getCmp('co_tg').getValue();
			    href_url_string+= "&co_gp=" + Ext.getCmp('co_gp').getValue();
			    href_url_string+= "&cmb_dp_pos_name=" + Ext.getCmp('cmb_dp_pos_name').getValue();
			    href_url_string+= "&id_dp_pos_name=" + Ext.getCmp('id_dp_pos_name').getValue();
			    href_url_string+= "&cmb_comp_lv_name=" + Ext.getCmp('cmb_comp_lv_name').getValue();
			    href_url_string+= "&cmb_gaps_val=" + Ext.getCmp('cmb_gaps_val').getValue();
			    href_url_string+= "&cmb_shifts_val=" + Ext.getCmp('cmb_shifts_val').getValue();
			    
			    location.href = href_url_string;
			  }
		  }
		],
	    handler: function(){
	    }
	  },{
	    xtype: 'button',
	    id: 'btnEdtIdv',
	    text: '{/literal}{$_.TRAINING.SET_INDIVIDUAL_TARGET}{literal}',
	    handler: function( obj, e ) {
	      var selection = repgrd.getSelectionModel().getSelectedCell();
	      if( selection ){
		var record = repgrd.getStore().getAt( selection[0] );
		var fieldName = repgrd.getColumnModel().getDataIndex( selection[1] ); // Get field name
		fn_getIndvCompTarget( record.data.position_id, record.data.employee_id, fieldName );
	      }
	      else{
		Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_INDIVIDUAL_NAME}{literal}');
	      }
	    }
	  },{
	    xtype: 'button',
	    id: 'btnEdtCompLvl',
	    text: '{/literal}{$_.TRAINING.SET_GAINED_COMP_LEVEL}{literal}',
	    disabled: true,
	    handler: function( obj, e ) {
	      var selection = repgrd.getSelectionModel().getSelectedCell();
	      if( selection ){
		var record = repgrd.getStore().getAt( selection[0] );
		var fieldName = repgrd.getColumnModel().getDataIndex( selection[1] ); // Get field name
		if( fieldName != 'name' ) {
		  fn_getGndCompLvl( fieldName, record.data.employee_id );
		}
		else {
		  Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_CORRESPONDING_CELL}{literal}');
		}
	      }
	      else{
		Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_CORRESPONDING_CELL}{literal}');
	      }
	    }
	  },{
	    layoutConfig: { columns: 2 },
	    layout: 'table',
	    items: [{
	      xtype: 'label',
	      text: '{/literal}{$_.LEGEND}{literal}: '
	    },{
	      xtype: 'label',
	      id: 'lbllgdhlpimg',
	      html: '<img src="/images/icons/help.gif" />'
	    }]
	  }]
	}]
    });
    
//Code for Legend
  Ext.Ajax.request({
    url: '/edit/competencies/getGapColours',
    success: function( resp, opts ) {
      var lv_data = Ext.decode( resp.responseText );
      var lv_total = parseInt( lv_data.total, 10 );
      var lv_items = lv_data.gapcol;
      
      var lv_outer_div = "<div id='lgotdiv' style='position: relative; float: left; background-color: #FFF; color: #000; display: block; width: 160px; padding: 2px;'>";
      
      var lv_div_gp = "<div id='lggpotdiv' style='display: block; width: 71px; border: 1px solid #000; position: relative; float: left; background-color: #FFF; color: #000; padding: 2px;'>";
          lv_div_gp+= "<div id='lggphddiv' style='clear: both; position: relative; float: left; font-weight: bold; color: #000;'>{/literal}{$_.EDT.GAP_COLOUR}{literal}</div>";
      
      var lv_div_gp_colrs = '';
      for(var i=0; i<lv_total; i++) {
	var lv_gap = i + 1;
	if( lv_items.hasOwnProperty( i ) ) {
	  lv_div_gp_colrs+= "<div style='clear: left; position: relative; float: left; margin: 2px; height: 21px; width: 21px; line-height: 21px; text-align: right;'>" + lv_gap + "</div>";
	  lv_div_gp_colrs+= "<div style='position: relative; float: left; margin: 2px; height: 21px; width: 21px; background-color: #" + lv_items[i].comp_gap_colour + ";'></div>";
	}
      }
      
      lv_div_gp+= lv_div_gp_colrs;
      lv_div_gp+= "</div>";
      
      
      Ext.Ajax.request({
	url: '/edit/competencies/getAllCpLv',
	success: function( resp, opts ) {
	  var lv_items_tg = Ext.decode( resp.responseText );
	  
	  var lv_div_tg = "<div id='lgtgotdiv' style='display: block; width: 71px; border: 1px solid #000; position: relative; float: left; background-color: #FFF; color: #000; padding: 2px; margin-left: 5px;'>";
	      lv_div_tg+= "<div id='lgtghddiv' style='clear: both; position: relative; float: left; font-weight: bold; color: #000;'>{/literal}{$_.EDT.LEVEL_COLOUR}{literal}</div>";
	  
	  var lv_div_tg_colrs = '';
	  for(var i=0; i<lv_items_tg.length; i++) {
	    if( lv_items_tg.hasOwnProperty( i ) ) {
	      lv_div_tg_colrs+= "<div style='clear: left; position: relative; float: left; margin: 2px; height: 21px; width: 21px; line-height: 21px; text-align: right;'>" + lv_items_tg[i].comp_lv_level_id + "</div>";
	      lv_div_tg_colrs+= "<div style='position: relative; float: left; margin: 2px; height: 21px; width: 21px; background-color: #" + lv_items_tg[i].comp_lv_colour + ";'></div>";
	    }
	  }
	  
	  lv_div_tg+= lv_div_tg_colrs;
	  lv_div_tg+= "</div>";
	  
	  lv_outer_div+= lv_div_gp + lv_div_tg;
	  
	  var lv_individualTip = new Ext.ToolTip({
	    target: 'lbllgdhlpimg',
	    header: false,
	    id: 'legendTip',
	    items: [{
	      xtype: 'panel',
	      frame: false,
	      autoScroll: true,
	      defaults:{autoHeight: true},
	      html: lv_outer_div
	    }],
	    trackMouse:true,
	    dismissDelay: 0
	  });
	}
      });
    }
  });
//End of code for Legend
  
  var repgrdStore = new Ext.data.JsonStore({
    url: '/training/competencies/getRepGrdCompData',
    root: 'items',
    totalProperty: 'totalCount',
    fields: [
	     'name','employee_id','position_id'
	     {/literal}
	     {section name=cpl loop=$compList}
	     ,'{$compList[cpl].cid}'
	     {/section}
	     {literal}
	    ]
  });
  
  repgrdStore.baseParams = {
    lt_ac: Ext.getCmp('lt_ac').getValue(),
    lt_tg: Ext.getCmp('lt_tg').getValue(),
    lt_gp: Ext.getCmp('lt_gp').getValue(),
    co_ac: Ext.getCmp('co_ac').getValue(),
    co_tg: Ext.getCmp('co_tg').getValue(),
    co_gp: Ext.getCmp('co_gp').getValue(),
    cmb_dp_pos_name: Ext.getCmp('cmb_dp_pos_name').getValue(),
    id_dp_pos_name: Ext.getCmp('id_dp_pos_name').getValue(),
    cmb_comp_lv_name: Ext.getCmp('cmb_comp_lv_name').getValue(),
    cmb_gaps_val: Ext.getCmp('cmb_gaps_val').getValue(),
    cmb_shifts_val: Ext.getCmp('cmb_shifts_val').getValue()
  };
    
  repgrdStore.load({
    params: {
      start: 0,
      limit: 20
    }
  });
  
  submitSrchForm = function() {
    repgrdStore.baseParams = {
	lt_ac: Ext.getCmp('lt_ac').getValue(),
	lt_tg: Ext.getCmp('lt_tg').getValue(),
	lt_gp: Ext.getCmp('lt_gp').getValue(),
	co_ac: Ext.getCmp('co_ac').getValue(),
	co_tg: Ext.getCmp('co_tg').getValue(),
	co_gp: Ext.getCmp('co_gp').getValue(),
	cmb_dp_pos_name: Ext.getCmp('cmb_dp_pos_name').getValue(),
	id_dp_pos_name: Ext.getCmp('id_dp_pos_name').getValue(),
	cmb_comp_lv_name: Ext.getCmp('cmb_comp_lv_name').getValue(),
	cmb_gaps_val: Ext.getCmp('cmb_gaps_val').getValue(),
	cmb_shifts_val: Ext.getCmp('cmb_shifts_val').getValue()
      };
    repgrdStore.reload({
      params: {
	start: 0,
	limit: 20
      }
    });
  }
  
  //Save the params values to SESSION
  fn_saveSearchParams = function() {
    Ext.Ajax.request({
      url: '/training/competencies/saveSearchParams',
      params: {
	lt_ac: Ext.getCmp('lt_ac').getValue(),
	lt_tg: Ext.getCmp('lt_tg').getValue(),
	lt_gp: Ext.getCmp('lt_gp').getValue(),
	co_ac: Ext.getCmp('co_ac').getValue(),
	co_tg: Ext.getCmp('co_tg').getValue(),
	co_gp: Ext.getCmp('co_gp').getValue(),
	cmb_dp_pos_name: Ext.getCmp('cmb_dp_pos_name').getValue(),
	id_dp_pos_name: Ext.getCmp('id_dp_pos_name').getValue(),
	cmb_comp_lv_name: Ext.getCmp('cmb_comp_lv_name').getValue(),
	cmb_gaps_val: Ext.getCmp('cmb_gaps_val').getValue(),
	cmb_shifts_val: Ext.getCmp('cmb_shifts_val').getValue(),
	txt_dp_pos_name: document.getElementById('txt_dp_pos_name').innerHTML,
	rep_typ: 'e'
      },
      success: function( resp, opts ) {
	
      }
    });
  }
  
  //Get back the params and reload grid-Store
  fn_getSearchParams = function() {
    Ext.Ajax.request({
      url: '/training/competencies/getSearchParams',
      params: {
	rep_typ: 'e'
      },
      success: function( resp, opts ) {
	var lv_params = Ext.decode( resp.responseText );
	
	if( typeof lv_params.cmb_dp_pos_name != 'undefined' ){
	  Ext.getCmp('cmb_dp_pos_name').setValue( lv_params.cmb_dp_pos_name );
	  
	    switch( lv_params.cmb_dp_pos_name ) {
	      case 'l' :
		Ext.getCmp('btn_dp_pos').hide();
		Ext.getCmp('cmb_comp_lv_name').show();
		Ext.getCmp('cmb_gaps_val').hide();
		Ext.getCmp('cmb_shifts_val').hide();
		break;
	      case 'g' :
		Ext.getCmp('btn_dp_pos').hide();
		Ext.getCmp('cmb_comp_lv_name').hide();
		Ext.getCmp('cmb_gaps_val').show();
		Ext.getCmp('cmb_shifts_val').hide();
		break;
	      case 'd' :
	      case 'p' :
	      case 'e' :
		Ext.getCmp('cmb_comp_lv_name').hide();
		Ext.getCmp('cmb_gaps_val').hide();
		Ext.getCmp('btn_dp_pos').show();
		Ext.getCmp('cmb_shifts_val').hide();
		break;
	      case 's':
		Ext.getCmp('cmb_comp_lv_name').hide();
		Ext.getCmp('cmb_gaps_val').hide();
		Ext.getCmp('btn_dp_pos').hide();
		Ext.getCmp('cmb_shifts_val').show();
		break;
	      default :
		Ext.getCmp('cmb_comp_lv_name').hide();
		Ext.getCmp('cmb_gaps_val').hide();
		Ext.getCmp('btn_dp_pos').hide();
		Ext.getCmp('cmb_shifts_val').hide();
	    }
	}
	
	if( typeof lv_params.id_dp_pos_name != 'undefined' ){
	  Ext.getCmp('id_dp_pos_name').setValue( lv_params.id_dp_pos_name );
	}
	
	if( typeof lv_params.cmb_comp_lv_name != 'undefined' ){
	  Ext.getCmp('cmb_comp_lv_name').setValue( lv_params.cmb_comp_lv_name );
	}
	
	if( typeof lv_params.cmb_gaps_val != 'undefined' ){
	  Ext.getCmp('cmb_gaps_val').setValue( lv_params.cmb_gaps_val );
	}
	
	if( typeof lv_params.cmb_shifts_val != 'undefined' ){
	  Ext.getCmp('cmb_shifts_val').setValue( lv_params.cmb_shifts_val );
	}
	
	if( typeof lv_params.txt_dp_pos_name != 'undefined' ){
	  Ext.getCmp('txt_dp_pos_name').setText( lv_params.txt_dp_pos_name );
	}
	
	if( ( typeof lv_params.lt_ac != 'undefined' ) && ( lv_params.lt_ac == 'true' ) ){
	  Ext.getCmp('lt_ac').setValue(true);
	  Ext.getCmp('lt_tg').setValue(false);
	  Ext.getCmp('lt_gp').setValue(false);
	}
	else if( ( typeof lv_params.lt_tg != 'undefined' ) && ( lv_params.lt_tg == 'true' ) ){
	  Ext.getCmp('lt_ac').setValue(false);
	  Ext.getCmp('lt_tg').setValue(true);
	  Ext.getCmp('lt_gp').setValue(false);
	}
	else if( ( typeof lv_params.lt_gp != 'undefined' ) && ( lv_params.lt_gp == 'true' ) ){
	  Ext.getCmp('lt_ac').setValue(false);
	  Ext.getCmp('lt_tg').setValue(false);
	  Ext.getCmp('lt_gp').setValue(true);
	}
	
	if( ( typeof lv_params.co_ac != 'undefined' ) && ( lv_params.co_ac == 'true' ) ){
	  Ext.getCmp('co_ac').setValue(true);
	  Ext.getCmp('co_tg').setValue(false);
	  Ext.getCmp('co_gp').setValue(false);
	}
	else if( ( typeof lv_params.co_tg != 'undefined' ) && ( lv_params.co_tg == 'true' ) ){
	  Ext.getCmp('co_ac').setValue(false);
	  Ext.getCmp('co_tg').setValue(true);
	  Ext.getCmp('co_gp').setValue(false);
	}
	else if( ( typeof lv_params.co_gp != 'undefined' ) && ( lv_params.co_gp == 'true' ) ){
	  Ext.getCmp('co_ac').setValue(false);
	  Ext.getCmp('co_tg').setValue(false);
	  Ext.getCmp('co_gp').setValue(true);
	}
	
	submitSrchForm();
      }
    });
  }
  
  var repgrd = new Ext.grid.GridPanel({
      el: 'repgrdDiv',
      id: 'repgrd',
      height: 493,
      width: 810,
      trackMouseOver: false,
      stripeRows: true,
      enableColumnMove: false,
      store: repgrdStore,
      sm: new Ext.grid.CellSelectionModel({
	singleSelect: false
      }),
      colModel: new Ext.grid.ColumnModel({
	columns: [{
	    header: '<b>{/literal}{$_.TRAINING.EMPLOYEE_NAME}{literal}</b>',
	    width: 150,
	    menuDisabled: true,
	    sortable:true,
	    dataIndex: 'name'
	  }
	  {/literal}
	  {section name=cl loop=$compList}
	  {literal}
	  ,{
	    header: '<img style="cursor:pointer" alt="{/literal}{$compList[cl].txttitle}{literal}" title="{/literal}{$compList[cl].txttitle}{literal}" src="/images/matrixTitle/competencyMatrix/{/literal}{$compList[cl].title|cat:".png"}{literal}" border="0"/>', 
	    width: 21,
	    resizable:false,
	    sortable:true,
	    menuDisabled: true,
	    dataIndex: '{/literal}{$compList[cl].cid}{literal}',
	    renderer: function(value, metadata, record) {
	      if( value != null ){
		var val_col_arry = value.split('~');
		if( ( val_col_arry[1] != null ) && ( val_col_arry[1] != '' ) ) {
		  metadata.attr = "ext:qtip='" + (val_col_arry[1]||'&nbsp;') + "'  style='text-overflow: clip; background-color: #" + val_col_arry[2] + "; color: #000000;'";
		}
		else {
		  metadata.attr = "style='text-overflow: clip; background-color: #" + val_col_arry[2] + "; color: #000000;'";
		}
		return val_col_arry[0];
	      }
	    }
	  }
	  {/literal}
	  {/section}
	  {literal}
	]
      }),
      bbar: new Ext.PagingToolbar({
	  pageSize: 20,
	  store: repgrdStore,
	  displayInfo: true,
	  displayMsg: '{/literal}{$_.TRAINING.EMPLOYEE}{literal} {0} - {1} {/literal}{$_.TRAINING.OF}{literal} {2}',
	  emptyMsg: '{/literal}{$_.PERSONNEL.NO_EMPLOYEE}{literal}'
      }),
      plugins: [new Ext.ux.plugins.GroupHeaderGrid({
	rows: [
		[
		  {}
		  {/literal}
		  {foreach key=key item=item from=$categoryList}
		  {literal}
		  ,{
		    header: '{/literal}{$key}{literal}',
		    tooltip: '{/literal}{$key}{literal}',
		    colspan: {/literal}{$item}{literal},
		    align: 'center'
		  }
		  {/literal}
		  {/foreach}
		  {literal}
		]
	],
	hierarchicalColMenu: true
      })]
  });
  repgrd.render();
  
  fn_setIdvTrgtGridDblClick = function ( grd, rowIdx, colIdx, e ) {
    var selection = grd.getSelectionModel().getSelectedCell();
    if( selection ){
      var record = grd.getStore().getAt( selection[0] );
      var fieldName = grd.getColumnModel().getDataIndex( selection[1] ); // Get field name
      fn_getIndvCompTarget( record.data.position_id, record.data.employee_id, fieldName );
    }
    else{
      Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_INDIVIDUAL_NAME}{literal}');
    }
  }
  
  fn_setGndCompLvlGridDblClick = function ( grd, rowIdx, colIdx, e ) {
    var selection = grd.getSelectionModel().getSelectedCell();
    if( selection ){
      var record = grd.getStore().getAt( selection[0] );
      var fieldName = grd.getColumnModel().getDataIndex( selection[1] ); // Get field name
      if( fieldName != 'name' ) {
	fn_getGndCompLvl( fieldName, record.data.employee_id );
      }
      else {
	Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_CORRESPONDING_CELL}{literal}');
      }
    }
    else{
      Ext.MessageBox.alert('{/literal}{$_.TRAINING.INFORMATION}{literal}!','{/literal}{$_.TRAINING.PLEASE_SELECT_CORRESPONDING_CELL}{literal}');
    }
  }
  
  //For Header Click
  fn_header_enbl_dsbl_btn = function( grd, colIdx, e ) {
    
    var lv_btn_obj = Ext.getCmp('btnEdtCompLvl');
    
    var selection = grd.getSelectionModel().getSelectedCell();
    if( selection ){
      var record = grd.getStore().getAt( selection[0] );
      var fieldName = grd.getColumnModel().getDataIndex( selection[1] ); // Get field name
      if( fieldName != 'name' ) {
	lv_btn_obj.enable();
      }
      else {
	lv_btn_obj.disable();
      }
    }
    else{
      lv_btn_obj.disable();
    }
  }
  
  repgrd.addListener( 'headerclick', fn_header_enbl_dsbl_btn );
  //End of code For Header Click
  
  //For Cell Click
  fn_enbl_dsbl_btn = function( grd, rowIdx, colIdx, e ) {
    
    var lv_btn_obj = Ext.getCmp('btnEdtCompLvl');
    
    var selection = grd.getSelectionModel().getSelectedCell();
    if( selection ){
      var record = grd.getStore().getAt( selection[0] );
      var fieldName = grd.getColumnModel().getDataIndex( selection[1] ); // Get field name
      if( fieldName != 'name' ) {
	lv_btn_obj.enable();
      }
      else {
	lv_btn_obj.disable();
      }
    }
    else{
      lv_btn_obj.disable();
    }
  }
  
  repgrd.addListener( 'cellclick', fn_enbl_dsbl_btn );
  //End of code For Cell Click
  
  //For Cell Double-Click
  fn_chooseAction = function( grd, rowIdx, colIdx, e ) {
  
    var ary_chooseAction = [
		       ['i', '{/literal}{$_.TRAINING.SET_INDIVIDUAL_TARGET}{literal}'],
		       ['g', '{/literal}{$_.TRAINING.SET_GAINED_COMP_LEVEL}{literal}']
		      ];
    var chooseActionStore = new Ext.data.SimpleStore({
      fields: ['id', 'txt'],
      data: ary_chooseAction
    });
    
    var chooseActionWin = new Ext.Window({
      id: 'chooseActionWin',
      title: '{/literal}{$_.TRAINING.PLEASE_CHOOSE_ACTION}{literal}',
      width: 243,
      closeAction: 'close',
      modal: true,
      items: [{
	xtype: 'panel',
	header: false,
	frame: false,
	autoScroll: true,
	defaults: { autoHeight: true },
	layoutConfig: { columns: 2 },
	layout: 'table',
	items: [{
	  xtype: 'label',
	  text: '{/literal}{$_.TRAINING.SELECT_ACTION}{literal} :'
	},{
	  xtype: 'combo',
	  id: 'cmbAction',
	  hiddenName: 'cmbActionName',
	  width: 143,
	  listWidth: 183,
	  triggerAction: 'all',
	  typeAhead: true,
	  forceSelection: true,
	  allowBlank: false,
	  store: chooseActionStore,
	  valueField: 'id',
	  displayField: 'txt',
	  mode: 'local',
	  emptyText: '{/literal}{$_.TRAINING.SELECT}{literal}'
	}]
      }],
      buttons: [{
	text: '{/literal}{$_.NEXT}{literal}-->>',
	id: 'btnChooseActionNext',
	handler: function() {
	  var lv_actionVal = Ext.getCmp('cmbAction').getValue();
	  
	  switch( lv_actionVal ) {
	    case 'i':
	      fn_setIdvTrgtGridDblClick( grd, rowIdx, colIdx, e );
	      chooseActionWin.close();
	      break;
	    case 'g':
	      fn_setGndCompLvlGridDblClick( grd, rowIdx, colIdx, e );
	      chooseActionWin.close();
	      break;
	  }
	}
      }]
    });
    
    chooseActionWin.show();
    
  }
  
  repgrd.addListener( 'celldblclick', fn_chooseAction );
  //End of code For Cell Double-Click
  
  var individualTip = new Ext.ToolTip({
    target: 'btnEdtIdv',
    id: 'individualTip',
    title: '{/literal}{$_.TRAINING.SET_INDIVIDUAL_TARGET}{literal}:-',
    width: 143,
    html: '{/literal}{$_.TRAINING.TIP_FOR_INDIVIDUAL_BTN}{literal}',
    trackMouse:true,
    dismissDelay: 7000
  });
  
//--------------Code for setting Individual Targets----------//
    var cpLvStore = new Ext.data.JsonStore({
      url: '/edit/competencies/getLevelList',
      root: 'items',
      remoteSort: true,
      totalProperty: 'totalCount',
      fields: ['comp_lv_id','comp_lv_level_id','comp_lv_name','comp_lv_colour','comp_lv_value']
    });
  cpLvStore.setDefaultSort('comp_lv_id','asc');
  cpLvStore.load();

  function fn_getIndvCompTarget( v_pos_id, v_emp_id, v_fieldName ) {
    
    var lv_height = 446;
    var lv_comp_id = null;
    if( v_fieldName != 'name' ) {
      lv_height = 93;
      lv_comp_id = v_fieldName;
    }
    
      var compStore = new Ext.data.JsonStore({
	  url: '/edit/competencies/getIndvCompTarget',
	  root: 'items',
	  remoteSort: true,
	  totalProperty: 'totalCount',
	  fields: ['comp_id', 'comp_name', 'comp_lv_id','pos_comp_lv_name'],
	  baseParams: {
	    pos_id: v_pos_id,
	    emp_id: v_emp_id,
	    person_type: '0',
	    comp_id: lv_comp_id
	  }
      });
    
    compStore.load({
	params: {
	    start: 0,
	    limit: 20
	}
    });
      
      var comp_cm = new Ext.grid.ColumnModel([
	  {
	      header: '{/literal}{$_.TRAINING.COMPETENCY}{literal}',
	      dataIndex: 'comp_name',
	      sortable: true,
	      width: 243
	  },{
	      header: '{/literal}{$_.TRAINING.POSITIONAL_LEVEL}{literal}',
	      dataIndex: 'pos_comp_lv_name',
	      sortable: true,
	      width: 143
	  },{
	      header: '{/literal}{$_.TRAINING.INDIVIDUAL_LEVEL}{literal}',
	      dataIndex: 'comp_lv_id',
	      sortable: true,
	      editor: new Ext.form.ComboBox({
		  width: 143,
		  selectOnFocus: true,
		  triggerAction: 'all',
		  store: cpLvStore,
		  displayField: 'comp_lv_name',
		  valueField: 'comp_lv_id',
		  mode: 'local',
		  allowBlank: true,
		  emptyText: '{/literal}{$_.EDT.SELECT_LEVEL}{literal}',
		  maxLength: 300,
		  tpl : '<tpl for="."><div class="x-combo-list-item">{comp_lv_name}&nbsp;</div></tpl>',
		  listeners: {
		    select: function( obj, rec, idx ) {
		      var v_sel_level = rec.data.comp_lv_id;
		      var v_sel_comp = gridCompetency.getSelectionModel().getSelected().data.comp_id;
		      
		      Ext.Ajax.request({
			  url: '/edit/competencies/saveIndvCompLevel',
			  success: function( res, opts ) {
			      gridCompetency.getStore().commitChanges();
			  },
			  failure: function( res, opts ) {
			      var resp = Ext.decode( res.responseText );
			      alert( resp.res );
			  },
			  params: {
			      comp_id: v_sel_comp,
			      pos_id: v_pos_id,
			      level_id: v_sel_level,
			      emp_id: v_emp_id,
			      person_type: '0'
			  }
		      });
		    }
		  }
	      }),
	      renderer: function( val, meta, rec, rowidx, colidx ) {
		  var selIdx = cpLvStore.find( 'comp_lv_id', val );
		  var retVal = "";
		  if( selIdx != -1 ) {
		      retVal = cpLvStore.getAt(selIdx).data.comp_lv_name;
		  }
		  return retVal;
	      }
	  }
	  
      ]);
      
      var gridCompetency = new Ext.grid.EditorGridPanel({
	  id: 'gridCompetency',
	  store: compStore,
	  cm: comp_cm,
	  height: lv_height,
	  width: 643,
	  trackMouseOver: false,
	  frame: false,
	  hidden: false,
	  clicksToEdit: 1,
	  sm: new Ext.grid.RowSelectionModel({
	     singleSelect: true 
	  }),
	  viewConfig: {
	      autoFill: true,
	      forceFit: true
	  },
	  bbar: new Ext.PagingToolbar({
	      pageSize: 20,
	      store: compStore,
	      displayInfo: true,
	      displayMsg: '{/literal}{$_.EDT.COMPETENCY}{literal} {0} - {1} {/literal}{$_.EDT.OF}{literal} {2}',
	      emptyMsg: '{/literal}{$_.EDT.NO_COMPETENCIES}{literal}'
	  })
      });
      
      var indvTargetWin = new Ext.Window({   
	  title: '{/literal}{$_.TRAINING.SET_INDIVIDUAL_TARGET}{literal}',
	  bodyStyle: 'position: relative;',
	  width: 668,
	  modal: true,
	  closable: false,
	  id: 'indvTargetWin',
	  autoScroll: true,
	  closeAction: 'close',
	  border: false,
	  items: [{
	      xtype: 'label',
	      cls: 'clsnote',
	      html: '{/literal}{$_.INDV_TARG_INSTRUCTION}{literal}'
	    },
	      gridCompetency
	  ],
	  buttons: [{
	      text: '{/literal}{$_.TRAINING.SAVE_N_CLOSE}{literal}',
	      id: 'indvTargetWindClose',
	      handler: function(){
		  submitSrchForm();
		  indvTargetWin.close();
	      }
	  }]
	  
      });
    indvTargetWin.show();
  }
    
    //--------------End of code for setting Individual Targets----------//
    
  
//--------------Code for setting Gained Competency Level----------//

  function fn_getGndCompLvl( lv_comp_id, lv_emp_id ) {
    
    var lv_date = new Date();
    lv_date = lv_date.format('d/m/Y');
    
    var compGdPnlForm = new Ext.FormPanel({
      frame: false,
      id: 'compGdPnlForm',
      method: 'POST',
      url: '/edit/competencies/saveCompGained',
      monitorValid: true,
      layoutConfig: {
	columns: 4
      },
      border: false,
      layout: 'table',
      items: [{},{
	xtype: 'label',
	html: '<b>{/literal}{$_.EDT.NEW_LEVEL}{literal}</b>'
      },{
	xtype: 'label',
	html: '<b>{/literal}{$_.TRAINING.COMMENT}{literal}</b>'
      },{}]
      
    });
    
    var compGdPnl = new Ext.Panel({
	header: false,
        frame:true,
	autoScroll: true,
        defaults:{autoHeight: true},
        items: [compGdPnlForm]
    });
      
    var gndCompLvlWin = new Ext.Window({   
	title: '{/literal}{$_.TRAINING.SET_GAINED_COMP_LEVEL}{literal}',
	bodyStyle: 'position: relative;',
	width: 343,
	modal: true,
	id: 'gndCompLvlWin',
	autoScroll: true,
	closeAction: 'close',
	border: false,
	items: [
	    compGdPnl
	],
	buttons: [{
	    text: '{/literal}{$_.SAVE}{literal}',
	    id: 'gndCompLvlWindSave',
	    handler: function( obj, e ){
	      var formPanel =   Ext.getCmp('compGdPnlForm');
	      formPanel.el.mask('{/literal}{$_.EDT.SAVING_TO_SERVER}{literal}', 'x-mask-loading');
	      
	      obj.disable();
	      
	      formPanel.getForm().submit({
		  success:  compGdPnlSuccess,
		  failure:  compGdPnlSuccess
	      });
	    }
	},{
	    text: '{/literal}{$_.CANCEL}{literal}',
	    id: 'gndCompLvlWindClose',
	    handler: function(){
		gndCompLvlWin.close();
	    }
	}]
	
    });
    
    compGdPnlSuccess = function(form, action) {
	var formPanel =   Ext.getCmp('compGdPnlForm');
	formPanel.el.unmask();
	
	var button = Ext.getCmp('gndCompLvlWindSave');
	button.enable();
	
	var result = action.result;
	if (result && result.success) {
	    submitSrchForm();
	  var lv_gndCompLvlWin = Ext.getCmp('gndCompLvlWin');
	  lv_gndCompLvlWin.close();
	} else if(!result) {
	  Ext.MessageBox.alert('FORM VALIDATION FAILED','ONE MORE FIELD MISSING INVALID');
	}
	else {
	  Ext.MessageBox.alert('SAVE ERROR','ERROR WITH SAVING');
	}
    }
	
      Ext.Ajax.request({
	url: '/edit/competencies/getCompGained',
	params: {
	  comp_id: lv_comp_id,
	  emp_id: lv_emp_id
	},
	success: function(response, opts) {
	  
	  var gv_obj = Ext.decode( response.responseText );
	  var j = 0;
	  var i = 1;
	  
	    for (var i=1; i <= gv_obj.length; i++) {
	      j = i - 1;
	      
	      //Set Window Title
	      gndCompLvlWin.setTitle( '{/literal}{$_.TRAINING.SET_GAINED_COMP_LEVEL}{literal} for "' + gv_obj[j].comp_name + '"' );
	      
	      compGdPnlForm.add({
		  xtype: 'checkbox',
		  id: 'chk' + i,
		  width: 23,
		  listeners: {
		    check : function( obj, chkd ) {
		      var id = parseInt( obj.id.substr(3), 10 );
		      var v_cmm = 'cg_comment' + id;
		      var v_cmb = 'name_cg_new_lvl' + id;
		      if( chkd ) {
			Ext.getCmp(v_cmm).enable();
			Ext.getCmp(v_cmb).enable();
		      }
		      else {
			Ext.getCmp(v_cmm).disable();
			Ext.getCmp(v_cmb).disable();
		      }
		    },
		    render: function( obj ) {
		      var row_id = parseInt( obj.id.substr(3), 10 ) - 1;
		      if( gv_obj[row_id].gained_level != 0 ){
			obj.setValue( 'on' );
		      }
		    }
		  }
		},{
		  xtype: 'combo',
		  id: 'name_cg_new_lvl' + i,
		  hiddenName: 'cg_new_lvl' + i,
		  tabIndex:0,
		  width: 153,
		  selectOnFocus: true,
		  disabled: true,
		  triggerAction: 'all',
		  store: levelListStore,
		  listWidth: 250,		  
		  displayField: 'comp_lv_name',
		  valueField: 'comp_lv_id',
		  mode: 'local',
		  allowBlank: false,
		  emptyText: '{/literal}{$_.EDT.SELECT_LEVEL}{literal}',
		  maxLength: 100,
		  listeners: {
		    render: function( obj ) {
		      var row_id = parseInt( obj.id.substr(15), 10 ) - 1;
		      obj.setValue( gv_obj[row_id].cg_new_lvl );
		    }
		  }
		},{
		  xtype: 'textfield',
		  id: 'cg_comment' + i,
		  disabled: true,
		  allowBlank: true,
		  width: 158,
		  autoCreate: {tag: 'input', type: 'text', size: '200', autocomplete: 'off', maxlength: '200'},
		  value: gv_obj[j].cg_comment
		},{
		  xtype: 'hidden',
		  id: 'comp_id' + i,
		  value: gv_obj[j].comp_id
		});
	    }
	    compGdPnlForm.add({
	      xtype: 'hidden',
	      id: 'training_id',
	      value: 0
	    },{
	      xtype: 'hidden',
	      id: 'emp_id',
	      value: lv_emp_id
	    },{
	      xtype: 'hidden',
	      id: 'tte_id',
	      value: 0
	    },{
	      xtype: 'hidden',
	      id: 'tte_ts_id',
	      value: 0
	    },{
	      xtype: 'hidden',
	      id: 'person_type',
	      value: '0'
	    },{
	      xtype: 'hidden',
	      id: 'end_date',
	      value: lv_date
	    });
	    compGdPnlForm.doLayout();
	    
	  gndCompLvlWin.show();
	}
      });
  }
    
    //--------------End of code for Gained Competency Level----------//
    
    
    
    
  
  //Called to maintain the State of Search Parameters
  fn_getSearchParams();
});
{/literal}
</script>
<div style="clear: both; float: left; position: relative;">
  <div id="pnlCont" style="clear: both; float: left; position: relative;">
    <div id="expSelCompPnl" style="clear: both; float: left; position: relative;"></div>
    <div id="srchFrmPnl" style="float: left; position: relative;"></div>
  </div>
  
  <div id="repgrdDiv" style="clear: left; float: left; position: relative;"></div>
</div>