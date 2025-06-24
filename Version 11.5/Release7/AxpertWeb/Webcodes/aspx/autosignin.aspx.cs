using DocumentFormat.OpenXml.Drawing;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class autosignin : System.Web.UI.Page
{
    Util.Util util = new Util.Util();
    public StringBuilder strParams = new StringBuilder();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["adInfo"] != null)
        {
            util.KillSession();
            string adInfo = util.encrtptDecryptAES(Request.QueryString["adInfo"], false);
            string openpage = string.Empty;
            if (Request.QueryString["openpage"] != null)
            {
                openpage = Request.QueryString["openpage"];
            }
            if (adInfo != "")
                LoginDWB(adInfo, openpage);
            else
                Response.Redirect(Constants.LOGINPAGE, true);
        }
        else
        {
            Response.Redirect(Constants.LOGINPAGE, true);
        }
    }

    private void LoginDWB(string qrDetails, string openpage)
    {
        string project = string.Empty;
        try
        {
            string[] lngDetails = qrDetails.Split('♦');

            string redisLicDetails = GetServerLicDetails();
            if (redisLicDetails.StartsWith("error:"))
            {
                Response.Redirect(Constants.LOGINPAGE, true);
                return;
            }
            string proj = lngDetails[0];
            LoginHelper login = new LoginHelper(proj, lngDetails[5]);
            if (proj != "")
            {
                project = lngDetails[0];
                login.user = lngDetails[1];
                login.password = lngDetails[2];
                login.selectedLanguage = lngDetails[3];
                login.isSSO = false;
                login.isMobile = "False";
                login.hybridGUID = lngDetails[4];
                login.staySignedId = "false";
                login.lic_redis = redisLicDetails;
                login.privateSsoToken = "";
                login.oldappurl = "true";
                login.oaulandingpage = openpage;
                try
                {
                    login.CallLoginService();
                    login.result = login.result.Split('♠')[1];
                }
                catch (Exception ex)
                {
                    string strErrMsg = ex.Message;
                    if (strErrMsg.ToLower().Contains("ora-"))
                    {
                        strErrMsg = "Error occurred(2). Please try again or contact administrator.";
                    }
                    else if (strErrMsg.Length > 50)
                    {
                        strErrMsg = strErrMsg.Substring(0, 50);
                        strErrMsg += "...";
                    }
                    else
                    {
                        strErrMsg = ex.Message;
                    }
                }
                finally
                {

                }
                if (login.result == string.Empty || login.result.StartsWith(Constants.ERROR) || login.result.Contains(Constants.ERROR))
                {
                    XmlDocument xmldoc = new XmlDocument();
                    xmldoc.LoadXml(login.result);
                    string msg = string.Empty;
                    XmlNode errorNode = xmldoc.SelectSingleNode("/error");
                    if (login.result.Contains("\n"))
                        login.result = login.result.Replace("\n", "");

                    foreach (XmlNode msgNode in errorNode)
                    {
                        if (msgNode.Name == "msg")
                        {
                            msg = msgNode.InnerText;
                            break;
                        }
                    }

                    if (msg == string.Empty && errorNode.InnerText != string.Empty)
                        msg = errorNode.InnerText;
                    if (msg != string.Empty && msg.Contains("\n"))
                        msg = msg.Replace("\n", "");
                    string loginPath = Application["LoginPath"].ToString();
                    string queryProj = string.Empty;
                    if (Session["queryProj"] != null)
                        queryProj = Session["queryProj"].ToString();

                    //Unique Constraint Violation error
                    if (msg.Contains("Duplicate entry") || msg.Contains("Violation of PRIMARY KEY constraint"))
                    {
                        Session["Project"] = proj;
                        Session["nsessionid"] = login.sid;
                        try
                        {
                            Response.Redirect(HttpContext.Current.Application["SessExpiryPath"] + "?msg=" + msg, true);
                        }
                        catch (ThreadAbortException ex)
                        {​​​​​ 
                 Thread.ResetAbort();
                        }​​​​​
            }
                    else if (msg.ToLower().Contains("ora-"))
                    {
                        msg = "Error occurred(2). Please try again or contact administrator.";
                        ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "Javascript", "javascript:SetLoginErrorMsg('" + msg + "');", true);
                    }
                }
                else
                {
                    foreach (var item in Session)
                    {
                        if (item.ToString() != "FDR" && item.ToString() != "allUrls" && item.ToString() != "urlIndex" && item.ToString() != "kernelTime")
                            login.sessions.Add(item.ToString(), Session[item.ToString()] != null ? Session[item.ToString()].ToString() : null);
                        else if (item.ToString() == "allUrls" || item.ToString() == "urlIndex")
                            login.sessions.Add(item.ToString(), null);
                    }
                    Guid guid = Guid.NewGuid();
                    string guidVal = project + "-" + guid.ToString();
                    try
                    {
                        FDW fdwObj = FDW.Instance;
                        bool added = fdwObj.WriteKeyNoSchema(guidVal, Newtonsoft.Json.JsonConvert.SerializeObject(login), 5);
                        if (added == false)
                            HttpContext.Current.Cache.Insert(guidVal, Newtonsoft.Json.JsonConvert.SerializeObject(login));
                    }
                    catch (Exception) { }
                    strParams.Append("<input type=hidden name=\"hdnAxGKey\" value=\"" + guidVal + "\">");
                    strParams.Append("<input type=hidden name=\"hdnLanguage\" value=\"" + login.selectedLanguage + "\">");

                    string setIns = string.Empty;
                    if (Session["queryProj"] != null)
                        setIns = "javascript:SetInstance('" + project + "','" + login.sid + "','true','','');";
                    else
                        setIns = "javascript:SetInstance('" + project + "','" + login.sid + "','false','','');";
                    ClientScript.RegisterStartupScript(this.GetType(), "Javascript", setIns + "window.document.form2.submit();", true);
                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    private string GetServerLicDetails()
    {
        string licdetails = string.Empty;
        try
        {
            string redisIp = string.Empty;
            string redisPwd = string.Empty;
            if (ConfigurationManager.AppSettings["axpLic_RedisIp"] != null)
                redisIp = ConfigurationManager.AppSettings["axpLic_RedisIp"].ToString();

            if (ConfigurationManager.AppSettings["axpLic_RedisPass"] != null)
                redisPwd = ConfigurationManager.AppSettings["axpLic_RedisPass"].ToString();

            if (redisIp != string.Empty)
            {
                string rlicConn = util.GetServerLicDetails(redisIp, redisPwd);
                switch (rlicConn)
                {
                    case "notConnected":
                        licdetails = "error:Redis Connection details for Axpert license is not proper. Please contact your support person.";
                        break;
                    case "keyNotExists":
                        licdetails = "error:Server seems to be not licensed. Please contact your support person.";
                        break;
                    case "keyNotMatch":
                        licdetails = "error:Redis IP for Axpert license should be set as 127.0.0.1. Please contact your support person.";
                        break;
                    case "keyExists":
                        if (redisPwd != string.Empty)
                            redisPwd = util.EncryptPWD(redisPwd);
                        licdetails = "lic_redis='" + redisIp + "~" + redisPwd + "'";
                        break;
                }
            }
            else
                licdetails = string.Empty;
        }
        catch (Exception ex)
        {
        }
        return licdetails;
    }
}
