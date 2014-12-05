
/* General */

body	{
	font-family: 'Montserrat', sans-serif;
	font-size: 14px;
		
	background: #e5e1de;
	background: -moz-radial-gradient(center, ellipse cover,  #ffffff 0%, #e5e1de 100%);
	background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%,#ffffff), color-stop(100%,#e5e1de));
	background: -webkit-radial-gradient(center, ellipse cover,  #ffffff 0%,#e5e1de 100%);
	background: -o-radial-gradient(center, ellipse cover,  #ffffff 0%,#e5e1de 100%);
	background: -ms-radial-gradient(center, ellipse cover,  #ffffff 0%,#e5e1de 100%);
	background: radial-gradient(ellipse at center,  #ffffff 0%,#e5e1de 100%);
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#e5e1de',GradientType=1 );
	
	padding: 0;
	margin: 0;
}

html,
body {
	margin: 0;
	padding: 0;
}

#wrapper {
	min-height: 100%;
	position: relative;
}

#content {
	padding-bottom: 80px; /* Height of the footer element */
}

#footer {
	width:100%;
	position:absolute;
	bottom:0;
	left:0;
}

body th,
body td	{
	font-family: 'Montserrat', sans-serif;
	font-size: 14px;
}

#centre,
div.end-inner	{
	width: 960px;
	margin: 0 auto;
	position: relative;
}

.lookupHoverDetail.individualPalette .bPageBlock .pbHeader	{
	padding: 10px 10px 5px 15px;
}

/* Reset */

.message	{
	border-radius: 2px;	
	margin: 10px 0;
}

body .bPageBlock, body #bodyCell .bResource .secondaryPalette, body .secondaryPalette.bPageBlock, body .individualPalette .secondaryPalette.bPageBlock, body .bodyDiv .genericTable, body .genericPageBlockTable, body .bodyDiv .bSubBlock, body .bComponentBlock .bPageBlock, body .bMyDashboard .bPageBlock, body.rlHoverFrame .bPageBlock, body.subjectSelectionPopup div.choicesBox, body.lookupTab .secondaryPalette.bPageBlock, body.popupTab .secondaryPalette.bPageBlock, body.UserTagStatsPage .secondaryPalette.bPageBlock	{
	border: none;
	border-radius: 0;
	background: none;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody	{
	margin: 0;
}

body button, body .x-btn, body .btn, body .btnDisabled, body .btnCancel, body .menuButton .menuButtonButton	{
	margin: 0;
	font-weight: normal;
}

body .bPageBlock .pbBody .labelCol, body .bPageBlock .pbBody .dataCol, body .bPageBlock .pbBody .data2Col, body .print .topics-label, body .print .topics-list	{
	/* invalid, suppresses the default padding */
	padding: auto;
}

body .bPageBlock .detailList tr td, body .bPageBlock .detailList tr th, body table.list tr td, body table.list tr th, body .hoverDetail .bPageBlock .detailList tr td, body .hoverDetail .bPageBlock .detailList tr th	{
	border: none;
}

body .pbBody table.list tr.headerRow td, body .pbBody table.list tr.headerRow th	{
	background: none;
	border: none;
	font-size: inherit;
	padding: 0;
}

body .bRelatedList .pbBody table.list, body .apexp .pbBody table.list	{
	border: none;
}

body #wrapper .pbBody table.list tr.headerRow td, body #wrapper .pbBody table.list tr.headerRow th	{
	font-weight: normal;
	border:	none;
}

body .pbBody table.list tr.dataRow th, body .pbBody table.list tr.dataRow td	{
	border: none;
}

.bPageBlock .detailList th, .bPageBlock .detailList td	{
	vertical-align: middle;
}

.bPageBlock .labelCol, body .print .topics-label	{
	font-family: inherit;
	font-size: inherit;
	font-weight: normal;
}

.Custom15Tab .tertiaryPalette, .individualPalette .Custom15Block .tertiaryPalette, .layoutEdit .individualPalette .Custom15Block .tertiaryPalette	{
	background: none;
}

body .bPageBlock .pbBody .pbSubheader	{
	padding: 0;
	border: none;
	color: inherit;
}

.apexp .bPageBlock.apexDefaultPageBlock .pbBody .pbSubheader	{
	color: inherit;
}

body .bEditBlock .pbBottomButtons>table, body .apexp .bPageBlock.apexDefaultPageBlock .pbBottomButtons>table	{
	border: none;
}

body .bEditBlock .pbBottomButtons, body .apexp .bPageBlock.apexDefaultPageBlock .pbBottomButtons	{
	border: none;
}

body .x-btn button, body .btn, body .btnImportant, body .btnDisabled, body .btnCancel, body .menuButton .menuButtonButton, body .menuButton .menuButtonMenu a, body .menuButton .menuButtonMenu input.theOption, h1, h2, h3, h4, h5, h6	{
	font-family: inherit;
}

.bEditBlock .pbHeader>table>tbody>tr>td, .bPageBlock .pbHeader>table>tbody>tr>td, .bLayoutBlock .pbHeader>table>tbody>tr>td, .bEditBlock .pbBottomButtons>table>tbody>tr>td, .bPageBlock .pbBottomButtons>table>tbody>tr>td, .bLayoutBlock .pbBottomButtons>table>tbody>tr>td	{
	padding: 0;
}

.Custom15Tab .secondaryPalette, .individualPalette .Custom15Block .secondaryPalette	{
/* can't do this because of popups! */
/*	background: none; */
	border: none;
}

.bEditBlock .pbHeader>table, .apexp .bPageBlock.apexDefaultPageBlock .pbHeader>table, #ep.bLayoutBlock .pbHeader>table	{
	border: none;
}

