var applstJson = "";
let handlerType = "";
var redislstJson = "";
var isFile = "false";
var isArm = "false";
$j(document).ready(function () {
    $("#lstconnection").select2();
    $("#lstRconnection").select2();
    $("#ddldbtype").select2();
    // $(".axSelectProj").select2();
    $("#ddldbversion").select2();
    $("#lstconnection").val(selProj).trigger('change');

    $("#btnaddcon").click(function () {
        $("#lstconnection").val("").trigger('change');
        $("#ddldbtype").val("").trigger('change');
        $("#ddldbversion").val("").trigger('change');

    })
    //$("#axSelectProj").select2().select2('val',localStorageProj);

    if (IsLicExist == "false") {
        //$("#btnRefresh").attr('disabled', 'disabled').addClass("disabledButton");
        //$("#btnActivate").removeAttr("disabled").removeClass("disabledButton");
        //$("#btnTrial").removeAttr("disabled").removeClass("disabledButton");
        $("#dvlicmessage").show();
        $("#btnRefresh").hide();
        $("#btnActivate").show();
        $("#btnTrial").show();
        $(".licActOptions").show();
        $("#dvdbConnection").addClass("disabledDiv");
    }
    else {
        $("#dvlicmessage").hide();
        $(".licActOptions").hide();
        $("#btnRefresh").show();
        $("#btnActivate").hide();
        $("#btnTrial").hide();
        $("#dvdbConnection").removeClass("disabledDiv");
    }

    redislist = ReverseCheckSpecialChars(redislist);
    if (redislist != "") {
        var rxml = parseXml(redislist)
        redislstJson = JSON.parse(xml2json(rxml, ""));
        if (redislstJson != "") {
            let fstValue = $("#lstRconnection option:first").val();
            if (typeof fstValue != "undefined") {
                var rhost = redislstJson.axp_rconn[fstValue].host;
                var rport = redislstJson.axp_rconn[fstValue].port;
                var rpwd = redislstJson.axp_rconn[fstValue].pwd;
                $("#txtrhotname").val(rhost);
                $("#txtrport").val(rport);
                $("#txtrpwd").val("");
                $('#lstRconnection').val(fstValue); // Select the option with a value of '1'
                $('#lstRconnection').trigger('change');
            }
        }
    }

    // $("#btndelete").hide(); // hide class is added in asp button    
    $("#ddldbversion").val(version).prop("disabled", true);
    applist = ReverseCheckSpecialChars(applist);
    if (applist != "") {
        var xml = parseXml(applist)
        applstJson = JSON.parse(xml2json(xml, ""));
        if (selProj != "" && applstJson != "") {
            $("#lstconnection").val(selProj).focus();
            // setProjectImages(selProj);
            var db = applstJson.connections[selProj].db;
            var dbcon = applstJson.connections[selProj].dbcon;
            var dbuser = applstJson.connections[selProj].dbuser;
            var version = applstJson.connections[selProj].version == null ? "" : applstJson.connections[selProj].version;
            var driver = applstJson.connections[selProj].driver;

            $("#lblconname").text(selProj);
            $("#ddldbtype").val(db).trigger('change');
            if (db.toString() != "MS SQL")
                $(".databasever").addClass("d-none");
            // $("#ddldbtype").val(db);
            if (version != "")
                $("#ddldbversion").val(version).prop("disabled", false);
            else
                $("#ddldbversion").val(version).prop("disabled", true);
            $("#txtccname").val(dbcon);
            $("#txtusername").val(dbuser);
            $("#ddldriver").val(driver);
        }
        else if (applstJson != "") {
            var fstValue = $("#lstconnection option:first").val();
            if (typeof fstValue != "undefined") {
                $("#lstconnection").val(fstValue).focus();
                // setProjectImages(fstValue);
                var db = applstJson.connections[fstValue].db;
                var dbcon = applstJson.connections[fstValue].dbcon;
                var dbuser = applstJson.connections[fstValue].dbuser;
                var version = applstJson.connections[fstValue].version == null ? "" : applstJson.connections[fstValue].version;
                var driver = applstJson.connections[fstValue].driver;

                $("#lblconname").text(fstValue);
                $("#ddldbtype").val(db).trigger('change');
                // $("#ddldbtype").val(db);
                if (version != "")
                    $("#ddldbversion").val(version).prop("disabled", false);
                else
                    $("#ddldbversion").val(version).prop("disabled", true);
                $("#txtccname").val(dbcon);
                $("#txtusername").val(dbuser);
                $("#ddldriver").val(driver);
            }
        }
    }
    if (applstJson != "") {
        var fstValuearm = $("#armproj option:first").val();
        if (typeof fstValuearm != "undefined") {
            $("#armproj").val(fstValuearm).focus();
            $('#armproj').trigger('change');
            //var dbuserarm = applstJson.connections[fstValuearm].dbuser;
            //var proj = dbuserarm;
            var proj = fstValuearm;
            if (proj.indexOf("\\") != -1)
                proj = proj.split("\\")[0];
            $("#hdnprojarm").val(proj);
            armlist = armlist.replace('"{\r\n', '{\r\n').replace('\r\n}"', '\r\n}').replaceAll("\r\n", "");
            // Parse the JSON data into a JavaScript object
            if (armlist != "") {
                var configData = JSON.parse(armlist);
                // Check if the specified key exists in the JSON object
                if (configData.hasOwnProperty(proj)) {
                    // Get the JSON object corresponding to the specified key
                    document.getElementById("txtarmkey").value = configData[proj].ARM_PrivateKey;
                    document.getElementById("txtarmurl").value = configData[proj].ARM_URL;
                    document.getElementById("txtscripturl").value = configData[proj].ARM_Scripts_URL;
                    document.getElementById("txtpeg").value = configData[proj].PEG;
                    $('#txtpeg').trigger('change');
                }
            }
        }
    }

    if (applstJson != "") {
        var fstValuefile = $("#fileproj option:first").val();
        if (typeof fstValuefile != "undefined") {
            $("#fileproj").val(fstValuefile).focus();
            $('#fileproj').trigger('change');
            //var dbuserfile = applstJson.connections[fstValuefile].dbuser;
            /*var projfile = dbuserfile;*/
            var projfile = fstValuefile;
            if (projfile.indexOf("\\") != -1)
                projfile = projfile.split("\\")[0];
            $("#hdnfileproj").val(projfile);
            filelist = filelist.replace('"{\r\n', '{\r\n').replace('\r\n}"', '\r\n}').replaceAll("\r\n", "");
            // Parse the JSON data into a JavaScript object
            if (filelist != "") {
                var configDatafile = JSON.parse(filelist);
                // Check if the specified key exists in the JSON object
                if (configDatafile.hasOwnProperty(projfile)) {
                    // Get the JSON object corresponding to the specified key
                    document.getElementById("txtfileupload").value = configDatafile[projfile].FileUploadPath;
                    document.getElementById("txtfiledownload").value = configDatafile[projfile].FileDownloadPath;
                    document.getElementById("txtfileMapUsername").value = configDatafile[projfile].FileServerMapUsername;
                    document.getElementById("tstfileMapPwd").value = configDatafile[projfile].FileServerMapPwd;
                }
            }
        }
    }

    $(document).on('click', ".upload-button", function (e) {
        try {
            if ($("#axSelectProj").val() == "") {
                showAlertDialog("warning", "Please Select UI Configuration Project");
                $("#axSelectProj").focus();
                e.preventDefault();
                e.stopPropagation();
                return false;
            }

            handlerType = "upload";
            $(e.currentTarget).nextAll(".file-upload").trigger("click");
        } catch (ex) { }
    });

    $(document).on('click', ".delete-button", function (e) {
        try {
            if ($("#axSelectProj").val() == "") {
                showAlertDialog("warning", "Please Select UI Configuration Project");
                $("#axSelectProj").focus();
                e.preventDefault();
                e.stopPropagation();
                return false;
            }

            handlerType = "delete";
            $(e.currentTarget).parent().find(".file-upload").trigger("change");
        } catch (ex) { }
    });

    $(document).on('change', ".file-upload", function (e) {
        uploadLogo(e);
    });

    $("#ddlIsNewConnection").val('new');
    $("#txtNewConName").val('');

    $("#ddlIsRedisNewConnection").val('new');
    $("#txtRedisNewConn").val('');

    $("#demo").on("hide.bs.collapse", function () {
        $(".licInfoAccordion").html('<span class="material-icons">expand_more</span>');
    });
    $("#demo").on("show.bs.collapse", function () {
        $(".licInfoAccordion").html('<span class="material-icons">expand_less</span>');
    });
    if (IsLicExist == "false") {
        $("#demo").addClass("in");
        $(".licInfoAccordion").html('<span class="material-icons">expand_less</span>');
    }


    $('#filMyFile').bind({
        change: function () {
            var filename = $("#filMyFile").val();
            if (/^\s*$/.test(filename)) {
                $(".file-upload").removeClass('active');
                $("#lblfuerror").text("No file chosen...");
            }
            else
                $(".file-upload").addClass('active');
            var fileExtension = ['lic'];
            var ext = filename.split('.').pop().toLowerCase();
            if ($.inArray(ext, fileExtension) == -1) {
                $('#btnFileUpload').prop('disabled', true);
                $("#lblfuerror").text("Invalid file format.");
            }
            else {
                $('#btnFileUpload').prop('disabled', false);
                $("#lblfuerror").text("");
            }
            var uploadControl = $('#filMyFile')[0].files;
            if (uploadControl.length > 0)
                $("#lblnofilename").text(uploadControl[0].name);
        }
    });

    if (authPopup == "true")
        $("#myModalAuth").show();

    initUiPanel();
});

