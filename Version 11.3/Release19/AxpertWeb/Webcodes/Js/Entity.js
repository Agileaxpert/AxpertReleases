let isFetching = false;
var dtCulture = eval(callParent('glCulture'));
var _entity;
var _entityCommon;
let currentEditFieldId = null;
var rowData;
var pageNo = 1;

class Entity {
    constructor() {
        this.entityName = '';
        this.entityTransId = '';
        this.metaData = {};
        this.listJson = {};
        this.maxPageNumber = 1;
        this.pageSize = 100;
        this.kpiJson = [];
        this.chartsJson = [];
        this.chartsMetaData = {};
        this.selectedChartsArr = [];
        this.selectedChartCaptions = {};
        this.emptyRowsHtml = `No data found`;
        this.nullRowsHtml = `Configure the fields properly in the 'Select Field(s)' option`;
        this.fields = "All";
        this.keyField = '';
        this.filter = [];
        this.filterObj = {};
        this.allowCreate = true;
        this.isLastPage = false;
        this.tableViewFlag = false;
        this.viewChart = true;
        this.captionsEnabled = false;
        this.lastScrollTop = 0;
        this.lastScrollLeft = 0;
        this.properties = {};
        this.modificationFields = "";
        this.rightPanel = "expanded";

    }

    init() {
        parent.ShowDimmer(false);

        this.getUrlParams();
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.entityTransId = urlParams.get('tstid');

        var entityPageLoadData = document.querySelector("#hdnEntityPageLoadData").value;
        entityPageLoadData = entityPageLoadData.replaceAll("T00:00:00", "");
        entityPageLoadData = JSON.parse(entityPageLoadData);

        this.properties = entityPageLoadData.result.data.Properties;
        this.tableViewFlag = (this.properties.TABLEVIEW && this.properties.TABLEVIEW.toLowerCase() === 'true') || false;
        this.captionsEnabled = (this.properties.CAPTIONVALUE && this.properties.CAPTIONVALUE.toLowerCase() === 'true') || false;

        if (entityPageLoadData.result.data.EntityName) {
            this.entityName = entityPageLoadData.result.data.EntityName;
            document.title = this.entityName;
        }

        this.applyTheme();
        this.rightPanelView();

        highlightInitialSelection();

        document.querySelector("#EntityTitle").innerHTML = this.entityName || entityPageLoadData.result.data.EntityName;
      
        const myDiv = document.getElementById('body_Container');

        try {

            this.metaData = entityPageLoadData.result.data.MetaData;

            var metadataEntry = this.metaData.find(meta => meta.dcname === 'dc1');
            var tablename = metadataEntry ? metadataEntry.tablename : null;

            // Parse the entity list data
            this.listJson = entityPageLoadData.result.data.ListData?.[0]?.data_json ? JSON.parse(entityPageLoadData.result.data.ListData[0].data_json) : [];
            this.fields = this.properties.FIELDS || "All";
            this.keyField = this.properties.KEYFIELD || "";


            if (this.properties.CHARTS)
                this.selectedChartsArr = JSON.parse(this.properties.CHARTS);


            this.maxPageNumber = entityPageLoadData.result.data.PageNo;

            if (_entityCommon.isValid(this.properties.FILTERS)) {
                _entityFilter.filterObj = JSON.parse(this.properties.FILTERS);
                _entityFilter.createFilterPills();
            }

            if (this.fields == "All")
                this.modificationFields = "modifiedon,modifiedby,createdby,createdon";
            else
                this.modificationFields = this.properties.MODIFICATIONFIELDS || "";

            if (this.listJson?.length > 0) {
                this.populateInitialView();
                this.initCharts();
            }

            this.bindEvents();

            this.addCustomParams();
            parent.ShowDimmer(false);
        } catch (error) {
            showAlertDialog("error", "Error occurred. Please check with administrator.");
            console.error(error);
        }
    }


    rightPanelView() {
        let _this = this;
        const viewChartState = _this.properties.RIGHTPANEL || "expanded";
        if (viewChartState === "expanded") {
            document.getElementById("Entity_management_Right").style.setProperty("display", "block", "important");
            document.querySelector("button[onclick='toggleRightPanel();']").style.setProperty("display", "none", "important");
        } else {
            document.getElementById("Entity_management_Right").style.setProperty("display", "none", "important");
            document.querySelector("button[onclick='toggleRightPanel();']").style.setProperty("display", "inline-block", "important");
        }
    }

    addCustomParams() {
        var _this = this;
        var metadataEntry = _this.metaData.find(meta => meta.dcname === 'dc1');
        var tablename = metadataEntry ? metadataEntry.tablename : null;

        _this.metaData.push({
            "ftransid": _this.entityTransId,
            "fcaption": _this.entityName,
            "fldname": "createdon",
            "fldcap": "Created on",
            "cdatatype": "Date",
            "fdatatype": "d",
            "fmodeofentry": "calculate",
            "hide": "F",
            "props": null,
            "normalized": "F",
            "allowempty": "T",
            "filtertype": "Text",
            "tablename": tablename,
            "dcname": "dc1"
        });
        _this.metaData.push({
            "ftransid": _this.entityTransId,
            "fcaption": _this.entityName,
            "fldname": "createdby",
            "fldcap": "Created by",
            "cdatatype": "DropDown",
            "fdatatype": "c",
            "fmodeofentry": "calculate",
            "hide": "F",
            "props": null,
            "normalized": "F",
            "allowempty": "T",
            "filtertype": "Text",
            "tablename": tablename,
            "dcname": "dc1"
        });
        _this.metaData.push({
            "ftransid": _this.entityTransId,
            "fcaption": _this.entityName,
            "fldname": "modifiedon",
            "fldcap": "Modified on",
            "cdatatype": "Date",
            "fdatatype": "d",
            "fmodeofentry": "calculate",
            "hide": "F",
            "props": null,
            "normalized": "F",
            "allowempty": "T",
            "filtertype": "Text",
            "tablename": tablename,
            "dcname": "dc1"
        });
        _this.metaData.push({
            "ftransid": _this.entityTransId,
            "fcaption": _this.entityName,
            "fldname": "username",
            "fldcap": "Modified by",
            "cdatatype": "DropDown",
            "fdatatype": "c",
            "fmodeofentry": "calculate",
            "hide": "F",
            "props": null,
            "normalized": "F",
            "allowempty": "T",
            "filtertype": "Text",
            "tablename": tablename,
            "dcname": "dc1"
        });
    }

    generateHTMLBasedOnDataType(fldProps, rowData) {
        var _this = this;
        var fldkey = fldProps.fldname;
        var fldtype = getFieldDataType(fldProps);
        var fldcap = fldProps.fldcap ? fldProps.fldcap.replaceAll("*", "") : '';
        var fProps = fldProps.props;
        var fldValue = rowData[fldkey];

        // Skip "Modified On" and "Modified By" fields
        if (fldkey.toLowerCase() === 'modifiedon' || fldkey.toLowerCase() === 'username' || fldkey.toLowerCase() === 'createdby' || fldkey.toLowerCase() === 'createdon') {
            return '';
        }

        if (_entity.inValid(fldValue) && fldtype.toUpperCase() != "BUTTON")
            return '';

        let html = '';

        const tooltipAttr = _this.captionsEnabled ? '' : `data-toggle="tooltip" data-placement="top" title="${fldcap}"`;

        if (_this.captionsEnabled) {
            html = `<div class="Data-fields-items" ${tooltipAttr}>
                        <div class="caption-style">
                            <span class="txt-bold Data-field-caption">${fldcap}</span>
                            <span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>
                    </div>`;
        }

        switch (fldtype.toUpperCase()) {
            case 'LARGE TEXT':
                html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <p class="task-description moretext" style="margin-bottom:0px !important;">${fldValue}</p>
                            <a class="moreless-button" href="#">Read more</a>
                        </div>`;
                break;
            case 'SHORT TEXT':
                html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">description</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'CURRENCY':
                html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">payments</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'DATE':
                // Format the date value
                var formattedDate = formatDate(fldValue.replace("T00:00:00", ""), dateFormat);

                // When captions are enabled
                if (_this.captionsEnabled) {
                    html = `<div class="Data-fields-items Date-field" ${tooltipAttr}>
                                    <div class="caption-style">
                                        <span class="txt-bold Data-field-caption">${fldcap}</span>
                                        <span class="txt-bold Data-field-value">${formattedDate}</span> <!-- Use formatted date here -->
                                    </div>
                                </div>`;
                } else {
                    // Default case when captions are not enabled
                    html = `<div class="Data-fields-items Date-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                                    <span class="material-icons material-icons-style material-icons-2">today</span>
                                    <span class="txt-bold Data-field-value">${formattedDate}</span>
                                </div>`;
                }
                break;

            case 'TIME':
                html = html || `<div class="Data-fields-items Time-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">schedule</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'LINK':
                html = html || `<div class="Data-fields-items link-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">link</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'MOBILE':
                html = html || `<div class="Data-fields-items Email-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">phone</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'PHONE':
                html = html || `<div class="Data-fields-items Email-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">phone</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'PINCODE':
                html = html || `<div class="Data-fields-items Email-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">location_on</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'ZIPCODE':
                html = html || `<div class="Data-fields-items Email-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">location_on</span><span class="txt-bold Data-field-value">${fldValue}</span>
                        </div>`;
                break;
            case 'EMAIL':
                html = html || `<div class="Data-fields-items Email-field truncate" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                            <span class="material-icons material-icons-style material-icons-2">mail</span><span class="txt-bold Data-field-value" data-text="${fldValue}" onclick="showPopup(this)">${fldValue}</span>
                        </div>`;
                break;
            case 'BOOL':
                if (fldValue === "T" || fldValue === "F") {
                    html = html || `<div class="Data-fields-items Email-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" role="switch" ${fldValue === "T" ? 'checked' : ''} readonly>
                                    <span class="txt-bold Data-field-value">${fldcap}</span>
                                </div>
                            </div>`;
                } else {
                    html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                                <span class="txt-bold Data-field-value">${fldValue}</span>
                            </div>`;
                }
                break;
            case 'BUTTON':
                var propsVal = fProps.split("|");
                var iconVal = propsVal[0].split("~")[1];
                html = html || `<a href="javascript:void(0)" title="View form"
                           class="btn btn-white btn-color-gray-700 btn-active-primary d-inline-flex align-items-center btn-sm me-2 ">
                            <span class="material-icons material-icons-style material-icons-2" style="color: darkmagenta;">${iconVal}</span>${fldcap}
                        </a>`;
                break;
            case 'ATTACHMENTS':
                if (fldValue?.length > 0) {
                    var fileObj = parseFilePath(fldValue);
                    if (fileObj.filename?.length > 0) {
                        var fileType = getFileType(fldValue);
                        var iconClass = getIconClass(fileType);
                        html = html || `<div class="Files-Attached" ${tooltipAttr}>
                                    ${iconClass}
                                    <div class="ms-1 fw-semibold">
                                        <a class="attached-filename" onclick="downloadFileFromPath('${fileObj.folder.replaceAll("\\", "\\\\")}','${fileObj.filename}.${fileObj.ext}')">${fileObj.filename}</a>
                                    </div>
                                </div>`;
                    }
                }
                break;
            default:
                if (fldValue === "T" || fldValue === "F") {
                    html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                                <div class="d-flex align-items-center">
                                    <div class="form-check ms-1">
                                        <input class="form-check-input" type="checkbox" ${fldValue === "T" ? 'checked' : ''} readonly disabled>
                                    </div>
                                </div>
                            </div>`;
                } else {
                    html = html || `<div class="Data-fields-items Department-field" ${tooltipAttr} data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
                                <span class="txt-bold Data-field-value">${fldValue}</span>
                            </div>`;
                }
        }
        return html;
    }



    populateInitialView() {
        const myDiv = document.getElementById('body_Container');

        myDiv.removeEventListener('scroll', scrollListener);

        if (this.tableViewFlag) {
            toggleView();
        } else {
            createListHTML(this.listJson, pageNo);

            myDiv.addEventListener('scroll', scrollListener);
        }

        $('[data-toggle="tooltip"]').tooltip();
        initReadMore();
    }

    toggleCaptions() {
        this.captionsEnabled = !this.captionsEnabled;

        const data = {
            page: "Entity",
            transId: _entity.entityTransId,
            properties: {
                CAPTIONVALUE: this.captionsEnabled
            },
            confirmNeeded: true,
            allUsers: false
        };

        _entityCommon.setAnalyticsDataWS(data, () => {
            this.captionsEnabled = !this.captionsEnabled;
            _entity.saveCaptionValue();
            _entity.refreshData();
        }, (error) => {
            showAlertDialog("error", error.status + " " + error.statusText);
        });
    }


    saveCaptionValue() {
        var data = {
            page: "Entity",
            transId: _entity.entityTransId,
            properties: { CAPTIONVALUE: this.captionsEnabled },
            allUsers: false
        };

        _entityCommon.setAnalyticsDataWS(data, () => {
            _this.refreshData();
        }, (error) => {
            console.error('Error in SetEntityFieldsWS:', error);
            ShowDimmer(false);
        });
    }


    refreshData() {
        _entity.reloadEntityPage();
    }


    generateCustomKPIHTML(jsonData, caption) {
        let html = '';
        jsonData.forEach(function (obj) {
            let criterianodeResponse = obj.criteria || '';

            let criteriaItems = criterianodeResponse.split('~');
            let transid = criteriaItems[1].trim();
            let fldname = criteriaItems[2].trim();

            html += `
           <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
    <a href="#" class="Invoice-item" >
        <div class="Invoice-icon">
            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
        </div>
        <div class="Invoice-content" >
            <h6 class="subtitle" data-keyname="${obj.keyname || caption}" onclick="navigateToListPage('${transid}', '${fldname}', this)">${obj.keyname || caption}</h6>
            <h3 class="title">${obj.keyvalue?.toLocaleString() || 0}</h3>
        </div>
        <div class="Invoice-icon2"></div>
    </a>
</div>

        `;
        });

        // Return the generated HTML
        return html;
    }


    getEntityListData(pageNo) {
        
        let _this = this;
        let url = "../aspx/Entity.aspx/GetEntityListDataWS";

        let data = { transId: _this.entityTransId, fields: _this.fields, pageNo: pageNo, pageSize: _this.pageSize, filter: _this.filter };

        if (pageNo == 1)
            _this.isLastPage = false;

        if (_this.isLastPage) {
            parent.ShowDimmer(false);
            return;
        }

        this.callAPI(url, data, false, result => {
            if (result.success) {
                parent.ShowDimmer(false);
                let listJson = JSON.parse(JSON.parse(result.response).d);
                listJson = listJson.result.data.ListData?.[0]?.data_json ?? "[]";

                try {
                    if (listJson.constructor != Array)
                        listJson = JSON.parse(listJson);
                }
                catch {
                    showAlertDialog("error", "Error occurred in data fetch.");
                    return;
                }

                if (listJson.length === 0) {
                    if (pageNo === 1) {
                        _this.listJson = [];
                        document.querySelector("#body_Container").innerHTML = _this.emptyRowsHtml;
                        document.querySelector("#table-body_Container").innerHTML = _this.emptyRowsHtml;
                    } else {
                        _this.isLastPage = true;
                        noMoreRecordsMessage.style.display = 'block';
                        setTimeout(function () {
                            noMoreRecordsMessage.style.display = 'none';
                        }, 3000);
                    }
                    return;
                } else {
                    if (pageNo === 1) {
                        _this.listJson = [];
                        document.querySelector("#body_Container").innerHTML = "";
                        document.querySelector("#table-body_Container").innerHTML = "";
                    }

                    _this.listJson.push(...listJson);

                    _this.maxPageNumber = pageNo;

                    const createHTMLFunction = (_entity.viewMode === 'table') ? createTableViewHTML : createListHTML;
                    createHTMLFunction(_this.listJson, pageNo);

                    $('[data-toggle="tooltip"]').tooltip();
                    initReadMore();
                }
            } else {
                parent.ShowDimmer(false);
            }
        });
    }


