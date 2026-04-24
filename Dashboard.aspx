<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="OutletDashboard.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="container py-4">
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h2 class="display-6 fw-bold text-dark"><i class="fas fa-chart-line me-2 text-primary"></i>Outlet Stock Dashboard</h2>
                <p class="text-muted mb-0">Monitor Healthy Nook and Binge & Bite outlets in real-time.</p>
            </div>
            <div class="col-md-4 text-md-end">
                <button type="button" class="btn btn-outline-secondary btn-sm me-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#infoModal">
                    <i class="fas fa-info-circle me-1"></i> Info
                </button>
                <div class="d-inline-flex align-items-center bg-white p-2 rounded shadow-sm border">
                    <i class="fas fa-clock text-info me-2"></i>
                    <span class="small fw-bold">Live Status: </span>
                    <span class="badge bg-light text-dark ms-2"><%= DateTime.Now.ToString("HH:mm:ss") %></span>
                </div>
            </div>
        </div>

        <!-- Info Modal -->
        <div class="modal fade" id="infoModal" tabindex="-1" aria-labelledby="infoModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title" id="infoModalLabel fw-bold"><i class="fas fa-info-circle me-2"></i>Stock Logic Information</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="list-group list-group-flush">
                            <div class="list-group-item d-flex align-items-center border-0 px-0 mb-3">
                                <div class="bg-danger rounded-circle me-3 shadow-sm" style="width: 24px; height: 24px;"></div>
                                <span class="fw-medium">Items with <strong>10% remaining</strong> should be displayed in <strong>red</strong>.</span>
                            </div>
                            <div class="list-group-item d-flex align-items-center border-0 px-0 mb-3">
                                <div class="bg-warning rounded-circle me-3 shadow-sm" style="width: 24px; height: 24px;"></div>
                                <span class="fw-medium">Items with <strong>20%–50% remaining</strong> should be displayed in <strong>yellow</strong>.</span>
                            </div>
                            <div class="list-group-item d-flex align-items-center border-0 px-0">
                                <div class="bg-success rounded-circle me-3 shadow-sm" style="width: 24px; height: 24px;"></div>
                                <span class="fw-medium">Items with <strong>more than 50% remaining</strong> should be displayed in <strong>green</strong>.</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary px-4 fw-bold" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="card mb-4 shadow-sm border-0">
                    <div class="card-body p-4">
                        <div class="row align-items-center g-3">
                            <div class="col-md-5">
                                <label for="<%= ddlOutlets.ClientID %>" class="form-label fw-bold text-secondary small text-uppercase">
                                    <i class="fas fa-store me-2 text-primary"></i>Current Outlet
                                </label>
                                <asp:DropDownList ID="ddlOutlets" runat="server" CssClass="form-select form-select-lg border-2 shadow-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlOutlets_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 ms-auto">
                                <label class="form-label fw-bold text-secondary small text-uppercase">
                                    <i class="fas fa-search me-2 text-primary"></i>Quick Search
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-2 border-end-0"><i class="fas fa-filter text-muted"></i></span>
                                    <input type="text" id="txtSearch" class="form-control border-2 border-start-0 shadow-sm" placeholder="Filter items..." onkeyup="filterTable()">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script type="text/javascript">
                    function filterTable() {
                        var input, filter, table, tr, td, i, txtValue;
                        input = document.getElementById("txtSearch");
                        filter = input.value.toUpperCase();
                        table = document.querySelector(".table");
                        if (!table) return;
                        tr = table.getElementsByTagName("tr");
                        for (i = 1; i < tr.length; i++) {
                            td = tr[i].getElementsByTagName("td")[0]; // Item Name column
                            if (td) {
                                txtValue = td.textContent || td.innerText;
                                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                    tr[i].style.display = "";
                                } else {
                                    tr[i].style.display = "none";
                                }
                            }
                        }
                    }
                </script>

                <!-- Summary Cards -->
                <div class="row mb-4 g-3">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm overflow-hidden" style="border-left: 5px solid #0d6efd !important;">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase fw-bold text-muted small">Total Ordered</h6>
                                        <h2 class="mb-0 fw-bold"><asp:Literal ID="litTotalOrdered" runat="server" Text="0"></asp:Literal></h2>
                                    </div>
                                    <div class="bg-primary bg-opacity-10 p-3 rounded-circle">
                                        <i class="fas fa-shopping-cart fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm overflow-hidden" style="border-left: 5px solid #198754 !important;">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase fw-bold text-muted small">Stock Remaining</h6>
                                        <h2 class="mb-0 fw-bold text-success"><asp:Literal ID="litStockRemaining" runat="server" Text="0"></asp:Literal></h2>
                                    </div>
                                    <div class="bg-success bg-opacity-10 p-3 rounded-circle">
                                        <i class="fas fa-boxes fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm overflow-hidden" style="border-left: 5px solid #dc3545 !important;">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-uppercase fw-bold text-muted small">Low Stock Items</h6>
                                        <h2 class="mb-0 fw-bold text-danger"><asp:Literal ID="litLowStockCount" runat="server" Text="0"></asp:Literal></h2>
                                    </div>
                                    <div class="bg-danger bg-opacity-10 p-3 rounded-circle">
                                        <i class="fas fa-exclamation-triangle fa-2x text-danger"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle mb-0" OnRowDataBound="gvItems_RowDataBound" EmptyDataText="No items available for the selected outlet." GridLines="None">
                                <HeaderStyle CssClass="bg-light text-muted small text-uppercase fw-bold" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Item Name">
                                        <ItemTemplate>
                                            <span class="fw-bold"><%# Eval("ItemName") %></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Category">
                                        <ItemTemplate>
                                            <span class="badge rounded-pill" style="background-color: <%# Eval("VegNonVegColor") %>; min-width: 60px;">
                                                <%# Eval("Category").ToString().ToUpper() %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TotalOrdered" HeaderText="Total Ordered" ItemStyle-CssClass="fw-bold text-primary" />
                                    <asp:BoundField DataField="RemainingQuantity" HeaderText="Remaining Quantity" ItemStyle-CssClass="fw-bold" />
                                    <asp:TemplateField HeaderText="Stock Health">
                                        <ItemTemplate>
                                            <div class="progress" style="height: 8px; min-width: 100px;">
                                                <div class="progress-bar <%# Eval("StockColor").ToString() == "red" ? "bg-danger" : (Eval("StockColor").ToString() == "yellow" ? "bg-warning" : "bg-success") %>" 
                                                     role="progressbar" 
                                                     style='width: <%# (int)Eval("RemainingQuantity") > 0 ? "100%" : "0%" %>;'></div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>