$j(document).on("click", "#lstconnection option", function (e) {
    var lvalue = $(this).val();
    if (applstJson != "") {
        var db = applstJson.connections[lvalue].db;
        var dbcon = applstJson.connections[lvalue].dbcon;
        var dbuser = applstJson.connections[lvalue].dbuser;
        var version = applstJson.connections[lvalue].version == null ? "" : applstJson.connections[lvalue].version;
        var driver = applstJson.connections[lvalue].driver;

        $("#lblconname").text(lvalue);
        $("#ddldbtype").val(db);
        if (db != "")
            $("#ddldbtype").val(db).trigger('change');


        if (version != "") {
            $("#ddldbversion").val(version).prop("disabled", false);
            $("#ddldbversion").val(version).trigger('change');
        }
        else
            $("#ddldbversion").val(version).prop("disabled", true);
        $("#txtccname").val(dbcon);
        $("#txtusername").val(dbuser);
        $("#ddldriver").val(driver);
    }
});

$j(document).on("change", "#lstconnection", function (e) {
    var lvalue = $(this).val();
    if (applstJson != "" && lvalue != null) {
        var db = applstJson.connections[lvalue].db;
        var dbcon = applstJson.connections[lvalue].dbcon;
        var dbuser = applstJson.connections[lvalue].dbuser;
        var version = applstJson.connections[lvalue].version == null ? "" : applstJson.connections[lvalue].version;
        var driver = applstJson.connections[lvalue].driver;

        $("#lblconname").text(lvalue);
        $("#ddldbtype").val(db);
        $('#ddldbtype').trigger('change');
        if (db != "")
            $("#ddldbtype").val(db).trigger('change');
        if (db.toString().toLowerCase() != "ms sql") {
            $("#ddldbversion").val("").trigger('change');
            $(".databasever").addClass("d-none");
        }//'MS SQL'
        else
            $(".databasever").removeClass("d-none");
        if (version != "") {
            $("#ddldbversion").val(version).prop("disabled", false);
            $("#ddldbversion").val(version).trigger('change');
        }
        else {
            $("#ddldbversion").val(version).prop("disabled", true);

        }
        $("#txtccname").val(dbcon);
        $("#txtusername").val(dbuser);
        $("#ddldriver").val(driver);

        // setProjectImages(lvalue);
    }
});

$j(document).on("change", "#fileproj", function (e) {
    var lvalue = $(this).val();
    if (applstJson != "") {
        //var dbuser = applstJson.connections[lvalue].dbuser;
        //var proj = dbuser;
        var proj = lvalue;
        if (proj.indexOf("\\") != -1)
            proj = proj.split("\\")[0];
        $("#hdnfileproj").val(proj);
        if (filelist.indexOf("\\r\\n") == -1 && filelist.indexOf("\r\n") == -1 && isFile == "false") {
            filelist = filelist.slice(1, -1);

        }
        //if (filelist.indexOf("\\") != -1)
        //    filelist = filelist.replaceAll("\\", "");
        if (filelist.indexOf("\\r\\n") != -1)
            filelist = filelist.replace('"{\\r\\n', '{\\r\\n').replace('\\r\\n}"', '\\r\\n}').replaceAll("\\r\\n", "").replaceAll("\\", "");
        else
            filelist = filelist.replace('"{\r\n', '{\r\n').replace('\r\n}"', '\r\n}').replaceAll("\r\n", "");

        // Parse the JSON data into a JavaScript object
        try {
            if (filelist != "") {
                var configDatafile = JSON.parse(filelist);
                isFile = "true"
                // Check if the specified key exists in the JSON object
                if (configDatafile.hasOwnProperty(proj)) {
                    // Get the JSON object corresponding to the specified key
                    document.getElementById("txtfileupload").value = configDatafile[proj].FileUploadPath;
                    document.getElementById("txtfiledownload").value = configDatafile[proj].FileDownloadPath;
                    document.getElementById("txtfileMapUsername").value = configDatafile[proj].FileServerMapUsername;
                    document.getElementById("tstfileMapPwd").value = configDatafile[proj].FileServerMapPwd;
                }
                else {
                    document.getElementById("txtfileupload").value = "";
                    document.getElementById("txtfiledownload").value = "";
                    document.getElementById("txtfileMapUsername").value = "";
                    document.getElementById("tstfileMapPwd").value = "";
                }
            }
        }
        catch (ex) { }
    }
});

$j(document).on("change", "#armproj", function (e) {
    var lvalue = $(this).val();
    if (applstJson != "") {
        //var dbuser = applstJson.connections[lvalue].dbuser;
        //var proj = dbuser;
        var proj = lvalue;
        if (proj.indexOf("\\") != -1)
            proj = proj.split("\\")[0];
        $("#hdnprojarm").val(proj);
        if (armlist.indexOf("\\r\\n") == -1 && armlist.indexOf("\r\n") == -1 && isArm == "false") {
            armlist = armlist.slice(1, -1);
        }
        if (armlist.indexOf("\\") != -1)
            armlist = armlist.replaceAll("\\", "");
        if (armlist.indexOf("\\r\\n") != -1)
            armlist = armlist.replace('"{\\r\\n', '{\\r\\n').replace('\\r\\n}"', '\\r\\n}').replaceAll("\\r\\n", "").replaceAll("\\", "");
        else
            armlist = armlist.replace('"{\r\n', '{\r\n').replace('\r\n}"', '\r\n}').replaceAll("\r\n", "");
        // Parse the JSON data into a JavaScript object
        try {
            if (armlist != "") {

                var configDataARM = JSON.parse(armlist);
                isArm = "true"
                // Check if the specified key exists in the JSON object
                if (configDataARM.hasOwnProperty(proj)) {
                    // Get the JSON object corresponding to the specified key
                    document.getElementById("txtarmkey").value = configDataARM[proj].ARM_PrivateKey;
                    document.getElementById("txtarmurl").value = configDataARM[proj].ARM_URL;
                    document.getElementById("txtscripturl").value = configDataARM[proj].ARM_Scripts_URL;
                    document.getElementById("txtpeg").value = configDataARM[proj].PEG;
                    $('#txtpeg').trigger('change');
                }
                else {
                    document.getElementById("txtarmkey").value = "";
                    document.getElementById("txtarmurl").value = "";
                    document.getElementById("txtscripturl").value = "";
                    document.getElementById("txtpeg").value = "";
                    $('#txtpeg').trigger('change');
                }
            }
        }
        catch (ex) { }
    }
});
$j(document).on("click", "#btnApply", function (e) {
    if ($("#lstconnection").val() == null || $("#lstconnection").val() == "") {
        $("#ddlIsNewConnection").val('new');
        $('#myModal').modal("show");
    }
    else {
        $("#ddlIsNewConnection").val('old');
        $("#txtNewConName").val($("#lstconnection").val());
        $("#btnok").click();
    }
});