    hideChartsMenu() {
        document.querySelector("#add_chart")?.click();
    }

    openEntityForm(entityName, transId, recordId, keyValue, rowNo) {
        let _this = this;
        _this.updateRelatedData(transId, rowNo);

        var url = `../aspx/EntityForm.aspx?ename=${entityName}&tstid=${transId}&recid=${recordId}&keyval=${keyValue}`;
        parent.LoadIframe(url);
    }

    updateRelatedData(transId, rowNo) {
        let _this = this;
        if (!window.top.entityNavList)
            window.top.entityNavList = {};

        window.top.entityNavList[transId] = _this.getNearestRecords(rowNo);
        window.top.entityNavList.lastTransId = transId;
        window.top.entityNavList.lastCaption = `Other ${_this.entityName}`;
    }

    getSelectedChartsCriteria() {
        let _this = this;
        let criteriaArr = [];
        _this.selectedCharts.split("^").forEach((chart) => {
            var chartItems = chart.split("~");
            const grpFldVal = chartItems[1];
            const aggFldVal = chartItems[2];
            if (grpFldVal != "") {
                const fldData = _this.chartsMetaData["GroupFld"][grpFldVal];
                criteriaArr.push(`${chart}~${fldData.normalized}~${fldData.srctable || ""}~${fldData.srcfield || ""}~${fldData.allowempty}~${fldData.tablename}~~`);
            }
            else {
                const fldData = _this.chartsMetaData["AggFld"][aggFldVal];
                criteriaArr.push(`${chart}~${fldData.normalized}~${fldData.srctable || ""}~${fldData.srcfield || ""}~${fldData.allowempty}~${fldData.tablename}~~`);
            }
        })
        return criteriaArr.join("^");
    }

    getChartCriteria(criteria) {
        let parts = criteria.split("~");
        let result = parts.slice(0, 4).join("~");
        return result;
    }

    generateGeneralKPIHTML(data) {
        let html = '';

        html += `
        <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
            <a href="#" class="Invoice-item">
                <div class="Invoice-icon">
                    <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                </div>
                <div class="Invoice-content">
                    <h6 class="subtitle" onclick="navigateToPeriod('total')">Total</h6>
                    <h3 class="title">${data.totrec || 0}</h3>
                </div>
                <div class="Invoice-icon2"></div>
            </a>
        </div>
    `;

        if (data.cyear !== 0) {
            html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle" onclick="navigateToPeriod('year')">This year</h6>
                        <h3 class="title">${data.cyear || 0}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        }

        if (data.cmonth !== 0) {
            html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle" onclick="navigateToPeriod('month')">This month</h6>
                        <h3 class="title">${data.cmonth || 0}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        }

        if (data.cweek !== 0) {
            html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle" onclick="navigateToPeriod('week')">This week</h6>
                        <h3 class="title">${data.cweek || 0}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        }

        if (data.cyesterday !== 0) {
            html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle" onclick="navigateToPeriod('yesterday')">Yesterday</h6>
                        <h3 class="title">${data.cyesterday || 0}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        }

        if (data.ctoday !== 0) {
            html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle" onclick="navigateToPeriod('today')">Today</h6>
                        <h3 class="title">${data.ctoday || 0}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        }

        return html;
    }

    getEntityChartsData(input, condition) {
        let _this = this;
        let url = `/aspx/Analytics.aspx/GetAnalyticsChartsDataWS`
        if (condition != "General") {
            url = `/aspx/Analytics.aspx/GetAnalyticsMultipleChartsDataWS`
        }

        $.ajax({
            url: top.window.location.href.toLowerCase().substring(0, top.window.location.href.toLowerCase().indexOf("/aspx/")) + url,
            type: 'POST',
            cache: false,
            async: true,
            dataType: 'json',
            data: JSON.stringify(input),
            contentType: "application/json",
            success: function (data) {
                try {
                    var result = JSON.parse(data.d);

                    if (result.result.success) {
                        var chartsData = JSON.parse(result.result.charts[0].data_json);
                    }
                    //handleValidChartData();

                    if (condition == "General") {
                        if (chartsData.length > 0) {
                            var kpiJson = chartsData[0];
                            var html = _entity.generateGeneralKPIHTML(kpiJson);
                            document.querySelector('#KPI-2 .row').innerHTML = html;
                            return;
                        }
                    } else {
                        document.querySelector("#Homepage_CardsList_Wrapper").innerHTML = "";
                        // Handle other conditions if needed
                        if (chartsData.length > 0) {
                            //document.querySelector("#Homepage_CardsList_Wrapper").innerHTML = "";

                            var result = JSON.parse(data.d);

                            if (result.result.success) {
                                _this.chartsJson = result;
                            }

                            //_this.chartsJson = JSON.parse(JSON.parse(result.response).d);
                            //_this.chartsJson.result.charts = JSON.parse(_this.chartsJson.result.charts[0].data_json);
                            try {
                                //const groupedChartData = {};
                                //_this.chartsJson.result.charts.forEach(chartsData => {
                                //    var chartData = JSON.parse(chartsData.data_json);
                                //    chartData.forEach(item => {
                                //        const { criteria, keyname, keyvalue } = item;

                                //        if (!groupedChartData[criteria]) {
                                //            groupedChartData[criteria] = [];
                                //        }

                                //        groupedChartData[criteria].push({ "data_label": keyname, "value": keyvalue });
                                //    });
                                //});



                                var finalDataObj = [];


                                //Object.entries(groupedChartData).forEach(([key, value]) => {
                                _this.chartsJson.result.charts.forEach((chartsData, idx) => {
                                    let tempChartJson = JSON.parse(chartsData.data_json);
                                    let criteria = _this.getChartCriteria(tempChartJson[0].criteria);

                                    var chartJson = JSON.parse(chartsData.data_json).map(item => {
                                        return { data_label: item.keyname, value: item.keyvalue };
                                    });

                                    finalDataObj.push({
                                        "chartsid": "chart" + idx.toString(),
                                        "charttype": "chart",
                                        "chartjson": JSON.stringify(chartJson),
                                        "chartname": `${_this.getChartCaptions(criteria)}`

                                    });

                                });

                                //_this.chartsJson.result.charts.forEach(entry => {
                                //    finalDataObj.push({
                                //        "chartsid": entry.criteria,
                                //        "charttype": "chart",
                                //        "chartjson": JSON.stringify({ "data_label": entry.keyname, "value": entry.keyvalue }),  //entry.data_json.replaceAll("keyname", "data_label").replaceAll("keyvalue", "value"),
                                //        "chartname": `${this.selectedChartsObj[entry.criteria]}`

                                //    });
                                //});

                                _this.chartsJson = finalDataObj;

                            }

                            catch (e) {
                                console.log("Error in charts" + e);
                                return;
                            }
                        } else {
                            handleNoChartData();
                        }
                    }

                    // Load additional resources and initialize UI
                    var LoadIframe = callParentNew("LoadIframe");
                    var cardsData = {}, cardsDesign = {}, xmlMenuData = "", menuJson = "";
                    let cardsDashboardObj = {
                        dirLeft: true,
                        enableMasonry: false,
                        homePageType: "cards",
                        isCardsDashboard: true,
                        isMobile: isMobileDevice(),
                    };
                    var files = {
                        css: [],
                        js: []
                    };

                    // Add JavaScript and CSS files
                    files.js.push("/ThirdParty/lodash.min.js");
                    files.js.push("/ThirdParty/deepdash.min.js");
                    files.js.push("/Js/handlebars.min.js?v=1");
                    files.js.push("/Js/handleBarsHelpers.min.js");
                    files.js.push("/ThirdParty/Highcharts/highcharts.js");
                    files.js.push("/ThirdParty/Highcharts/highcharts-3d.js");
                    files.js.push("/ThirdParty/Highcharts/highcharts-more.js");
                    files.js.push("/ThirdParty/Highcharts/highcharts-exporting.js");
                    files.js.push("/Js/high-charts-functions.js?v=20");
                    files.js.push("/Js/AxInterface.js?v=10");
                    //files.js.push("/ThirdParty/DataTables-1.10.13/media/js/jquery.dataTables.js");
                    //files.js.push("/ThirdParty/DataTables-1.10.13/media/js/dataTables.bootstrap.js");
                    files.js.push("/ThirdParty/DataTables-1.10.13/extensions/Extras/moment.min.js");
                    files.css.push("/ThirdParty/fullcalendar/lib/main.min.css");
                    files.js.push("/ThirdParty/fullcalendar/lib/main.min.js");

                    if (cardsDashboardObj.isMobile) {
                        files.js.push("/ThirdParty/jquery-ui-touch-punch-master/jquery.ui.touch-punch.min.js");
                    }

                    if (cardsDashboardObj.enableMasonry) {
                        files.js.push("/ThirdParty/masonry/masonry.pkgd.min.js");
                    }

                    files.js.push(`/js/entity-charts.min.js?v=3`);

                    if (document.getElementsByTagName("body")[0].classList.contains("btextDir-rtl")) {
                        cardsDashboardObj.dirLeft = false;
                    }

                    loadAndCall({
                        files: files,
                        callBack: () => {

                            $(function () {

                                ShowDimmer(true);
                                deepdash(_);
                                var cardVisibleArray = [];
                                //var chartsJson = _entity.getEntityChartsData();


                                cardsData.value = JSON.stringify(_entity.chartsJson);
                                cardsDesign.value = JSON.stringify(cardVisibleArray);
                                xmlMenuData = "";

                                //start cards dasboard Init

                                if (xmlMenuData != "") {
                                    xmlMenuData = xmlMenuData.replace(/'/g, "'");
                                    var xml = parseXml(xmlMenuData)
                                    var xmltojson = xml2json(xml, "");
                                    menuJson = JSON.parse(xmltojson);
                                }
                                appGlobalVarsObject._CONSTANTS.menuConfiguration = $.extend(true, {},
                                    appGlobalVarsObject._CONSTANTS.menuConfiguration, {
                                    menuJson: menuJson,
                                });
                                // try {

                                appGlobalVarsObject._CONSTANTS.cardsPage = {
                                    setCards: false,
                                    cards: []
                                }

                                $.axpertUI.options.cardsPage.cards = [];
                                appGlobalVarsObject._CONSTANTS.cardsPage = $.extend(true, {},
                                    appGlobalVarsObject._CONSTANTS.cardsPage, {
                                    setCards: true,
                                    cards: (JSON.parse(cardsData.value !== "" ? ReverseCheckSpecialChars(cardsData.value) : "[]",
                                        function (k, v) {
                                            try {
                                                return (typeof v === "object" || isNaN(v) || v.toString().trim() === "") ? v : (typeof v == "string" && (v.startsWith("0") || v.startsWith("-")) ? parseFloat(v, 10) : JSON.parse(v));
                                            } catch (ex) {
                                                return v;
                                            }
                                        }
                                    ) || []).map(arr => _.mapKeys(arr, (value, key) => key.toString().toLowerCase())),
                                    design: (JSON.parse(cardsDesign.value !== "" ? cardsDesign.value : "[]",
                                        function (k, v) {
                                            try {
                                                return (typeof v === "object" || isNaN(v) || v.toString().trim() === "") ? v : (typeof v == "string" && (v.startsWith("0") || v.startsWith("-")) ? parseFloat(v, 10) : JSON.parse(v));
                                            } catch (ex) {
                                                return v;
                                            }
                                        }
                                    ) || []).map(arr => _.mapKeys(arr, (value, key) => key.toString().toLowerCase())),
                                    enableMasonry: cardsDashboardObj.enableMasonry,
                                    staging: {
                                        iframes: ".splitter-wrapper",
                                        cardsFrame: {
                                            div: ".cardsPageWrapper",
                                            cardsDiv: "#Homepage_CardsList_Wrapper",
                                            cardsDesigner: ".cardsDesigner",
                                            cardsDesignerToolbar: ".designer",
                                            editSaveButton: ".editSaveCardDesign",
                                            icon: "span.material-icons",
                                            divControl: "#arrangeCards"
                                        },
                                    }
                                });

                                var lcm = appGlobalVarsObject.lcm;
                                var tempaxpertUIObj = $.axpertUI
                                    .init({
                                        isHybrid: appGlobalVarsObject._CONSTANTS.isHybrid,
                                        isMobile: cardsDashboardObj.isMobile,
                                        compressedMode: appGlobalVarsObject._CONSTANTS.compressedMode,
                                        dirLeft: cardsDashboardObj.dirLeft,
                                        axpertUserSettings: {
                                            settings: appGlobalVarsObject._CONSTANTS.axpertUserSettings
                                        },
                                        cardsPage: appGlobalVarsObject._CONSTANTS.cardsPage
                                    });

                                appGlobalVarsObject._CONSTANTS.cardsPage = tempaxpertUIObj.cardsPage;

                                ShowDimmer(false);
                            });

                            $.axpertUI.cardsPage._addCardHeader = function (cardElement, card) {

                                cardElement.find(".card-title").attr("title", (card["chartname"] || "")).find("headerContent").replaceWith(card["chartname"] || "");
                                cardElement.find(".card-header").attr("data-bs-target", `#${card["chartsid"].replaceAll("~", "")}`);
                                cardElement.find(".KC_Items_Content").attr("id", `${card["chartsid"].replaceAll("~", "")}`);
                                cardElement.attr("title", (card["chartname"] || ""));


                                var toolBarHtml = `<span class="material-icons material-icons-style" onclick="_entity.deleteChart('${card["chartsid"]}')">close</span>`;
                                cardElement.find("toolbarContent").replaceWith(toolBarHtml);

                            }
                        }
                    });


                } catch (e) {
                    console.error("Error processing summary data:", e);
                }
            }

        });
    }

    createChartsFieldsForSelection() {
        let _this = this;

        const groupedFields = {
            "GroupFld": {},
            "AggFld": {}
        };

        const gfldSelect = document.querySelector("select#grpFld");
        _this.metaData.filter(chart => chart.grpfield === "T" && chart.listingfld === "T").forEach(chart => {
            const option = document.createElement("option");
            option.value = chart.fldname;
            option.textContent = `${chart.fldcap || ''}(${chart.fldname})`;
            gfldSelect.appendChild(option);

            groupedFields["GroupFld"][chart.fldname] = {
                "cnd": chart.cnd,
                "fldcap": chart.fldcap || '',
                "fldname": chart.fldname,
                "normalized": chart.normalized,
                "allowempty": chart.allowempty,
                "srctable": chart.srctable,
                "srcfield": chart.srcfield,
                "tablename": chart.tablename
            };
        });

        const aEntSelect = document.querySelector("select#subEnt");
        if (aEntSelect) {
            const option = document.createElement("option");
            option.value = _this.entityTransId;
            option.textContent = `${_this.entityName}(${_this.entityTransId})`;
            aEntSelect.appendChild(option);
        }

        const afldSelect = document.querySelector("select#aggFld");
        _this.metaData.filter(chart => chart.aggfield === "T" && chart.listingfld === "T").forEach(chart => {
            const option = document.createElement("option");
            option.value = chart.fldname;
            option.textContent = `${chart.fldcap || ''}(${chart.fldname})`;
            afldSelect.appendChild(option);

            groupedFields["AggFld"][chart.fldname] = {
                "cnd": chart.cnd,
                "fldcap": chart.fldcap || '',
                "fldname": chart.fldname,
                "normalized": chart.normalized,
                "allowempty": chart.allowempty,
                "srctable": chart.srctable,
                "srcfield": chart.srcfield,
                "tablename": chart.tablename

            };
        });

        document.getElementById('aggFld').addEventListener('change', function () {
            const aggCondSelect = document.getElementById('aggCond');
            if (this.value === 'count') {
                aggCondSelect.value = 0;
                aggCondSelect.disabled = true;
            } else {
                aggCondSelect.value = "sum";
                aggCondSelect.disabled = false;
            }
        });

        this.chartsMetaData = groupedFields;
    }
    getSelectedCharts() {
        let _this = this;

        var grpFldVal = document.getElementById("grpFld").value;
        var aggCondVal = document.getElementById("aggCond").value;
        var aggFldVal = document.getElementById("aggFld").value;
        // Construct the payload

        let data = {
            aggField: "count",
            aggFunc: "count",
            aggTransId: _this.entityTransId,
            groupField: "all",
            groupTransId: _this.entityTransId,
            page: "Entity",
            transId: _this.entityTransId
        };
        _this.getEntityChartsData(data, "General");

        if (this.selectedChartsArr.length) {
            let data = {
                page: "Entity",
                transId: _this.entityTransId,
                charts: this.selectedChartsArr
            };

            _this.getEntityChartsData(data);
            document.querySelector(".NO-KPI-Items").classList.add("d-none");
        } else {
            document.querySelector(".NO-KPI-Items").classList.remove("d-none");
        }

        ShowDimmer();



        // AJAX call to get selected charts
        // $.ajax({
        //     url: top.window.location.href.toLowerCase().substring(0, top.window.location.href.toLowerCase().indexOf("/aspx/")) + '/aspx/Analytics.aspx/GetAnalyticsChartsDataWS',
        //       type: 'POST',
        //     contentType: 'application/json',
        //     data: JSON.stringify(data),
        //     success: function (result) {
        //         if (result.d) {
        //             let parsedResult = JSON.parse(result.d);  // Parse result.d first

        //             if (parsedResult.result.success) {
        //                 _this.selectedCharts = parsedResult.result.charts;
        //                 let entityPageLoadData = JSON.parse(document.querySelector("#hdnEntityPageLoadData").value);

        //                this.properties.Charts = _this.selectedCharts;

        //                if (_this.selectedCharts != "") {
        //                 _this.getEntityChartsData(data);
        //                 // _this.getChartCaptions();
        //                 document.querySelector(".NO-KPI-Items").classList.add("d-none");
        //             }else {
        //                     document.querySelector(".NO-KPI-Items").classList.remove("d-none");
        //                 }

        //                 ShowDimmer();

        //         }
        //          else {
        //             ShowDimmer(false);
        //         }
        //     },
        //     error: function () {
        //         ShowDimmer(false);
        //         console.error("Error fetching selected charts");
        //     }
        // });
    }


    // getSelectedCharts() {
    //     let _this = this;
    //     let url = "../aspx/Entity.aspx/GetSelectedEntityChartsWS";
    //     let data = { transId: _this.entityTransId };
    //     this.callAPI(url, data, true, result => {
    //         if (result.success) {
    //             _this.selectedCharts = JSON.parse(result.response).d;
    //             if (_this.selectedCharts != "") {
    //                 _this.getEntityChartsData('Custom');
    //                 // _this.getChartCaptions();
    //                 document.querySelector(".NO-KPI-Items").classList.add("d-none");
    //             }
    //             else {
    //                 document.querySelector(".NO-KPI-Items").classList.remove("d-none");
    //             }
    //             ShowDimmer(false);
    //         } else {
    //             ShowDimmer(false);
    //         }
    //     });
    // }



    setSelectedCharts() {
        let _this = this;

        var data = {
            page: "Entity",
            transId: _this.entityTransId,
            properties: { "CHARTS": JSON.stringify(this.selectedChartsArr) },
            confirmNeeded: true,
            allUsers: true
        }

        _entityCommon.setAnalyticsDataWS(data, () => {
            window.location.reload();
        }, (error) => {
            showAlertDialog("error", error.status + " " + error.statusText);
        })
    }



    clearChartSelection() {
        if (!confirm("Clear all Charts?"))
            return;

        let _this = this;
        _this.selectedChartsArr = [];
        this.setSelectedCharts();
    }

    applyChartSelection() {
        let _this = this;

        // Get values from UI elements
        var grpFldVal = document.getElementById("grpFld").value;
        var aggCondVal = document.getElementById("aggCond").value;
        var aggFldVal = document.getElementById("aggFld").value;

        // Validate the inputs
        if (aggFldVal == "count") {
            aggCondVal = "count";
        } else if (aggCondVal === "0") {
            showAlertDialog("error", "Select a valid Display function");
            document.getElementById("aggCond").focus();
            return;
        }

        if (grpFldVal === "0") {
            grpFldVal = "";
        }

        let chart = {
            aggField: aggFldVal,
            aggFunc: aggCondVal,
            aggTransId: _this.entityTransId,
            groupField: grpFldVal,
            groupTransId: _this.entityTransId,
            page: "Entity",
            transId: _this.entityTransId
        };

        let chartData = {
            aggField: chart.aggField,
            aggFunc: chart.aggFunc,
            aggTransId: chart.aggTransId,
            groupField: chart.groupField,
            groupTransId: chart.groupTransId
        };

        this.selectedChartsArr.push(chartData);

        this.setSelectedCharts();

        document.querySelector(".NO-KPI-Items").classList.add("d-none");
    }

    getChartCaptions(chart) {
        let _this = this;
        if (!_this.selectedChartCaptions[chart]) {
            var chartItems = chart.split("~");
            const grpFldVal = chartItems[1];
            const grpFldData = _this.chartsMetaData["GroupFld"][grpFldVal];
            const aggCondVal = chartItems[3];
            const aggFldVal = chartItems[2];
            const aggFldData = _this.chartsMetaData["AggFld"][aggFldVal];
            var chartStr = "";
            if (aggCondVal == "count")
                chartStr = `${grpFldData.fldcap || ''} wise ${aggCondVal}`;
            else {
                if (grpFldVal != "")
                    chartStr = `${grpFldData.fldcap || ''} wise ${aggFldData.fldcap || ''}(${aggCondVal})`;
                else
                    chartStr = `${aggFldData.fldcap || ''}(${aggCondVal})`;
            }
            _this.selectedChartCaptions[chart] = chartStr;
        }
        return _this.selectedChartCaptions[chart];
    }

    filterByFldname(metaData, fldname) {
        return metaData.filter(obj => obj.fldname === fldname);
    }

    setSelectedFields() {
        let _this = this;

        var data = {
            page: "Entity",
            transId: _this.entityTransId,
            properties: {
                KEYFIELD: _this.keyField,
                FIELDS: _this.fields
            },
            allUsers: false
        }

        _entityCommon.setAnalyticsDataWS(data, () => {
            _this.reloadEntityPage();
        }, (error) => {
            console.error('Error in SetEntityFieldsWS:', error);
            ShowDimmer(false);
        })
    }




    reloadPage() {
        window.location.reload();
    }

    deleteChart(chart) {
        if (!confirm("Delete this chart?"))
            return;

        let _this = this;

        let chartIdx = chart.replace("chart", "");
        chartIdx = parseInt(chartIdx);

        if (chartIdx > -1) {
            this.selectedChartsArr.splice(chartIdx, 1);
        }

        this.setSelectedCharts();

    }

    generateGeneralKPIHTML(data) {
        let html = '';
        html += `
            <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                <a href="#" class="Invoice-item">
                    <div class="Invoice-icon">
                        <span class="material-icons material-icons-style material-icons-2">bar_chart</span><i class="fas fa-signal"></i>
                    </div>
                    <div class="Invoice-content">
                        <h6 class="subtitle">Total</h6>
                        <h3 class="title">${data.totrec}</h3>
                    </div>
                    <div class="Invoice-icon2"></div>
                </a>
            </div>
        `;
        if (data.cyear !== 0) {
            html += `
                <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                    <a href="#" class="Invoice-item">
                        <div class="Invoice-icon">
                            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                        </div>
                        <div class="Invoice-content">
                            <h6 class="subtitle">This year</h6>
                            <h3 class="title">${data.cyear}</h3>
                        </div>
                        <div class="Invoice-icon2"></div>
                    </a>
                </div>
            `;
        }
        if (data.cmonth !== 0) {
            html += `
                <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                    <a href="#" class="Invoice-item">
                        <div class="Invoice-icon">
                            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                        </div>
                        <div class="Invoice-content">
                            <h6 class="subtitle">This month</h6>
                            <h3 class="title">${data.cmonth}</h3>
                        </div>
                        <div class="Invoice-icon2"></div>
                    </a>
                </div>
            `;
        }
        if (data.cweek !== 0) {
            html += `
                <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                    <a href="#" class="Invoice-item">
                        <div class="Invoice-icon">
                            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                        </div>
                        <div class="Invoice-content">
                            <h6 class="subtitle">This week</h6>
                            <h3 class="title">${data.cweek}</h3>
                        </div>
                        <div class="Invoice-icon2"></div>
                    </a>
                </div>
            `;
        }
        if (data.cyesterday !== 0) {
            html += `
                <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                    <a href="#" class="Invoice-item">
                        <div class="Invoice-icon">
                            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                        </div>
                        <div class="Invoice-content">
                            <h6 class="subtitle">Yesterday</h6>
                            <h3 class="title">${data.cyesterday}</h3>
                        </div>
                        <div class="Invoice-icon2"></div>
                    </a>
                </div>
            `;
        }
        if (data.ctoday !== 0) {
            html += `
                <div class="col-xl-12 col-lg-12 col-sm-12 Invoice-content-wrap">
                    <a href="#" class="Invoice-item">
                        <div class="Invoice-icon">
                            <span class="material-icons material-icons-style material-icons-2">bar_chart</span>
                        </div>
                        <div class="Invoice-content">
                            <h6 class="subtitle">Today</h6>
                            <h3 class="title">${data.ctoday}</h3>
                        </div>
                        <div class="Invoice-icon2"></div>
                    </a>
                </div>
            `;
        }
        return html;
    }

    showTimeLine(processName, keyValue) {
        axTimeLineObj = new ProcessTimeLine();
        axTimeLineObj.keyvalue = keyValue;
        axTimeLineObj.processName = processName;

        if (!this.inValid(axTimeLineObj.keyvalue) && axTimeLineObj.keyvalue != "NA")
            axTimeLineObj.getTimeLineData();
    }

    initCharts() {
        let _this = this;

        _this.createChartsFieldsForSelection();
        _this.getSelectedCharts();

    }

    getUrlParams() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.entityName = urlParams.get('ename');
        this.entityTransId = urlParams.get('tstid');

        //if (urlParams.get('applyfilter') == 'true' && urlParams.get('filterval') && urlParams.get('filterfld')) {
        //    this.applyFilter = true;
        //    this.applyFilterStr = urlParams.get('filterfld') + "^^^" + urlParams.get('filterval');
        //}

    }