body .bEditBlock .pbHeader, body .bLayoutBlock .pbHeader, body .apexp .bPageBlock.apexDefaultPageBlock .pbHeader	{
	border: none;	
}

/* Header */

div.banner	{
	height: 158px;
	background: #1e1d19;
	padding: 26px 0;
}

div.hdr.end-logo	{
	float: left;
	background: url(../img/logo.png) no-repeat;
	width: 233px;
	height: 54px;
	text-indent: -9999px;
}

div.hdr.end-logout,
div.hdr.end-profile	{
	padding-top: 20px;
	width: 120px;
	float: right;
	text-align: right;
}

div.hdr.end-logout a,
div.hdr.end-profile a	{
	text-decoration: none;
	color: #fff;
}

#header	{
	margin-top: -110px;
}

#header a	{
	display: inline-block;
	padding: 10px 8px;
	color: #fff;
	text-decoration: none;
}

#header a:first-child	{
	padding-left: 0;
}

#header a:hover	{
	color: #ccc;
}

#header input	{
	background: #fff;
	border-radius: 2px;
	border: none;
	color: #000;
	margin-right: 8px;
}

/* Hero image */

div.end-banner	{
	margin-top: 0;
	border-top: 4px solid #ee750d;
}

div.end-banner img	{
	width: 960px;
	display: block;
}

/* Search box */

div.end-search	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto;
	padding-top: 23px;
}

div.end-search table	{
	width: 100%;
}

div.end-search table.detailList	{
	border-bottom: 23px solid #fff;
}

.apexp .bPageBlock .detailList	{
	width: 100%;
}

div.end-search th	{
	font-weight: normal;
}

div.end-search div.apexp .end-label	{
	width: 25%;
	text-align: right;
	padding-right: 10px;
}

div.end-search .end-input	{
	white-space: nowrap;
}

div.end-search .end-input input	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2 url(../img/icn-magnifier.png) no-repeat 8px 8px;
	height: 27px;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 3px 3px 30px;
	min-width: 220px;
}

div.end-search .end-input input[type="button"]	{
	background: #312e29;
	color: #fff;
	border: none;
	border-radius: 0;
	text-align: center;
	height: 35px;
	padding: 3px 20px;
	display: inline-block;
	margin-left: 10px;
	min-width: 0;
	border-radius: 2px;
	cursor: pointer;
}

div.end-search .end-new	{
	width: 25%;
	text-align: center;
}

div.end-search .end-new input	{
	cursor: pointer;
	background: none;
	border: none;
	text-decoration: underline;
	font-family: inherit;
	font-size: inherit;
	color: #ee750d;

}