$j(document).on("click", "#btnChangePassword", function (e) {
    $('#myModaldbpassword').modal("show");
});

$j(document).on("click", "#btnCancel", function (e) {
    window.document.location.href = "signin.aspx";
});

$j(document).on("click", "#btnaddcon", function (e) {
    $("#ddldbtype").prop('selectedIndex', 0);
    $("#ddldbversion").prop('selectedIndex', 0).prop("disabled", true);
    $(".databasever").removeClass("d-none");
    $("#ddldriver").prop('selectedIndex', 0);
    $("#lblconname").text("");
    $("#txtccname").val("");
    $("#txtusername").val("");
    $("#lstconnection").val("");
    $("#txtPassword").val("");
    $("#txtNewPassword").val("");
    $("#txtConfirmPassword").val("");
});

$j(document).on("click", "#btncdelete", function (e) {
    var conDelete = $.confirm({
        closeIcon: false,
        title: 'Confirm',
        escapeKey: 'buttonB',
        theme: 'modern',
        onContentReady: function () {
            disableBackDrop('bind');
        },
        content: eval(callParent('lcm[512]')),
        buttons: {
            buttonA: {
                text: eval(callParent('lcm[279]')),
                btnClass: 'btn btn-primary',
                action: function () {
                    $j("#btndelete").click();
                }
            },
            buttonB: {
                text: eval(callParent('lcm[280]')),
                btnClass: 'btn btn-bg-light btn-color-danger btn-active-light-danger',
                action: function () {
                    disableBackDrop('destroy');
                }
            }
        }
    });
})

$j(document).on("change", "#ddldbtype", function (e) {
    var dbtype = $(this).val();
    if (dbtype == "MS SQL") {
        $("#ddldbversion").prop("disabled", false);
        $("#ddldriver").val("ado");
    }
    else {
        $("#ddldbversion").val("").prop("disabled", true);
        $("#ddldriver").val("dbx");
    }
});

function OpenSignIn() {
    window.document.location.href = "Signin.aspx";
}

$j(document).on("click", "#btnlicactivation", function (e) {

    //displayBootstrapModalDialog("License Activation", "xs", "156px", true, "./licactivation.aspx", "", "", CallbackFunctionBootstrap)

    //function CallbackFunctionBootstrap() {

    //}
    window.document.location.href = "licactivation.aspx";
});

function TestConnection() {
    let dbtype = $("#ddldbtype").val();
    if (dbtype == "") {
        $("#ddldbtype").focus();
        showAlertDialog("error", "Database name should not be left empty.");
        return false;
    }
    let dbverno = $("#ddldbversion").val();
    if (dbtype.toLowerCase() == "ms sql" && dbverno == "") {
        $("#ddldbversion").focus();
        showAlertDialog("error", "Database verion should not be left empty.");
        return false;
    }

    let txtccname = $("#txtccname").val();
    if (txtccname == "") {
        $("#txtccname").focus();
        showAlertDialog("error", "Connection name should not be left empty.");
        return false;
    }

    let txtusername = $("#txtusername").val();
    if (txtusername == "") {
        $("#txtusername").focus();
        showAlertDialog("error", "User name should not be left empty.");
        return false;
    }

    let txtPassword = $("#txtPassword").val();
    if (txtPassword == "") {
        $("#txtPassword").focus();
        showAlertDialog("error", "Password should not be left empty.");
        return false;
    }

    TestConnectionWs();
    // return true;
}

