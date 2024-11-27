<%@ Page Language="C#" AutoEventWireup="true" CodeFile="autosignin.aspx.cs" Inherits="autosignin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function SetInstance(insName, SessId, boolVal) {
            let appSessUrl = top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
            if (boolVal == "true") {
                localStorage.setItem("duplicateUser-" + appSessUrl, insName + "-" + SessId);
                localStorage.setItem("instanceName-" + appSessUrl, insName);
            } else {
                localStorage.setItem("duplicateUser-" + appSessUrl, insName + "-" + SessId);
            }
        }
        function SetLoginErrorMsg(msg) {
            let applnUrl = top.window.location.href.toLowerCase().substring("0", top.window.location.href.indexOf("/aspx/"));
            localStorage["lnmsg-" + applnUrl] = msg;
            top.window.location.href = applnUrl + "/aspx/signin.aspx";
        }
    </script>
</head>
<body>
    <form name="form2" method="post" action="mainnew.aspx" id="form2" defaultfocus="uname" class="form-vertical login-form" novalidate>
        <div>
            <%=strParams.ToString() %>
        </div>
    </form>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
