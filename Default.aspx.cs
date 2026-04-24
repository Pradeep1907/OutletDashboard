using System;
using System.Web.UI;

namespace OutletDashboard
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Add any server-side logic here, e.g., custom redirects or data loading.
            // For now, it's simple—authentication is handled by Web.config.
            // If you want to redirect logged-in users directly to Dashboard.aspx, uncomment below:
            // if (User.Identity.IsAuthenticated)
            // {
            //     Response.Redirect("~/Dashboard.aspx");
            // }
        }
    }
}