function TestConnectionWs() {
    $.ajax({
        url: 'Config.aspx/AppTestConnection',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            ddldbtype: $("#ddldbtype").val(), ddldbversion: $("#ddldbversion").val(), ddldriver: $("#ddldriver").val(), txtccname: $("#txtccname").val(), txtusername: $("#txtusername").val(), txtPassword: $("#txtPassword").val()
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {
                var response = $.parseJSON(data.d)
                if (response.result[0].result == "true") {
                    showAlertDialog("success", "Test Connection was Successful.");
                    EnableApplyConnection();
                }
                else
                    showAlertDialog("error", response.result[0].error.msg);
            }
            else
                showAlertDialog("error", data.d);
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}

function EnableApplyConnection() {
    $("#btnApply").removeAttr("disabled").removeClass("btndisable");
    $("#btnChangePassword").removeAttr("disabled").removeClass("btndisable");
}


function applyconnection() {
    let txtNewConName = $("#txtNewConName").val();
    if (txtNewConName == "") {
        $("#txtNewConName").focus();
        showAlertDialog("error", "Connection name should not be left empty.");
        return false;
    }
    var regex = new RegExp("^[a-zA-Z0-9]+$");
    if (!regex.test(txtNewConName)) {
        $("#txtNewConName").focus();
        showAlertDialog("error", "Invalid Name - Special characters not allowed.");
        return false;
    }
    return true;
}

function applydbpwdconnection() {
    let txtNewConName = $("#txtNewPassword").val();
    if (txtNewConName == "") {
        $("#txtNewPassword").focus();
        showAlertDialog("error", "Password can not be empty.");
        return false;
    }
    let txtConfirmPassword = $("#txtConfirmPassword").val();
    if (txtConfirmPassword == "") {
        $("#txtConfirmPassword").focus();
        showAlertDialog("error", "Confirm Password can not be empty.");
        return false;
    }

    if (txtNewConName != txtConfirmPassword) {
        $("#txtNewPassword").focus();
        showAlertDialog("error", "The password you entered did not match.");
        return false;
    }
    return true;
}

$j(document).on("click", "#btnnewcancel,#myModalclose", function (e) {
    $('#myModal').hide();
    $("#btnApply").attr("disabled", true).addClass("btndisable");
    $("#btnChangePassword").attr("disabled", true).addClass("btndisable");
});

$j(document).on("click", "#btndbpwdcancel,#myModaldbpasswordclose", function (e) {
    $('#myModaldbpassword').hide();
    $("#btnApply").attr("disabled", true).addClass("btndisable");
    $("#btnChangePassword").attr("disabled", true).addClass("btndisable");
});

function SuccApplyConnection(isSucc, newConnection) {
    if (isSucc == "success") {
        showAlertDialog("success", "Connection is created successful.");
    }
    else {
        showAlertDialog("error", "Connection Name already exists.");
    }
}

function SuccPasswordChange(isSucc, succMsg) {
    if (isSucc == "success") {
        showAlertDialog("success", succMsg);
    }
    else {
        showAlertDialog("error", succMsg);
    }
}

function setProjectImages(proj) {
    let logoImage = `../images/loginlogo.png`;
    let webBgImage = `../AxpImages/login-img.png`;
    let mobBgImage = `../AxpImages/login-img.png`;

    let logoImageDiv = $(".file-upload[data-type=logo]").parent().parent().find(".profile-pic");
    let webBgImageDiv = $(".file-upload[data-type=webbg]").parent().parent().find(".profile-pic");
    let mobBgImageDiv = $(".file-upload[data-type=mobbg]").parent().parent().find(".profile-pic")//$(".file-upload[data-type=mobbg]").prevAll(".profile-pic");

    if (proj) {
        getProjectAppLogo(proj, async = true,
            (success) => {
                if (success?.d) {
                    let { logo, webbg, mobbg } = JSON.parse(success.d);

                    let updateMobileBG = false;

                    if (webbg && !mobbg) {
                        mobbg = webbg;
                        updateMobileBG = true;
                    }

                    logoImageDiv.prop("src", logo ? `${logo}?v=${(new Date().getTime())}` : logoImage);
                    webBgImageDiv.prop("src", webbg ? webbg : webBgImage);
                    mobBgImageDiv.prop("src", mobbg ? mobbg : mobBgImage);

                    if (logo) {
                        logoImageDiv.parent().find(".delete-button").removeClass("d-none");
                    } else {
                        logoImageDiv.parent().find(".delete-button").addClass("d-none");
                    }

                    if (webbg) {
                        webBgImageDiv.parent().find(".delete-button").removeClass("d-none");
                    } else {
                        webBgImageDiv.parent().find(".delete-button").addClass("d-none");
                    }

                    if (mobbg && !updateMobileBG) {
                        mobBgImageDiv.parent().find(".delete-button").removeClass("d-none");
                    } else {
                        mobBgImageDiv.parent().find(".delete-button").addClass("d-none");
                    }
                } else {
                    logoImageDiv.prop("src", logoImage);
                    webBgImageDiv.prop("src", webBgImage);
                    mobBgImageDiv.prop("src", mobBgImage);

                    logoImageDiv.parent().find(".delete-button").addClass("d-none");
                    webBgImageDiv.parent().find(".delete-button").addClass("d-none");
                    mobBgImageDiv.parent().find(".delete-button").addClass("d-none");
                }
            },
            (error) => {
                logoImageDiv.prop("src", logoImage);
                webBgImageDiv.prop("src", webBgImage);
                mobBgImageDiv.prop("src", mobBgImage);

                logoImageDiv.parent().find(".delete-button").addClass("d-none");
                webBgImageDiv.parent().find(".delete-button").addClass("d-none");
                mobBgImageDiv.parent().find(".delete-button").addClass("d-none");
            }
        );
    } else {
        logoImageDiv.prop("src", logoImage);
        webBgImageDiv.prop("src", webBgImage);
        mobBgImageDiv.prop("src", mobBgImage);

        logoImageDiv.nextAll(".delete-button").addClass("hide");
        webBgImageDiv.nextAll(".delete-button").addClass("hide");
        mobBgImageDiv.nextAll(".delete-button").addClass("hide");
    }
}

$j(document).on("click", "#btnUpload", function (e) {
    $("#myModalLicUpload").show();
});

function licActivateCheck() {
    if (!$("#btnActivate").hasClass("disabledButton")) {
        let txtlicappkey = $("#txtlicappkey").val();
        if (txtlicappkey == "") {
            $("#txtlicappkey").focus();
            showAlertDialog("error", "Please enter license key provided by Agile Labs...");
        }
        else {
            $("#btnActivateasp").trigger("click");
        }
    }
}

function licRefreshCheck() {
    if (!$("#btnRefresh").hasClass("disabledButton")) {
        $("#btnRefreshasp").trigger("click");
    }
}

function licTrialCheck() {
    if (!$("#btnTrial").hasClass("disabledButton")) {
        $("#btnTrialasp").trigger("click");
    }
}

function offlinelicDownload() {
    let txtlicofflinekey = $("#txtlicofflinekey").val();
    if (txtlicofflinekey == "") {
        $("#txtlicofflinekey").focus();
        showAlertDialog("error", "Please enter license key provided by Agile Labs...");
    }
    else {
        $("#btnDownloadasp").trigger("click");
    }
}

function LicActivationSucc(mdgtype, msg) {
    if (mdgtype == "success") {
        showAlertDialog("success", msg);
        setTimeout(function () {
            var qstr = window.document.location.href;
            window.document.location.href = qstr;
        }, 300);
    }
    else {
        showAlertDialog("error", msg);
    }
}

function LicDownloadSucc(mdgtype, msg) {
    if (mdgtype == "success") {
        showAlertDialog("success", msg);
        $("#btndownloadfile").trigger("click");
        //$('#rbllictype input').val('online');
    }
    else {
        showAlertDialog("error", msg);
    }
}

function closeUploadDialog() {
    $('#btnFileUpload').prop('disabled', false);
    $("#filMyFile").val('');
    $("#lblnofilename").text('');
    $("#myModalLicUpload").hide();
}

$j(document).on("change", "#rbllictype input", function (e) {
    switch ($(this).val()) {
        case 'offline':
            $("#dvOffline").show();
            $("#dvOnline").hide();
            break;
        default:
            $("#dvOffline").hide();
            $("#dvOnline").show();
            break;
    }
});

function uploadLogo(e) {

    // var fileUpload = $("#UploadAppLogoImg").get(0);
    var fileUpload = e.target;
    var files = fileUpload.files;

    var data = new FormData();
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }

    var url = location.origin + location.pathname.substr(0, location.pathname.indexOf('aspx'));

    if ($("#axSelectProj").val()) {
        $.ajax({
            url: url + `ProjectImageUploadHandler.ashx?proj=${$("#axSelectProj").val()}&type=${fileUpload?.dataset?.type || ""}&handlertype=${handlerType}`,
            type: "POST",
            data: data,
            contentType: false,
            processData: false,
            success(result) {
                handlerType = "upload";
                if (result.indexOf("success") > -1) {
                    setProjectImages($("#axSelectProj").val());
                    showAlertDialog("success", result);
                } else if (result.indexOf("size") > -1 || result.indexOf("select")) {
                    showAlertDialog("warning", result);
                } else if (result.indexOf("error") > -1) {
                    showAlertDialog("error", result);
                } else {
                    showAlertDialog("error", result);
                }
                $(fileUpload).val("");
            },
            error(err) {
                handlerType = "upload";
                showAlertDialog("error", err.statusText);
                $(fileUpload).val("");
            }
        });
    } else {
        handlerType = "upload";
        showAlertDialog("error", "Project Name should be selected");
    }
}

function AuthenticateUser() {
    let txtAuthUsername = $("#txtAuthUsername").val();
    if (txtAuthUsername == "") {
        $("#txtAuthUsername").focus();
        showAlertDialog("error", "User name should not be left empty.");
        return false;
    }

    let txtAuthPwd = $("#txtAuthPwd").val();
    if (txtAuthPwd == "") {
        $("#txtAuthPwd").focus();
        showAlertDialog("error", "Password should not be left empty.");
        return false;
    }

    $.ajax({
        url: 'Config.aspx/UserAuthentication',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            AuthUsername: $("#txtAuthUsername").val(), AuthPwd: $("#txtAuthPwd").val()
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            $('#configbody').removeClass('m-auto');

            $('#main_body').removeAttr("style")
            if (data.d != "") {
                var qstr = window.document.location.href;
                if (qstr.indexOf("?") > -1) {
                    var qsAuth = qstr.split("?")[1];
                    if (qsAuth.indexOf("auth=") > -1) {
                        var varAuth = "";
                        qsAuth.split("&").forEach(function (elem) {
                            if (elem.indexOf("auth=") == -1)
                                varAuth += elem + "&";
                        });
                        window.document.location.href = "config.aspx?" + varAuth + "auth=" + data.d;
                    }
                    else
                        window.document.location.href = qstr + "&auth=" + data.d;
                }
                else
                    window.document.location.href = "config.aspx?auth=" + data.d;
            }
            else
                showAlertDialog("error", "Incorrect credentials. please try again!");
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}

$j(document).on("click", "#btnAuthCancel,#myModalAuthClose", function (e) {
    window.document.location.href = "signin.aspx";
});

function initUiPanel() {
    // if(selProj){
    $("#axSelectProj").val(selProj);

    setProjectImages(selProj);
    // }
    var newArr = $("#lstconnection option").toArray().map((opt) => {
        return { label: opt.value, value: opt.value, link: "" };
    });
    $("#axSelectProj").select2({
        data: applstJson
    }).on('select2:select', function (event) {
        (appGlobalVarsObject?._CONSTANTS?.window || window).toastr.clear();

        setProjectImages($(this).val());
    });

    //$("#axSelectProj").autocomplete({
    //    minLength: 0,
    //    selectFirst: true,
    //    autoFocus: true,
    //    source: function (request, response) {
    //        response($("#lstconnection option").toArray().map((opt)=>{
    //            return { label: opt.value, value: opt.value, link: "" };
    //        }));
    //    },
    //    open: function (event, ui) {
    //        // var dialog = $(this).closest('.ui-dialog');
    //        // if (dialog.length > 0) {
    //        //     $('.ui-autocomplete.ui-front').zIndex(dialog.zIndex() + 1);
    //        // }
    //    },
    //    select: function (event, ui) {

    //        // if (ui.item.label == lcm[0]) {
    //        //     $(this).val('');
    //        //     return false;
    //        // }
    //        // else {
    //        //     $(this).val(ui.item.label);
    //        // }
    //        // setProjectNeeds(ui.item.label);
    //        // HideErrorMsg();
    //        hideAlertDialog('', 'error');

    //        setProjectImages(ui.item.value);
    //    },
    //    forceChange(){
    //        // setProjectNeeds($(this).val());
    //    }
    //});
}

function applyRedisconnection() {
    let txtrhotname = $("#txtrhotname").val();
    if (txtrhotname == "") {
        $("#txtrhotname").focus();
        showAlertDialog("error", "Host name should not be left empty.");
        return false;
    }

    let txtrport = $("#txtrport").val();
    if (txtrport == "") {
        $("#txtrport").focus();
        showAlertDialog("error", "Port should not be left empty.");
        return false;
    }

    //let txtrpwd = $("#txtrpwd").val();
    //if (txtrpwd == "") {
    //    $("#txtrpwd").focus();
    //    showAlertDialog("error", "Password should not be left empty.");
    //    return false;
    //}
    TestRedisConnectionWs();
    //$("#btnRedisTestConnection").click();
}

$j(document).on("click", "#btnRedisApply", function (e) {
    if ($("#lstRconnection").val() == null || $("#lstRconnection").val() == "") {
        $("#ddlIsRedisNewConnection").val('new');
        $('#myModalRedis').modal("show");
    }
    else {
        $("#ddlIsRedisNewConnection").val('old');
        $("#txtRedisNewConn").val($("#lstRconnection").val());
        $("#btnRedisOk").click();
    }
});

function EnableRedisApplyConnection() {
    $("#btnRedisApply").removeAttr("disabled").removeClass("btndisable");
}

function SuccRedisConnection(msgType) {
    if (msgType == "success") {
        showAlertDialog("success", "Connection is created successful.");
    }
    else {
        showAlertDialog("error", "Connection Name already exists.");
    }
}

function TestRedisConnectionWs() {
    $.ajax({
        url: 'Config.aspx/RedisTestConnection',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            rHost: $("#txtrhotname").val(), rPort: $("#txtrport").val(), rPwd: $("#txtrpwd").val()
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {
                if (data.d == "true:yes") {
                    $("#hdnRPwd").val("true");
                    showAlertDialog("success", "Test Connection was Successful.");
                    EnableRedisApplyConnection();
                } else if (data.d == "true:no") {
                    $("#hdnRPwd").val("false");
                    showAlertDialog("success", "Test Connection was Successful.");
                    EnableRedisApplyConnection();
                }
                else {
                    $("#hdnRPwd").val("true");
                    let txtrpwd = $("#txtrpwd").val();
                    if (txtrpwd == "")
                        showAlertDialog("error", "Test Connection failed. Please enter password and try again.");
                    else
                        showAlertDialog("error", "Test Connection failed.");
                    $("#btnRedisApply").attr("disabled", "true").addClass("btndisable");
                }
            }
            else {
                $("#hdnRPwd").val("true");
                showAlertDialog("error", "Test Connection failed.");
                $("#btnRedisApply").attr("disabled", "true").addClass("btndisable");
            }
        }, error: function (error) {
            $("#hdnRPwd").val("true");
            showAlertDialog("error", error);
        }
    });
}

function TestARMConnectionWs() {
    var proj = $("#hdnprojarm").val();
    if (proj.indexOf("\\") != -1)
        proj = proj.split("\\")[0];
    if ($.trim(proj) === '')
        return showAlertDialog("error", "Project cannot be left empty");
    if ($.trim($("#txtarmkey").val()) === '')
        return showAlertDialog("error", "ARMPrivate Key cannot be left empty");
    if ($.trim($("#txtarmurl").val()) === '')
        return showAlertDialog("error", "ARM URL cannot be left empty");
    if ($.trim($("#txtscripturl").val()) === '')
        return showAlertDialog("error", "ARM Scripts URL cannot be left empty");
    if ($.trim($("#txtpeg").val()) === '')
        return showAlertDialog("error", "PEG cannot be left empty");
    $.ajax({
        url: 'Config.aspx/ARMConnection',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            aKey: $("#txtarmkey").val(), aUrl: $("#txtarmurl").val(), aScriptsUrl: $("#txtscripturl").val(), aPeg: $("#txtpeg").val(), proj: proj
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {
                showAlertDialog("success", "ARM Connection is saved successfully");
                document.getElementById("txtarmkey").value = "";
                document.getElementById("txtarmurl").value = "";
                document.getElementById("txtscripturl").value = "";
                document.getElementById("txtpeg").value = "";
                $('#txtpeg').trigger('change');
                $('#armproj').val(null).trigger('change');

                armlist = data.d;
            }
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}

function DelARMConnectionWs() {
    var proj = $("#hdnprojarm").val();
    if (proj.indexOf("\\") != -1)
        proj = proj.split("\\")[0];
    $.ajax({
        url: 'Config.aspx/DelARMConnectionWs',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            proj: proj
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {
                showAlertDialog("success", "ARM Connection is deleted successfully");
                document.getElementById("txtarmkey").value = "";
                document.getElementById("txtarmurl").value = "";
                document.getElementById("txtscripturl").value = "";
                document.getElementById("txtpeg").value = "";
                $('#txtpeg').trigger('change');
                armlist = data.d;

            }
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}

function TestFileConnectionWs() {
    var proj = $("#hdnfileproj").val();
    if (proj.indexOf("\\") != -1)
        proj = proj.split("\\")[0];
    if ($.trim(proj) === '')
        return showAlertDialog("error", "Project cannot be left empty");
    if ($.trim($("#txtfileupload").val()) === '')
        return showAlertDialog("error", "File Upload Path cannot be left empty");
    if ($.trim($("#txtfiledownload").val()) === '')
        return showAlertDialog("error", "File Download Path cannot be left empty");

    $.ajax({
        url: 'Config.aspx/FileConnection',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            fUpload: $("#txtfileupload").val(), fDownload: $("#txtfiledownload").val(), proj: proj, fMapUsername: $("#txtfileMapUsername").val(), fMapPwd: $("#tstfileMapPwd").val()
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {

                showAlertDialog("success", "File Connection is saved successfully");
                filelist = data.d;
            }
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}

function DelFileConnectionWs() {
    var proj = $("#hdnfileproj").val();
    if (proj.indexOf("\\") != -1)
        proj = proj.split("\\")[0];
    $.ajax({
        url: 'Config.aspx/DelFileConnectionWs',
        type: 'POST',
        cache: false,
        async: true,
        data: JSON.stringify({
            proj: proj
        }),
        dataType: 'json',
        contentType: "application/json",
        success: function (data) {
            if (data.d != "") {
                showAlertDialog("success", "File Connection is deleted successfully");
                document.getElementById("txtfileupload").value = "";
                document.getElementById("txtfiledownload").value = "";
                document.getElementById("txtfileMapUsername").value = "";
                document.getElementById("tstfileMapPwd").value = "";
                filelist = data.d;
            }
        }, error: function (error) {
            showAlertDialog("error", error);
        }
    });
}


function CreateRedisConnection() {
    let txtNewConName = $("#txtRedisNewConn").val();
    if (txtNewConName == "") {
        $("#txtRedisNewConn").focus();
        showAlertDialog("error", "Connection name should not be left empty.");
        return false;
    }
    var regex = new RegExp("^[a-zA-Z0-9]+$");
    if (!regex.test(txtNewConName)) {
        $("#txtRedisNewConn").focus();
        showAlertDialog("error", "Invalid Name - Special characters not allowed.");
        return false;
    }
}

$j(document).on("click", "#lstRconnection option", function (e) {
    var rlvalue = $(this).val();
    if (redislstJson != "") {
        var rhost = redislstJson.axp_rconn[rlvalue].host;
        var rport = redislstJson.axp_rconn[rlvalue].port;
        var rpwd = redislstJson.axp_rconn[rlvalue].pwd;
        $("#txtrhotname").val(rhost);
        $("#txtrport").val(rport);
        $("#txtrpwd").val("");
    }
});

$j(document).on("change", "#lstRconnection", function (e) {
    var rlvalue = $(this).val();
    if (redislstJson != "" && rlvalue != null) {
        var rhost = redislstJson.axp_rconn[rlvalue].host;
        var rport = redislstJson.axp_rconn[rlvalue].port;
        var rpwd = redislstJson.axp_rconn[rlvalue].pwd;
        $("#txtrhotname").val(rhost);
        $("#txtrport").val(rport);
        $("#txtrpwd").val("");
    }
});

$j(document).on("click", "#btnRedisAdd", function (e) {
    $("#txtrhotname").val("");
    $("#txtrport").val("");
    $("#txtrpwd").val("");
    $("#lstRconnection").val("").trigger('change');
});

$j(document).on("click", "#btnRcdelete", function (e) {
    var conDelete = $.confirm({
        closeIcon: false,
        title: 'Confirm',
        escapeKey: 'buttonB',
        theme: 'modern',
        onContentReady: function () {
            disableBackDrop('bind');
        },
        content: eval(callParent('lcm[522]')),
        buttons: {
            buttonA: {
                text: eval(callParent('lcm[279]')),
                btnClass: 'btn btn-primary',
                action: function () {
                    $j("#btnRedisdelete").click();
                }
            },
            buttonB: {
                text: eval(callParent('lcm[280]')),
                btnClass: 'btn btn-bg-light btn-color-danger btn-active-light-danger',
                action: function () {
                    disableBackDrop('destroy');
                }
            }
        }
    });
});

$j(document).on("click", "#btnrnewcancel,#myModalRedisclose", function (e) {
    $('#myModalRedis').modal("hide");
});

function SaveSSOConnectionWs() {
    var proj = $("#hdnssoProj").val();
    if (proj.indexOf("\\") != -1)
        proj = proj.split("\\")[0];
    if ($.trim(proj) === '')
        return showAlertDialog("error", "Project cannot be left empty");
    let _ssoType = $("#ssoType").val();
    $("#hdnssoType").val(_ssoType);
    if (typeof _ssoType != "undefined" && _ssoType != "") {
        let ssoOptionWindow = $("#ssoOptionWindow").is(":checked") == true ? "true" : "false";
        let requestData = {};
        if (_ssoType == "windows") {
            if ($.trim($("#ssowindowsdomain").val()) === '')
                return showAlertDialog("error", "Windows Domain Name cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                ssoWinDomain: $("#ssowindowsdomain").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "saml") {
            if ($.trim($("#SamlPartnerIdP").val()) === '')
                return showAlertDialog("error", "SAML Partnet IDP cannot be left empty");
            if ($.trim($("#SamlIdentifier").val()) === '')
                return showAlertDialog("error", "SAML Identifier cannot be left empty");
            if ($.trim($("#SamlCertificate").val()) === '')
                return showAlertDialog("error", "SAML Certificate cannot be left empty");
            if ($.trim($("#ssoredirecturlsaml").val()) === '')
                return showAlertDialog("error", "SAML Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                SamlPartnerIdP: $("#SamlPartnerIdP").val(),
                SamlIdentifier: $("#SamlIdentifier").val(),
                SamlCertificate: $("#SamlCertificate").val(),
                SamlRedirectUrl: $("#ssoredirecturlsaml").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "office365") {
            if ($.trim($("#of365ssoclientKey").val()) === '')
                return showAlertDialog("error", "Office365 Client Key cannot be left empty");
            if ($.trim($("#of365ssoclientsecretKey").val()) === '')
                return showAlertDialog("error", "Office365 Secret Key cannot be left empty");
            if ($.trim($("#ssoredirecturlof365").val()) === '')
                return showAlertDialog("error", "Office365 Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                of365clientkey: $("#of365ssoclientKey").val(),
                of365secretkey: $("#of365ssoclientsecretKey").val(),
                of365redirecturl: $("#ssoredirecturlof365").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "okta") {
            if ($.trim($("#ssoclientKeyokta").val()) === '')
                return showAlertDialog("error", "OKAT Client Key cannot be left empty");
            if ($.trim($("#ssoclientsecretKeyokta").val()) === '')
                return showAlertDialog("error", "OKTA Secret Key cannot be left empty");
            if ($.trim($("#ssooktadomain").val()) === '')
                return showAlertDialog("error", "OKTA Domain cannot be left empty");
            if ($.trim($("#ssoredirecturlokta").val()) === '')
                return showAlertDialog("error", "OKTA Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                oktaclientkey: $("#ssoclientKeyokta").val(),
                oktasecretkey: $("#ssoclientsecretKeyokta").val(),
                oktadomain: $("#ssooktadomain").val(),
                oktaredirecturl: $("#ssoredirecturlokta").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "google") {
            if ($.trim($("#ssoclientKeygoogle").val()) === '')
                return showAlertDialog("error", "Google Client Key cannot be left empty");
            if ($.trim($("#ssoclientsecretKeygoogle").val()) === '')
                return showAlertDialog("error", "Google Secret Key cannot be left empty");
            if ($.trim($("#ssoredirecturlgoogle").val()) === '')
                return showAlertDialog("error", "Google Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                googleclientkey: $("#ssoclientKeygoogle").val(),
                googlesecretkey: $("#ssoclientsecretKeygoogle").val(),
                googleredirecturl: $("#ssoredirecturlgoogle").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "facebook") {
            if ($.trim($("#ssoclientKeyfb").val()) === '')
                return showAlertDialog("error", "Facebook Client Key cannot be left empty");
            if ($.trim($("#ssoclientsecretKeyfb").val()) === '')
                return showAlertDialog("error", "Facebook Secret Key cannot be left empty");
            if ($.trim($("#ssoredirecturlfb").val()) === '')
                return showAlertDialog("error", "Facebook Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                fbclientkey: $("#ssoclientKeyfb").val(),
                fbsecretkey: $("#ssoclientsecretKeyfb").val(),
                fbredirecturl: $("#ssoredirecturlfb").val(),
                onlysso: ssoOptionWindow
            };
        } else if (_ssoType == "openid") {
            if ($.trim($("#ssoclientKeyOpenId").val()) === '')
                return showAlertDialog("error", "OpenID Client Key cannot be left empty");
            if ($.trim($("#ssoclientsecretKeyOpenId").val()) === '')
                return showAlertDialog("error", "OpenID Secret Key cannot be left empty");
            if ($.trim($("#ssoopeniddomain").val()) === '')
                return showAlertDialog("error", "OpenID Domain cannot be left empty");
            if ($.trim($("#ssoredirecturlopenid").val()) === '')
                return showAlertDialog("error", "OpenID Redirect URL cannot be left empty");
            requestData = {
                ssoType: _ssoType,
                openidclientkey: $("#ssoclientKeyOpenId").val(),
                openidsecretkey: $("#ssoclientsecretKeyOpenId").val(),
                openiddomain: $("#ssoopeniddomain").val(),
                openidredirecturl: $("#ssoredirecturlopenid").val(),
                onlysso: ssoOptionWindow
            };
        }

        if (ssoOptionWindow == "true") {
            if (SSOlistcon != "") {
                let cleanedSSOlistcon = SSOlistcon.trim();
                cleanedSSOlistcon = cleanedSSOlistcon.replace(/^"|"$/g, '');
                cleanedSSOlistcon = cleanedSSOlistcon.replace(/\\r\\n|\\n|\\r/g, '');
                cleanedSSOlistcon = cleanedSSOlistcon.replace(/\\"/g, '"');
                let _SSOlistcon = JSON.parse(cleanedSSOlistcon);
                let projectData = _SSOlistcon[proj];
                let existingOnlySSO = null;
                for (let ssoType in projectData) {
                    if (projectData[ssoType]["onlysso"] === "true") {
                        existingOnlySSO = ssoType;
                    }
                }
                if (existingOnlySSO && existingOnlySSO !== _ssoType) {
                    var conDelete = $.confirm({
                        closeIcon: false,
                        title: 'Confirm',
                        escapeKey: 'buttonB',
                        theme: 'modern',
                        onContentReady: function () {
                            disableBackDrop('bind');
                        },
                        content: "Only SSO login can be enabled for a single SSO. Do you want to continue?",
                        buttons: {
                            buttonA: {
                                text: eval(callParent('lcm[279]')),
                                btnClass: 'btn btn-primary',
                                action: function () {
                                    let updatereqJson = {};
                                    updatereqJson[existingOnlySSO] = { ...projectData[existingOnlySSO] };
                                    updatereqJson[existingOnlySSO]["onlysso"] = "false";
                                    $.ajax({
                                        url: 'Config.aspx/SaveUpdateSSOConnection',
                                        type: 'POST',
                                        cache: false,
                                        async: true,
                                        data: JSON.stringify({ requestJson: requestData, ssoType: _ssoType, ssoProj: proj, updatereqJson: updatereqJson, updateSsoType: existingOnlySSO }),
                                        dataType: 'json',
                                        contentType: "application/json",
                                        success: function (data) {
                                            if (data.d != "") {
                                                showAlertDialog("success", "SSO Connection is saved successfully");
                                                SSOlistcon = data.d;
                                                window.location.href = window.location.href;
                                            }
                                        }, error: function (error) {
                                            showAlertDialog("error", error);
                                        }
                                    });
                                }
                            },
                            buttonB: {
                                text: eval(callParent('lcm[280]')),
                                btnClass: 'btn btn-bg-light btn-color-danger btn-active-light-danger',
                                action: function () {
                                    disableBackDrop('destroy');
                                }
                            }
                        }
                    });
                } else {
                    $.ajax({
                        url: 'Config.aspx/SaveSSOConnection',
                        type: 'POST',
                        cache: false,
                        async: true,
                        data: JSON.stringify({ requestJson: requestData, ssoType: _ssoType, ssoProj: proj }),
                        dataType: 'json',
                        contentType: "application/json",
                        success: function (data) {
                            if (data.d != "") {
                                showAlertDialog("success", "SSO Connection is saved successfully");
                                SSOlistcon = data.d;
                                window.location.href = window.location.href;
                            }
                        }, error: function (error) {
                            showAlertDialog("error", error);
                        }
                    });
                }
            } else {
                $.ajax({
                    url: 'Config.aspx/SaveSSOConnection',
                    type: 'POST',
                    cache: false,
                    async: true,
                    data: JSON.stringify({ requestJson: requestData, ssoType: _ssoType, ssoProj: proj }),
                    dataType: 'json',
                    contentType: "application/json",
                    success: function (data) {
                        if (data.d != "") {
                            showAlertDialog("success", "SSO Connection is saved successfully");
                            SSOlistcon = data.d;
                            window.location.href = window.location.href;
                        }
                    }, error: function (error) {
                        showAlertDialog("error", error);
                    }
                });
            }
        } else {
            $.ajax({
                url: 'Config.aspx/SaveSSOConnection',
                type: 'POST',
                cache: false,
                async: true,
                data: JSON.stringify({ requestJson: requestData, ssoType: _ssoType, ssoProj: proj }),
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    if (data.d != "") {
                        showAlertDialog("success", "SSO Connection is saved successfully");
                        SSOlistcon = data.d;
                        window.location.href = window.location.href;
                    }
                }, error: function (error) {
                    showAlertDialog("error", error);
                }
            });
        }
    } else
        return showAlertDialog("error", "SSO Type cannot be left empty");
}

$j(document).on("change", "#ssoProj", function (e) {
    let ssoProjValue = $(this).val();
    if (ssoProjValue != "") {
        var proj = ssoProjValue;
        if (proj.indexOf("\\") != -1)
            proj = proj.split("\\")[0];
        $("#hdnssoProj").val(proj);
        let _ssoType = $("#ssoType").val();
        $("#hdnssoType").val(_ssoType);
        if (typeof _ssoType != "undefined" && _ssoType != "") {
            if (_ssoType == "windows") {
                $("#dvssoWindows").removeClass("d-none");
                $("#dvssoSAML").addClass("d-none");
                $("#dvssoOff365").addClass("d-none");
                $("#dvssoOkta").addClass("d-none");
                $("#dvssoGoogle").addClass("d-none");
                $("#dvssoFb").addClass("d-none");
                $("#dvssoOpenId").addClass("d-none");
            }

        } else {
            try {
                if (SSOlistcon != "") {
                    var configDataSSO = JSON.parse(SSOlistcon);
                    if (configDataSSO.hasOwnProperty(proj)) {

                    }
                    else {

                    }
                }
            }
            catch (ex) { }
        }
    }
});

$j(document).on("change", "#ssoType", function (e) {
    let _ssoType = $(this).val();
    let _proj = $("#ssoProj").val();
    if (_ssoType != "" && _proj != "") {
        if (_proj.indexOf("\\") != -1)
            _proj = _proj.split("\\")[0];
        $("#hdnssoProj").val(_proj);
        $("#hdnssoType").val(_ssoType);
        $("#dvssoOptionWindow").removeClass("d-none");
        if (_ssoType == "windows") {
            $("#dvssoWindows").removeClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "saml") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").removeClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "office365") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").removeClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "okta") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").removeClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "google") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").removeClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "facebook") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").removeClass("d-none");
            $("#dvssoOpenId").addClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        } else if (_ssoType == "openid") {
            $("#dvssoWindows").addClass("d-none");
            $("#dvssoSAML").addClass("d-none");
            $("#dvssoOff365").addClass("d-none");
            $("#dvssoOkta").addClass("d-none");
            $("#dvssoGoogle").addClass("d-none");
            $("#dvssoFb").addClass("d-none");
            $("#dvssoOpenId").removeClass("d-none");
            existtingSSOInfo(_proj, _ssoType);
        }
    }
});

function existtingSSOInfo(_proj, _ssoType) {
    if (SSOlistcon != "") {
        let cleanedSSOlistcon = SSOlistcon.trim();
        cleanedSSOlistcon = cleanedSSOlistcon.replace(/^"|"$/g, '');
        cleanedSSOlistcon = cleanedSSOlistcon.replace(/\\r\\n|\\n|\\r/g, '');
        cleanedSSOlistcon = cleanedSSOlistcon.replace(/\\"/g, '"');
        let _SSOlistcon = JSON.parse(cleanedSSOlistcon);
        if (_ssoType == "windows") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssowindowsdomain").val(_SSOlistcon[_proj][_ssoType]['ssoWinDomain']);
        } else if (_ssoType == "saml") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#SamlPartnerIdP").val(_SSOlistcon[_proj][_ssoType]['SamlPartnerIdP']);
            $("#SamlIdentifier").val(_SSOlistcon[_proj][_ssoType]['SamlIdentifier']);
            $("#SamlCertificate").val(_SSOlistcon[_proj][_ssoType]['SamlCertificate']);
            $("#ssoredirecturlsaml").val(_SSOlistcon[_proj][_ssoType]['SamlRedirectUrl']);
        } else if (_ssoType == "office365") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#of365ssoclientKey").val(_SSOlistcon[_proj][_ssoType]['of365clientkey']);
            $("#of365ssoclientsecretKey").val(_SSOlistcon[_proj][_ssoType]['of365secretkey']);
            $("#ssoredirecturlof365").val(_SSOlistcon[_proj][_ssoType]['of365redirecturl']);
        } else if (_ssoType == "okta") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssoclientKeyokta").val(_SSOlistcon[_proj][_ssoType]['oktaclientkey']);
            $("#ssoclientsecretKeyokta").val(_SSOlistcon[_proj][_ssoType]['oktasecretkey']);
            $("#ssooktadomain").val(_SSOlistcon[_proj][_ssoType]['oktadomain']);
            $("#ssoredirecturlokta").val(_SSOlistcon[_proj][_ssoType]['oktaredirecturl']);
        } else if (_ssoType == "google") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssoclientKeygoogle").val(_SSOlistcon[_proj][_ssoType]['googleclientkey']);
            $("#ssoclientsecretKeygoogle").val(_SSOlistcon[_proj][_ssoType]['googlesecretkey']);
            $("#ssoredirecturlgoogle").val(_SSOlistcon[_proj][_ssoType]['googleredirecturl']);
        } else if (_ssoType == "google") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssoclientKeygoogle").val(_SSOlistcon[_proj][_ssoType]['googleclientkey']);
            $("#ssoclientsecretKeygoogle").val(_SSOlistcon[_proj][_ssoType]['googlesecretkey']);
            $("#ssoredirecturlgoogle").val(_SSOlistcon[_proj][_ssoType]['googleredirecturl']);
        } else if (_ssoType == "facebook") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssoclientKeyfb").val(_SSOlistcon[_proj][_ssoType]['fbclientkey']);
            $("#ssoclientsecretKeyfb").val(_SSOlistcon[_proj][_ssoType]['fbsecretkey']);
            $("#ssoredirecturlfb").val(_SSOlistcon[_proj][_ssoType]['fbredirecturl']);
        } else if (_ssoType == "openid") {
            $("#ssoOptionWindow").prop("checked", _SSOlistcon[_proj][_ssoType]['onlysso'] == 'true' ? true : false);
            $("#ssoclientKeyOpenId").val(_SSOlistcon[_proj][_ssoType]['openidclientkey']);
            $("#ssoclientsecretKeyOpenId").val(_SSOlistcon[_proj][_ssoType]['openidsecretkey']);
            $("#ssoopeniddomain").val(_SSOlistcon[_proj][_ssoType]['openiddomain']);
            $("#ssoredirecturlopenid").val(_SSOlistcon[_proj][_ssoType]['openidredirecturl']);
        }
    }
}
$j(document).on("click", "#btnSSOdeleteType", function (e) {
    if ($("#ssoProj").val() != null && $("#ssoProj").val() != "" && $("#ssoType").val() != null && $("#ssoType").val() != "") {
        var conDelete = $.confirm({
            closeIcon: false,
            title: 'Confirm',
            escapeKey: 'buttonB',
            theme: 'modern',
            onContentReady: function () {
                disableBackDrop('bind');
            },
            content: eval(callParent('lcm[538]')),
            buttons: {
                buttonA: {
                    text: eval(callParent('lcm[279]')),
                    btnClass: 'btn btn-primary',
                    action: function () {
                        $.ajax({
                            url: 'Config.aspx/SSoTypeDelete',
                            type: 'POST',
                            cache: false,
                            async: true,
                            data: JSON.stringify({ ssoProj: $("#ssoProj").val(), ssoType: $("#ssoType").val() }),
                            dataType: 'json',
                            contentType: "application/json",
                            success: function (data) {
                                if (data.d != "" && data.d == "deleted") {
                                    showAlertDialog("success", "SSO Connection deleted successfully");
                                    window.location.href = window.location.href;
                                } else
                                    showAlertDialog("error", "Error while deleting SSO Connection, please try later.");
                            }, error: function (error) {
                                showAlertDialog("error", error);
                            }
                        });
                    }
                },
                buttonB: {
                    text: eval(callParent('lcm[280]')),
                    btnClass: 'btn btn-bg-light btn-color-danger btn-active-light-danger',
                    action: function () {
                        disableBackDrop('destroy');
                    }
                }
            }
        });
    } else {
        showAlertDialog("error", "Please Select SSO Connection Name and SSO Type.");
    }
});

$j(document).on("click", "#btnSSOdeleteCon", function (e) {
    if ($("#ssoProj").val() != null && $("#ssoProj").val() != "") {
        var conDelete = $.confirm({
            closeIcon: false,
            title: 'Confirm',
            escapeKey: 'buttonB',
            theme: 'modern',
            onContentReady: function () {
                disableBackDrop('bind');
            },
            content: eval(callParent('lcm[537]')),
            buttons: {
                buttonA: {
                    text: eval(callParent('lcm[279]')),
                    btnClass: 'btn btn-primary',
                    action: function () {
                        $.ajax({
                            url: 'Config.aspx/SSoConDelete',
                            type: 'POST',
                            cache: false,
                            async: true,
                            data: JSON.stringify({ ssoProj: $("#ssoProj").val() }),
                            dataType: 'json',
                            contentType: "application/json",
                            success: function (data) {
                                if (data.d != "" && data.d == "deleted") {
                                    showAlertDialog("success", "SSO Connection deleted successfully");
                                    window.location.href = window.location.href;
                                } else
                                    showAlertDialog("error", "Error while deleting SSO Connection, please try later.");
                            }, error: function (error) {
                                showAlertDialog("error", error);
                            }
                        });
                    }
                },
                buttonB: {
                    text: eval(callParent('lcm[280]')),
                    btnClass: 'btn btn-bg-light btn-color-danger btn-active-light-danger',
                    action: function () {
                        disableBackDrop('destroy');
                    }
                }
            }
        });
    } else {
        showAlertDialog("error", "Please Select SSO Connection Name.");
    }
});