    bindEvents() {
        this.bindThemeEvent();
        this.bindUtilityEvent();

        //const toggleButton = document.getElementById('toggleCaptionsBtn');
        //toggleButton.addEventListener('click', () => this.toggleCaptions());

        //$('.entity-card').on('click', function () {
        //    const wrapper = $('#Homepage_CardsList_Wrapper');
        //    const arrowIcon = $(this).find('.arrow-icon');

        //    if (wrapper.hasClass('show')) {
        //        wrapper.removeClass('show').slideUp();
        //    } else {
        //        wrapper.addClass('show').slideDown();
        //    }

        //    arrowIcon.toggleClass('fa-chevron-down fa-chevron-up');
        //});

        const fieldCaptionsMenuItem = document.querySelector('#fieldCaptionsMenuItem');
        fieldCaptionsMenuItem.addEventListener('click', function (e) {
            e.preventDefault();
            _entity.toggleCaptions();
        });
    }




    openNewTstruct() {

        parent.LoadIframe(`../aspx/tstruct.aspx?transid=${this.entityTransId}&dummyload=false`)
    }

    editEntity(recordId) {
        var _this = this;
        let inputJson = { page: "Entity", transId: _this.entityTransId, recordId: recordId };
        var editable = _entityCommon.getEntityEditableFlag(inputJson);

        if (editable) {
            parent.LoadIframe(`../aspx/tstruct.aspx?transid=${this.entityTransId}&act=load&recordid=${recordId}&dummyload=false`);
            return true;
        }
        else {
            showAlertDialog("error", "User does not have 'Edit' access for this record. Please check with administrator.");
            return false;
        }

    }

    reloadEntityPage() {

        parent.LoadIframe(`../aspx/Entity.aspx?ename=${this.entityName}&tstid=${this.entityTransId}`)

    }

    bindThemeEvent() {
        var _this = this;
        var menuItems = document.querySelectorAll("#selectThemes .menu-link");

        menuItems.forEach(function (item) {
            item.addEventListener("click", function (event) {
                event.preventDefault();
                var target = this.getAttribute("data-target");
                _this.updateTheme(target);
                _this.updateActiveClass(item);
                localStorage.setItem(`selectedTheme-${_this.entityName}`, target);
            });
        });

    }

    bindUtilityEvent() {
        var _this = this;
        var utilityItems = document.querySelectorAll("#exportMenuItem .menu-link");

        utilityItems.forEach(function (item) {
            item.addEventListener("click", function (event) {
                event.preventDefault();
                var target = this.getAttribute("data-target");
                _this.handleUtilityAction(target);
            });
        });
    }



    handleUtilityAction(action) {
        handleExport(action, '#table-body_Container .table');
    }

    applyTheme() {
        var _this = this;
        var storedTheme = localStorage.getItem(`selectedTheme-${_this.entityName}`);
        if (storedTheme) {
            _this.updateTheme(storedTheme);
            var activeMenuItem = document.querySelector(`#selectThemes .menu-link[data-target="${storedTheme}"]`);
            if (activeMenuItem) {
                _this.updateActiveClass(activeMenuItem);
            }
        }
    }

    updateActiveClass(clickedItem) {
        var menuItems = document.querySelectorAll("#selectThemes .menu-link");
        menuItems.forEach(function (item) {
            item.classList.remove("active");
        });

        clickedItem.classList.add("active");
    }

    updateTheme(target) {
        var body = document.body;

        // Remove existing theme-related classes
        body.classList.remove("lightTheme", "blackTheme", "gradTheme", "compactTheme");

        // Add the new theme class based on the data-target attribute
        if (target === "lightTheme" || target === "light") {
            body.classList.add("lightTheme");
        } else if (target === "blackTheme" || target === "dark") {
            body.classList.add("blackTheme");
        } else if (target === "gradTheme" || target === "gradient" || target === "system") {
            body.classList.add("gradTheme");
        } else if (target === "compactTheme" || target === "pattern") {
            body.classList.add("compactTheme");
        }
    }

    //getNearestRecords(currentRow) {
    //    let _this = this;
    //    const currentIndex = _this.listJson.findIndex(record => record.rno === currentRow);

    //    if (currentIndex === -1) {
    //        return [];
    //    }

    //    let startIndex = Math.max(0, currentIndex - 5);
    //    let endIndex = Math.min(_this.listJson.length - 1, currentIndex + 4);

    //    if (currentIndex - startIndex < 5) {
    //        endIndex = Math.min(_this.listJson.length - 1, startIndex + 9);
    //    }

    //    if (endIndex - currentIndex < 5) {
    //        startIndex = Math.max(0, endIndex - 9);
    //    }

    //    return _this.listJson.slice(startIndex, endIndex + 1);
    //}

