package com.elite.asr.model;

import java.util.ArrayList;
import java.util.List;

public class OrderItem {
    private String name;
    private double price;
    private int quantity;
    private List<String> components = new ArrayList<>();

    public OrderItem(String name, double price, int quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    public OrderItem(String name, double price, int quantity, List<String> components) {
        this(name, price, quantity);
        this.components = components;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public List<String> getComponents() {
        return components;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void incrementQuantity() {
        this.quantity++;
    }
}
