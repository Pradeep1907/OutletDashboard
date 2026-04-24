<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="OutletDashboard.Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="p-5 mb-4 bg-light rounded-3 shadow-sm">
        <div class="container-fluid py-5">
            <h1 class="display-4 fw-bold">Outlet Dashboard</h1>
            <p class="col-md-8 fs-4 lead">Welcome to the centralized dashboard for monitoring Healthy Nook and Binge & Bite outlets. Track item orders, stock levels, and more in real-time.</p>
            <a href="Dashboard.aspx" class="btn btn-primary btn-lg px-4">Go to Dashboard &raquo;</a>
        </div>
    </div>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="h4 card-title text-primary">Real-Time Monitoring</h2>
                    <p class="card-text text-muted">View live updates on item orders and remaining quantities for efficient stock management.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="h4 card-title text-success">Veg/Non-Veg Highlights</h2>
                    <p class="card-text text-muted">Easily identify items with color-coded indicators (green for Veg, red for Non-Veg).</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body">
                    <h2 class="h4 card-title text-warning">Stock Alerts</h2>
                    <p class="card-text text-muted">Rows highlight in red, yellow, or green based on remaining stock percentages.</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>