    //getNearestRecords(currentRow) {
    //    let _this = this;
    //    const currentIndex = _this.listJson.findIndex(record => record.rno === currentRow);

    //    if (currentIndex === -1) {
    //        return [];
    //    }

    //    let startIndex = Math.max(0, currentIndex - 2);
    //    let endIndex = Math.min(_this.listJson.length - 1, currentIndex + 2);

    //    return _this.listJson.slice(startIndex, endIndex + 1);
    //}

    getNearestRecords(currentRow) {
        let _this = this;
        let filteredList = _this.listJson.filter(record => _this.inValid(record[record.keycol]) === false);
        let currentIndex = filteredList.findIndex(record => record.rno === currentRow);

        if (currentIndex === -1) {
            return [];
        }

        let nearestRecords = [];

        // Add the previous record if it exists
        if (currentIndex > 0) {
            let prevRecord = { ...filteredList[currentIndex - 1], navtype: 'prev' };
            nearestRecords.push(prevRecord);
        }

        let currentRecord = { ...filteredList[currentIndex], navtype: 'current' };
        nearestRecords.push(currentRecord);

        // Add the next record if it exists
        if (currentIndex < filteredList.length - 1) {
            let nextRecord = { ...filteredList[currentIndex + 1], navtype: 'next' };
            nearestRecords.push(nextRecord);
        }

        return nearestRecords;
    }


    callAPI(url, data, async, callBack) {
        let _this = this;
        var xhr = new XMLHttpRequest();
        xhr.open("POST", url, async);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        if (_this.isAxpertFlutter) {
            xhr.setRequestHeader('Authorization', `Bearer ${armToken}`);
            data["armSessionId"] = armSessionId;
        }
        xhr.onreadystatechange = function () {
            if (this.readyState == 4) {
                if (this.status == 200) {
                    callBack({ success: true, response: this.responseText });
                }
                else {
                    _this.catchError(this.responseText);
                    callBack({ success: false, response: this.responseText });
                }
            }
        }
        xhr.send(JSON.stringify(data));
    };

    catchError(error) {
        showAlertDialog("error", error);
    };

    showSuccess(message) {
        showAlertDialog("success", message);
    };

    dataConvert(data, type) {
        if (type == "AXPERT") {
            try {
                data = JSON.parse(data.d);
                if (typeof data.result[0].result.row != "undefined") {
                    return data.result[0].result.row;
                }

                if (typeof data.result[0].result != "undefined") {
                    return data.result[0].result;
                }
            }
            catch (error) {
                ShowDimmer(false);
                this.catchError(error.message);
            };
        }
        else if (type == "ARM") {
            try {
                if (!this.isAxpertFlutter)
                    data = JSON.parse(data.d);
                if (data.result && data.result.success) {
                    if (!this.isUndefined(data.result.data)) {
                        return data.result.data;
                    }
                }
                else {
                    if (!this.isUndefined(data.result.message)) {
                        this.catchError(data.result.message);
                    }
                }
            }
            catch (error) {
                ShowDimmer(false);
                this.catchError(error.message);
            };
        }

        return data;
    };

    generateFldId() {
        return `fid${Date.now()}${Math.floor(Math.random() * 90000) + 10000}`;
    };

    isEmpty(elem) {
        return elem == "";
    };

    isNull(elem) {
        return elem == null;
    };

    isNullOrEmpty(elem) {
        return elem == null || elem == "";
    };

    inValid(elem) {
        return elem == null || typeof elem == "undefined" || elem == "";
    };

    isUndefined(elem) {
        return typeof elem == "undefined";
    };

}

class Field {
    constructor(fieldData) {
        this.fldcap = fieldData.fldcap || '';
        this.fldname = fieldData.fldname;
        this.cdatatype = fieldData.cdatatype;
        this.fdatatype = fieldData.fdatatype;
        this.moe = fieldData.moe;
        this.hide = fieldData.hide;
        this.props = fieldData.props;
    }
}

class EntityMetaData {
    constructor(jsonData) {
        if (!jsonData || !Array.isArray(jsonData)) {
            throw new Error('Invalid JSON data');
        }

        // Map each field data to a Field object
        this.metadata = jsonData.map(fieldData => new Field(fieldData));
    }
}

function createListHTML(listJson, pageNo) {
    let bodyContainer = $('#body_Container');

    if (!isCardView) {
        bodyContainer.html('');
    }

    let html = '';
    const filteredRows = filterRowsByPage(listJson, pageNo);
    var largeTextElements = [];
    var attachmentElements = [];
    var otherElements = [];
    var buttonElements = [];

    // Iterate over the metadata array to categorize fields
    $.each(_entity.metaData, function (index, field) {
        if (field.hide === 'T') {
            return true; // Skip hidden fields
        }

        var fldType = getFieldDataType(field).toUpperCase(); // Determine field type
        if (fldType === "BUTTON") {
            buttonElements.push(field);
        } else if (fldType === "ATTACHMENTS") {
            attachmentElements.push(field);
        } else if (fldType === "LARGE TEXT") {
            largeTextElements.push(field);
        } else {
            otherElements.push(field);
        }
    });

    var keyCol = _entity.keyField;
    var isRowsAdded = false;

    // Loop through each row of filtered data
    for (var rowData of filteredRows) {
        if (!rowData.hasOwnProperty(keyCol)) {
            var keyField = getKeyField();
            keyCol = keyField ? keyField.fldname : _entity.keyField;
        }

        rowData.keycol = keyCol;
        if (!_entity.inValid(rowData[keyCol]) && rowData[keyCol] != "--") {
            isRowsAdded = true;

            // Constructing HTML for each card
            html += `<div class="Project_items" id="row_${rowData.recordid}">
                <div class="card">
                    <div class="col-xl-12 col-md-12 d-flex flex-column flex-column-fluid">`;

            // Card header with title and edit button
            html += ` <div class="page-Header">
                        <h3 class="card-title collapsible cursor-pointer rotate" data-bs-toggle="collapse"
                            aria-expanded="true" data-bs-target="#Sub-Entity_wrapper" >
                            <input class="Select-Project" type="checkbox" id="checkbox_${rowData.recordid}" data-recordid="${rowData.recordid}" value="">
                            <span class="Project_title" onclick="_entity.openEntityForm('${_entity.entityName}', '${rowData.transid}', '${rowData.recordid}', '${rowData[keyCol].replace("T00:00:00", "")}', ${rowData.rno})">${rowData[keyCol].replace("T00:00:00", "")}</span>
                            <input type="hidden" class="transid" id="transid_${rowData.recordid}" value="${rowData.transid}"/>
                            <input type="hidden" class="recid" id="recid_${rowData.recordid}" value="${rowData.recordid}"/>
                            <div class="Project_updates">
                            </div>
                        </h3>
                        <div id="" class="card-toolbar">
                            <div class="d-flex">
                                <div class="edit-container">
                                    <button type="button" id=""
                                        class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm me-3"
                                        data-bs-toggle="tooltip" title="Edit" data-bs-original-title="Edit"
                                        onclick="return _entity.editEntity('${rowData.recordid}')">
                                        <span class="material-icons material-icons-style material-icons-2" style="color: red;">
                                            edit_note
                                        </span>
                                    </button>
                                </div>
                                <button type="submit" id=""
                                    class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm me-3 d-none"
                                    data-bs-toggle="tooltip" title="" data-bs-original-title="Options">
                                    <span class="material-icons material-icons-style material-icons-2" style="color: #47BE7D;">
                                        more_vert
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>`;

            if (!_entity.inValid(rowData.modifiedby) && !_entity.inValid(rowData.modifiedon) && !_entity.inValid(rowData.createdby) && !_entity.inValid(rowData.createdon)) {
                let formattedDateModified = moment(rowData.modifiedon).format('DD/MM/YYYY');
                let timePartModified = moment(rowData.modifiedon).format('HH:mm:ss');
                var entity_realtiveTimeModified = moment(rowData.modifiedon).fromNow();

                let formattedDateCreated = moment(rowData.createdon).format('DD/MM/YYYY');
                let timePartCreated = moment(rowData.createdon).format('HH:mm:ss');
                var entity_realtiveTimeCreated = moment(rowData.createdon).fromNow();

                // Initialize the tooltip content variables
                let tooltipModifiedBy = "";
                let tooltipModifiedOn = "";
                let tooltipCreatedBy = "";
                let tooltipCreatedOn = "";

                // Check if each field exists in the _entity.modificationFields array and build tooltips
                if (_entity.modificationFields.includes("modifiedby") && rowData.modifiedby) {
                    tooltipModifiedBy = `Modified by: ${rowData.modifiedby}`;
                }
                if (_entity.modificationFields.includes("createdby") && rowData.createdby) {
                    tooltipCreatedBy = `Created by: ${rowData.createdby}`;
                }

                if (_entity.modificationFields.includes("modifiedon") && rowData.modifiedon) {
                    tooltipModifiedOn = `Modified on: ${formattedDateModified} ${timePartModified}`;
                }
                if (_entity.modificationFields.includes("createdon") && rowData.createdon) {
                    tooltipCreatedOn = `Created on: ${formattedDateCreated} ${timePartCreated}`;
                }

                // Add the tooltip content based on the conditions
                let tooltipContent = "";
                if (_entity.modificationFields.includes("createdby") && _entity.modificationFields.includes("modifiedby")) {
                    tooltipContent = `${tooltipModifiedBy}\n${tooltipCreatedBy}`;
                } else if (_entity.modificationFields.includes("createdby") && !_entity.modificationFields.includes("modifiedby")) {
                    tooltipContent = tooltipCreatedBy;
                } else if (!_entity.modificationFields.includes("createdby") && _entity.modificationFields.includes("modifiedby")) {
                    tooltipContent = tooltipModifiedBy;
                }

                // Create the HTML for the first span (Modified by/Created by)
                html += `<div class="workflow-container" style="display: flex; align-items: center;">
                                    <div class="workflow-row" style="display: flex; align-items: center;">
                                        <div class="workflow-items" style="display: flex; align-items: center;">`;

                // Render the symbol with the combined tooltip content for "Created by" or "Modified by"
                if (tooltipContent) {
                    html += `<div class="symbol symbol-25px symbol-circle initialized" data-bs-toggle="tooltip" title="${tooltipContent}" data-bs-original-title="${tooltipContent}">
                                        <span class="symbol-label bg-warning text-inverse-warning fw-bold">${rowData.modifiedby[0]}</span>
                                     </div>`;
                }

                // Render the span for either "Modified by" or "Created by"
                if (_entity.modificationFields.includes("createdby") && _entity.modificationFields.includes("modifiedby")) {
                    html += `<span data-toggle="tooltip" title="${tooltipContent}" class="Project_updates-value" style="margin-left: 10px;">
                                        ${rowData.modifiedby.split("@")[0]}
                                     </span>`;
                } else if (_entity.modificationFields.includes("createdby") && !_entity.modificationFields.includes("modifiedby")) {
                    html += `<span data-toggle="tooltip" title="${tooltipContent}" class="Project_updates-value" style="margin-left: 10px;">
                                        ${rowData.createdby.split("@")[0]}
                                     </span>`;
                } else if (!_entity.modificationFields.includes("createdby") && _entity.modificationFields.includes("modifiedby")) {
                    html += `<span data-toggle="tooltip" title="${tooltipContent}" class="Project_updates-value" style="margin-left: 10px;">
                                        ${rowData.modifiedby.split("@")[0]}
                                     </span>`;
                }

                // Add logic for the second span (Created on/Modified on)
                tooltipContent = "";
                if (_entity.modificationFields.includes("createdon") && _entity.modificationFields.includes("modifiedon")) {
                    tooltipContent = `${tooltipModifiedOn}\n${tooltipCreatedOn}`;
                } else if (_entity.modificationFields.includes("createdon") && !_entity.modificationFields.includes("modifiedon")) {
                    tooltipContent = tooltipCreatedOn;
                } else if (!_entity.modificationFields.includes("createdon") && _entity.modificationFields.includes("modifiedon")) {
                    tooltipContent = tooltipModifiedOn;
                }

                // Render the second span for "Last Modified" or "Created On"
                if (tooltipContent) {
                    html += `<span class="Project_updates-value" data-toggle="tooltip" data-placement="top" title="${tooltipContent}" 
                                         data-name="${formattedDateModified} ${timePartModified}" style="margin-left: 10px;">
                                         last modified ${entity_realtiveTimeModified}
                                     </span>`;
                } else if (_entity.modificationFields.includes("createdon") && !_entity.modificationFields.includes("modifiedon")) {
                    html += `<span class="Project_updates-value" data-toggle="tooltip" data-placement="top" title="${tooltipCreatedOn}" 
                                         data-name="${formattedDateCreated} ${timePartCreated}" style="margin-left: 10px;">
                                         created on: ${entity_realtiveTimeCreated}
                                     </span>`;
                } else if (!_entity.modificationFields.includes("createdon") && _entity.modificationFields.includes("modifiedon")) {
                    html += `<span class="Project_updates-value" data-toggle="tooltip" data-placement="top" title="${tooltipModifiedOn}" 
                                         data-name="${formattedDateModified} ${timePartModified}" style="margin-left: 10px;">
                                         last modified ${entity_realtiveTimeModified}
                                     </span>`;
                }

                html += `</div></div>`; // Close the workflow container

                // Add status timeline if exists
                if (rowData.axpeg_status && rowData.axpeg_status.toString() !== "" && rowData.axpeg_status.toString() !== "0") {
                    html += `<div class="status-timeline" style="display: flex; align-items: center; margin-left: 20px;">
                                        <span class="material-icons material-icons-style material-icons-2" style="margin-right: 10px; margin-bottom: 10px;">people</span>
                                        <button id="pd_timeline" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm entity-timelines" 
                                                data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end" 
                                                data-kt-menu-flip="top-end" data-kt-menu-attach="parent" title="Timeline" 
                                                style="margin-right: 10px; margin-bottom: 10px;">
                                            <span class="material-icons material-icons-style material-icons-2">history</span>
                                        </button>
                                        <div class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light fw-bolder w-400px py-3" 
                                             data-kt-menu="true" data-id="pd_timeline" 
                                             data-processname="${rowData.axpeg_processname}" data-keyvalue="${rowData.axpeg_keyvalue}">
                                        </div>
                                    </div>`;
                }

                html += `</div>`; // Close the main div
            }







            // Generate HTML for the fields (other, large text, attachment)
            html += generateRowElements(otherElements, largeTextElements, attachmentElements, rowData);

            // Generate buttons for the row
            html += generateRowButtonHTML(buttonElements, rowData);

            // Closing tags for the card
            html += `</div></div></div>`;
        }
    }

    if (filteredRows.length && !isRowsAdded) {
        bodyContainer.append(this.nullRowsHtml);
    } else if (html !== "") {
        bodyContainer.append(html);
        initReadMore(); // Initialize read more for large text fields
        KTMenu.init(); // Initialize the menu for timeline buttons

        // Initialize timeline behavior for each row
        document.querySelectorAll(".entity-timelines").forEach((item) => {
            KTMenu.getInstance(item).on("kt.menu.dropdown.show", function (item) {
                var popOver = KTMenu.getInstance(item).element;
                popOver.innerHTML = `<div id="TimeLine_overall" class="content">
                    <div class="card" id="Timeline-wrap">
                        <h1 class="Timeline-heading">Timeline</h1>
                        <ul class="Timel-sessions full-session d-none"></ul>
                        <span id="nodata" class="p-5">No Timeline data available.</span>
                    </div>
                </div>`;
                let popOverData = popOver.dataset;
                _entity.showTimeLine(popOverData.processname, popOverData.keyvalue);
            });

            KTMenu.getInstance(item).on("kt.menu.dropdown.hide", function (item) {
                KTMenu.getInstance(item).element.innerHTML = "";
            });
        });
    } else {
        bodyContainer.append(this.emptyRowsHtml);
    }
}