div.end-search table.list caption	{
	font-style: normal;
	text-align: left;
	font-size: 17px;
	margin: 0 0 10px 10px;
}

div.end-search table.list th	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;
	font-weight: normal!important;
}

div.end-search table.list td	{
	cursor: pointer;
	padding: 10px;
	background: #fff;
}

div.end-search table.list tr:nth-child(even) td	{
	background: #fafafa;
}

div.end-tools div.apexp table.detailList > tbody > tr > td	{
	width: 33%;
	padding-left: 10px;
	vertical-align: top;
}

div.end-tools div.apexp table.detailList > tbody > tr > td:first-child	{
	padding-left: 0;
}

div.end-tools table.detailList table	{
	border-spacing: 0;
	border-collapse: collapse;
}

div.end-tools table.detailList table caption	{
	font-style: normal;
	text-align: left;
	font-size: 17px;
	margin: 20px 0 10px 0;
	white-space: nowrap;
}

div.end-tools div.apexp table.detailList table th,
div.end-tools div.apexp table.detailList table td	{
	padding: 8px;
	font-size: 11px;
	border: none;
}

/* table.detailList.end-tools table th:first-child {
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
}

table.detailList.end-tools table th:last-child {
	box-shadow: 0 2px 2px -2px rgba(0,0,0, .13);
}

table.detailList.end-tools table td	{
	box-shadow: 0 2px 2px -2px rgba(0,0,0, .13);
} */

div.end-tools table.detailList table th	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;	
	font-weight: normal!important;
	border: none!important;
}

div.end-tools table.detailList table td	{
	padding: 10px;
	background: #fff;
	cursor: pointer;
}

div.end-tools table.detailList table tr:nth-child(even) td	{
	background: #fafafa;
}

#footer	{
	padding: 34px 0;
	background: #1e1d19;
	font-size: 12px;
	height: 12px;
	color: #ccc;	
}

/* Contact */

div.bPageBlock div.end-contact-block.end-contact-seeker	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 40px;
	padding: 23px;
}


div.bPageBlock div.end-contact-block.end-contact-seeker table.detailList	{
	width: 100%;
}

div.bPageBlock div.end-contact-block.end-contact-seeker table .labelCol	{
	text-align: right;
	padding-right: 10px;
}

div.bPageBlock div.end-contact-block.end-contact-seeker .pbSubsection table.detailList	th,
div.bPageBlock div.end-contact-block.end-contact-seeker .pbSubsection table.detailList	td	{
	width: 50%;
	font-size: 17px;
	background: #fff;
}

div.bPageBlock div.end-contact-block	{
	background: #fff;
}

div.bPageBlock div.end-contact-block div.pbSubheader	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;
	font-weight: normal!important;
}

div.bPageBlock div.end-contact-block div.pbSubheader h3	{
	display: inline-block;
	font-size: 17px;
	margin: 0;
	font-weight: normal;
}


div.bPageBlock div.end-contact-block table.detailList th	{
	text-align: right;
}

div.bPageBlock div.end-contact-block table.detailList th,
div.bPageBlock div.end-contact-block table.detailList td	{
	width: 50%;
	padding: 8px;
}

div.bPageBlock div.end-contact-block table.detailList tr:nth-child(even) th,
div.bPageBlock div.end-contact-block table.detailList tr:nth-child(even) td	{
	background: #fafafa;
}

#wrapper div.pbBottomButtons	{
	margin-bottom: 20px;
}

div.pbBottomButtons table	{
	width: 100%;
}

div.pbBottomButtons table td.pbTitle	{
	width: 0;
	padding: 0;
}

div.pbBottomButtons table td.pbButtonb {
	padding: 0;
	width: 100%;
	text-align: center;
}

div.pbBottomButtons table td.pbButtonb input[type="button"],
div.pbBottomButtons table td.pbButtonb input[type="submit"]	{
	background: #312e29;
	color: #fff;
	border: none;
	border-radius: 0;
	text-align: center;
	height: 35px;
	padding: 3px 20px;
	display: inline-block;
	margin-left: 10px;
	min-width: 0;
	border-radius: 2px;
}

