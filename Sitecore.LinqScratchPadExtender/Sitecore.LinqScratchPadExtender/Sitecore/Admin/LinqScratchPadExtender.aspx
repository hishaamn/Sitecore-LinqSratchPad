<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LinqScratchPadExtender.aspx.cs" Inherits="Sitecore.LinqScratchPadExtender.LinqScratchPadExtender" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Linq to Sitecore ScratchPad</title>
    <link href="/sitecore/shell/themes/standard/default/WebFramework.css" rel="Stylesheet" />
    <link href="/sitecore/admin/Wizard/UpdateInstallationWizard.css" rel="Stylesheet" />

    <script type="text/javascript" src="/sitecore/shell/Controls/lib/jQuery/jquery.js"></script>

    <script type="text/javascript" src="/sitecore/shell/controls/webframework/webframework.js"></script>
    <script type="text/javascript" src="../../sitecore/shell/Applications/Buckets/libs/jquery-linedtextarea/jquery-linedtextarea.js"></script>
    <link href="../../sitecore/shell/Applications/Buckets/libs/jquery-linedtextarea/jquery-linedtextarea.css" type="text/css" rel="stylesheet" />


</head>
<body>
    <img src="/sitecore/shell/themes/standard/Images/WebFramework/banner.png"/>
    <form id="form1" class="wf-container" runat="server">
        <div>
            <div style="padding: 20px;">Enter your code snippet in the following text field.</div>
            <div>
                <div>
                    <asp:TextBox ID="LinqQuery" runat="server" Class="lined" Height="659px" Width="891px" TextMode="MultiLine" Font-Size="11px">
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.Web;
    using Sitecore.ContentSearch.SearchTypes;
    using Sitecore.Buckets.Extensions;
    using Sitecore.Buckets.Interfaces;
    using Sitecore.Buckets.Search;
    using Sitecore.Buckets.Search.Tags;
    using Sitecore.Configuration;
    using Sitecore.ContentSearch;
    using Sitecore.ContentSearch.Utilities;
    using Sitecore.Data;
    using Sitecore.Data.Fields;
    using Sitecore.Data.Items;
    using Sitecore.Globalization;
    using Sitecore.SecurityModel;
    using Sitecore.Sites;
    using Sitecore.Web;
    using Sitecore;
    using System.ComponentModel;
    using System.Diagnostics.CodeAnalysis;

    using Sitecore.ContentSearch.Linq;
    using Sitecore.ContentSearch.Linq.Common;

    using Constants = Sitecore.Buckets.Util.Constants;
    using ContentSearchManager = Sitecore.ContentSearch.ContentSearchManager;
                     
    namespace Test {
                    
       class Program {
                        public static IEnumerable&lt;SearchResultItem&gt; Main(string str)
                        {
                            using (var context = ContentSearchManager.GetIndex(&quot;sitecore_master_index&quot;).CreateSearchContext())
                            {
                                return context.GetQueryable&lt;SearchResultItem&gt;().Take(10).ToList();
                            }
                        }
                    }
                  }
                    
        [PredefinedQuery("_templatename", ComparisonType.Contains, "sample")]
        public class TryYourOwnClass {
                    
                    [IndexField("_name")]
                    public string Name {get; set;}
                    
                    [IgnoreIndexFieldAttribute]
                    public string DoNotMapMe { get; set;}
                    }
                    </asp:TextBox>
                </div>
            </div>

            <div class="wf-footer">
                <div style="padding: 10px;">Insert your dll name in the textbox below. Separate each dll by a ','. Example: example1.dll, example2.dll</div>
                <asp:TextBox ID="AssemblyList" runat="server" Height="100px" Width="649px" TextMode="MultiLine" Font-Size="11px"></asp:TextBox>

				<hr/>

                <div style="padding: 10px;">Insert additional <b>system assembly</b> here. Separate each dll by a ','. Example: System.dll, System.Xml.dll.</div>
				<div><b>Already Present: System.dll, System.Xml.dll, mscorlib.dll, System.Configuration.dll, System.Core.dll</b></div>
                <asp:TextBox ID="SystemAssembly" runat="server" Height="100px" Width="649px" TextMode="MultiLine" Font-Size="11px"></asp:TextBox>
				
				<hr/>
                
                <div style="padding: 10px;">Insert the <b>parameter values</b> here. Separate each value by a ','.</div>
				<asp:TextBox ID="MethodParameters" runat="server" Height="100px" Width="649px" TextMode="MultiLine" Font-Size="11px"></asp:TextBox>
				
				<hr/>
                
				<div style="padding: 10px;">Insert the method that needs to be executed here. <b>Example: Main</b></div>
                <asp:TextBox ID="MethodStartUp" runat="server" Height="25px" Width="300px" Font-Size="11px" required></asp:TextBox>

                <div style="padding: 10px;">Insert your Main Class including your namespace here. <b>Example: Test.Program</b></div>
                <asp:TextBox ID="MainClass" runat="server" Height="25px" Width="300px" Font-Size="11px" required></asp:TextBox>
            </div>

            <div class="wf-footer">
                <asp:Button ID="btnNext" Text="Execute Code" runat="server" OnClick="btnNext_Click" />
            </div>
            <div class="wf-footer">
                <asp:Literal ID="Output" runat="server"></asp:Literal>
                <asp:Label ID="Error" runat="server"></asp:Label>
            </div>
        </div>
        <div>
        </div>
        <div class="wf-content" style="padding: 2em 100px 0 32px;">
            <asp:Label ID="lblError" CssClass="Error" Visible="false" runat="server"></asp:Label>
            <h1 runat="server" id="lblHeader"></h1>
            <asp:GridView ID="GridResults" runat="server" BackColor="White" BorderColor="Gray" Width="800">
                <AlternatingRowStyle BackColor="Silver" />
                <HeaderStyle BackColor="Gray" />
                <RowStyle Width="600px" />
            </asp:GridView>

        </div>

    </form>
</body>

<script>
    jQuery(function () {
        jQuery(".lined").linedtextarea(
            { selectedLine: 1 }
        );
    });
</script>

</html>