function generateRowElements(otherElements, largeTextElements, attachmentElements, rowData) {
    var RowElements = '<div class="Data-fields-row">';
    for (const rowfld of otherElements) {
        if (rowfld.fldname != rowData.keycol)
            RowElements += _entity.generateHTMLBasedOnDataType(rowfld, rowData);
    }
    for (const rowfld of largeTextElements) {
        if (rowfld.fldname != rowData.keycol)
            RowElements += _entity.generateHTMLBasedOnDataType(rowfld, rowData);
    }
    for (const rowfld of attachmentElements) {
        RowElements += _entity.generateHTMLBasedOnDataType(rowfld, rowData);
    }
    RowElements += '</div>';
    return RowElements;
}
function generateRowButtonHTML(buttonElements, rowData) {
    var rowButtonHTML = `<div class="Action-Btns-row ">
                                            <div class="d-flex align-items-center ">
                                                <a href="javascript:void(0)" title="Approve"
                                                   onclick="axTasksObj.doApprove('1409660000003', this);"
                                                   class="btn btn-white btn-sm btn-color-gray-700 btn-active-primary d-inline-flex align-items-center  btn-sm  me-2  ">
                                                    <span class="material-icons material-icons-style material-icons-2"
                                                          style="color: #47BE7D;">visibility</span>View form
                                                </a>
                                                <a href="javascript:void(0)" title="Reject"
                                                   class="btn btn-white btn-color-gray-700 btn-active-primary d-inline-flex align-items-center  me-2  btn-sm"
                                                   onclick="axTasksObj.doReject('1409660000003', this)">
                                                    <span class="material-icons material-icons-style material-icons-2"
                                                          style="color: red;">edit_note</span>Edit Form
                                                </a>`;
    for (const rowfld of buttonElements) {
        rowButtonHTML += _entity.generateHTMLBasedOnDataType(rowfld, rowData);
    }
    rowButtonHTML += ` </div>
                                        </div>`;
    return rowButtonHTML;
}

var dateFormat = 'DD/MM/YYYY';

// Function to format the date
function formatDate(dateStr, format) {
    // Remove any characters like 'T' and split the date
    dateStr = dateStr.split('T')[0]; // Handle timestamp with 'T'
    var dateParts = dateStr.split('-');
    var year = dateParts[0];
    var month = dateParts[1];
    var day = dateParts[2];

    if (format === 'DD/MM/YYYY') {
        return `${day}/${month}/${year}`;
    } else if (format === 'MM/DD/YYYY') {
        return `${month}/${day}/${year}`;
    } else {
        return dateStr; // Return as is if format is unknown
    }
}


// function generateHTMLBasedOnDataType(fldProps, rowData) {
//     var fldkey = fldProps.fldname;
//     var fldtype = getFieldDataType(fldProps);
//     var fldcap = fldProps.fldcap || '';
//     var fProps = fldProps.props;
//     var fldValue = rowData[fldkey];

//     // Skip "Modified On" and "Modified By" fields
//     if (fldkey.toLowerCase() === 'modifiedon' || fldkey.toLowerCase() === 'modifiedby') {
//         return '';
//     }

//     if (_entity.inValid(fldValue) && fldtype.toUpperCase() != "BUTTON")
//         return '';

//     let html = '';
//     switch (fldtype.toUpperCase()) {
//         case 'LARGE TEXT':
//             html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <p class="task-description moretext" style="margin-bottom:0px !important;">${fldValue}</p>
//                         <a class="moreless-button" href="#">Read more</a>
//                     </div>`;
//             break;
//         case 'SHORT TEXT':
//             html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">description</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'CURRENCY':
//             html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">payments</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'DATE':
//             // Format the date value
//             var formattedDate = formatDate(fldValue.replace("T00:00:00", ""), dateFormat);
//             html = `<div class="Data-fields-items Date-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                             <span class="material-icons material-icons-style material-icons-2">today</span><span class="txt-bold Data-field-value">${formattedDate}</span>
//                         </div>`;
//             break;
//         case 'TIME':
//             html = `<div class="Data-fields-items Time-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">schedule</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'LINK':
//             html = `<div class="Data-fields-items link-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">link</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'MOBILE':
//             html = `<div class="Data-fields-items Email-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">phone</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'PHONE':
//             html = `<div class="Data-fields-items Email-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">phone</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'PINCODE':
//             html = `<div class="Data-fields-items Email-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">location_on</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'ZIPCODE':
//             html = `<div class="Data-fields-items Email-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">location_on</span><span class="txt-bold Data-field-value">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'EMAIL':
//             html = `<div class="Data-fields-items Email-field truncate" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                         <span class="material-icons material-icons-style material-icons-2">mail</span><span class="txt-bold Data-field-value" data-text="${fldValue}" onclick="showPopup(this)">${fldValue}</span>
//                     </div>`;
//             break;
//         case 'BOOL':
//             // Check if the field value is "T" or "F" and display a checkbox accordingly
//             if (fldValue === "T" || fldValue === "F") {
//                 html = `<div class="Data-fields-items Email-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                                 <div class="form-check form-switch">
//                                     <input class="form-check-input" type="checkbox" role="switch" ${fldValue === "T" ? 'checked' : ''} readonly>
//                                     <span class="txt-bold Data-field-value">${fldcap}</span>
//                                 </div>
//                             </div>`;
//             } else {
//                 html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                                 <span class="txt-bold Data-field-value">${fldValue}</span>
//                             </div>`;
//             }
//             break;
//         case 'BUTTON':
//             var propsVal = fProps.split("|");
//             var iconVal = propsVal[0].split("~")[1];
//             html = `<a href="javascript:void(0)" title="View form"
//                        class="btn btn-white btn-color-gray-700 btn-active-primary d-inline-flex align-items-center  btn-sm  me-2 ">
//                         <span class="material-icons material-icons-style material-icons-2" style="color: darkmagenta;">${iconVal}</span>${fldcap}
//                     </a>`;
//             break;
//         case 'ATTACHMENTS':
//             if (fldValue?.length > 0) {
//                 var fileObj = parseFilePath(fldValue);
//                 if (fileObj.filename?.length > 0) {
//                     var fileType = getFileType(fldValue);
//                     var iconClass = getIconClass(fileType);
//                     html = `<div class="Files-Attached" data-toggle="tooltip" data-placement="top" title="${fileObj.filename}.${fileObj.ext}">
//                                 ${iconClass}
//                                 <div class="ms-1 fw-semibold">
//                                     <a class="attached-filename" onclick="downloadFileFromPath('${fileObj.folder.replaceAll("\\", "\\\\")}','${fileObj.filename}.${fileObj.ext}')">${fileObj.filename}</a>
//                                 </div>
//                             </div>`;
//                 }
//             }
//             break;
//         default:
//             if (fldValue === "T" || fldValue === "F") {
//                 html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                                 <div class="d-flex align-items-center">

//                                     <div class="form-check ms-1">
//                                         <input class="form-check-input" type="checkbox" ${fldValue === "T" ? 'checked' : ''} readonly disabled>
//                                     </div>
//                                 </div>
//                             </div>`;
//             } else {
//                 html = `<div class="Data-fields-items Department-field" data-toggle="tooltip" data-placement="top" title="${fldcap}" data-name="${fldcap.toLowerCase().replaceAll("*", "").replaceAll(" ", "")}">
//                                 <span class="txt-bold Data-field-value">${fldValue}</span>
//                             </div>`;
//             }
//     }
//     return html;
// }


// Event listener for scroll events
// Add a scroll event listener to your div

function parseFilePath(filePath) {
    // Regular expression to match folder, filename, and extension
    var regex = /^(.*[\\\/])([^\\\/]+)\.(\w+)$/;

    // Executing the regex on the filePath
    var match = regex.exec(filePath);

    // Initializing the result object
    var result = {
        folder: "",
        ext: "",
        filename: ""
    };

    // If match is found
    if (match) {
        result.folder = match[1];
        result.filename = match[2];
        result.ext = match[3];
    } else {
        // If no match is found, consider the whole string as folder path
        result.folder = filePath;
    }

    return result;
}

function downloadFileFromPath(filePath, filename) {
    $.ajax({
        type: "POST",
        url: top.window.location.href.toLowerCase().substring(0, top.window.location.href.indexOf("/aspx/")) + '/customwebservice.asmx/GetAttachments',
        cache: false,
        async: false,
        contentType: "application/json;charset=utf-8",
        data: JSON.stringify({
            filePath: filePath, // Should be folder1\\folderb
            fileName: filename // Should be filename, e.g., myimg.png
        }),
        dataType: "json",
        success: function (data) {
            if (data.d !== ("File not exists" || "File path not exists")) {
                var extension = data.d.split('.').pop().toLowerCase();
                downloadAttachment(data.d, filename, extension);
            } else {
                parent.showAlertDialog("error", data.d);
            }
        },
        error: function (data) {
            parent.showAlertDialog("error", data.d);
        }
    });
}

function isScrollAtBottomWithinDiv(divElement) {
    const distanceToBottom = divElement.scrollHeight - (divElement.scrollTop + divElement.clientHeight);
    return distanceToBottom <= 1;  // Ensure this threshold is correct for your use case
}

function isScrollAtTopWithinDiv(divElement) {
    // Calculate the distance between the top of the div and the top of the viewport
    const distanceToTop = divElement.scrollTop;

    // Check if the distance to the top is within a small threshold to account for rounding errors
    return distanceToTop <= 1;
}
function filterRowsByPage(rows, pageNumber) {
    return rows.filter(row => row.pageno === pageNumber);
}

function initReadMore() {
    // Get all elements with the "moretext" class
    var moreTextElements = document.querySelectorAll('.moretext');

    moreTextElements.forEach(function (moreText, index) {
        // Save the initial height when the page loads for each element
        var initialHeight = moreText.clientHeight;

        // Get the corresponding "Read more" button
        var moreLessButton = moreText.nextElementSibling;

        // Initial check and setup
        if (moreText.scrollHeight > moreText.clientHeight) {
            moreLessButton.style.display = 'inline-block';
            moreText.style.maxHeight = initialHeight + 'px'; // Set initial max height
        } else {
            moreLessButton.style.display = 'none'; // Hide button if content is not overflowing
        }

        moreLessButton.addEventListener('click', function () {
            var computedStyle = window.getComputedStyle(moreText);

            if (computedStyle.maxHeight === 'none' || computedStyle.maxHeight === initialHeight + 'px') {
                moreText.style.maxHeight = moreText.scrollHeight + 'px'; // Expand to full height
                moreLessButton.textContent = 'Read less';
            } else {
                moreText.style.maxHeight = initialHeight + 'px'; // Set back to initial height
                moreLessButton.textContent = 'Read more';
            }
        });
    });
}
function getFilesHtml(rowJson) {
    var returnHtml = "";
    var filesArray = rowJson["axpfile_file"].split(',');
    $.each(filesArray, function (index, value) {
        var fileType = getFileType(value);
        var iconClass = getIconClass(fileType);
        var attachmentURL = rowJson["axpfilepath_file"] + value;
        attachmentURL = attachmentURL.replace(/\\/g, "\\\\");
        if (value != "") {
            returnHtml += `<div class="Files-Attached ">
						   <!--begin::Icon-->	
						   ${iconClass}						   
						   <!--end::Icon-->                     
						   <!--begin::Info-->
						   <div class="ms-1 fw-semibold">
							  <!--begin::Desc-->							  
							  <a class="attached-filename" onclick="downloadFileFromPath('${attachmentURL}','${value}')">${value}</a>
							  <!--end::Desc-->                     
							  <!--begin::Number-->
							  <div class="attached-filedetails">
								 <span class="doctype">${fileType}</span>
								 <!--<span class="docsize">1.9mb</span>-->
							  </div>
							  <!--end::Number-->
						   </div>
						   <a class="attached-filename" onclick="downloadFileFromPath('${attachmentURL}','${value}')">
							   <span
								  class="material-icons material-icons-style material-icons-2 text-danger">cloud_download</span>
							</a>
						   <!--begin::Info-->
						</div>`;
        }

    });
    return returnHtml;
}
function getIconClass(fileType) {
    switch (fileType) {
        case 'pdf':
            return '<img src="../images/pdf.svg" class="file-img" />';
        case 'jpeg':
            return '<img src="../images/images.svg" class="file-img" />';
        case 'jpg':
            return '<img src="../images/images.svg" class="file-img" />';
        case 'png':
            return '<img src="../images/images.svg" class="file-img" />';
        case 'doc':
        case 'docx':
            return '<img src="../images/word.svg" class="file-img" />';
        case 'txt':
            return '<i style="margin:0px !important; font-size: 40px !important; " class="material-icons">description</i>';
        case 'xls':
        case 'xlsx':
            return '<img src="../images/xl.svg" class="file-img"/>';
        case 'ppt':
        case 'pptx':
            return '<img src="../images/ppt.svg" class="file-img"/>';
        case 'zip':
            return '<i style="margin:0px !important; font-size: 40px !important; " class="material-icons">archive</i>';
        case 'mp3':
            return '<i style="margin:0px !important; font-size: 40px !important; " class="material-icons">audiotrack</i>';
        case 'mp4':
            return '<i style="margin:0px !important; font-size: 40px !important; " class="material-icons">videocam</i>';
        default:
            return '<i style="margin:0px !important; font-size: 40px !important; " class="material-icons">insert_drive_file</i>'; // Default icon for unknown file types
    }
}
function getFileType(fileName) {
    // Split the file name into an array based on the dot separator
    var parts = fileName.split('.');

    // Get the last part of the array, which is the file extension
    var fileExtension = parts[parts.length - 1];

    // Convert the file extension to lowercase (optional, for consistency)
    return fileExtension.toLowerCase();
}
function scrollToTopOfDiv(divElement) {
    divElement.scrollTop = 0; // Set scrollTop to 0 to scroll to the top
}
/* End Function Set to generate html */
$(document).ready(function () {
    _entityFilter = new EntityFilter();
    _entityCommon = new EntityCommon();
    _entity = new Entity();
    _entity.init();

    _entityFilter.metaData = _entity.metaData;
    _entityFilter.pageName = "Entity";
    _entityFilter.entityTransId = _entity.entityTransId;
    _entityFilter.checkUrlFilters();

    _entityFilter.applyFilters = function () {
        _entity.filter = this.activeFilterArray;
        _entity.getEntityListData(1);
        $('#filterModal').modal('hide');
    }
});


var axTimeLineObj;
class ProcessTimeLine {
    constructor() {
        this.keyvalue = "";
        this.processName = "";
        this.make = `<li class="make">                                   
                    <p class="T-Desc">{{taskname}}#{{keyvalue}}</p>
 		    <p class="T-Heading">{{taskfromuser}}</p>
 		    <div class="time">{{tasktime}}</div>
                </li>`;
        this.check = `<li class="check">
                    <p class="T-Desc">{{taskname}}#{{keyvalue}} - {{taskstatus}}</p>
                    <p class="T-Heading">{{taskfromuser}}</p>                    
		    <div class="time">{{tasktime}}</div>
                </li>`;
        this.approve = `<li class="approve">
                   <p class="T-Desc">{{taskname}}#{{keyvalue}} - {{taskstatus}}</p>
                    <p class="T-Heading">{{taskfromuser}}</p>                    
		    <div class="time">{{tasktime}}</div>
                </li>`;
    }

