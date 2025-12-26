package com.elite.asr.model;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class TableSession {
    private final int tableId;
    private final int clients;
    private String notes = "";
    private final ObservableList<OrderItem> orderItems = FXCollections.observableArrayList();

    public TableSession(int tableId, int clients) {
        this.tableId = tableId;
        this.clients = clients;
    }

    public int getTableId() { return tableId; }
    public int getClients() { return clients; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public ObservableList<OrderItem> getOrderItems() { return orderItems; }
}
