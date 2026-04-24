using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OutletDashboard
{
    public partial class Dashboard : Page
    {
        private DataAccess da;

        protected void Page_Init(object sender, EventArgs e)
        {
            da = new DataAccess();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (ddlOutlets == null) return;

            if (!IsPostBack)
            {
                try
                {
                    var outlets = da.GetOutlets();
                    if (outlets != null)
                    {
                        ddlOutlets.DataSource = outlets;
                        ddlOutlets.DataTextField = "OutletName";
                        ddlOutlets.DataValueField = "OutletID";
                        ddlOutlets.DataBind();
                    }
                    ddlOutlets.Items.Insert(0, new ListItem("-- Select Outlet --", "0"));
                }
                catch (Exception ex)
                {
                    Response.Write("<div class='alert alert-danger'>Error loading outlets: " + ex.Message + "</div>");
                }
            }
            LoadDashboard();
        }

        protected void ddlOutlets_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        protected void gvItems_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var item = (ItemStatus)e.Row.DataItem;
                if (item != null)
                {
                    e.Row.Attributes["data-stock-color"] = item.StockColor; // Applies CSS for row coloring
                }
            }
        }

        private void LoadDashboard()
        {
            try
            {
                if (ddlOutlets.SelectedValue != "0" && int.TryParse(ddlOutlets.SelectedValue, out int outletID))
                {
                    var items = da.GetItemStatuses(outletID);
                    var itemList = items ?? new System.Collections.Generic.List<ItemStatus>();
                    
                    gvItems.DataSource = itemList;
                    gvItems.DataBind();

                    // Calculate Summary Data
                    int totalOrdered = 0;
                    int stockRemaining = 0;
                    int lowStockCount = 0;

                    foreach (var item in itemList)
                    {
                        totalOrdered += item.TotalOrdered;
                        stockRemaining += item.RemainingQuantity;
                        if (item.StockColor == "red")
                        {
                            lowStockCount++;
                        }
                    }

                    litTotalOrdered.Text = totalOrdered.ToString();
                    litStockRemaining.Text = stockRemaining.ToString();
                    litLowStockCount.Text = lowStockCount.ToString();
                }
                else
                {
                    gvItems.DataSource = null;
                    gvItems.DataBind();
                    litTotalOrdered.Text = "0";
                    litStockRemaining.Text = "0";
                    litLowStockCount.Text = "0";
                }
            }
            catch (Exception ex)
            {
                // Log or handle error (e.g., database query issue)
                gvItems.DataSource = null;
                gvItems.DataBind();
                litTotalOrdered.Text = "0";
                litStockRemaining.Text = "0";
                litLowStockCount.Text = "0";
                Response.Write("Error loading dashboard data: " + ex.Message);
            }
        }
    }
}