    getTimeLineData() {
        ShowDimmer(true);
        let _this = this;
        let url = "../aspx/AxPEG.aspx/AxGetTimelineData";
        let data = { keyValue: _this.keyvalue, processName: _this.processName };
        this.callAPI(url, data, false, result => {
            if (result.success) {
                let json = JSON.parse(result.response);
                let dataResult = _this.dataConvert(json, "ARM");
                _this.constructTimeline(dataResult);
                ShowDimmer(false);
            } else {
                ShowDimmer(false);
            }
        });
    };

    constructTimeline(data) {
        if (this.isUndefined(data) || data.length == 0) {
            document.querySelector(".Timel-sessions").classList.add("d-none");
            document.querySelector("#nodata").classList.remove("d-none");
        }
        else {
            document.querySelector("#nodata").classList.add("d-none");
            document.querySelector(".Timel-sessions").classList.remove("d-none");
            var timelineData = "";
            document.querySelector('.Timel-sessions').innerHTML = '';
            data.forEach((rowData) => {
                timelineData += Handlebars.compile(this[rowData.tasktype.toLowerCase()])(rowData);
            })
            document.querySelector('.Timel-sessions').insertAdjacentHTML("beforeend", timelineData);
        }
    }

    callAPI(url, data, async, callBack) {
        let _this = this;
        var xhr = new XMLHttpRequest();
        xhr.open("POST", url, async);
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        if (_this.isAxpertFlutter) {
            xhr.setRequestHeader('Authorization', `Bearer ${armToken}`);
            data["armSessionId"] = armSessionId;
        }
        xhr.onreadystatechange = function () {
            if (this.readyState == 4) {
                if (this.status == 200) {
                    callBack({ success: true, response: this.responseText });
                }
                else {
                    _this.catchError(this.responseText);
                    callBack({ success: false, response: this.responseText });
                }
            }
        }
        xhr.send(JSON.stringify(data));
    };

    catchError(error) {
        showAlertDialog("error", error);
    };

    showSuccess(message) {
        showAlertDialog("success", message);
    };

    dataConvert(data, type) {
        if (type == "AXPERT") {
            try {
                data = JSON.parse(data.d);
                if (typeof data.result[0].result.row != "undefined") {
                    return data.result[0].result.row;
                }

                if (typeof data.result[0].result != "undefined") {
                    return data.result[0].result;
                }
            }
            catch (error) {
                this.catchError(error.message);
            };
        }
        else if (type == "ARM") {
            try {
                if (!this.isAxpertFlutter)
                    data = JSON.parse(data.d);
                if (data.result && data.result.success) {
                    if (!this.isUndefined(data.result.data)) {
                        return data.result.data;
                    }
                }
                else {
                    if (!this.isUndefined(data.result.message)) {
                        this.catchError(data.result.message);
                    }
                }
            }
            catch (error) {
                this.catchError(error.message);
            };
        }

        return data;
    };

    generateFldId() {
        return `fid${Date.now()}${Math.floor(Math.random() * 90000) + 10000}`;
    };

    isEmpty(elem) {
        return elem == "";
    };

    isNull(elem) {
        return elem == null;
    };

    isNullOrEmpty(elem) {
        return elem == null || elem == "";
    };

    isUndefined(elem) {
        return typeof elem == "undefined";
    };

    inValid(elem) {
        return elem == null || typeof elem == "undefined" || elem == "";
    };
}



function showPopup(element) {
    var text = element.getAttribute('data-text');
    document.getElementById('popupText').textContent = text;
    $('#myModal').modal('show');
}



function formatDateString(dateString) {
    if (!dateString) return '';

    const dateTimeParts = dateString.split('T');
    const dateParts = dateTimeParts[0].split('-');
    const timeParts = (dateTimeParts[1] || "00:00:00").split(':');

    const year = dateParts[0];
    const month = dateParts[1];
    const day = dateParts[2];

    const hours = timeParts[0];
    const minutes = timeParts[1];
    const seconds = timeParts[2];

    const formattedDate = dtCulture === "en-us"
        ? `${month}/${day}/${year}`
        : `${day}/${month}/${year}`;

    const timePart = (hours !== "00" || minutes !== "00" || seconds !== "00")
        ? `${hours}:${minutes}:${seconds}`
        : '';

    return timePart ? `${formattedDate} ${timePart}` : formattedDate;
}


var isDDMMYYYY = true;


// Utility function to parse date in format DD/MM/YYYY or MM/DD/YYYY
function parseDate(dateString) {
    var parts = dateString.split('/');
    if (parts.length !== 3) {
        return null;
    }
    var day, month, year;
    // Assuming date format is DD/MM/YYYY, adjust if using MM/DD/YYYY
    if (isDDMMYYYY) {
        day = parseInt(parts[0], 10);
        month = parseInt(parts[1], 10) - 1;
        year = parseInt(parts[2], 10);
    } else {
        month = parseInt(parts[0], 10) - 1;
        day = parseInt(parts[1], 10);
        year = parseInt(parts[2], 10);
    }
    return new Date(year, month, day);
}




function getLastWeek() {
    var currentDate = new Date();
    var currentDay = currentDate.getDay();
    var startOfWeek = new Date(currentDate);
    startOfWeek.setDate(currentDate.getDate() - currentDay);
    var endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() - 6);
    var formattedStartOfWeek = startOfWeek.toISOString().split('T')[0];
    var formattedEndOfWeek = endOfWeek.toISOString().split('T')[0];

    return {
        start: formattedStartOfWeek,
        end: formattedEndOfWeek
    };
}

function getCurrentWeek() {
    var currentDate = new Date();
    var currentDay = currentDate.getDay();
    var startOfWeek = new Date(currentDate);
    startOfWeek.setDate(currentDate.getDate() - currentDay);
    var endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    var formattedStartOfWeek = startOfWeek.toISOString().split('T')[0];
    var formattedEndOfWeek = endOfWeek.toISOString().split('T')[0];

    return {
        start: formattedStartOfWeek,
        end: formattedEndOfWeek
    };
}

function getNextWeek() {

    var currentDate = new Date();
    var currentDay = currentDate.getDay();
    var startOfNextWeek = new Date(currentDate);
    startOfNextWeek.setDate(currentDate.getDate() - currentDay + 7);
    var endOfNextWeek = new Date(startOfNextWeek);
    endOfNextWeek.setDate(startOfNextWeek.getDate() + 6);

    var formattedStartOfNextWeek = startOfNextWeek.toISOString().split('T')[0];
    var formattedEndOfNextWeek = endOfNextWeek.toISOString().split('T')[0];

    return {
        start: formattedStartOfNextWeek,
        end: formattedEndOfNextWeek
    };
}

function getLastMonth() {

    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = currentDate.getMonth();
    var startOfLastMonth = new Date(year, month - 1, 2);
    var formattedStartOfLastMonth = startOfLastMonth.toISOString().split('T')[0];
    var endOfLastMonth = new Date(year, month, 1);
    var formattedEndOfLastMonth = endOfLastMonth.toISOString().split('T')[0];
    return {
        start: formattedStartOfLastMonth,
        end: formattedEndOfLastMonth
    };
}

function getCurrentMonth() {

    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = currentDate.getMonth() + 1;

    var startOfMonth = year + '-' + ('0' + month).slice(-2) + '-01';
    var endOfMonth = new Date(year, month, 1).toISOString().split('T')[0];
    return {
        start: startOfMonth,
        end: endOfMonth
    };
}

function getNextMonth() {

    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = currentDate.getMonth() + 2;
    var startOfNextMonth = year + '-' + ('0' + month).slice(-2) + '-01';
    var endOfNextMonth = new Date(year, month, 1);
    var formattedEndOfNextMonth = endOfNextMonth.toISOString().split('T')[0];
    return {
        start: startOfNextMonth,
        end: formattedEndOfNextMonth
    };
}

function getCurrentQuarter() {
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = currentDate.getMonth() + 1;
    var quarter = Math.ceil(month / 3);
    var startOfQuarter = year + '-' + ('0' + ((quarter - 1) * 3 + 1)).slice(-2) + '-01';
    var endOfQuarterMonth = quarter * 3;
    var endOfQuarter = new Date(year, endOfQuarterMonth, 1).toISOString().split('T')[0];

    return {
        start: startOfQuarter,
        end: endOfQuarter
    };
}

function getNextQuarter() {
    var currentDate = new Date();
    var year = currentDate.getFullYear();
    var month = currentDate.getMonth() + 1;
    var quarter = Math.ceil(month / 3);


    var startOfNextQuarterMonth = (quarter * 3) + 1;
    if (startOfNextQuarterMonth > 12) {
        startOfNextQuarterMonth = 1;
        year++;
    }
    var startOfNextQuarter = year + '-' + ('0' + startOfNextQuarterMonth).slice(-2) + '-01'; // Start from 01

    // Calculate the end date of the next quarter
    var endOfNextQuarter = new Date(year, (quarter * 3) + 3, 1).toISOString().split('T')[0]; // Get the last day of the last month of the next quarter

    // Return an object containing the start and end dates of the next quarter
    return {
        start: startOfNextQuarter,
        end: endOfNextQuarter
    };
}

function getCurrentYear() {
    var currentDate = new Date(); // Get the current date
    var year = currentDate.getFullYear(); // Get the current year

    // Calculate the start date of the current year
    var startOfYear = year + '-01-01'; // Start from January 1st

    // Calculate the end date of the current year
    var endOfYear = year + '-12-31'; // End on December 31st

    // Return an object containing the start and end dates of the current year
    return {
        start: startOfYear,
        end: endOfYear
    };
}

function getLastYear() {
    var currentDate = new Date(); // Get the current date
    var year = currentDate.getFullYear() - 1; // Get the current year

    // Calculate the start date of the current year
    var startOfYear = year + '-01-01'; // Start from January 1st

    // Calculate the end date of the current year
    var endOfYear = year + '-12-31'; // End on December 31st

    // Return an object containing the start and end dates of the current year
    return {
        start: startOfYear,
        end: endOfYear
    };
}

function getNextYear() {

    var currentDate = new Date(); // Get the current date
    var year = currentDate.getFullYear() + 1;// Get the current year

    // Calculate the start date of the current year
    var startOfYear = year + '-01-01'; // Start from January 1st

    // Calculate the end date of the current year
    var endOfYear = year + '-12-31'; // End on December 31st


    return {
        start: startOfYear,
        end: endOfYear
    };
}


function getDateBasedOnCulture(dateStr) {
    if (dateStr != "") {
        let dateStrArr = dateStr.split(" ");
        dateStr = dateStrArr[0];
        if (dtCulture == "en-us") {
            var splittedDate = dateStr.split("/");
            if (splittedDate.length > 2) {
                if (isPerf && splittedDate[0].length == 4) {
                    dateStr = splittedDate[2] + "/" + splittedDate[0] + "/" + splittedDate[1];
                } else {
                    dateStr = splittedDate[1] + "/" + splittedDate[0] + "/" + splittedDate[2];
                }
            }
        } else {
            var splittedDate = dateStr.split("-");
            if (splittedDate.length > 2) {
                if (isPerf && splittedDate[0].length == 4) {
                    dateStr = splittedDate[2] + "/" + splittedDate[1] + "/" + splittedDate[0];
                }
            }
        }
        if (dateStrArr[1]) {
            dateStr = `${dateStr} ${dateStrArr[1]}`;
        }
    }
    return dateStr;
}

function openFieldSelection() {

    $('#fieldsModal').modal('show');
    if ($('#fields-selection').html() == "")
        createFieldsLayout();
}

function createFieldsLayout() {
    const fieldsContainer = document.getElementById("fields-selection");
    let skipFields = ["transid", "modifiedby", "modifiedon", "createdby", "createdon", "username", "axpeg_nextlevel"];

    var fields = _entity.metaData.filter(item => item.ftransid === _entity.entityTransId && item.hide === "F" && item.griddc == "F" && skipFields.indexOf(item.fldname.toLowerCase()) == -1 && item.cdatatype != "Image");
    const groupedFields = {};
    fields.forEach(field => {
        if (field.dcname) {
            if (!groupedFields[field.dcname]) {
                groupedFields[field.dcname] = [];
            }
            groupedFields[field.dcname].push(field);
        }
    });

    var html = '';
    Object.entries(groupedFields).forEach(([dc, dcFields]) => {
        let dcName = _entity.metaData.find(item => item.dcname == dc).dccaption || dc;
        let collapsed = true;
        if (dc == "dc1")
            collapsed = false;

        html += `
        <div class="card KC_Items">
            <div class="card-header collapsible cursor-pointer rotate ${collapsed ? "collapsed" : ""}" data-bs-toggle="collapse" aria-expanded="true" data-bs-target="#fields-${dc}">
                <h3 class="card-title">${dcName} (${dc})</h3>
                <div class="card-toolbar rotate-180">
                    <span class="material-icons material-icons-style material-icons-2">
                        expand_circle_down
                    </span>
                </div>
            </div>
            <div class="KC_Items_Content collapse ${collapsed ? "" : "show"} heightControl pt-0---" id="fields-${dc}">
            <table class="table table-hover">
                <tbody id="fields-table-body">`;

        dcFields.forEach(fld => {
            html += `<tr><td><input type="checkbox" id="chk_${fld.fldname}" class="chk-fields chk-relateddataflds" value="${fld.fldname}" data-fldcap="${fld.fldcap}" data-dcname="${dc}"></td>
          <td><label for="chk_${fld.fldname}">${fld.fldcap || ''}  (${fld.fldname})</label></td></tr>`;
        });

        html += `</tbody></table></div></div>`;
    });

    // Add modification fields (without affecting normal fields logic)
    html += `
    <div class="card KC_Items">
        <div class="card-header">
            <h3 class="card-title">Modification Info</h3>
        </div>
        <div class="KC_Items_Content">
            <table class="table table-hover">
                <tbody>
                    <tr><td><input type="checkbox" id="chk_modifiedby" class="chk-modification" value="modifiedby" checked></td><td><label for="chk_modifiedby">Modified By</label></td></tr>
                    <tr><td><input type="checkbox" id="chk_modifiedon" class="chk-modification" value="modifiedon" checked></td><td><label for="chk_modifiedon">Modified On</label></td></tr>
                    <tr><td><input type="checkbox" id="chk_createdby" class="chk-modification" value="createdby" checked></td><td><label for="chk_createdby">Created By</label></td></tr>
                    <tr><td><input type="checkbox" id="chk_createdon" class="chk-modification" value="createdon" checked></td><td><label for="chk_createdon">Created On</label></td></tr>
                </tbody>
            </table>
        </div>
    </div>`;

    fieldsContainer.innerHTML = html;
    const checkFields = document.querySelectorAll(".chk-fields");
    const checkModifications = document.querySelectorAll(".chk-modification");

    // Handle normal field selection logic
    if (_entity.fields != "All") {
        _entity.fields.split(",").forEach(fldName => {
            if (document.querySelector(`#chk_${fldName}`))
                document.querySelector(`#chk_${fldName}`).checked = true;
        });

        if (checkFields.length == _entity.fields.split(",").length) {
            document.querySelector("#check-all").checked = true;
        }
    } else {
        checkFields.forEach((checkbox) => {
            if (checkbox.dataset.dcname == "dc1")
                checkbox.checked = true;
        });

        _entity.keyField = checkFields[0].value;
    }

    // Handle logic for modification checkboxes separately (no interference with normal fields)
    if (_entity.modificationFields && _entity.modificationFields != "All") {
        _entity.modificationFields.split(",").forEach(modField => {
            document.querySelector(`#chk_${modField}`).checked = true;
        });
    }

    // Update MODIFICATIONFIELDS property on checkbox change
    checkModifications.forEach((checkbox) => {
        checkbox.addEventListener("change", function () {
            let selectedModifications = [];
            checkModifications.forEach((modCheckbox) => {
                if (modCheckbox.checked) {
                    selectedModifications.push(modCheckbox.value);
                }
            });

            _entity.modificationFields = selectedModifications.length > 0 ? selectedModifications.join(",") : "";


            // Save changes when modification field is updated
            saveChanges();
        });
    });

    setModificationFields();


    // Handle Save Logic for modification fields (this logic won't interfere with normal fields)
    function saveChanges() {
        var data = {
            page: "Entity",
            transId: _entity.entityTransId,
            properties: {
                KEYFIELD: _entity.keyField,
                FIELDS: _entity.fields,
                MODIFICATIONFIELDS: _entity.modificationFields
            },
            allUsers: false
        };

        _entityCommon.setAnalyticsDataWS(data, () => {
        }, (error) => {
            console.error('Error in SetEntityFieldsWS:', error);
            ShowDimmer(false);
        });
    }

    updateSelectOptions();
}