/* attributes */

.bPageTitle img	{
	display: none;
}

#wrapper .bPageTitle .ptBody	{
	background: none;
}

#wrapper .bPageTitle .ptBody h1	{
	margin: 0;
}

body .bPageTitle	{
	padding: 0;
	margin-bottom: 10px;
}

div.end-job-seeker-attributes-top	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 40px;
	padding: 23px;
}

div.end-verbal-spiel	{
	display: table-row;	
}

div.end-verbal-spiel-label	{
	vertical-align: middle;
	display: table-cell;
	padding-right: 10px;
}

div.end-verbal-spiel audio	{
	display: table-cell;
}

div.end-verbal-spiel-intro	{
	margin-top: 20px;
}

#wrapper div.end-job-seeker-attributes h2	{
	font-weight: normal;
	font-size: 17px;
	margin: 0;
	padding-bottom: 20px;
}

table.end-attributes	{
	border: none;
	border-spacing: 0;
	border-collapse: collapse;
	background: #fff;
}

#wrapper table.end-attributes table	{
	border: none;
	border-spacing: 0;
	border-collapse: collapse;
}

#wrapper table.end-attributes td	{
	vertical-align: top;
	padding: 0;
}

#wrapper table.end-attributes table td	{
	padding: 10px;
}

table.end-attributes > caption	{
	margin: 0 0 8px;
	text-align: left;
}

table.end-attributes caption	{
	font-size: 14px;
}

table.end-attributes .skillCap	{
	color: #fff!important;
	background: #ee750d!important;
	font-weight: normal!important;
	padding: 8px;
}

div.end-job-seeker-attributes-bottom > div > div > table.detailList > tbody > tr > td.dataCol	{
	width: 50%;
	padding-left: 10px;
	vertical-align: top;
}

div.end-job-seeker-attributes-bottom textarea	{
	margin-top: 10px;
	box-sizing: border-box;
	padding: 10px;
	width: 100%;
	font-size: inherit;
	font-family: inherit;
}

div.end-job-seeker-attributes-bottom ul.attUl	{
	padding: 0 0 0 10px;
	margin: 0;
}

#wrapper div.end-job-seeker-attributes-bottom th.labelCol	{
	text-align: right;
	padding-top: 20px;
	padding-right: 10px;
	vertical-align: top;
	white-space: nowrap;
}

#accordion h3.ui-state-default	{
	color: #fff;
	font-weight: normal;	
}

#accordion h3.ui-state-active	{
	color: #000;
	font-weight: bold;
}

.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default	{
	background: #ee750d;
	border: none;
}

.ui-state-active	{
	background: #fff;
}

#accordion *	{
	border-radius: 0;
	border: none;
	font-size: 14px;
}

#wrapper div.end-job-seeker-attributes div.pbHeader td.pbTitle	{
	width: 100%;
}

#wrapper div.end-job-seeker-attributes .ui-accordion-content table td	{
	padding: 10px;
	vertical-align: top;
}

/* search */

div.end-employer-search div.end-search-buttons	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 30px;
	padding: 45px 23px 23px;
}

div.end-employer-search #centre div.end-search-button	{
	margin-top: -120px;
	text-align: center;
	width: 33%;
	display: inline-block;
}

#centre div.end-search-button div.end-search-btn	{
	display: inline-block;
	padding: 20px;
	background: rgba(0,0,0,.9);
	color: #fff;
	text-transform: uppercase;
	cursor: pointer;
	border-radius: 2px;
}

#centre div.end-search-button div.end-search-btn:hover	{
	background: rgba(0,0,0,.7);
}

#centre div.end-search-button img	{
	display: none;
}

div.end-employer-search #faq	{
	padding-bottom: 20px;
}

div.end-employer-search #faq h2	{
	font-size: 17px;
	font-weight: normal;
	padding-bottom: 20px;
	display: block;
}

div.end-search-nav {
	margin-top: 20px;
}

div.end-employer-search #nav	{
	width: 20%;
	float: left;
	max-height: 665px;
	line-height: 20px;     
	overflow: auto;
	font-size: 12px;
	margin-bottom: 30px;
}

