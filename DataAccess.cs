using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;

namespace OutletDashboard
{
    public class DataAccess
    {
        private string GetConnectionString()
        {
            var setting = ConfigurationManager.ConnectionStrings["OutletDB"];
            if (setting == null)
            {
                throw new Exception("Connection string 'OutletDB' not found in Web.config. Please check the <connectionStrings> section.");
            }
            return setting.ConnectionString;
        }

        public List<Outlet> GetOutlets()
        {
            var outlets = new List<Outlet>();
            string connString = GetConnectionString();
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT * FROM Outlets", conn);
                var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    outlets.Add(new Outlet { OutletID = (int)reader["OutletID"], OutletName = reader["OutletName"].ToString() });
                }
            }
            return outlets;
        }

        public List<ItemStatus> GetItemStatuses(int outletID)
        {
            var items = new List<ItemStatus>();
            string connString = GetConnectionString();
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
                    SELECT i.ItemID, i.ItemName, i.Category, i.TotalStock,
                           ISNULL(SUM(o.QuantityOrdered), 0) AS TotalOrdered,
                           (i.TotalStock - ISNULL(SUM(o.QuantityOrdered), 0)) AS RemainingQuantity
                    FROM Items i
                    LEFT JOIN Orders o ON i.ItemID = o.ItemID AND o.OutletID = @OutletID
                    GROUP BY i.ItemID, i.ItemName, i.Category, i.TotalStock", conn);
                cmd.Parameters.AddWithValue("@OutletID", outletID);
                var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    var remaining = reader["RemainingQuantity"] != DBNull.Value ? (int)reader["RemainingQuantity"] : 0;
                    var totalStock = reader["TotalStock"] != DBNull.Value ? (int)reader["TotalStock"] : 0;
                    var percentage = totalStock > 0 ? (remaining / (double)totalStock) * 100 : 0;
                    
                    // Logic: 10% (and below) is Red, 20-50% is Yellow, > 50% is Green
                    string stockColor = percentage <= 20 ? "red" : (percentage <= 50 ? "yellow" : "green");
                    
                    items.Add(new ItemStatus
                    {
                        ItemName = reader["ItemName"] != DBNull.Value ? reader["ItemName"].ToString() : "Unknown",
                        Category = reader["Category"] != DBNull.Value ? reader["Category"].ToString() : "Unknown",
                        TotalOrdered = reader["TotalOrdered"] != DBNull.Value ? Convert.ToInt32(reader["TotalOrdered"]) : 0,
                        RemainingQuantity = remaining,
                        VegNonVegColor = reader["Category"] != DBNull.Value && reader["Category"].ToString().Equals("Veg", StringComparison.OrdinalIgnoreCase) ? "#28a745" : "#dc3545",
                        StockColor = stockColor
                    });
                }
            }
            return items;
        }
    }

    public class Outlet { public int OutletID { get; set; } public string OutletName { get; set; } }
    public class ItemStatus
    {
        public string ItemName { get; set; }
        public string Category { get; set; }
        public int TotalOrdered { get; set; }
        public int RemainingQuantity { get; set; }
        public string VegNonVegColor { get; set; } // "green" or "red"
        public string StockColor { get; set; } // "red", "yellow", or "green"
    }
}