function setModificationFields() {
    // Split the stored modification field (which is a comma-separated string) into an array
    const modificationFields = _entity.modificationFields.split(",");  // e.g., ["modifiedby", "modifiedon"]
    const checkboxes = document.querySelectorAll(".chk-modification");  // Select all modification checkboxes

    console.log("Modification Fields:", modificationFields);  // Log the modification fields to check

    if (checkboxes.length === 0) {
        console.error("No checkboxes found with the class 'chk-modification'.");  // Error if no checkboxes found
        return;
    }

    // Reset checkboxes and disable them if no values
    let anySelected = false;
    checkboxes.forEach((checkbox) => {
        checkbox.checked = false;

        // If the checkbox value matches a modification field, check it
        if (modificationFields.includes(checkbox.value)) {
            checkbox.checked = true;  // Check the ones present in the MODIFICATIONFIELDS
            anySelected = true;  // Set flag to true if any checkbox is selected
        }
    });
}



function updateSelectOptions() {
    const selectField = document.getElementById("selectField");
    selectField.innerHTML = "";
    const checkFields = document.querySelectorAll(".chk-fields");
    checkFields.forEach((checkbox) => {
        if (checkbox.checked) {
            const fieldName =
                checkbox.dataset.fldcap || '';
            const option = document.createElement("option");
            option.textContent = fieldName;
            option.value = checkbox.value;
            selectField.appendChild(option);
        }
    });
    selectField.disabled = ![...checkFields].some(
        (checkbox) => checkbox.checked
    );
    selectField.value = _entity.keyField;
}

function applyFields() {
    const selectedFields = document.querySelectorAll(".chk-fields:checked");

    if (selectedFields.length === 0) {
        showAlertDialog("error", "Error: No fields are selected.");
        return; // Exit the function
    }

    const selectField = document.getElementById("selectField");
    if (selectField.value === 0 || selectField.value === "") {
        showAlertDialog("error", "Error: Key Field is not selected.");
        return; // Exit the function
    }

    let fldsStr = "";
    let selectedFldsArray = []
    selectedFields.forEach((field) => {
        const fieldName = field.value;
        selectedFldsArray.push(fieldName);
    });

    fldsStr = selectedFldsArray.join(",");

    const data = {
        page: "Entity",
        transId: _entity.entityTransId,
        properties: {
            FIELDS: fldsStr,
            KEYFIELD: selectField.value
        },
        confirmNeeded: true,
        allUsers: false
    };

    _entityCommon.setAnalyticsDataWS(data, () => {
        _entity.fields = fldsStr;
        _entity.keyField = selectField.value;
        _entity.setSelectedFields();
        console.log("FIELDS and KEYFIELD updated successfully");
    }, (error) => {
        showAlertDialog("error", error.status + " " + error.statusText);
    });
}


function resetFields() {
    const checkFields = document.querySelectorAll(".chk-fields, #check-all");

    const data = {
        page: "Entity",
        transId: _entity.entityTransId,
        properties: {
            FIELDS: "",
            KEYFIELD: ""
        },
        confirmNeeded: true,
        allUsers: false
    };

    _entityCommon.setAnalyticsDataWS(data, () => {
        checkFields.forEach((checkbox) => {
            checkbox.checked = true;
        });

        _entity.fields = "All";
        _entity.keyField = checkFields[0].value;
        updateSelectOptions();
        _entity.setSelectedFields();
        console.log("Fields reset to default values");
    }, (error) => {
        showAlertDialog("error", error.status + " " + error.statusText);
    });
}

function fieldsModelClose() {
    $('#fieldsModal').modal('hide');
}

function getFieldDataType(fldProps) {
    if (_entity.inValid(fldProps.cdatatype)) {
        if (fldProps.fdatatype == "n")
            return "Number";
        else if (fldProps.fdatatype == "d")
            return "Date";
        else if (fldProps.fdatatype == "c")
            return "Text";
        else if (fldProps.fdatatype == "i")
            return "Image";
        else if (fldProps.fdatatype == "t")
            return "Large Text";
        else
            return "Text";
    }
    else
        return fldProps.cdatatype;
}


function getKeyField() {
    var selectedFields = _entity.fields.split(",");
    const metaData = _entity.metaData.filter(item => item.listingfld === "T" && item.hide != "T" && ((_entity.fields == "All" && item.dcname == "dc1") || (selectedFields.indexOf(item.fldname) > -1)));

    // Filter objects with "cdatatype": "Autogenerate"
    const autoGenerateField = metaData.find(item => item.cdatatype === "Auto Generate");
    if (autoGenerateField) {
        return autoGenerateField;
    }

    // Filter objects with hide = F and mandatory/allow empty = T and allowduplicate = F
    const mandatoryUniqueFld = metaData.find(item => item.hide === "F" && item.allowempty === "F" && item.allowduplicate === "F");
    if (mandatoryUniqueFld) {
        return mandatoryUniqueFld;
    }

    // Filter objects with hide = F and mandatory/allow empty = T
    const mandatoryFld = metaData.find(item => item.hide === "F" && item.allowempty === "F");
    if (mandatoryFld) {
        return mandatoryFld;
    }

    // Filter objects with hide = F
    const visibleFld = metaData.find(item => item.hide === "F");
    if (visibleFld) {
        return visibleFld;
    }

    // If none of the above conditions match, return first row
    return metaData[0];
}

function getARMLogs() {
    const tableContainer = document.getElementById('logs-table-container');
    tableContainer.innerHTML = "Loading logs...";
    $('#logsModal').modal('show');

    let _this = _entity;
    let url = "../aspx/Entity.aspx/GetARMLogsWS";
    _this.callAPI(url, {}, true, result => {
        if (result.success) {

            try {
                let logsJson = JSON.parse(JSON.parse(result.response).d);
                tableContainer.innerHTML = createARMLogsTable(logsJson);
            }
            catch {
                tableContainer.innerHTML = "No Logs available";
            }
        }
        else {
        }
    });
}

function createARMLogsTable(data) {
    // Create the table element
    const table = document.createElement('table');
    table.className = 'table table-striped table-bordered';

    // Create the table body
    const tbody = document.createElement('tbody');

    // Populate the table rows
    data.forEach(item => {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        cell.innerText = item;
        row.appendChild(cell);
        tbody.appendChild(row);
    });

    table.appendChild(tbody);
    return table.outerHTML;
}


function debounce(func, delay) {
    let timer;
    return function (...args) {
        clearTimeout(timer);
        timer = setTimeout(() => {
            func.apply(this, args);
        }, delay);
    };
}

const searchInput = document.getElementById("searchBox");
const liveSearchDebounced = debounce(liveSearch, 500);

function handleSearchInput() {
    if (searchInput.value === "") {
        liveSearch();
    } else {
        liveSearchDebounced();
    }
}

searchInput.addEventListener("keyup", handleSearchInput);
searchInput.addEventListener("input", handleSearchInput);

function liveSearch() {
    let cardsData = document.querySelectorAll(".Project_items");
    let tableRows = document.querySelectorAll("tbody tr");
    let searchTerm = searchInput.value.toLowerCase();

    // Filter card view items
    cardsData.forEach((card) => {
        if (card.innerText.toLowerCase().includes(searchTerm)) {
            card.classList.remove("d-none");
        } else {
            card.classList.add("d-none");
        }
    });

    // Filter table view rows
    tableRows.forEach((row) => {
        if (row.innerText.toLowerCase().includes(searchTerm)) {
            row.classList.remove("d-none");
        } else {
            row.classList.add("d-none");
        }
    });
}


let isCardView = true;

function toggleView(storeData = false) {
    pageNo = 1;
    isCardView = !isCardView;
    _entity.viewMode = isCardView ? 'card' : 'table';

    if (storeData) {
        var data = {
            page: "Entity",
            transId: _entity.entityTransId,
            properties: { "TABLEVIEW": !isCardView },
            confirmNeeded: true,
            storeData: storeData,
            allUsers: false
        };

        _entityCommon.setAnalyticsDataWS(data, successCB = () => {
            console.log('View state saved successfully');
        }, errorCB = (error) => {
            showAlertDialog("error", error.status + " " + error.statusText);
        });
    }

    if (isCardView) {
        $('#table-body_Container').hide();
        $('#body_Container').show();
        createCardViewHTML();
        $('#viewIcon').text('view_module');
    } else {
        $('#body_Container').hide();
        $('#table-body_Container').show();
        if (_entity.listJson.length > 0) {
            $('#table-body_Container').html(createTableViewHTML(_entity.listJson));

            const tableDiv = document.querySelector('.table-responsive');
            tableDiv.removeEventListener('scroll', scrollListener);
            tableDiv.addEventListener('scroll', scrollListener);

            $('#viewIcon').text('view_list');
        } else {
            _entity.listJson = [];
            document.querySelector("#table-body_Container").innerHTML = _entity.emptyRowsHtml;
            $('#viewIcon').text('view_module');

            const noMoreRecordsMessage = document.createElement('div');
            noMoreRecordsMessage.classList.add('no-records-message');
            noMoreRecordsMessage.textContent = "No more records";
            $('#table-body_Container').append(noMoreRecordsMessage);

            setTimeout(function () {
                $(noMoreRecordsMessage).remove();
            }, 3000);
        }
    }
}

function onToggleButtonClick() {
    toggleView(true);
}



// Define formatFieldName function
function formatFieldName(field) {
    return field
        .replace(/([A-Z])/g, ' $1')
        .replace(/createdby/g, 'Created By')
        .replace(/modifiedby/g, 'Modified By')
        .replace(/createdon/g, 'Created On')
        .replace(/modifiedon/g, 'Modified On')
        .replace(/^ /, '');
}

function createTableViewHTML(listJson, _pageNo) {
    let tableBodyContainer = $('#table-body_Container');
    let tableExists = tableBodyContainer.find('table').length > 0;
    let keyCol = _entity.keyField || '';
    let html = '';
    let excludedFields = new Set(['transid', 'ftransid']);

    let hideTransid = !listJson.some(rowData => rowData[keyCol]);

    const filteredMetaData = _entity.metaData.filter(item => item.listingfld === "T");
    const fieldsWithData = new Set();
    const addedFields = new Set();

    // Dynamic Fields to be checked against _entity.modificationFields
    const dynamicFields = ['modifiedby', 'modifiedon', 'createdby', 'createdon'];

    // Check if modificationFields exists and is a valid string
    if (_entity.modificationFields && typeof _entity.modificationFields === 'string') {
        const modificationFieldsArray = _entity.modificationFields.split(",");

        // Ensure modificationFieldsArray is not empty and contains valid values
        if (modificationFieldsArray.length > 0) {
            dynamicFields.forEach(field => {
                if (modificationFieldsArray.includes(field)) {
                    const fieldMeta = {
                        fldname: field,
                        fldcap: formatFieldName(field),
                        listingfld: "T"
                    };
                    filteredMetaData.push(fieldMeta);
                }
            });
        }
    } else {
        // If modificationFields is empty or invalid, include all dynamic fields
        dynamicFields.forEach(field => {
            if (listJson.some(rowData => rowData[field])) {
                const fieldMeta = {
                    fldname: field,
                    fldcap: formatFieldName(field),
                    listingfld: "T"
                };
                filteredMetaData.push(fieldMeta);
            }
        });
    }

    listJson.forEach(rowData => {
        for (let field in rowData) {
            if (rowData[field] !== null && rowData[field] !== undefined && !excludedFields.has(field)) {
                fieldsWithData.add(field);
            }
        }
    });

    if (!keyCol || !_entity.metaData.some(field => field.fldname === keyCol)) {
        const keyField = getKeyField();
        keyCol = keyField ? keyField.fldname : _entity.keyField;
    }

    if (!tableExists) {
        html += '<div class="table-responsive"><table class="table table-striped">';

        html += '<thead class="sticky-header"><tr>';
        html += '<th><input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll(this)"></th>';
        html += '<th>Edit Form</th>';

        if (fieldsWithData.has(keyCol)) {
            const keyField = _entity.metaData.find(field => field.fldname === keyCol);
            if (keyField) {
                html += `<th>${keyField.fldcap}</th>`;
            }
        }

        // Add fields from filteredMetaData (including dynamically added fields)
        filteredMetaData.forEach(field => {
            if (field.fldname !== keyCol && fieldsWithData.has(field.fldname) && !excludedFields.has(field.fldname) && (!hideTransid || field.fldname !== 'transid')) {
                if (!addedFields.has(field.fldname)) {
                    html += `<th>${field.fldcap}</th>`;
                    addedFields.add(field.fldname);
                }
            }
        });
        html += '</tr></thead><tbody>';
    } else {
        tableBodyContainer.find('tbody').empty();
    }

    // Loop through listJson and generate the rows
    listJson.forEach((rowData, index) => {
        html += `<tr>`;
        html += `<td><input type="checkbox" class="rowCheckbox" data-index="${index}" data-recordid="${rowData.recordid}"></td>`;
        html += `<td><button type="button" class="btn btn-icon btn-white btn-color-gray-600 btn-active-primary shadow-sm tb-btn btn-sm me-3" data-bs-toggle="tooltip" title="Edit" data-bs-original-title="Edit" onclick="return _entity.editEntity('${rowData.recordid}')"><span class="material-icons material-icons-style material-icons-2" style="color: red;">edit_note</span></button></td>`;

        if (fieldsWithData.has(keyCol)) {
            const entityName = _entity.entityName;
            const transId = _entity.entityTransId;
            const recordId = rowData.recordid;
            const keyValue = rowData[keyCol];
            const rowNo = rowData.rno;

            html += `<td><a href="#" onclick="_entity.openEntityForm('${entityName}','${transId}', '${recordId}', '${keyValue}', ${rowNo})">${keyValue}</a></td>`;
        } else {
            html += `<td></td>`;
        }

        filteredMetaData.forEach(field => {
            if (field.fldname !== keyCol && fieldsWithData.has(field.fldname) && !excludedFields.has(field.fldname) && (!hideTransid || field.fldname !== 'transid')) {

                let fieldValue = rowData[field.fldname];
                let cellContent = '';

                // Handle boolean fields
                if (fieldValue === 'T' || fieldValue === 'F') {
                    cellContent = `
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" ${fieldValue === 'T' ? 'checked' : ''} disabled>
                        </div>`;

                } else if ((field.fldname === 'modifiedon' || field.fldname === 'createdon' || field.fldname === 'docdate') && fieldValue) {
                    cellContent = formatDateString(fieldValue);

                } else {
                    cellContent = `${fieldValue || ''}`;
                }

                html += `<td>${cellContent}</td>`;
            }
        });

        html += `</tr>`;
    });

    if (!tableExists) {
        html += '</tbody></table></div>';
        tableBodyContainer.append(html);
        initializeDataTable();
    } else {
        const dataTableInstance = $('#table-body_Container .table').DataTable();

        if ($.fn.DataTable.isDataTable('#table-body_Container .table')) {
            dataTableInstance.destroy();
            tableBodyContainer.find('tbody').empty();
        }

        tableBodyContainer.find('tbody').append(html);
        initializeDataTable();
    }
}