div.end-employer-search div.end-search-results	{
	width: 80%;
	float: left;
}

div.end-employer-search #spiel	{
	clear: both;
	
	background: #fff;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 40px;
	padding: 23px;
}

div.end-employer-search #spiel h2	{
	font-size: 17px;
	font-weight: normal;
}

div.end-employer-search table.detailList tr:nth-child(even) td	{
	background: #fafafa;
}

div.end-employer-search table.detailList td	{
	vertical-align: top;
	padding-left: 10px;
}

div.end-employer-search table.list	{
	border: none;
	border-spacing: 0;
	border-collapse: collapse;
	font-size: 12px;
	margin-bottom: 10px;
}

div.end-employer-search table.list th	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;	
	font-weight: normal!important;
}

div.end-employer-search table.list td	{
	font-size: inherit;
	cursor: pointer;
}

div.end-employer-search div.end-search-data div.mapData {
	margin-bottom: 5px;
}

div.end-employer-search div.end-search-data div.mapData	span {
	display: inline-block;
	width: 108px;
}

div.end-employer-search div.end-search-data div.mapData	> div {
	clear: right;
    display: inline-block;
    float: right;
    margin-bottom: 5px;
    }

div.end-employer-search div.end-search-data div.mapData	> div input {
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #fff;
	height: 27px;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	width: 183px;
}

div.end-employer-search table.detailList div.mapData span {
	font-weight: bold;
	margin-top: 3px;
}

div.end-employer-search table.detailList div.mapData {
	margin-bottom: 5px;
	clear: right;
}

div.end-employer-search table.detailList div.mapData input[type="text"] {
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #fff;
	height: 27px;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	box-sizing: border-box;
	width: 150px;
}

div.end-employer-search table.detailList div.mapData  span.dateInput input	{
	width: 200px;
}

div.end-employer-search table.detailList div.end-employer-search-link-spiel {
	margin-top: 10px;
}

div.end-employer-search table.detailList div.mapData input[type="button"] {
	background: #312e29;
	color: #fff;
	border: none;
	border-radius: 2px;
	text-align: center;
	height: 35px;
	padding: 3px 20px;
	display: inline-block;
	margin: 10px 0 0 0;
	min-width: 0;
}

#mapFrame	{
	margin: 20px 0 0;
	border: none;
}

span.end-page-button input	{
	background: #312e29;
	color: #fff;
	border: none;
	border-radius: 2px;
	text-align: center;
	padding: 3px 5px;
	display: inline-block;
}

#wrapper td.end-employer-search-col1	{
	width: 304px;	
}

#wrapper td.end-employer-search-col2	{
	width: 440px;
}

#wrapper div.end-employer-search span.end-page	{
	padding-top: 3px;
	display: inline-block;
}

#wrapper div.end-employer-search span.end-page-button	{
	float: right;
}

div.end-employer-mapdiv	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto;
	padding: 10px;
}

#indTabs,
#indTabs div	{
	background: none;
    border: none;
    font-size: 12px;
    padding: 0;
}

#indTabs ul	{
	background: none;
	padding: 0;
	margin: 7px 0 10px;
	display: block;
	border: none;
}

#indTabs ul li	{
	display: inline-block;
	float: none;
	background: none;
	padding: 0;
	margin: 0;
	border: none;
}

#indTabs ul li a	{
	font-size: 11px;
	background: #000;
	color: #fff;
	padding: 5px;
	margin-right: 2px;
}

#indTabs ul li.ui-state-active a	{
	background: #666;
}


/* follow up */

#wrapper div.end-followup div.pbBody	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto;
	padding: 23px;
}

#wrapper div.end-followup div.pbBody table.detailList td	{
	padding: 10px;
}

#wrapper div.end-followup div.pbBody table.detailList th	{
	width: 25%;
	padding: 10px;
	white-space: nowrap;
}

/* job seeker */

div.end-job-seeker-top	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto;
	padding: 23px;
}

div.end-job-seeker-top .bPageBlock .detailList .labelCol	{
	width: 50%;
}

div.end-job-seeker-top .bPageTitle .ptBody .content	{
	width: 100%;
	text-align: center;
	padding-left: 0;
}

div.end-job-seeker-tools div.apexp table.detailList > tbody > tr > td	{
	width: 33%;
	padding-left: 10px;
	vertical-align: top;
}

div.end-job-seeker-tools div.apexp table.detailList > tbody > tr > td:first-child	{
	padding-left: 0;
}

div.end-job-seeker-tools table.detailList table	{
	border-spacing: 0;
	border-collapse: collapse;
}

div.end-job-seeker-tools table.detailList table caption	{
	font-style: normal;
	text-align: left;
	font-size: 17px;
	margin: 20px 0 10px 0;
	white-space: nowrap;
}

div.end-job-seeker-tools div.apexp table.detailList table th,
div.end-job-seeker-tools div.apexp table.detailList table td	{
	padding: 8px;
	font-size: 11px;
	border: none;
}

div.end-job-seeker-tools table.detailList table th	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;	
	font-weight: normal!important;
	border: none!important;
}

div.end-job-seeker-tools table.detailList table td	{
	padding: 10px;
	background: #fff;
	cursor: pointer;
}

div.end-job-seeker-tools table.detailList table tr:nth-child(even) td	{
	background: #fafafa;
}

/* job seeker edit */

div.end-job-sseker-edit-top	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 20px;
	padding: 23px;
}

div.end-job-sseker-edit-top input[type="text"]	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2;
	height: 27px;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	min-width: 320px;
}

div.end-job-sseker-edit-top textarea	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	min-width: 320px;
}

/* all followups, all job seekers and all contacts */

div.end-employer-contacts-all table.list,
div.end-followups-all table.list,
div.end-job-seekers-all table.list	{
	margin: 20px 0 50px;
}

div.end-employer-contacts-all table.list th,
div.end-followups-all table.list th,
div.end-job-seekers-all table.list th	{
	text-align: left;
	padding: 10px!important;
	color: #fff!important;
	background: #ee750d!important;
	font-weight: normal!important;
}

div.end-employer-contacts-all table.list td,
div.end-followups-all table.list td,
div.end-job-seekers-all table.list td	{
	cursor: pointer;
	padding: 10px;
	background: #fff;
}

div.end-employer-contacts-all table.list tr:nth-child(even) td,
div.end-followups-all table.list tr:nth-child(even) td,
div.end-job-seekers-all table.list tr:nth-child(even) td	{
	background: #fafafa;
}

div.end-employer-contacts-all table.list caption,
div.end-followups-all table.list caption,
div.end-job-seekers-all table.list caption	{
	text-align: left;
	font-size: 17px;
	padding-bottom: 10px;
}

/* my profile */

div.end-my-profile-top	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 50px;
	padding: 23px;
}

#wrapper div.end-my-profile-top h2	{
	font-size: 17px;
	font-weight: normal;
	margin-bottom: 10px;
}


#wrapper div.end-my-profile-top .pbSubheader	{
	background: #ee750d;
	padding: 10px;
	color: #fff;
}

#wrapper div.end-my-profile-top .pbSubheader h3	{
	font-weight: normal;
	font-size: 14px;
}

div.end-my-profile-top input[type="text"]	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2;
	height: 27px;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	min-width: 240px;
}

div.end-my-profile-top textarea	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	min-width: 240px;
}

#wrapper div.end-my-profile-top .pbBottomButtons	{
	margin-bottom: 0;
}

div.end-help-top	{
	background: #fff;
	max-width: 840px;
	box-shadow: 0 2px 2px rgba(0,0,0, .13);
	margin: 0 auto 50px;
	padding: 23px;
}

div.end-help-top textarea	{
	-webkit-appearance: none;
	border: 1px solid #a0a09d;
	background: #d6d5d2;
	font-family: inherit;
	font-size: inherit;
	padding: 3px 5px;
	width: 100%;
}

#wrapper div.end-help-top th.labelCol	{
	width: 25%;
	vertical-align: top;
}

#wrapper div.end-help-top td.dataCol	{
	width: 75%;
}

#wrapper div.end-help-top td.empty	{
	width: 0;
}