// Helper function to capitalize first letter of the string
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}


function deleteSelectedRecordsFromToolbar() {
    const tableCheckboxes = document.querySelectorAll('.rowCheckbox');
    const cardCheckboxes = document.querySelectorAll('.Select-Project');

    const selectedIds = [

        ...Array.from(tableCheckboxes)
            .filter(checkbox => checkbox.checked)
            .map(checkbox => checkbox.closest('tr').querySelector('td:nth-child(3) a').textContent.trim()),


        ...Array.from(cardCheckboxes)
            .filter(checkbox => checkbox.checked)
            .map(checkbox => checkbox.getAttribute('data-recordid'))
    ];

    if (selectedIds.length > 0) {
        const confirmationModalBody = document.getElementById('confirmationModalBody');
        confirmationModalBody.textContent = `Are you sure you want to delete ${selectedIds.length} record(s)?`;
        const confirmationModal = new bootstrap.Modal(document.getElementById('confirmationModal1'));

        confirmationModal.show();

        document.getElementById('confirmButton').addEventListener('click', () => {
            deleteSelectedRecords(selectedIds);


            selectedIds.forEach(id => {
                const tableRowCheckbox = document.querySelector(`.rowCheckbox[id="checkbox_${id}"]`);
                const cardCheckbox = document.querySelector(`.Select-Project[id="checkbox_${id}"]`);


                if (tableRowCheckbox) {
                    tableRowCheckbox.closest('tr').remove();
                }


                if (cardCheckbox) {
                    cardCheckbox.closest('.page-Header').remove();
                }
            });

            confirmationModal.hide();
        });
    } else {
        const notificationModalBody = document.getElementById('notificationModalBody');
        notificationModalBody.textContent = 'No records selected for deletion.';
        const notificationModal = new bootstrap.Modal(document.getElementById('notificationModal'));

        notificationModal.show();
    }
}





function initializeDataTable() {
    if ($.fn.DataTable.isDataTable('#table-body_Container .table')) {
        $('#table-body_Container .table').DataTable().destroy();
    }

    table = $('#table-body_Container .table').DataTable({
        "bInfo": false,
        dom: 'Bfrtip',
        paging: false,
        searching: false,
        ordering: true,
        columnDefs: [
            { targets: 0, orderable: false }
        ]
    });

    $('#floatingMenu-export a').on('click', function (e) {
        e.preventDefault();
        const action = $(this).data('target');
        const exportButton = table.buttons(`.buttons-${action.toLowerCase()}`);
        if (exportButton) {
            exportButton.trigger();
        }
    });
}






function handleExport(action, tableSelector) {
    const entityName = _entity.entityName;
    const dateFormat = dtCulture === "en-us" ? "MM/dd/yyyy" : "dd/MM/yyyy";

    function getFileExtension(action) {
        switch (action.toUpperCase()) {
            case 'PDF':
                return 'pdf';
            case 'EXCEL':
                return 'xlsx';
            case 'PRINT':
                return 'pdf';
            case 'WORD':
                return 'docx';
            default:
                return 'pdf';
        }
    }

    function exportData(table, action) {
        if (table.buttons) {
            switch (action.toUpperCase()) {
                case 'PRINT':
                    table.button('.buttons-print').trigger();
                    break;
                case 'PDF':
                    table.button('.buttons-pdf').trigger();
                    break;
                case 'EXCEL':
                    table.button('.buttons-excel').trigger();
                    break;
                default:
                    console.error("Unsupported export action: " + action);
            }
        } else {
            console.error("Buttons are not initialized for the table");
        }
    }


    const dataCount = _entity.listJson.length;
    const transId = _entity.entityTransId;
    const fileExtension = getFileExtension(action);
    const fileName = `${entityName}.${fileExtension}`;

    if (action.toUpperCase() === 'WORD' || dataCount > ((_entity.pageSize * _entity.maxPageNumber) - 1)) {
        ASB.WebService.ARMExportPushToQueue(transId, "list", fileName, "Entity", dateFormat, _entity.fields, _entity.entityName,
            () => {
                $('#exportModal').modal('show');
            },
            (error) => {
                //$('#exportModal').modal('show');
                console.error("Export request failed: ", error);
            }
        );
    } else {

        const hiddenTableSelector = '#hiddenTable';

        if ($.fn.dataTable.isDataTable(hiddenTableSelector)) {
            $(hiddenTableSelector).DataTable().destroy();
        }

        createHiddenTableFromMetadata();

        

        const hiddenTable = $(hiddenTableSelector).DataTable({
            layout: {
                topStart: {
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                }
            }
        });

        exportData(hiddenTable, action);
        
    }
}




function createHiddenTableFromMetadata() {    
    $('#hiddenTableContainer').empty();

    let tableHtml = `<table id="hiddenTable" class="display nowrap" style="width:100%">
        <thead><tr>`;

    let fieldsWithData = [];

    _entity.metaData.forEach(field => {
        if (field.hide !== 'T') {
            let hasData = _entity.listJson.some(rowData => rowData[field.fldname] && typeof rowData[field.fldname] != "undefined" && rowData[field.fldname]?.toString().trim() !== '');

            if (hasData) {
                fieldsWithData.push(field);
                tableHtml += `<th>${field.fldcap}</th>`;
            }
        }
    });

    tableHtml += `</tr></thead><tbody>`;

    _entity.listJson.forEach(rowData => {
        let rowHasData = false;
        let rowHtml = `<tr>`;

        fieldsWithData.forEach(field => {
            let cellValue = rowData[field.fldname]?.toString() || '';

            if (cellValue !== '') {
                rowHasData = true;

                if (isDateField(field)) {
                    const dateValue = new Date(cellValue);
                    if (!isNaN(dateValue)) {
                        if (field.fldname.toLowerCase() === 'modifiedon') {
                            const formattedDate = dateValue.toLocaleDateString('en-GB', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric'
                            });
                            const formattedTime = dateValue.toLocaleTimeString('en-GB', {
                                hour: '2-digit',
                                minute: '2-digit',
                                second: '2-digit'
                            });
                            cellValue = `${formattedDate} ${formattedTime}`;
                        } else {
                            // Format other date fields as DD/MM/YYYY
                            cellValue = dateValue.toLocaleDateString('en-GB', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric'
                            });
                        }
                    }
                } else {
                    // For non-date fields, remove 'T' and 'Z' if present
                    cellValue = cellValue.replace('T', ' ').replace(/Z$/, '');
                }

                rowHtml += `<td>${cellValue}</td>`;
            } else {
                rowHtml += `<td></td>`;
            }
        });

        rowHtml += `</tr>`;

        if (rowHasData) {
            tableHtml += rowHtml;
        }
    });

    tableHtml += `</tbody></table>`;

    $('#hiddenTableContainer').append(tableHtml);
}


function isDateField(field) {
    return field.cdatatype === 'Date' ||
        field.fdatatype === 'd' ||
        field.fldname.toLowerCase() === 'modifiedon';
}



function toggleSelectAll(source) {
    const checkboxes = document.querySelectorAll('.rowCheckbox');
    checkboxes.forEach(checkbox => {
        checkbox.checked = source.checked;
    });

    // updateDataTableOrdering(source.checked);

    const selectedIds = Array.from(checkboxes)
        .filter(checkbox => checkbox.checked)
        .map(checkbox => checkbox.closest('tr').querySelector('td:nth-child(3) a').textContent.trim());

    if (selectedIds.length > 0) {
        deleteSelectedRecords(selectedIds);
    }
}




function showNotification(message) {
    const modalBody = document.querySelector('#notificationModal .modal-body');
    modalBody.textContent = message;

    const confirmationModal = new bootstrap.Modal(document.getElementById('notificationModal'));
    confirmationModal.show();
}

function deleteSelectedRecords() {
    const tableCheckboxes = document.querySelectorAll('.rowCheckbox:checked');
    const cardCheckboxes = document.querySelectorAll('.Select-Project:checked');

    const selectedCheckboxes = [...tableCheckboxes, ...cardCheckboxes];

    if (selectedCheckboxes.length === 0) {
        showNotification("Please select at least one record to delete.");
        return;
    }

    let recIds = [];
    let xmlData = '';

    selectedCheckboxes.forEach((checkbox, index) => {
        const recordId = checkbox.getAttribute('data-recordid');
        recIds.push(recordId);
        xmlData += `
            <row>
                <rowno>${index + 1}</rowno>
                <recordid>${recordId}</recordid>
            </row>`;
    });

    const traceValue = window.top.axTraceFlag ? `â™¦â™¦DeleteRow-${_entity.entityTransId}â™¦` : "";

    const requestPayload = {
        recIds: recIds.join(','),
        transid: _entity.entityTransId,
        s: `<root axpapp="${window.top.mainProject}" trace="${traceValue}" sessionid="${window.top.mainSessionId}" stype="iviews" sname="${_entity.entityTransId}" actname="delete">
            <varlist>${xmlData}</varlist>
        `
    };

    console.log("Request Payload:", requestPayload);

    function successCallback(resposne) {
        if (resposne) {
            response = JSON.parse(resposne)
            if (response.error) {
                showAlertDialog("error", response.error?.[0]?.msg);
                return;
            }
            else {
                showNotification("Records deleted successfully.");
                _entity.reloadEntityPage();
            }
        }

        else {
            showNotification("Failed to delete records. Please try again.");
        }


    }

    function errorCallback(error) {
        console.error("Error details:", error);
        showNotification("Error while deleting records. Please try again.");
    }

    ASB.WebService.DeleteIviewRow(requestPayload.recIds, requestPayload.transid, requestPayload.s, successCallback, errorCallback);
}





// function updateDataTableOrdering(disableOrdering) {
//     if (disableOrdering) {
//         table.order([]).draw(); 
//         table.columns().every(function () {
//             this.header().setAttribute('data-orderable', 'false'); 
//         });
//     } else {
//         table.columns().every(function () {
//             this.header().removeAttribute('data-orderable'); 
//         });
//     }
// }




function createCardViewHTML() {
    createListHTML(_entity.listJson, 1);
}

function scrollListener(event) {
    const myDiv = event.target;

    const currentScrollTop = myDiv.scrollTop;
    const currentScrollLeft = myDiv.scrollLeft;


    if (this.lastScrollTop !== currentScrollTop) {
        this.lastScrollTop = currentScrollTop;

        if (!isFetching && isScrollAtBottomWithinDiv(myDiv)) {
            isFetching = true;
            pageNo++;

            _entity.getEntityListData(pageNo);

            setTimeout(() => {
                isFetching = false;
            }, 500);
        }
    }

    this.lastScrollLeft = currentScrollLeft;
}


// Function to handle when no chart data is available (works for both analytics and entity)
function handleNoChartData() {
    document.querySelectorAll(".analytics-container, .entity-card").forEach(item => {
        item.classList.add("d-none");
    });
    document.querySelectorAll(".nodata, .NO-KPI-Items").forEach(item => {
        item.classList.remove("d-none");
    });
}

// Function to handle when chart data is available (works for both analytics and entity)
function handleValidChartData() {
    document.querySelectorAll(".analytics-container, .entity-card").forEach(item => {
        item.classList.remove("d-none");
    });
    document.querySelectorAll(".nodata, .NO-KPI-Items").forEach(item => {
        item.classList.add("d-none");
    });
}


$(document).ready(function () {
    $('.entity-card').on('click', function () {
        const wrapper = $('#Homepage_CardsList_Wrapper');
        const arrowIcon = $(this).find('.arrow-icon');

        if (wrapper.hasClass('show')) {
            wrapper.removeClass('show').slideUp();
        } else {
            wrapper.addClass('show').slideDown();
        }

        arrowIcon.toggleClass('fa-chevron-down fa-chevron-up');
    });
});



function selectView(viewType) {
    if (viewType === 'table') {
        _entity.tableViewFlag = true;
    } else {
        _entity.tableViewFlag = false;
    }

    // Highlight the selected option
    const tableLink = document.getElementById('tableView');
    const listLink = document.getElementById('listView');

    if (_entity.tableViewFlag) {
        tableLink.classList.add('selected');
        listLink.classList.remove('selected');
    } else {
        listLink.classList.add('selected');
        tableLink.classList.remove('selected');
    }
}

function selectCaptions(captionsType) {
    if (captionsType === 'visible') {
        _entity.captionsEnabled = true;
    } else {
        _entity.captionsEnabled = false;
    }

    const visibleLink = document.getElementById('visible');
    const hiddenLink = document.getElementById('hidden');

    if (_entity.captionsEnabled) {
        visibleLink.classList.add('selected');
        hiddenLink.classList.remove('selected');
    } else {
        hiddenLink.classList.add('selected');
        visibleLink.classList.remove('selected');
    }
}

function highlightInitialSelection() {
    if (_entity.tableViewFlag) {
        selectView('table');
    } else {
        selectView('list');
    }

    if (_entity.captionsEnabled) {
        selectCaptions('visible');
    } else {
        selectCaptions('hidden');
    }
}



// function toggleRightPanel() {
//     const entityDiv = document.getElementById("Entity_management_Right");
//     const currentDisplay = window.getComputedStyle(entityDiv).getPropertyValue("display");

//     if (currentDisplay === "none") {
//         entityDiv.style.setProperty("display", "block", "important");
//     } else {
//         entityDiv.style.setProperty("display", "none", "important"); 
//     }
// }


function toggleRightPanel() {
    const entityDiv = document.getElementById("Entity_management_Right");
    const button = document.querySelector("button[onclick='toggleRightPanel();']");
    const currentDisplay = window.getComputedStyle(entityDiv).getPropertyValue("display");

    const data = {
        page: "Entity",
        transId: _entity.entityTransId,
        properties: {
            RIGHTPANEL: (currentDisplay === "none") ? "expanded" : "collapsed"
        },
        confirmNeeded: true,
        allUsers: false
    };

    _entityCommon.setAnalyticsDataWS(data, () => {

        if (currentDisplay === "none") {
            entityDiv.style.setProperty("display", "block", "important");
            button.style.setProperty("display", "none", "important");

            _entity.properties.RIGHTPANEL = "expanded";
        } else {
            entityDiv.style.setProperty("display", "none", "important");
            button.style.setProperty("display", "inline-block", "important");

            _entity.properties.RIGHTPANEL = "collapsed";
        }

    }, (error) => {
        showAlertDialog("error", error.status + " " + error.statusText);
    });
}




function togglePin() {
    const entityDiv = document.getElementById("Entity_management_Right");
    const button = document.querySelector("button[onclick='toggleRightPanel();']");
    const currentDisplay = window.getComputedStyle(entityDiv).getPropertyValue("display");

    const data = {
        page: "Entity",
        transId: _entity.entityTransId,
        properties: {
            RIGHTPANEL: (currentDisplay === "none") ? "expanded" : "collapsed"
        },
        confirmNeeded: true,
        allUsers: false
    };

    _entityCommon.setAnalyticsDataWS(data, () => {
        if (currentDisplay === "none") {
            entityDiv.style.setProperty("display", "block", "important");
            button.style.setProperty("display", "none", "important");
            _entity.properties.RIGHTPANEL = "expanded";
        } else {
            entityDiv.style.setProperty("display", "none", "important");
            button.style.setProperty("display", "inline-block", "important");
            _entity.properties.RIGHTPANEL = "collapsed";
        }
        console.log("RIGHTPANEL updated successfully");
    }, (error) => {
        showAlertDialog("error", error.status + " " + error.statusText);
    });
}

